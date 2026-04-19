# res://scripts/core/world_manager.gd
# class_name WorldManager
extends Node

## 世界管理器单例
## 负责：时间步进、实体数据持有、存档序列化

# --- 信号 ---
signal world_ticked(tick_count: int)
signal world_loaded()  # 世界加载完成信号

# --- 配置 ---
@export_group("Simulation")
@export var ticks_per_second: float = 10.0
@export var world_bounds: Rect2 = Rect2(-600, -400, 1200, 800)  # 世界边界矩形

# --- 运行时数据 ---
var entities: Array[EntityData] = []
var current_tick: int = 0
var accumulator: float = 0.0

# --- 核心逻辑 ---

func _process(delta: float) -> void:
	# 使用累加器确保固定步进
	accumulator += delta
	var tick_interval: float = 1.0 / ticks_per_second

	while accumulator >= tick_interval:
		accumulator -= tick_interval
		tick_step()

# world_manager.gd 中的核心逻辑更新
func tick_step() -> void:
	current_tick += 1

	for entity in entities:
		if not is_instance_valid(entity): continue

		# 1. 基础演化 (变老)
		entity.age_step(1)

		# 2. 简单的 AI 决策：机械体捕食逻辑
		if entity.entity_type == "mechanical":
			_handle_mechanical_ai(entity)

	world_ticked.emit(current_tick)

# 针对 MX110 优化的数组查找逻辑
# world_manager.gd 中的修正版函数
func _handle_mechanical_ai(hunter: EntityData) -> void:
	# 1. 寻找最近的猎物（玩家优先级）
	var nearest_prey: EntityData = null
	var min_dist = 400.0 # 感知范围

	for target in entities:
		# 跳过无效目标
		if target.health <= 0:
			continue

		var d: float = hunter.position.distance_to(target.position)
		if d > min_dist:
			continue

		# 判断目标类型
		var is_player: bool = (target.entity_type == "player")
		var is_organic: bool = (target.entity_type == "organic")

		# 玩家优先级逻辑
		if is_player:
			# 锁定玩家：除非有更近的玩家，否则不切换目标
			nearest_prey = target
			min_dist = d
		elif is_organic and (nearest_prey == null or nearest_prey.entity_type != "player"):
			# 只有当前没有锁定玩家时，才考虑有机体
			if d < min_dist:
				nearest_prey = target
				min_dist = d

	# 2. 决策行为
	if nearest_prey:
		# --- 核心改进：移动逻辑 ---
		# 只有当距离大于 5 像素时才真正执行移动
		# 这样可以防止在目标点附近"反复横跳"
		if min_dist > 5.0:
			var dir = (nearest_prey.position - hunter.position).normalized()
			# 计算本次 tick 的位移量
			var movement = dir * hunter.move_speed * 0.1
			hunter.position += movement

		# --- 核心改进：伤害逻辑 ---
		# 只有足够近（小于 10 像素）才吸血
		if min_dist < 10.0:
			nearest_prey.health -= 5.0 # 有机体扣血
			hunter.health = min(100.0, hunter.health + 2.0) # 机械体回血

	# 【重要修复】无论有没有猎物，都得守法（不穿墙、不撞墙）
	hunter.position = clamp_position(hunter.position)
	resolve_collisions(hunter)

# --- 实体管理 ---
func register_entity(data: EntityData) -> void:
	if data != null and not entities.has(data):
		entities.append(data)
		print("实体已注册: ", data.id)

func unregister_entity(data: EntityData) -> void:
	if data != null and entities.has(data):
		entities.erase(data)
		print("实体已注销: ", data.id)

# --- 持久化逻辑 ---

func save_world(slot_name: String) -> void:
	# 创建临时资源容器
	var world_data: WorldSaveData = WorldSaveData.new()

	# 复制当前世界状态（避免引用问题）
	world_data.entities = entities.duplicate(true)
	world_data.current_tick = current_tick
	world_data.save_timestamp = Time.get_unix_time_from_system()

	# 构建保存路径
	var save_path: String = "user://saves/" + slot_name + ".res"

	# 确保保存目录存在
	var dir: DirAccess = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")

	# 保存资源文件
	var error: Error = ResourceSaver.save(world_data, save_path)
	if error == OK:
		print("世界状态已保存到: ", save_path)
	else:
		push_error("保存失败，错误码: " + str(error))

func load_world(slot_name: String) -> void:
	# 构建加载路径
	var load_path: String = "user://saves/" + slot_name + ".res"

	# 检查文件是否存在
	if not FileAccess.file_exists(load_path):
		push_error("存档文件不存在: " + load_path)
		return

	# 加载资源文件
	var world_data: WorldSaveData = ResourceLoader.load(
		load_path, "", ResourceLoader.CACHE_MODE_IGNORE)

	if world_data != null:
		# 恢复世界状态
		entities = world_data.entities.duplicate(true)
		current_tick = world_data.current_tick
		accumulator = 0.0  # 重置累加器

		print("世界状态已加载，实体数量: ", entities.size())
		print("当前tick: ", current_tick)
		print("保存时间: ", world_data.save_timestamp)

		# 发出世界加载完成信号
		world_loaded.emit()
	else:
		push_error("加载失败: " + load_path)

# 碰撞检测与解决函数
func resolve_collisions(subject: EntityData) -> void:
	# 遍历所有实体，检测与静态障碍物的碰撞
	for entity in entities:
		# 跳过无效实体和自己
		if entity == null or entity == subject:
			continue

		# 只检测与静态障碍物的碰撞
		if entity.entity_type == "static":
			# 计算两实体间的距离
			var d: float = subject.position.distance_to(entity.position)

			# 计算最小安全距离（半径之和）
			var min_dist: float = subject.collision_radius + entity.collision_radius

			# 如果发生碰撞
			if d < min_dist and d > 0.0:
				# 计算挤开向量
				var push: Vector2 = (subject.position - entity.position).normalized() * (min_dist - d)

				# 应用排斥力
				subject.position += push

				# 约束位置在世界边界内
				subject.position = clamp_position(subject.position)

# 位置限制函数
func clamp_position(pos: Vector2) -> Vector2:
	# 返回世界边界限制后的坐标
	return pos.clamp(world_bounds.position, world_bounds.position + world_bounds.size)

# 获取当前世界状态信息
func get_world_info() -> Dictionary:
	return {
		"current_tick": current_tick,
		"entity_count": entities.size(),
		"ticks_per_second": ticks_per_second,
		"world_bounds": world_bounds
	}

# 清空世界状态（用于重置或测试）
func clear_world() -> void:
	entities.clear()
	current_tick = 0
	accumulator = 0.0
	print("世界状态已清空")

# --- 辅助数据容器 ---

# ## 世界保存数据容器类
# class WorldSaveData extends Resource:
# 	@export var entities: Array[EntityData] = []
# 	@export var current_tick: int = 0
# 	@export var save_timestamp: int = 0