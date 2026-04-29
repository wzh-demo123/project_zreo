# res://scripts/core/world_tuning.gd
class_name WorldTuning
extends Resource

## 世界平衡参数配置
## 作用：集中管理所有游戏平衡参数，支持编辑器内调整

# --- 代谢系统参数 ---
@export_group("Metabolism", "metabolism_")
@export var metabolism_base_rate: float = 0.05          # 基础代谢速率（每秒能量消耗）
@export var metabolism_night_multiplier: float = 1.5    # 夜晚代谢倍率
@export var metabolism_travel_penalty: float = 5.0      # 忌出行时的移动惩罚倍率
@export var metabolism_starvation_damage: float = 0.1   # 空腹伤害（每秒生命扣除）

# --- 温度系统参数 ---
@export_group("Temperature", "temp_")
@export var temp_night_change: float = -0.5             # 夜晚体温变化（每秒）
# [热源系统已禁用] @export var temp_heat_source_change: float = 1.0        # 热源附近体温变化（每秒）
@export var temp_min: float = 20.0                      # 最低体温限制
@export var temp_max: float = 36.5                      # 最高体温限制
@export var temp_hypothermia_threshold: float = 30.0    # 失温伤害阈值
@export var temp_hypothermia_damage_multiplier: float = 0.05  # 失温伤害系数

# --- 战斗系统参数 ---
@export_group("Combat", "combat_")
@export var combat_player_damage: float = 30.0          # 玩家基础伤害
@export var combat_cooldown: float = 0.4                # 攻击冷却时间
@export var combat_radius: float = 40.0                 # 攻击半径
@export var combat_angle: float = 90.0                  # 攻击角度
@export var combat_mechanical_damage: float = 5.0       # 机械体伤害
@export var combat_mechanical_heal: float = 2.0         # 机械体吸血量
@export var combat_mechanical_detection_range: float = 400.0  # 机械体感知范围
@export var combat_mechanical_attack_range: float = 10.0     # 机械体攻击范围
@export var combat_mechanical_move_threshold: float = 5.0     # 机械体移动阈值
@export var combat_knockback_distance: float = 50.0           # 击退距离（像素）
@export var combat_knockback_duration: float = 0.15           # 击退持续时间（秒）

# --- 视觉特效参数 ---
@export_group("Visual", "visual_")
@export var visual_hit_flash_duration: float = 0.1            # 受击红光持续时间（秒）
@export var visual_hit_flash_intensity: float = 0.8           # 受击红光强度（0-1）
@export var visual_hit_shake_amount: float = 3.0              # 受击屏幕震动幅度（像素）

# --- 采集系统参数 ---
@export_group("Harvest", "harvest_")
@export var harvest_distance: float = 100.0             # 采集距离
@export var harvest_base_gain: float = 10.0             # 基础采集收益
@export var harvest_taboo_bonus_multiplier: float = 2.0 # 宜挖掘加成倍率
@export var harvest_energy_max: float = 100.0           # 能量上限

# --- 禁忌系统参数 ---
@export_group("Taboo", "taboo_")
@export var taboo_killing_damage_penalty: float = 0.5   # 忌杀生伤害惩罚倍率

# --- 实体生成参数 ---
@export_group("Spawn", "spawn_")
@export var spawn_organic_count: int = 20               # 有机体生成数量
@export var spawn_mechanical_count: int = 3             # 机械体生成数量
@export var spawn_static_obstacle_count: int = 15       # 静态障碍物数量
# [热源系统已禁用] @export var spawn_heat_source_count_min: int = 3        # 热源最小数量
# [热源系统已禁用] @export var spawn_heat_source_count_max: int = 5        # 热源最大数量
@export var spawn_resource_count_min: int = 2           # 资源点最小数量
@export var spawn_resource_count_max: int = 4           # 资源点最大数量
@export var spawn_range: Vector2 = Vector2(1000, 1000)  # 生成区域范围

# --- 实体属性参数 ---
@export_group("Entity", "entity_")
@export var entity_organic_health: float = 50.0         # 有机体初始生命
@export var entity_mechanical_health: float = 150.0     # 机械体初始生命
@export var entity_static_health: float = 9999.0        # 静态障碍物生命
@export var entity_collision_radius_min: float = 30.0   # 障碍物最小碰撞半径
@export var entity_collision_radius_max: float = 50.0   # 障碍物最大碰撞半径
