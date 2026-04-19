# res://scripts/core/base_entity_view.gd
class_name BaseEntityView
extends Node2D

# 数据绑定
@export var data: EntityData = null

# 视觉参数配置
@export var follow_lerp_speed: float = 20.0  # 位置跟随速度
@export var rotation_speed: float = 10.0  # 转向速度

# 动态贴图配置组
@export_group("Visual Textures")
@export var tex_organic: Texture2D = null    # 有机体贴图
@export var tex_mechanical: Texture2D = null # 机械体贴图
@export var tex_player: Texture2D = null     # 玩家贴图
@export var tex_static: Texture2D = null     # 静态障碍物贴图

# 贴图缩放配置
@export var scale_organic: Vector2 = Vector2(1.0, 1.0)    # 有机体缩放
@export var scale_mechanical: Vector2 = Vector2(1.0, 1.0) # 机械体缩放
@export var scale_player: Vector2 = Vector2(1.0, 1.0)     # 玩家缩放
@export var scale_static: Vector2 = Vector2(1.0, 1.0)     # 静态障碍物缩放

# 缓存的节点引用
var sprite_node: Sprite2D = null
var health_bar: ProgressBar = null

# 动画和调试状态
var attack_tween: Tween = null
var damage_tween: Tween = null
var debug_attack_origin: Vector2 = Vector2.ZERO
var debug_attack_dir: Vector2 = Vector2.RIGHT
var debug_radius: float = 40.0
var debug_attack_angle: float = 90.0
var debug_timer: float = 0.0


func _ready() -> void:
	# 缓存节点引用（避免_process中频繁get_node）
	sprite_node = get_node_or_null("Sprite2D")
	health_bar = get_node_or_null("HealthBar")

	# 加入实体视图组，便于统一管理
	add_to_group("entity_views")

	# 安全检查：确保数据存在
	if data == null:
		push_error("BaseEntityView: data 未设置！")
		return

	# 初始位置同步
	global_position = data.position

	# 初始化血条
	if health_bar != null:
		health_bar.max_value = data.health
		health_bar.value = data.health

	# 设置视觉表现（贴图 + 颜色）
	_setup_visuals()

	# 注册实体到世界管理器
	WorldManager.register_entity(data)
	WorldManager.world_ticked.connect(_on_world_tick)

	# 连接受伤事件（如果EventBus存在）
	_connect_damage_events()

	print("实体视图初始化完成: ", data.id)
	# 显示血条
	if health_bar != null:
		health_bar.show()  # <--- 关键：启动游戏时强制让它显示出来
		health_bar.max_value = data.health
		health_bar.value = data.health


# 每帧更新 - 实现平滑移动和转向
func _process(delta: float) -> void:
	if data == null:
		return

	# 性能优化：静态障碍物不需要每帧更新
	if data.entity_type == "static":
		# 只更新Debug绘制（如果需要）
		if debug_timer > 0.0:
			debug_timer -= delta
			queue_redraw()
		return

	# 平滑位置同步
	if global_position.distance_to(data.position) < 0.5:
		global_position = data.position
	else:
		global_position = global_position.lerp(data.position, follow_lerp_speed * delta)

	# 平滑转向逻辑
	_handle_facing_direction(delta)

	# 更新Debug计时器
	if debug_timer > 0.0:
		debug_timer -= delta
		queue_redraw()  # 触发重绘


# 面向方向处理（RPG风格左右翻转）
func _handle_facing_direction(_delta: float) -> void:
	# 确保节点不旋转，保持RPG视角
	rotation = 0.0

	# 计算移动方向向量
	var move_direction: Vector2 = data.position - global_position

	# 如果移动距离足够大，才进行翻转计算
	if move_direction.length() > 0.1:
		# RPG风格左右翻转逻辑
		if move_direction.x < -0.1:
			# 向左移动：翻转贴图
			if sprite_node != null:
				sprite_node.flip_h = true
		elif move_direction.x > 0.1:
			# 向右移动：正常贴图
			if sprite_node != null:
				sprite_node.flip_h = false


# 设置视觉表现（贴图 + 颜色）
func _setup_visuals() -> void:
	if sprite_node == null:
		return

	var texture_applied: bool = false

	# 优先应用贴图
	match data.entity_type:
		"organic":
			if tex_organic != null:
				sprite_node.texture = tex_organic
				sprite_node.scale = scale_organic  # 应用有机体缩放
				texture_applied = true
		"mechanical":
			if tex_mechanical != null:
				sprite_node.texture = tex_mechanical
				sprite_node.scale = scale_mechanical  # 应用机械体缩放
				texture_applied = true
		"player":
			if tex_player != null:
				sprite_node.texture = tex_player
				sprite_node.scale = scale_player  # 应用玩家缩放
				texture_applied = true

			# 给玩家视图添加特殊标签，便于摄像机识别
			add_to_group("player_view")
		"static":
			if tex_static != null:
				sprite_node.texture = tex_static
				sprite_node.scale = scale_static  # 应用静态障碍物缩放
				texture_applied = true
		"energy":
			# 能量体：保持默认贴图，使用颜色区分
			pass
		"digital":
			# 数字体：保持默认贴图，使用颜色区分
			pass
		_:
			# 未知类型：保持默认设置
			pass

	# 如果贴图应用成功，重置为白色避免颜色污染
	if texture_applied:
		sprite_node.self_modulate = Color.WHITE
	else:
		# 否则使用颜色作为Fallback
		_apply_fallback_color()


# 备用颜色方案（当贴图未配置时使用）
func _apply_fallback_color() -> void:
	match data.entity_type:
		"organic":
			# 有机体：绿色
			sprite_node.self_modulate = Color.GREEN
		"mechanical":
			# 机械体：红色
			sprite_node.self_modulate = Color.RED
		"energy":
			# 能量体：蓝色
			sprite_node.self_modulate = Color.BLUE
		"digital":
			# 数字体：紫色
			sprite_node.self_modulate = Color.PURPLE
		_:
			# 未知类型：白色（默认）
			sprite_node.self_modulate = Color.WHITE


func _on_world_tick(_tick: int) -> void:
	if data == null:
		return

	# 这里只负责处理生死逻辑，不操作坐标
	if data.health <= 0.0:
		queue_free()


# 播放攻击动画
func play_attack_anim(
	origin_pos: Vector2, direction: Vector2, radius: float, angle_deg: float
) -> void:
	# 设置Debug信息
	debug_attack_origin = origin_pos
	debug_attack_dir = direction
	debug_radius = radius
	debug_attack_angle = angle_deg
	debug_timer = 0.1  # 显示0.1秒

	# 创建Tween动画
	if attack_tween != null:
		attack_tween.kill()

	attack_tween = create_tween()
	attack_tween.set_parallel(true)  # 并行执行多个动画

	# 计算攻击方向（确保使用单位向量）
	var attack_dir: Vector2 = direction.normalized()

	# 动画1：只让图片节点移动，避免干扰父节点的位置同步逻辑
	var shake_offset: Vector2 = attack_dir * 8.0  # 抖动幅度

	# 移动图片节点的position（相对于父中心）
	if sprite_node != null:
		attack_tween.tween_property(sprite_node, "position", shake_offset, 0.05)
		attack_tween.tween_property(sprite_node, "position", Vector2.ZERO, 0.05)

	# 动画2：轻微缩放效果
	if sprite_node != null:
		var original_scale: Vector2 = sprite_node.scale
		var attack_scale: Vector2 = original_scale * 1.2

		attack_tween.tween_property(sprite_node, "scale", attack_scale, 0.05)
		attack_tween.tween_property(sprite_node, "scale", original_scale, 0.05)

	# 动画完成后清理
	attack_tween.finished.connect(_on_attack_anim_finished)


# 攻击动画完成回调
func _on_attack_anim_finished() -> void:
	if attack_tween != null:
		attack_tween.kill()
		attack_tween = null


# Debug绘制函数
func _draw() -> void:
	# 只在Debug计时器激活时绘制
	if debug_timer > 0.0:
		# 将世界坐标转换为本地坐标
		var local_attack_origin: Vector2 = to_local(debug_attack_origin)

		# 构建扇形顶点数组
		var points: PackedVector2Array = PackedVector2Array()

		# 添加原点（扇形起点）
		points.append(local_attack_origin)

		# 计算扇形角度范围
		var start_angle: float = debug_attack_dir.angle() - deg_to_rad(debug_attack_angle) / 2.0
		var end_angle: float = debug_attack_dir.angle() + deg_to_rad(debug_attack_angle) / 2.0

		# 分段构建扇形边缘（16段）
		var segment_count: int = 16
		for i in range(segment_count + 1):
			# 插值计算当前角度
			var t: float = float(i) / segment_count
			var current_angle: float = lerp(start_angle, end_angle, t)

			# 计算边缘点位置
			var edge_point: Vector2 = Vector2.RIGHT.rotated(current_angle) * debug_radius

			# 转换为本地坐标系并添加到数组
			points.append(local_attack_origin + edge_point)

		# 绘制扇形（半透明红色）
		var sector_color: Color = Color(1.0, 0.0, 0.0, 0.3)
		draw_polygon(points, [sector_color])

		# 绘制攻击方向线
		var line_color: Color = Color(1.0, 0.0, 0.0, 0.8)
		var line_end: Vector2 = local_attack_origin + debug_attack_dir * debug_radius

		draw_line(local_attack_origin, line_end, line_color, 2.0)


func _exit_tree() -> void:
	if data != null and WorldManager.world_ticked.is_connected(_on_world_tick):
		WorldManager.world_ticked.disconnect(_on_world_tick)

	print("实体视图已清理: ", data.id if data != null else "unknown")


# # 连接受伤事件
# func _connect_damage_events() -> void:
# 	# 检查EventBus是否存在
# 	if ClassDB.class_exists("EventBus"):
# 		# 安全连接事件（如果EventBus已注册为Autoload）
# 		if EventBus.has_signal("entity_damaged"):
# 			EventBus.entity_damaged.connect(_on_entity_damaged)
# 	else:
# 		# 如果EventBus不存在，使用WorldManager的tick信号作为备用
# 		print("EventBus未找到，使用WorldManager tick作为受伤检测")


# 连接受伤事件
func _connect_damage_events() -> void:
	# 只要在"项目设置->自动加载"里配了 EventBus，它就等同于全局常量
	# 我们只需要防重复连接即可
	if not EventBus.entity_damaged.is_connected(_on_entity_damaged):
		EventBus.entity_damaged.connect(_on_entity_damaged)


# 实体受伤事件处理
func _on_entity_damaged(
	target_data: EntityData, _damage_amount: float, attacker_pos: Vector2
) -> void:
	# 检查是否是自己受伤
	if target_data != data:
		return

	# 更新血条显示
	_update_health_bar()

	# 播放受伤反馈动画
	_play_damage_feedback(attacker_pos)


# 更新血条显示
func _update_health_bar() -> void:
	if health_bar != null:
		health_bar.value = data.health


# 播放受伤反馈动画
func _play_damage_feedback(attacker_pos: Vector2) -> void:
	# 闪红效果
	_play_flash_red_anim()

	# 击退效果
	_play_knockback_anim(attacker_pos)


# 闪红动画
func _play_flash_red_anim() -> void:
	if sprite_node == null:
		return

	# 清理之前的动画
	if damage_tween != null:
		damage_tween.kill()

	damage_tween = create_tween()
	damage_tween.set_parallel(false)  # 顺序执行

	# 记录原始颜色
	var original_color: Color = sprite_node.self_modulate

	# 闪红动画序列
	damage_tween.tween_property(sprite_node, "self_modulate", Color.RED, 0.1)
	damage_tween.tween_property(sprite_node, "self_modulate", original_color, 0.1)


# 击退动画
func _play_knockback_anim(attacker_pos: Vector2) -> void:
	# 计算击退方向（远离攻击者）
	var knockback_dir: Vector2 = (data.position - attacker_pos).normalized()

	# 击退距离（根据伤害或固定值）
	var knockback_distance: float = 20.0

	# 应用瞬间位移
	data.position += knockback_dir * knockback_distance

	print("击退效果: ", data.id, " 被击退 ", knockback_distance, " 像素")