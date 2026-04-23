# res://scripts/ui/debug_hud.gd
extends CanvasLayer

## 调试HUD界面
## 作用：实时显示玩家生存状态数据，用于开发和调试

# --- 内部状态 ---
var announcement_timer: float = 0.0
var current_day: int = 1
var current_time_ratio: float = 0.0

# --- UI节点引用 ---
@onready var time_label: Label = $VBoxContainer/TimeLabel
@onready var taboo_label: Label = $VBoxContainer/TabooLabel
@onready var health_label: Label = $VBoxContainer/HealthLabel
@onready var energy_label: Label = $VBoxContainer/EnergyLabel
@onready var temp_label: Label = $VBoxContainer/TempLabel
@onready var announcement_label: Label = $VBoxContainer/AnnouncementLabel

# --- 初始化 ---
func _ready() -> void:
	# 订阅EventBus信号
	EventBus.player_stat_updated.connect(_on_stat_updated)
	EventBus.taboo_changed.connect(_on_taboo_updated)
	EventBus.time_phase_changed.connect(_on_time_phase_changed)
	EventBus.announcement.connect(_on_announcement)

	# 初始化UI状态
	_update_time_display()

	print("[DebugHUD] 调试界面初始化完成")

# --- 每帧更新 ---
func _process(delta: float) -> void:
	# 更新公告显示计时器
	if announcement_timer > 0.0:
		announcement_timer -= delta
		if announcement_timer <= 0.0:
			announcement_label.text = ""

	# 更新时间显示（模拟实时时钟）
	_update_time_display()

# --- 信号处理函数 ---

# 玩家状态更新
func _on_stat_updated(key: String, value: float) -> void:
	match key:
		"health":
			health_label.text = "生命: %.1f" % value
			# 血量低于30%时变红色警告
			if value < 30.0:
				health_label.modulate = Color(1.0, 0.3, 0.3)
			else:
				health_label.modulate = Color(1.0, 1.0, 1.0)

		"energy":
			energy_label.text = "能量: %.1f" % value
			# 能量低于20%时变黄色警告
			if value < 20.0:
				energy_label.modulate = Color(1.0, 1.0, 0.3)
			else:
				energy_label.modulate = Color(1.0, 1.0, 1.0)

		"temperature":
			temp_label.text = "体温: %.1f°C" % value
			# 体温低于30°C时变蓝色警告
			if value < 30.0:
				temp_label.modulate = Color(0.3, 0.3, 1.0)
			else:
				temp_label.modulate = Color(1.0, 1.0, 1.0)

# 禁忌更新
func _on_taboo_updated(taboo: int) -> void:
	var taboo_name: String = _get_taboo_name(taboo)
	taboo_label.text = "今日禁忌: " + taboo_name

	# 禁忌变更时显示特殊颜色
	taboo_label.modulate = Color(1.0, 0.8, 0.2)

	# 3秒后恢复原色
	var timer: SceneTreeTimer = get_tree().create_timer(3.0)
	timer.timeout.connect(_reset_taboo_color)

# 昼夜变更
func _on_time_phase_changed(is_night: bool) -> void:
	# 更新背景颜色表示昼夜
	if is_night:
		time_label.modulate = Color(0.7, 0.7, 1.0)  # 夜晚蓝色
	else:
		time_label.modulate = Color(1.0, 1.0, 1.0)  # 白天白色

# 公告信息
func _on_announcement(text: String) -> void:
	announcement_label.text = text
	announcement_timer = 5.0  # 显示5秒

# --- 辅助函数 ---

# 更新时间显示
func _update_time_display() -> void:
	# 模拟时间显示（实际应该从CalendarManager获取）
	var minutes: int = int(current_time_ratio * 24 * 60) % (24 * 60)
	var hours: int = minutes / 60
	var mins: int = minutes % 60

	time_label.text = "时间: 第%d天 - %02d:%02d" % [current_day, hours, mins]

	# 模拟时间流逝（用于演示）
	current_time_ratio += 0.0001  # 非常缓慢的时间流逝
	if current_time_ratio >= 1.0:
		current_time_ratio = 0.0
		current_day += 1

# 获取禁忌名称
func _get_taboo_name(taboo: int) -> String:
	match taboo:
		0:
			return "无禁忌"
		1:
			return "忌出行"
		2:
			return "忌杀生"
		3:
			return "宜挖掘"
		_:
			return "未知禁忌"

# 重置禁忌标签颜色
func _reset_taboo_color() -> void:
	taboo_label.modulate = Color(1.0, 1.0, 1.0)

# 调试功能：手动更新状态（用于测试）
func update_debug_info(health: float, energy: float, temp: float) -> void:
	health_label.text = "生命: %.1f" % health
	energy_label.text = "能量: %.1f" % energy
	temp_label.text = "体温: %.1f°C" % temp