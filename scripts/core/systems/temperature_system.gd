# res://scripts/core/systems/temperature_system.gd
class_name TemperatureSystem
extends RefCounted

## 温度系统
## 负责处理实体的体温变化、失温伤害等逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager
var event_bus: EventBus

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager, p_event_bus: EventBus):
	tuning = p_tuning
	calendar_manager = p_calendar_manager
	event_bus = p_event_bus

## 处理单个实体的温度逻辑
func process_temperature(entity: EntityData, ticks_per_second: float) -> void:
	# 跳过静态障碍物
	if entity.entity_type == "static":
		return

	# 体温变化速率（每秒）
	var temperature_change: float = 0.0

	# 环境影响：夜晚失温
	if calendar_manager.is_night and not entity.is_near_heat_source:
		temperature_change = tuning.temp_night_change

	# 热源恢复：靠近热源时回温
	if entity.is_near_heat_source:
		temperature_change = tuning.temp_heat_source_change

	# 应用体温变化
	entity.temperature += temperature_change / ticks_per_second

	# 体温限制：正常体温范围
	entity.temperature = clamp(entity.temperature, tuning.temp_min, tuning.temp_max)

	# 失温惩罚：体温过低时扣除生命值
	if entity.temperature < tuning.temp_hypothermia_threshold:
		var hypothermia_damage: float = (tuning.temp_hypothermia_threshold - entity.temperature) * tuning.temp_hypothermia_damage_multiplier
		entity.health -= hypothermia_damage
		entity.health = max(0.0, entity.health)
		
		# 如果是玩家，发出状态更新信号
		if entity.entity_type == "player":
			event_bus.player_stat_updated.emit("health", entity.health)

## 处理多个实体的温度逻辑
func process_entities(entities: Array[EntityData], ticks_per_second: float) -> void:
	for entity in entities:
		if not is_instance_valid(entity):
			continue
		process_temperature(entity, ticks_per_second)
