# res://scripts/core/systems/metabolism_system.gd
class_name MetabolismSystem
extends RefCounted

## 代谢系统
## 负责处理实体的能量消耗、空腹伤害等逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager
var event_bus: EventBus

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager, p_event_bus: EventBus):
	tuning = p_tuning
	calendar_manager = p_calendar_manager
	event_bus = p_event_bus

## 计算实体速度（通过前后帧位置差）
func _calculate_entity_velocity(entity: EntityData, ticks_per_second: float) -> Vector2:
	# 计算当前位置与上一帧位置的差值
	var displacement: Vector2 = entity.position - entity.last_position

	# 更新上一帧位置（为下一帧计算做准备）
	entity.last_position = entity.position

	# 返回位移向量（每秒位移量）
	return displacement * ticks_per_second

## 处理单个实体的代谢逻辑
func process_metabolism(entity: EntityData, ticks_per_second: float) -> void:
	# 跳过静态障碍物
	if entity.entity_type == "static":
		return

	# 计算真实位移速度（基于前后帧位置差）
	var velocity: Vector2 = _calculate_entity_velocity(entity, ticks_per_second)

	# 基础代谢速率（每秒消耗）
	var base_metabolic_rate: float = tuning.metabolism_base_rate

	# 环境压迫：夜晚代谢加速
	if calendar_manager.is_night:
		base_metabolic_rate *= tuning.metabolism_night_multiplier

	# 禁忌惩罚：忌出行时的移动惩罚
	var movement_multiplier: float = 1.0
	if calendar_manager.current_taboo == CalendarManager.Taboo.AVOID_TRAVEL:
		if velocity.length() > 0.1:  # 如果实体正在移动
			movement_multiplier = tuning.metabolism_travel_penalty

	# 计算总能量消耗
	var energy_consumption: float = base_metabolic_rate * movement_multiplier

	# 应用能量消耗
	entity.energy = max(0.0, entity.energy - energy_consumption)

	# 空腹惩罚：能量耗尽时扣除生命值
	if entity.energy <= 0.0:
		entity.health -= tuning.metabolism_starvation_damage  # 每秒扣除生命值
		entity.health = max(0.0, entity.health)
		
		# 如果是玩家，发出状态更新信号
		if entity.entity_type == "player":
			event_bus.player_stat_updated.emit("health", entity.health)

## 处理多个实体的代谢逻辑
func process_entities(entities: Array[EntityData], ticks_per_second: float) -> void:
	for entity in entities:
		if not is_instance_valid(entity):
			continue
		process_metabolism(entity, ticks_per_second)
