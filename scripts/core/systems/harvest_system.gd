# res://scripts/core/systems/harvest_system.gd
class_name HarvestSystem
extends RefCounted

## 采集系统
## 负责处理资源采集逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager
var event_bus: EventBus

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager, p_event_bus: EventBus):
	tuning = p_tuning
	calendar_manager = p_calendar_manager
	event_bus = p_event_bus

## 查找最近的资源点
func _find_nearest_resource(player_pos: Vector2, static_entities: Array[StaticEntityData]) -> StaticEntityData:
	var nearest_resource: StaticEntityData = null
	var min_distance: float = tuning.harvest_distance

	for static_ent in static_entities:
		# 只检查资源类型且未耗尽的实体
		if static_ent.type == "resource" and not static_ent.is_depleted:
			var distance: float = player_pos.distance_to(static_ent.position)
			if distance < min_distance:
				min_distance = distance
				nearest_resource = static_ent

	return nearest_resource

## 采集资源
func harvest_resource(player_data: EntityData, static_entities: Array[StaticEntityData]) -> void:
	var nearest_resource: StaticEntityData = _find_nearest_resource(player_data.position, static_entities)

	if nearest_resource == null:
		print("[HarvestSystem] 附近没有可采集的资源")
		event_bus.announcement.emit("附近没有可采集的资源")
		return

	# 计算采集收益
	var harvest_gain: float = tuning.harvest_base_gain

	# 禁忌加成：宜挖掘时收益翻倍
	if calendar_manager.current_taboo == CalendarManager.Taboo.SUIT_DIGGING:
		harvest_gain *= tuning.harvest_taboo_bonus_multiplier
		print("[HarvestSystem] 禁忌加成：采集收益翻倍！")
		event_bus.announcement.emit("宜挖掘：采集效率翻倍！")

	# 采集资源
	nearest_resource.resource_amount -= harvest_gain

	# 更新玩家能量
	player_data.energy += harvest_gain
	player_data.energy = min(player_data.energy, tuning.harvest_energy_max)

	# 发送状态更新信号
	event_bus.player_stat_updated.emit("energy", player_data.energy)
	event_bus.resource_harvested.emit(player_data, harvest_gain)

	print("[HarvestSystem] 采集成功！获得能量: ", harvest_gain, " 剩余资源: ", nearest_resource.resource_amount)
	event_bus.announcement.emit("采集成功！获得能量: " + str(harvest_gain))

	# 检查资源是否耗尽
	if nearest_resource.resource_amount <= 0.0:
		nearest_resource.is_depleted = true
		print("[HarvestSystem] 资源耗尽: ", nearest_resource.id)
		event_bus.static_entity_depleted.emit(nearest_resource)
		event_bus.announcement.emit("资源已耗尽")
