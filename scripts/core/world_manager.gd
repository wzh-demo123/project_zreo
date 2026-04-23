# res://scripts/core/world_manager.gd
# class_name WorldManager
extends Node

## 世界管理器单例
## 负责：时间步进、实体数据持有、存档序列化

# --- 信号 ---
signal world_ticked(tick_count: int)
signal world_loaded  # 世界加载完成信号

# --- 配置 ---
@export_group("Simulation")
@export var ticks_per_second: float = 10.0
@export var world_bounds: Rect2 = Rect2(-600, -400, 1200, 800)  # 世界边界矩形

# --- 律法时钟配置 ---
@export_group("Time System")
@export var day_length_seconds: float = 600.0  # 10分钟一个昼夜周期

# --- 资源系统配置 ---
@export_group("Resource System")
@export var harvest_distance: float = 100.0  # 采集距离
@export var base_harvest_gain: float = 10.0  # 基础采集收益

# --- 运行时数据 ---
var entities: Array[EntityData] = []
var static_entities: Array[StaticEntityData] = []  # 静态实体数组
var current_tick: int = 0
var accumulator: float = 0.0
var world_time: float = 0.0  # 世界时间（秒）

# --- 初始化 ---
func _ready() -> void:
	# 生成静态实体
	_generate_static_entities()

	print("WorldManager 初始化完成")
	print("固定Tick频率: ", ticks_per_second, " Hz")
	print("世界边界: ", world_bounds)
	print("静态实体数量: ", static_entities.size())

# --- 核心逻辑 ---

func _physics_process(delta: float) -> void:
	# 10Hz物理步进：所有生存逻辑在此运行
	_on_logic_tick(delta)

# 废弃旧的_process，所有逻辑迁移到_physics_process
func _process(delta: float) -> void:
	# 保留空函数，避免Godot警告
	pass

# 10Hz逻辑步进中枢
func _on_logic_tick(delta: float) -> void:
	# 使用累加器确保固定步进
	accumulator += delta
	var tick_interval: float = 1.0 / ticks_per_second

	while accumulator >= tick_interval:
		accumulator -= tick_interval
		tick_step()

	# 律法时钟步进（基于真实时间，不受固定tick影响）
	_step_world_clock(delta)

# --- 静态实体系统 ---

# 生成静态实体（热源、资源点等）
func _generate_static_entities() -> void:
	# 清空现有静态实体
	static_entities.clear()

	# 生成热源
	_generate_heat_sources()

	# 生成资源点
	_generate_resource_entities()

	print("[WorldManager] 静态实体生成完成，共生成 ", static_entities.size(), " 个静态实体")

# 生成热源
func _generate_heat_sources() -> void:
	# 随机生成3-5个热源
	var heat_source_count: int = randi() % 3 + 3  # 3-5个

	for i in range(heat_source_count):
		var heat_source: StaticEntityData = StaticEntityData.new()
		heat_source.type = "heat_source"
		heat_source.position = _get_random_position_within_bounds()
		heat_source.effect_radius = randf_range(80.0, 120.0)  # 随机半径80-120
		heat_source.heat_strength = randf_range(0.8, 1.2)     # 随机强度0.8-1.2

		static_entities.append(heat_source)

		# 发送信号通知View层生成视觉表现
		EventBus.static_entity_spawned.emit(heat_source)

		print("[WorldManager] 生成热源: ", heat_source.get_debug_info())

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
			print("[WorldManager] 玩家进入热源范围，体温开始回升")
			EventBus.announcement.emit("感受到温暖，体温回升中...")
		else:
			print("[WorldManager] 玩家离开热源范围")
			EventBus.announcement.emit("离开温暖区域，注意体温")

# 获取玩家实体（辅助函数）
func _get_player_entity() -> EntityData:
	for entity in entities:
		if entity.entity_type == "player":
			return entity
	return null

# --- 资源采集系统 ---

# 查找最近的资源点
func _find_nearest_resource(player_pos: Vector2) -> StaticEntityData:
	var nearest_resource: StaticEntityData = null
	var min_distance: float = harvest_distance

	for static_ent in static_entities:
		# 只检查资源类型且未耗尽的实体
		if static_ent.type == "resource" and not static_ent.is_depleted:
			var distance: float = player_pos.distance_to(static_ent.position)
			if distance < min_distance:
				min_distance = distance
				nearest_resource = static_ent

	return nearest_resource

# 采集资源
func harvest_resource(player_data: EntityData) -> void:
	var nearest_resource: StaticEntityData = _find_nearest_resource(player_data.position)

	if nearest_resource == null:
		print("[WorldManager] 附近没有可采集的资源")
		EventBus.announcement.emit("附近没有可采集的资源")
		return

	# 计算采集收益
	var harvest_gain: float = base_harvest_gain

	# 禁忌加成：宜挖掘时收益翻倍
	if CalendarManager.current_taboo == CalendarManager.Taboo.SUIT_DIGGING:
		harvest_gain *= 2.0
		print("[WorldManager] 禁忌加成：采集收益翻倍！")
		EventBus.announcement.emit("宜挖掘：采集效率翻倍！")

	# 采集资源
	nearest_resource.resource_amount -= harvest_gain

	# 更新玩家能量
	player_data.energy += harvest_gain
	player_data.energy = min(player_data.energy, 100.0)  # 上限100

	# 发送状态更新信号
	EventBus.player_stat_updated.emit("energy", player_data.energy)
	EventBus.resource_harvested.emit(player_data, harvest_gain)

	print("[WorldManager] 采集成功！获得能量: ", harvest_gain, " 剩余资源: ", nearest_resource.resource_amount)
	EventBus.announcement.emit("采集成功！获得能量: " + str(harvest_gain))

	# 检查资源是否耗尽
	if nearest_resource.resource_amount <= 0.0:
		nearest_resource.is_depleted = true
		print("[WorldManager] 资源耗尽: ", nearest_resource.id)
		EventBus.static_entity_depleted.emit(nearest_resource)
		EventBus.announcement.emit("资源已耗尽")

# 生成资源点（在静态实体生成函数中添加）
func _generate_resource_entities() -> void:
	# 生成2-4个资源点
	var resource_count: int = randi() % 3 + 2  # 2-4个

	for i in range(resource_count):
		var resource: StaticEntityData = StaticEntityData.new()
		resource.type = "resource"
		resource.position = _get_random_position_within_bounds()
		resource.resource_amount = randf_range(50.0, 100.0)  # 随机储量
		resource.resource_type = "wood"  # 暂时固定为木材

		static_entities.append(resource)

		# 发送信号通知View层生成视觉表现
		EventBus.static_entity_spawned.emit(resource)

		print("[WorldManager] 生成资源点: ", resource.get_debug_info())

	print("[WorldManager] 资源点生成完成，共生成 ", resource_count, " 个资源点")


# world_manager.gd 中的核心逻辑更新
func tick_step() -> void:
	current_tick += 1

	for entity in entities:
		if not is_instance_valid(entity):
			continue

		# 1. 基础演化 (变老)
		entity.age_step(1)

		# 2. 代谢系统处理
		_handle_metabolism(entity)

		# 3. 简单的 AI 决策：机械体捕食逻辑
		if entity.entity_type == "mechanical":
			_handle_mechanical_ai(entity)

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


# --- 代谢系统 ---


# 代谢解算器：处理能量消耗和禁忌惩罚
func _handle_metabolism(entity: EntityData) -> void:
	# 跳过静态障碍物
	if entity.entity_type == "static":
		return

	# 计算真实位移速度（基于前后帧位置差）
	var velocity: Vector2 = _calculate_entity_velocity(entity)

	# 基础代谢速率（每秒消耗）
	var base_metabolic_rate: float = 0.05

	# 环境压迫：夜晚代谢加速
	if CalendarManager.is_night:
		base_metabolic_rate *= 1.5

	# 禁忌惩罚：忌出行时的移动惩罚
	var movement_multiplier: float = 1.0
	if CalendarManager.current_taboo == CalendarManager.Taboo.AVOID_TRAVEL:
		if velocity.length() > 0.1:  # 如果实体正在移动
			movement_multiplier = 5.0  # 移动时能量消耗x5

	# 计算总能量消耗
	var energy_consumption: float = base_metabolic_rate * movement_multiplier

	# 应用能量消耗
	entity.energy = max(0.0, entity.energy - energy_consumption)

	# 空腹惩罚：能量耗尽时扣除生命值
	if entity.energy <= 0.0:
		entity.health -= 0.1  # 每秒扣除0.1生命值
		entity.health = max(0.0, entity.health)

	# 体温系统处理
	_handle_temperature(entity)

	# 玩家状态同步（仅对玩家实体）
	if entity.entity_type == "player":
		EventBus.player_stat_updated.emit("energy", entity.energy)
		EventBus.player_stat_updated.emit("health", entity.health)
		EventBus.player_stat_updated.emit("temperature", entity.temperature)

# 计算实体速度（通过前后帧位置差）
func _calculate_entity_velocity(entity: EntityData) -> Vector2:
	# 计算当前位置与上一帧位置的差值
	var displacement: Vector2 = entity.position - entity.last_position

	# 更新上一帧位置（为下一帧计算做准备）
	entity.last_position = entity.position

	# 返回位移向量（每秒位移量）
	return displacement * ticks_per_second

# 体温系统：处理环境温度影响
func _handle_temperature(entity: EntityData) -> void:
	# 跳过静态障碍物
	if entity.entity_type == "static":
		return

	# 体温变化速率（每秒）
	var temperature_change: float = 0.0

	# 环境影响：夜晚失温
	if CalendarManager.is_night and not entity.is_near_heat_source:
		temperature_change = -0.5  # 每秒下降0.5度

	# 热源恢复：靠近热源时回温
	if entity.is_near_heat_source:
		temperature_change = 1.0  # 每秒回升1.0度

	# 应用体温变化
	entity.temperature += temperature_change / ticks_per_second

	# 体温限制：正常体温范围
	entity.temperature = clamp(entity.temperature, 20.0, 36.5)

	# 失温惩罚：体温过低时扣除生命值
	if entity.temperature < 30.0:
		var hypothermia_damage: float = (30.0 - entity.temperature) * 0.05
		entity.health -= hypothermia_damage
		entity.health = max(0.0, entity.health)


# 针对 MX110 优化的数组查找逻辑
# world_manager.gd 中的修正版函数
func _handle_mechanical_ai(hunter: EntityData) -> void:
	# 1. 寻找最近的猎物（玩家优先级）
	var nearest_prey: EntityData = null
	var min_dist = 400.0  # 感知范围

	for target in entities:
		# 跳过无效目标
		if target.health <= 0:
			continue

		var d: float = hunter.position.distance_to(target.position)
		if d > min_dist:
			continue

		# 判断目标类型
		var is_player: bool = target.entity_type == "player"
		var is_organic: bool = target.entity_type == "organic"

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
			nearest_prey.health -= 5.0  # 有机体扣血
			hunter.health = min(100.0, hunter.health + 2.0)  # 机械体回血

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

# --- 辅助数据容器 ---

# ## 世界保存数据容器类
# class WorldSaveData extends Resource:
# 	@export var entities: Array[EntityData] = []
# 	@export var current_tick: int = 0
# 	@export var save_timestamp: int = 0