# res://scripts/core/systems/combat_system.gd
class_name CombatSystem
extends RefCounted

## 战斗系统
## 负责处理攻击判定、伤害计算等逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager
var event_bus: EventBus

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager, p_event_bus: EventBus):
	tuning = p_tuning
	calendar_manager = p_calendar_manager
	event_bus = p_event_bus

## 处理玩家攻击
func player_attack(
	attacker: EntityData,
	facing_direction: Vector2,
	attack_radius: float,
	attack_angle: float,
	base_damage: float,
	entities: Array[EntityData]
) -> int:
	if attacker == null or attacker.health <= 0.0:
		return 0

	var hit_origin: Vector2 = attacker.position
	var hit_dir: Vector2 = facing_direction.normalized()
	if hit_dir == Vector2.ZERO:
		hit_dir = Vector2.RIGHT

	var final_damage: float = base_damage
	if calendar_manager.current_taboo == CalendarManager.Taboo.AVOID_KILLING:
		final_damage *= tuning.taboo_killing_damage_penalty

	var hit_count: int = 0
	for entity in entities:
		if entity == null or entity == attacker or entity.health <= 0.0:
			continue
		if entity.position.distance_to(hit_origin) > attack_radius:
			continue

		var dir_to_enemy: Vector2 = (entity.position - hit_origin).normalized()
		var angle_diff: float = rad_to_deg(hit_dir.angle_to(dir_to_enemy))
		if abs(angle_diff) > attack_angle / 2.0:
			continue

		entity.health -= final_damage
		hit_count += 1
		event_bus.entity_damaged.emit(entity, final_damage, hit_origin)

		# 如果受伤的是玩家，额外发出玩家状态更新信号
		if entity.entity_type == "player":
			event_bus.player_stat_updated.emit("health", entity.health)

	return hit_count
