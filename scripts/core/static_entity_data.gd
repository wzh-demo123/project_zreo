# res://scripts/core/static_entity_data.gd
class_name StaticEntityData
extends Resource

## 静态实体数据模型
## 作用：定义不可移动的资源/设施数据，如热源、祭坛、资源点等

# --- 基础属性 ---
@export var id: String = ""                    # 实体唯一标识
@export var position: Vector2 = Vector2.ZERO    # 世界坐标位置
@export var type: String = "heat_source"        # 实体类型：热源、资源、祭坛等
@export var effect_radius: float = 100.0        # 作用半径

# --- 类型特定属性 ---
# [热源系统已禁用] @export var heat_strength: float = 1.0          # 热源强度（仅热源类型）
@export var resource_type: String = "wood"      # 资源类型（仅资源类型）
@export var resource_amount: float = 10.0       # 资源储量（仅资源类型）
@export var is_depleted: bool = false           # 是否已耗尽

# --- 初始化函数 ---
func _init() -> void:
	# 自动生成ID（如果未设置）
	if id.is_empty():
		id = "static_" + str(randi() % 10000)

# --- 辅助函数 ---

# 获取实体类型描述
func get_type_description() -> String:
	match type:
		# [热源系统已禁用] "heat_source":
		#	return "热源（温暖区域）"
		"resource":
			return "资源点（" + resource_type + "）"
		"altar":
			return "祭坛（神秘力量）"
		_:
			return "未知类型"

# 检查位置是否在作用范围内
func is_position_in_range(check_pos: Vector2) -> bool:
	return position.distance_to(check_pos) <= effect_radius

# 获取调试信息
func get_debug_info() -> Dictionary:
	return {
		"id": id,
		"type": type,
		"position": position,
		"radius": effect_radius,
		"description": get_type_description()
	}