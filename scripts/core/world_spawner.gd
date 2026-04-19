class_name WorldSpawner
extends Node2D

# 世界生成器类
# 功能：在指定区域内生成不同类型的实体
# 设计目标：提供可配置的实体生成系统，支持动态世界构建

# 配置变量
@export var base_view_scene: PackedScene = null  # 基础实体视图场景
@export var organic_count: int = 20              # 有机体（食物）生成数量
@export var mechanical_count: int = 3            # 机械体（猎食者）生成数量
@export var static_obstacle_count: int = 15      # 静态障碍物数量
@export var spawn_range: Vector2 = Vector2(1000, 1000)  # 生成区域范围

# 内部计数器
var total_spawned: int = 0

# 节点初始化
func _ready() -> void:
	# 连接世界加载信号，实现读档后的视觉重建
	WorldManager.world_loaded.connect(_on_world_loaded)

	# 延迟一帧生成，确保所有系统已初始化
	call_deferred("spawn_all")

# 读档后的视觉重建逻辑
func _on_world_loaded() -> void:
	print("[Spawner] 开始读档后的视觉重建...")

	# 第一步：清场 - 瞬间杀掉地图上所有的旧肉身
	get_tree().call_group("entity_views", "queue_free")
	print("[Spawner] 已清理所有旧实体视图")

	# 第二步：等待一帧，确保旧肉身已经彻底清理干净
	await get_tree().process_frame

	# 第三步：重生 - 根据WorldManager中的新灵魂重新塑造肉身
	var player_entity: EntityData = null

	for entity_data in WorldManager.entities:
		if entity_data == null:
			continue

		# 实例化新的实体视图
		var entity_view: BaseEntityView = base_view_scene.instantiate()

		# 核心绑定：将新视图绑定到存档中的实体数据
		entity_view.data = entity_data

		# 添加为子节点
		add_child(entity_view)

		# 记录玩家实体，用于后续重绑
		if entity_data.entity_type == "player":
			player_entity = entity_data
			print("[Spawner] 找到玩家实体: ", entity_data.id)

	print("[Spawner] 视觉重建完成，共重生 ", WorldManager.entities.size(), " 个实体")

	# 第四步：通知PlayerController更新目标视图（如果找到玩家）
	if player_entity != null:
		# 通过EventBus或直接通知PlayerController
		call_deferred("_notify_player_rebind", player_entity)

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
	# 生成有机体（食物）
	for i in range(organic_count):
		_create_entity("organic", "food_" + str(i))

	# 生成机械体（猎食者）
	for i in range(mechanical_count):
		_create_entity("mechanical", "hunter_" + str(i))

	# 生成静态障碍物
	for i in range(static_obstacle_count):
		_create_static_obstacle("obstacle_" + str(i))

	# 打印统计信息
	print("世界生成完成 - 总计实体: ", total_spawned)
	print("有机体: ", organic_count, " | 机械体: ", mechanical_count, " | 障碍物: ", static_obstacle_count)
	print("生成区域: ", spawn_range)

# 创建单个实体
func _create_entity(entity_type: String, entity_id: String) -> void:
	# 安全检查
	if base_view_scene == null:
		push_error("WorldSpawner: base_view_scene 未设置")
		return

	# 实例化实体视图
	var entity_view: BaseEntityView = base_view_scene.instantiate()

	# 创建全新的实体数据（确保数据独立）
	var entity_data: EntityData = EntityData.new()

	# 设置实体数据属性
	entity_data.id = entity_id
	entity_data.entity_type = entity_type
	entity_data.faction = _get_faction_by_type(entity_type)
	entity_data.health = _get_initial_health(entity_type)
	entity_data.position = _get_random_position()

	# 绑定数据到视图
	entity_view.data = entity_data

	# 添加为子节点
	add_child(entity_view)

	# 更新计数器
	total_spawned += 1

	# 调试信息
	print("生成实体: ", entity_id, " | 类型: ", entity_type, " | 位置: ", entity_data.position)

# 根据实体类型获取初始生命值
func _get_initial_health(entity_type: String) -> float:
	match entity_type:
		"organic":
			return 50.0  # 食物生命值较低
		"mechanical":
			return 150.0  # 猎食者生命值较高
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
	# 安全检查
	if base_view_scene == null:
		push_error("WorldSpawner: base_view_scene 未设置")
		return

	# 实例化实体视图
	var obstacle_view: BaseEntityView = base_view_scene.instantiate()

	# 创建全新的实体数据
	var obstacle_data: EntityData = EntityData.new()

	# 设置障碍物属性
	obstacle_data.id = obstacle_id
	obstacle_data.entity_type = "static"
	obstacle_data.faction = "neutral"
	obstacle_data.health = 9999.0  # 障碍物不可摧毁
	obstacle_data.collision_radius = randf_range(30.0, 50.0)  # 随机半径30-50
	obstacle_data.position = _get_random_position()

	# 绑定数据到视图
	obstacle_view.data = obstacle_data

	# 添加为子节点
	add_child(obstacle_view)

	# 更新计数器
	total_spawned += 1

	# 调试信息
	print("生成障碍物: ", obstacle_id, " | 半径: "
	, obstacle_data.collision_radius, " | 位置: ", obstacle_data.position)

# 获取随机生成位置
func _get_random_position() -> Vector2:
	var random_x: float = randf_range(-spawn_range.x / 2, spawn_range.x / 2)
	var random_y: float = randf_range(-spawn_range.y / 2, spawn_range.y / 2)

	# 相对于生成器的位置
	return global_position + Vector2(random_x, random_y)

# 调试信息显示
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if base_view_scene == null:
		warnings.append("base_view_scene 未设置，无法生成实体")

	return warnings