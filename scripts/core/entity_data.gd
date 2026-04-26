# res://scripts/core/entity_data.gd
class_name EntityData
extends Resource

@export var id: String = ""
@export var entity_type: String = "unknown"
@export var faction: String = "neutral"
@export var health: float = 100.0
@export var max_health: float = 100.0  # 最大生命值
@export var position: Vector2 = Vector2.ZERO
@export var age_ticks: int = 0

# --- 新增：生存与博弈属性 ---
@export var move_speed: float = 50.0  # 移动速度
@export var energy: float = 100.0     # 饥饿/能量
@export var max_energy: float = 100.0 # 最大能量值
@export var collision_radius: float = 20.0  # 碰撞半径

# --- 新增：速度检测与体温系统 ---
@export var last_position: Vector2 = Vector2.ZERO # 用于计算真实位移
@export var temperature: float = 36.5              # 当前体温
@export var is_near_heat_source: bool = false      # 是否靠近热源（由 WorldManager 判定）

func age_step(ticks: int) -> void:
	age_ticks += ticks

	match entity_type:
		"organic":
			health = max(0.0, health - ticks * 0.01)
		"mechanical":
			# 机械体基础消耗
			energy = max(0.0, energy - ticks * 0.05)
			if energy <= 0:
				health -= ticks * 0.1
		"digital":
			pass
		"energy":
			var cycle = sin(age_ticks * 0.01)
			health = 100.0 + cycle * 20.0