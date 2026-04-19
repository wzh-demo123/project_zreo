# res://scripts/core/game_camera.gd
extends Camera2D

## 平滑跟随摄像机
## 作用：平滑追赶目标位置，且与实体层级完全解耦

@export var target_node: Node2D # 在编辑器里把红方块拖进来
@export var smooth_speed: float = 5.0 # 跟随的丝滑程度 (值越大越快)

# --- 初始化 ---
func _ready() -> void:
	# 连接世界加载信号，实现读档后的摄像机重绑
	WorldManager.world_loaded.connect(_on_world_loaded)

	print("[Camera] 摄像机初始化完成")

# 世界加载完成后的处理
func _on_world_loaded() -> void:
	print("[Camera] 收到世界加载信号，开始重绑玩家...")

	# 等待一帧，确保新玩家已经创建出来
	await get_tree().process_frame

	# 自动找人：通过组系统找到新玩家
	var new_player_view: Node2D = get_tree().get_first_node_in_group("player_view")

	if new_player_view != null:
		print("[Camera] 找到新玩家视图: ", new_player_view.name)

		# 瞬间传送逻辑
		print("[Camera] 执行瞬间传送...")

		# 1. 关闭平滑，避免传送过程中的插值干扰
		set_position_smoothing_enabled(false)

		# 2. 强制位移到新玩家位置
		global_position = new_player_view.global_position

		# 3. 立即更新摄像机位置
		force_update_scroll()

		# 4. 重新绑定目标节点
		target_node = new_player_view

		# 5. 重新开启平滑跟随
		set_position_smoothing_enabled(true)

		print("[Camera] 摄像机重绑成功！")
	else:
		print("[Camera] 警告：未找到玩家视图")

func _process(delta: float) -> void:
	# 即使目标消失了，摄像机也不会报错
	if is_instance_valid(target_node):
		# 使用 lerp 进行平滑位置插值
		# 这样摄像机看起来会有一定的重量感和缓冲
		global_position = global_position.lerp(target_node.global_position, smooth_speed * delta)