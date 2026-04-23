# res://scripts/core/calendar_manager.gd
# 律法时钟管理器 - 零号协议 V0.2 核心组件
extends Node

## 律法时钟中枢
## 作用：管理世界时间、禁忌历法、昼夜交替，为硬核生存系统提供数学基础

# --- 禁忌枚举定义 ---
enum Taboo {
	NONE = 0,           # 无禁忌
	AVOID_TRAVEL = 1,   # 忌出行
	AVOID_KILLING = 2,  # 忌杀生
	SUIT_DIGGING = 3    # 宜挖掘
}

# --- 运行时状态 ---
var day_count: int = 1              # 当前天数
var current_taboo: Taboo = Taboo.NONE  # 当前禁忌
var is_night: bool = false          # 是否为夜晚

# --- 初始化 ---
func _ready() -> void:
	# 初始化随机种子
	randomize()

	# 生成初始禁忌
	advance_day()

	print("[CalendarManager] 律法时钟初始化完成")
	print("[CalendarManager] 初始天数: ", day_count, " | 初始禁忌: ", _get_taboo_name(current_taboo))

# --- 核心逻辑 ---

# 推进一天，生成新的禁忌
func advance_day() -> void:
	# 递增天数
	day_count += 1

	# 随机生成新禁忌
	var new_taboo: Taboo = Taboo.values()[randi() % Taboo.size()]
	current_taboo = new_taboo

	# 通过EventBus广播禁忌变更
	EventBus.taboo_changed.emit(current_taboo)

	# 发送全局公告
	var announcement_text: String = "第" + str(day_count) + "天 - " + _get_taboo_name(current_taboo)
	EventBus.announcement.emit(announcement_text)

	print("[CalendarManager] 新的一天开始: ", announcement_text)

# 更新昼夜状态
func update_time_phase(time_ratio: float) -> void:
	# 时间比例范围: 0.0-1.0 (0.0=日出, 0.5=正午, 1.0=次日日出)
	# 夜晚判定: 0.75-1.0 和 0.0-0.25 为夜晚
	var new_is_night: bool = (time_ratio > 0.75 or time_ratio < 0.25)

	# 如果昼夜状态发生变化
	if new_is_night != is_night:
		is_night = new_is_night

		# 通过EventBus广播昼夜变更
		EventBus.time_phase_changed.emit(is_night)

		# 发送昼夜变更公告
		var phase_name: String = "夜晚" if is_night else "白天"
		EventBus.announcement.emit("进入" + phase_name)

		print("[CalendarManager] 昼夜变更: ", phase_name)

# --- 辅助函数 ---

# 获取禁忌名称
func _get_taboo_name(taboo: Taboo) -> String:
	match taboo:
		Taboo.NONE:
			return "无禁忌"
		Taboo.AVOID_TRAVEL:
			return "忌出行"
		Taboo.AVOID_KILLING:
			return "忌杀生"
		Taboo.SUIT_DIGGING:
			return "宜挖掘"
		_:
			return "未知禁忌"

# 获取当前禁忌效果描述
func get_current_taboo_effects() -> Dictionary:
	match current_taboo:
		Taboo.AVOID_TRAVEL:
			return {"移动速度惩罚": 0.7, "说明": "今日不宜远行"}
		Taboo.AVOID_KILLING:
			return {"攻击伤害惩罚": 0.5, "说明": "今日忌杀生"}
		Taboo.SUIT_DIGGING:
			return {"采集效率加成": 1.5, "说明": "今日宜挖掘"}
		Taboo.NONE:
			return {"无效果": 1.0, "说明": "今日诸事皆宜"}
		_:
			return {}

# 获取当前时间信息
func get_time_info() -> Dictionary:
	return {
		"day_count": day_count,
		"current_taboo": current_taboo,
		"taboo_name": _get_taboo_name(current_taboo),
		"is_night": is_night,
		"time_phase": "夜晚" if is_night else "白天"
	}

# 调试信息输出
func print_debug_info() -> void:
	var info: Dictionary = get_time_info()
	print("[CalendarManager] 调试信息: ", info)