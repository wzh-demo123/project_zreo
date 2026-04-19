class_name PlayerController
extends Node

# 玩家输入控制器类
# 架构定位：输入处理层，直接操作数据模型（Model），不干预视图（View）
# 设计原则：遵循MVVM模式，保持输入逻辑与视觉表现的分离

# 目标实体视图绑定
@export var target_view: BaseEntityView = null

# 战斗属性配置
@export var attack_damage: float = 30.0  # 攻击伤害
@export var attack_cooldown: float = 0.4  # 攻击冷却时间
@export var attack_radius: float = 40.0  # 攻击判定扇形半径
@export var attack_angle: float = 90.0  # 攻击扇形张角（度）

# 内部状态变量
var last_direction: Vector2 = Vector2.RIGHT  # 最后朝向
var attack_timer: float = 0.0  # 攻击冷却计时器

# --- 初始化 ---
func _ready() -> void:
	# 加入玩家控制器组，便于Spawner查找
	add_to_group("player_controllers")

	# 连接世界加载信号，实现读档后的玩家重绑
	WorldManager.world_loaded.connect(_on_world_loaded)

	print("[PlayerController] 初始化完成")

# 世界加载完成后的处理
func _on_world_loaded() -> void:
	print("[PlayerController] 收到世界加载信号，开始重绑玩家...")

	# 等待一帧，确保Spawner已经完成视觉重建
	await get_tree().process_frame

	# 遍历所有实体视图，寻找玩家
	var player_view: BaseEntityView = null

	# 获取所有在"entity_views"组里的节点
	var entity_views: Array[Node] = get_tree().get_nodes_in_group("entity_views")

	for view in entity_views:
		if view is BaseEntityView and view.data != null and view.data.entity_type == "player":
			player_view = view
			print("[PlayerController] 找到玩家视图: ", view.data.id)
			break

	if player_view != null:
		# 更新目标视图
		target_view = player_view
		print("[PlayerController] 玩家重绑成功！")
	else:
		print("[PlayerController] 警告：未找到玩家实体视图")

# 外部调用的重绑函数（由Spawner调用）
func rebind_player(player_data: EntityData) -> void:
	print("[PlayerController] 收到外部重绑请求")
	_on_world_loaded()  # 直接调用内部重绑逻辑


# 每帧输入处理
func _process(delta: float) -> void:
	# 保存/加载功能（K键保存，L键加载） - 移动到最前，确保即使玩家死亡也能触发
	if Input.is_physical_key_pressed(KEY_K):
		print("[System] 正在保存世界状态...")
		WorldManager.save_world("test_slot")

	if Input.is_physical_key_pressed(KEY_L):
		print("[System] 正在读取存档...")
		WorldManager.load_world("test_slot")

	# 安全检查：确保目标视图和数据存在且存活
	if not _is_target_valid():
		return

	# 更新攻击冷却计时器
	if attack_timer > 0.0:
		attack_timer -= delta

	# 获取输入方向向量
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# 更新最后朝向（如果玩家有输入）
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()

	# 处理玩家移动
	if direction != Vector2.ZERO:
		_handle_player_movement(direction, delta)

	# 处理攻击输入
	if Input.is_action_just_pressed("ui_accept") and attack_timer <= 0.0:
		_handle_attack()

	# # 调试信息显示
	# _debug_attack_info()


# 检查目标有效性
func _is_target_valid() -> bool:
	if target_view == null:
		return false

	if target_view.data == null:
		return false

	# 检查实体是否存活
	if target_view.data.health <= 0.0:
		return false

	return true


# 处理玩家移动
func _handle_player_movement(direction: Vector2, delta: float) -> void:
	# 计算移动距离
	var move_distance: float = target_view.data.move_speed * delta

	# 直接修改数据层的位置 - 核心MVVM架构
	target_view.data.position += direction * move_distance

	# 限制玩家位置在世界边界内
	target_view.data.position = WorldManager.clamp_position(target_view.data.position)

	# 解决碰撞（防止穿墙）
	WorldManager.resolve_collisions(target_view.data)

	# 调试输出（可选）
	if Engine.is_editor_hint():
		print(
			"玩家移动: ",
			direction,
			" | 速度: ",
			target_view.data.move_speed,
			" | 新位置: ",
			target_view.data.position
		)


# 攻击处理逻辑
func _handle_attack() -> void:
	# 重置冷却计时器
	attack_timer = attack_cooldown

	# 攻击起点改为玩家自身位置
	var hit_origin: Vector2 = target_view.data.position

	# 触发攻击动画
	target_view.play_attack_anim(hit_origin, last_direction, attack_radius, attack_angle)

	# 直接访问全局 Autoload 单例
	var hit_count: int = 0
	for entity in WorldManager.entities:
		# 跳过无效实体
		if entity == null:
			continue

		# 跳过玩家自己
		if entity == target_view.data:
			continue

		# 跳过已死亡的实体
		if entity.health <= 0.0:
			continue

		# 第一关：距离过滤
		if entity.position.distance_to(hit_origin) > attack_radius:
			continue

		# 第二关：角度过滤
		var dir_to_enemy: Vector2 = (entity.position - hit_origin).normalized()
		var angle_diff: float = rad_to_deg(last_direction.angle_to(dir_to_enemy))

		if abs(angle_diff) > attack_angle / 2.0:
			continue

		# 通过两关判定，执行伤害
		entity.health -= attack_damage
		hit_count += 1
		EventBus.entity_damaged.emit(entity, attack_damage, hit_origin)
		print("攻击命中: ", entity.id, " | 伤害: ", attack_damage, " | 剩余生命: ", entity.health)

	# 攻击反馈
	if hit_count > 0:
		print("攻击成功！命中 ", hit_count, " 个目标")
	else:
		print("攻击落空")


# # 调试攻击信息
# func _debug_attack_info() -> void:
# 	if not Engine.is_editor_hint():
# 		return

# 	# 计算攻击圆心位置
# 	var hit_center: Vector2 = target_view.data.position + last_direction * attack_offset

# 	# 显示攻击范围信息
# 	print("攻击圆心: ", hit_center, " | 冷却: ", attack_timer, " | 朝向: ", last_direction)


# 限制玩家位置在世界边界内
func _clamp_position_to_world_bounds() -> void:
	# 这里可以添加世界边界限制逻辑
	pass
	# 例如：限制在特定区域内移动
	# target_view.data.position = target_view.data.position.clamp(Vector2.ZERO, world_size)
	pass


# 调试信息显示
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if target_view == null:
		warnings.append("target_view 未设置，玩家控制器将无法工作")

	return warnings


# 获取当前玩家状态信息（用于UI显示等）
func get_player_info() -> Dictionary:
	if not _is_target_valid():
		return {}

	return {
		"position": target_view.data.position,
		"health": target_view.data.health,
		"entity_type": target_view.data.entity_type,
		"faction": target_view.data.faction
	}


# 设置玩家移动速度（外部控制接口）
func set_move_speed(speed: float) -> void:
	if _is_target_valid():
		target_view.data.move_speed = speed


# 获取玩家移动速度
func get_move_speed() -> float:
	if _is_target_valid():
		return target_view.data.move_speed
	return 0.0