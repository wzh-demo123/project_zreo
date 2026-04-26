# res://scripts/core/world_manager.gd
# class_name WorldManager
extends Node

## 世界管理器单例
## 负责：时间步进、实体数据持有、存档序列化

# --- 信号 ---
signal world_ticked(tick_count: int)
signal world_loaded  # 世界加载完成信号
signal world_clock_updated(day_count: int, time_ratio: float, is_night: bool)

# --- 配置 ---
@export_group("Simulation")
@export var ticks_per_second: float = 10.0
@export var world_bounds: Rect2 = Rect2(-600, -400, 1200, 800)  # 世界边界矩形

# --- 律法时钟配置 ---
@export_group("Time System")
@export var day_length_seconds: float = 600.0  # 10分钟一个昼夜周期

# --- 资源系统配置 ---
@export_group("Resource System")
@export var harvest_distance: float = 100.0  # 采集距离（已废弃，使用 WorldTuning）
@export var base_harvest_gain: float = 10.0  # 基础采集收益（已废弃，使用 WorldTuning）

# --- 平衡参数配置 ---
@export var tuning: WorldTuning = WorldTuning.new()  # 平衡参数资源

# --- 系统实例 ---
var temperature_system: RefCounted = null
var metabolism_system: RefCounted = null
var combat_system: RefCounted = null
var harvest_system: RefCounted = null
var ai_system: RefCounted = null

# --- 运行时数据 ---
var entities: Array[EntityData] = []
var static_entities: Array[StaticEntityData] = []  # 静态实体数组
var current_tick: int = 0
var accumulator: float = 0.0
var world_time: float = 0.0  # 世界时间（秒）

# --- Debug 统计 ---
var last_tick_time: float = 0.0
var tick_time_accumulator: float = 0.0
var tick_time_samples: int = 0
var debug_update_interval: float = 1.0  # 每秒更新一次统计
var debug_timer: float = 0.0

# --- 初始化 ---
func _ready() -> void:
	# 初始化系统
	temperature_system = load("res://scripts/core/systems/temperature_system.gd").new(tuning, CalendarManager, EventBus)
	metabolism_system = load("res://scripts/core/systems/metabolism_system.gd").new(tuning, CalendarManager, EventBus)
	combat_system = load("res://scripts/core/systems/combat_system.gd").new(tuning, CalendarManager, EventBus)
	harvest_system = load("res://scripts/core/systems/harvest_system.gd").new(tuning, CalendarManager, EventBus)
	ai_system = load("res://scripts/core/systems/simple_ai_system.gd").new(tuning, world_bounds, ticks_per_second, EventBus)

	# 生成静态实体
	_generate_static_entities()

	print("WorldManager 初始化完成，Tick频率: ", ticks_per_second, " Hz，实体数量: ", static_entities.size())

# --- 核心逻辑 ---

func _physics_process(delta: float) -> void:
	# 10Hz物理步进：所有生存逻辑在此运行
	_on_logic_tick(delta)

# 废弃旧的_process，所有逻辑迁移到_physics_process
func _process(_delta: float) -> void:
	# 保留空函数，避免Godot警告
	pass

# 10Hz逻辑步进中枢
func _on_logic_tick(delta: float) -> void:
	# 使用累加器确保固定步进
	accumulator += delta
	var tick_interval: float = 1.0 / ticks_per_second

	while accumulator >= tick_interval:
		accumulator -= tick_interval
		var start_time: float = Time.get_ticks_usec()
		tick_step()
		var end_time: float = Time.get_ticks_usec()
		var tick_duration: float = (end_time - start_time) / 1000.0  # 转换为毫秒

		# 统计 tick 耗时
		tick_time_accumulator += tick_duration
		tick_time_samples += 1

	# 律法时钟步进（基于真实时间，不受固定tick影响）
	_step_world_clock(delta)

	# 定期输出 debug 统计（已禁用以减少console混乱）
	# debug_timer += delta
	# if debug_timer >= debug_update_interval:
	# 	debug_timer = 0.0
	# 	_print_debug_stats()

# --- 静态实体系统 ---

# 生成静态实体（热源、资源点等）
func _generate_static_entities() -> void:
	# 清空现有静态实体
	static_entities.clear()

	# 生成热源
	_generate_heat_sources()

	# 生成资源点
	_generate_resource_entities()

	# print("[WorldManager] 静态实体生成完成，共生成 ", static_entities.size(), " 个静态实体")

# 生成热源
func _generate_heat_sources() -> void:
	# 随机生成热源
	var heat_source_count: int = randi() % (tuning.spawn_heat_source_count_max - tuning.spawn_heat_source_count_min + 1) + tuning.spawn_heat_source_count_min

	for i in range(heat_source_count):
		var heat_source: StaticEntityData = StaticEntityData.new()
		heat_source.type = "heat_source"
		heat_source.position = _get_random_position_within_bounds()
		heat_source.effect_radius = randf_range(80.0, 120.0)  # 随机半径80-120
		heat_source.heat_strength = randf_range(0.8, 1.2)     # 随机强度0.8-1.2

		static_entities.append(heat_source)

		# 发送信号通知View层生成视觉表现
		EventBus.static_entity_spawned.emit(heat_source)

		# print("[WorldManager] 生成热源: ", heat_source.get_debug_info())

# 获取世界边界内的随机位置
func _get_random_position_within_bounds() -> Vector2:
	var x: float = randf_range(world_bounds.position.x + 50, world_bounds.position.x + world_bounds.size.x - 50)
	var y: float = randf_range(world_bounds.position.y + 50, world_bounds.position.y + world_bounds.size.y - 50)
	return Vector2(x, y)

# 更新玩家与静态实体的邻近效果
func _update_proximity_effects(player_data: EntityData) -> void:
	# 热源检测
	var found_heat: bool = false

	for static_ent in static_entities:
		if static_ent.type == "heat_source":
			var dist: float = player_data.position.distance_to(static_ent.position)
			if dist < static_ent.effect_radius:
				found_heat = true
				break

	# 更新玩家热源状态
	var was_near_heat: bool = player_data.is_near_heat_source
	player_data.is_near_heat_source = found_heat

	# 状态变更反馈
	if was_near_heat != found_heat:
		if found_heat:
			# print("[WorldManager] 玩家进入热源范围，体温开始回升")
			EventBus.announcement.emit("感受到温暖，体温回升中...")
		else:
			# print("[WorldManager] 玩家离开热源范围")
			EventBus.announcement.emit("离开温暖区域，注意体温")

# 获取玩家实体（辅助函数）
func _get_player_entity() -> EntityData:
	for entity in entities:
		if entity.entity_type == "player":
			return entity
	return null

# --- 资源采集系统（已拆分到 HarvestSystem）---

# 采集资源
func harvest_resource(player_data: EntityData) -> void:
	if harvest_system != null:
		harvest_system.harvest_resource(player_data, static_entities)

# 生成资源点（在静态实体生成函数中添加）
func _generate_resource_entities() -> void:
	# 生成资源点
	var resource_count: int = randi() % (tuning.spawn_resource_count_max - tuning.spawn_resource_count_min + 1) + tuning.spawn_resource_count_min

	for i in range(resource_count):
		var resource: StaticEntityData = StaticEntityData.new()
		resource.type = "resource"
		resource.position = _get_random_position_within_bounds()
		resource.resource_amount = randf_range(50.0, 100.0)  # 随机储量
		resource.resource_type = "wood"  # 暂时固定为木材

		static_entities.append(resource)

		# 发送信号通知View层生成视觉表现
		EventBus.static_entity_spawned.emit(resource)

		# print("[WorldManager] 生成资源点: ", resource.get_debug_info())

	# print("[WorldManager] 资源点生成完成，共生成 ", resource_count, " 个资源点")


# world_manager.gd 中的核心逻辑更新
func tick_step() -> void:
	current_tick += 1

	# 使用代谢系统处理所有实体
	if metabolism_system != null:
		metabolism_system.process_entities(entities, ticks_per_second)

	# 使用温度系统处理所有实体
	if temperature_system != null:
		temperature_system.process_entities(entities, ticks_per_second)

	# 使用AI系统处理机械体
	if ai_system != null:
		ai_system.process_entities(entities)

	# 处理其他逻辑
	for entity in entities:
		if not is_instance_valid(entity):
			continue

		# 1. 基础演化 (变老)
		entity.age_step(1)

		# 2. 玩家状态同步（仅对玩家实体）
		if entity.entity_type == "player":
			EventBus.player_stat_updated.emit("energy", entity.energy)
			EventBus.player_stat_updated.emit("health", entity.health)
			EventBus.player_stat_updated.emit("temperature", entity.temperature)

	world_ticked.emit(current_tick)

	# 更新玩家与静态实体的邻近效果
	var player_entity: EntityData = _get_player_entity()
	if player_entity != null:
		_update_proximity_effects(player_entity)

# --- 律法时钟系统 ---


# 世界时钟步进函数
func _step_world_clock(delta: float) -> void:
	# 累加世界时间
	world_time += delta

	# 检查是否到达新的一天
	if world_time >= day_length_seconds:
		world_time = 0.0
		CalendarManager.advance_day()

	# 计算时间比例并更新昼夜状态
	var time_ratio: float = world_time / day_length_seconds
	CalendarManager.update_time_phase(time_ratio)
	world_clock_updated.emit(CalendarManager.day_count, time_ratio, CalendarManager.is_night)


func player_attack(
	attacker: EntityData,
	facing_direction: Vector2,
	attack_radius: float,
	attack_angle: float,
	base_damage: float
) -> int:
	if combat_system != null:
		return combat_system.player_attack(attacker, facing_direction, attack_radius, attack_angle, base_damage, entities)
	return 0


# --- 代谢系统（已拆分到 MetabolismSystem）---
# --- 体温系统（已拆分到 TemperatureSystem）---

# --- AI系统（已拆分到 SimpleAISystem）---


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
	world_data.save_timestamp = int(Time.get_unix_time_from_system())

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
		load_path, "", ResourceLoader.CACHE_MODE_IGNORE
	)

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
				var push: Vector2 = (
					(subject.position - entity.position).normalized() * (min_dist - d)
				)

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

# --- Debug 统计函数 ---

# 打印 debug 统计信息
func _print_debug_stats() -> void:
	if tick_time_samples == 0:
		return

	var avg_tick_time: float = tick_time_accumulator / tick_time_samples
	var total_entity_count: int = entities.size()
	var player_count: int = 0
	var organic_count: int = 0
	var mechanical_count: int = 0
	var static_count: int = 0

	# 统计各类型实体数量
	for entity in entities:
		if entity.entity_type == "player":
			player_count += 1
		elif entity.entity_type == "organic":
			organic_count += 1
		elif entity.entity_type == "mechanical":
			mechanical_count += 1
		elif entity.entity_type == "static":
			static_count += 1

	static_count += static_entities.size()

	print("--- WorldManager Debug Stats ---")
	print("Tick: ", current_tick, " | Avg Tick Time: ", "%.3f" % avg_tick_time, "ms")
	print("Entities: ", total_entity_count, " (Player:", player_count, " Organic:", organic_count, " Mechanical:", mechanical_count, " Static:", static_count, ")")
	print("--------------------------------")

	# 重置统计器
	tick_time_accumulator = 0.0
	tick_time_samples = 0

# --- 辅助数据容器 ---

# ## 世界保存数据容器类
# class WorldSaveData extends Resource:
# 	@export var entities: Array[EntityData] = []
# 	@export var current_tick: int = 0
# 	@export var save_timestamp: int = 0
