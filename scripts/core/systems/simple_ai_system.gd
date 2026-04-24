# res://scripts/core/systems/simple_ai_system.gd
class_name SimpleAISystem
extends RefCounted

## 简单AI系统
## 负责处理机械体的AI行为

var tuning: WorldTuning
var world_bounds: Rect2
var ticks_per_second: float

func _init(p_tuning: WorldTuning, p_world_bounds: Rect2, p_ticks_per_second: float):
	tuning = p_tuning
	world_bounds = p_world_bounds
	ticks_per_second = p_ticks_per_second

## 处理机械体AI（针对 MX110 优化的数组查找逻辑）
func process_mechanical_ai(hunter: EntityData, entities: Array[EntityData]) -> void:
	# 1. 寻找最近的猎物（玩家优先级）
	var nearest_prey: EntityData = null
	var min_dist = tuning.combat_mechanical_detection_range  # 感知范围

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
		# 只有当距离大于阈值时才真正执行移动
		# 这样可以防止在目标点附近"反复横跳"
		if min_dist > tuning.combat_mechanical_move_threshold:
			var dir = (nearest_prey.position - hunter.position).normalized()
			# 计算本次 tick 的位移量
			var tick_interval: float = 1.0 / ticks_per_second
			var movement = dir * hunter.move_speed * tick_interval
			hunter.position += movement

		# --- 核心改进：伤害逻辑 ---
		# 只有足够近才吸血
		if min_dist < tuning.combat_mechanical_attack_range:
			nearest_prey.health -= tuning.combat_mechanical_damage  # 有机体扣血
			hunter.health = min(100.0, hunter.health + tuning.combat_mechanical_heal)  # 机械体回血

	# 【重要修复】无论有没有猎物，都得守法（不穿墙、不撞墙）
	hunter.position = _clamp_position(hunter.position)

## 处理所有机械体AI
func process_entities(entities: Array[EntityData]) -> void:
	for entity in entities:
		if not is_instance_valid(entity):
			continue
		if entity.entity_type == "mechanical":
			process_mechanical_ai(entity, entities)

## 位置限制函数
func _clamp_position(pos: Vector2) -> Vector2:
	# 返回世界边界限制后的坐标
	return pos.clamp(world_bounds.position, world_bounds.position + world_bounds.size)
