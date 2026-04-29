class_name WorldSpawner
extends Node2D

# 世界生成器类（重构版）
# 实体类型场景配置（在编辑器中拖拽赋值）

@export_group("View Scenes")
@export var organic_scene: PackedScene = null
@export var mechanical_scene: PackedScene = null
@export var static_scene: PackedScene = null
# [热源系统已禁用] @export var heat_source_scene: PackedScene = null
@export var resource_scene: PackedScene = null

# 内部字典映射（运行时构建）
var view_scenes: Dictionary = {}

# 默认保底场景（当类型未配置时使用）
var _default_scene: PackedScene = preload("res://scenes/base_entity_view.tscn")

func _build_view_scenes_dict() -> void:
	view_scenes.clear()
	view_scenes["organic"] = organic_scene
	view_scenes["mechanical"] = mechanical_scene
	view_scenes["static"] = static_scene
	# [热源系统已禁用] view_scenes["heat_source"] = heat_source_scene
	view_scenes["resource"] = resource_scene

# --- 平衡参数配置 ---
@export var tuning: WorldTuning = WorldTuning.new()

# 内部计数器
var total_spawned: int = 0
var static_entity_views: Dictionary = {}  # key: static id, value: Node2D

# 节点初始化
func _ready() -> void:
	# 连接世界加载信号
	WorldManager.world_loaded.connect(_on_world_loaded)
	if not EventBus.static_entity_spawned.is_connected(_on_static_entity_spawned):
		EventBus.static_entity_spawned.connect(_on_static_entity_spawned)
	if not EventBus.static_entity_depleted.is_connected(_on_static_entity_depleted):
		EventBus.static_entity_depleted.connect(_on_static_entity_depleted)

	# 构建场景字典
	_build_view_scenes_dict()
	
	# 延迟一帧生成
	call_deferred("spawn_all")
	call_deferred("_rebuild_static_entity_views")

# 读档后的视觉重建逻辑
func _on_world_loaded() -> void:
	print("[Spawner] 开始读档后的视觉重建...")

	# 清场
	get_tree().call_group("entity_views", "queue_free")
	print("[Spawner] 已清理所有旧实体视图")

	await get_tree().process_frame
	_clear_static_entity_views()
	_rebuild_static_entity_views()

	# 重生实体
	var player_entity: EntityData = null

	for entity_data in WorldManager.entities:
		if entity_data == null:
			continue

		var scene: PackedScene = _get_scene_for_type(entity_data.entity_type)
		if scene == null:
			push_error("[Spawner] 未找到场景: " + entity_data.entity_type)
			continue

		var entity_view = scene.instantiate()
		if entity_view is BaseEntityView:
			entity_view.data = entity_data
		add_child(entity_view)

		if entity_data.entity_type == "player":
			player_entity = entity_data
			print("[Spawner] 找到玩家实体: ", entity_data.id)

	print("[Spawner] 视觉重建完成，共重生 ", WorldManager.entities.size(), " 个实体")

	if player_entity != null:
		call_deferred("_notify_player_rebind", player_entity)


# 静态实体生成后创建对应View
func _on_static_entity_spawned(static_data: StaticEntityData) -> void:
	_create_static_entity_view(static_data)


# 资源耗尽后播放缩放消失动画并清理
func _on_static_entity_depleted(static_data: StaticEntityData) -> void:
	var view_node: Node2D = static_entity_views.get(static_data.id, null)
	if view_node == null or not is_instance_valid(view_node):
		return

	var tween: Tween = create_tween()
	tween.tween_property(view_node, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.finished.connect(
		func() -> void:
			if is_instance_valid(view_node):
				view_node.queue_free()
			static_entity_views.erase(static_data.id)
	)


# 重建所有静态实体视图（用于首帧补齐和读档重建）
func _rebuild_static_entity_views() -> void:
	for static_data in WorldManager.static_entities:
		_create_static_entity_view(static_data)


# 统一创建静态实体视图
func _create_static_entity_view(static_data: StaticEntityData) -> void:
	if static_data == null or static_data.is_depleted:
		return
	if static_entity_views.has(static_data.id):
		return
	
	# 根据类型获取场景（带保底回退）
	var scene: PackedScene = _get_scene_for_type(static_data.type)

	var view = scene.instantiate()
	view.name = "StaticView_" + static_data.id
	view.position = static_data.position
	view.set_meta("static_entity_id", static_data.id)

	# 先赋值数据，再添加为子节点（关键顺序！）
	if view is BaseEntityView:
		var entity_data := EntityData.new()
		entity_data.id = static_data.id
		entity_data.entity_type = "static"
		entity_data.position = static_data.position
		entity_data.health = 100.0
		entity_data.max_health = 100.0
		entity_data.faction = "neutral"
		view.data = entity_data  # 先赋值
		WorldManager.register_entity(entity_data)

	# 设置缩放
	view.scale = _get_scale_by_type(static_data.type)

	add_child(view)  # 后添加
	static_entity_views[static_data.id] = view
	
	print("[WorldSpawner] 创建静态实体视图: ", static_data.id, " 类型: ", static_data.type)


# 清理静态实体视图缓存
func _clear_static_entity_views() -> void:
	for view_node in static_entity_views.values():
		if is_instance_valid(view_node):
			view_node.queue_free()
	static_entity_views.clear()

# 延迟通知PlayerController重绑玩家
func _notify_player_rebind(player_data: EntityData) -> void:
	# 查找PlayerController节点并通知它
	var player_controller: PlayerController = get_tree().get_first_node_in_group("player_controllers")
	if player_controller != null:
		player_controller.call_deferred("rebind_player", player_data)
	else:
		print("[Spawner] 警告：未找到PlayerController节点")

# 重新生成所有实体（可用于重置或测试）
func respawn_all() -> void:
	# 重新构建场景字典
	_build_view_scenes_dict()
	
	# 清除现有实体
	for child in get_children():
		if child is BaseEntityView:
			child.queue_free()

	# 重置计数器
	total_spawned = 0

	# 重新生成
	spawn_all()

# 批量生成所有实体
func spawn_all() -> void:
	# 确保场景字典已构建
	_build_view_scenes_dict()
	
	# 生成有机体
	for i in range(tuning.spawn_organic_count):
		_create_entity("organic", "food_" + str(i))

	# 生成机械体
	for i in range(tuning.spawn_mechanical_count):
		_create_entity("mechanical", "hunter_" + str(i))

	# 生成静态障碍物
	for i in range(tuning.spawn_static_obstacle_count):
		_create_static_obstacle("obstacle_" + str(i))

	print("世界生成完成 - 总计实体: ", total_spawned)

# 创建单个实体
func _create_entity(entity_type: String, entity_id: String) -> void:
	var scene: PackedScene = _get_scene_for_type(entity_type)

	var entity_view = scene.instantiate()

	# 创建实体数据
	var entity_data := EntityData.new()
	entity_data.id = entity_id
	entity_data.entity_type = entity_type
	entity_data.faction = _get_faction_by_type(entity_type)
	var initial_health: float = _get_initial_health(entity_type)
	entity_data.health = initial_health
	entity_data.max_health = initial_health
	entity_data.position = _get_random_position()

	# 先赋值数据，再添加为子节点（关键顺序！）
	if entity_view is BaseEntityView:
		entity_view.data = entity_data

	# 设置实体缩放
	entity_view.scale = _get_scale_by_type(entity_type)

	add_child(entity_view)
	total_spawned += 1
	
	print("生成实体: ", entity_id, " | 类型: ", entity_type)

# 根据实体类型获取缩放比例
func _get_scale_by_type(entity_type: String) -> Vector2:
	match entity_type:
		"organic":
			return Vector2(0.8, 0.8)  # 有机体
		"mechanical":
			return Vector2(1.5, 1.5)  # 机械体
		"static":
			return Vector2(1.5, 1.5)  # 静态障碍物
		"resource":
			return Vector2(1.2, 1.2)  # 资源点
		_:
			return Vector2(1.0, 1.0)  # 默认大小

# 根据实体类型获取初始生命值
func _get_initial_health(entity_type: String) -> float:
	match entity_type:
		"organic":
			return tuning.entity_organic_health
		"mechanical":
			return tuning.entity_mechanical_health
		_:
			return 100.0  # 默认值

# 根据实体类型获取阵营
func _get_faction_by_type(entity_type: String) -> String:
	match entity_type:
		"organic":
			return "prey"  # 猎物阵营
		"mechanical":
			return "predator"  # 捕食者阵营
		_:
			return "neutral"  # 默认阵营

# 创建静态障碍物
func _create_static_obstacle(obstacle_id: String) -> void:
	var scene: PackedScene = view_scenes.get("static", null)
	if scene == null:
		push_error("WorldSpawner: 未找到 static 场景")
		return

	var obstacle_view = scene.instantiate()

	var obstacle_data := EntityData.new()
	obstacle_data.id = obstacle_id
	obstacle_data.entity_type = "static"
	obstacle_data.faction = "neutral"
	var static_health: float = tuning.entity_static_health
	obstacle_data.health = static_health
	obstacle_data.max_health = static_health
	obstacle_data.collision_radius = randf_range(tuning.entity_collision_radius_min, tuning.entity_collision_radius_max)
	obstacle_data.position = _get_random_position()

	if obstacle_view is BaseEntityView:
		obstacle_view.data = obstacle_data

	# 设置缩放
	obstacle_view.scale = _get_scale_by_type("static")

	add_child(obstacle_view)
	total_spawned += 1
	
	print("生成障碍物: ", obstacle_id)

# 获取随机生成位置
func _get_random_position() -> Vector2:
	var random_x: float = randf_range(-tuning.spawn_range.x / 2, tuning.spawn_range.x / 2)
	var random_y: float = randf_range(-tuning.spawn_range.y / 2, tuning.spawn_range.y / 2)

	# 相对于生成器的位置
	return global_position + Vector2(random_x, random_y)

# 根据类型获取场景（带保底回退）
func _get_scene_for_type(entity_type: String) -> PackedScene:
	var scene: PackedScene = view_scenes.get(entity_type, null)
	if scene == null:
		push_warning("[WorldSpawner] 未找到场景: " + entity_type + "，使用默认保底场景")
		return _default_scene
	return scene

# 调试信息显示
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if organic_scene == null:
		warnings.append("Organic Scene 未设置")
	if mechanical_scene == null:
		warnings.append("Mechanical Scene 未设置")
	if static_scene == null:
		warnings.append("Static Scene 未设置")

	return warnings