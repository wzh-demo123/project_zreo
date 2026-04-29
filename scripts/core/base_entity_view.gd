# res://scripts/core/base_entity_view.gd
# 精简版：只负责平滑跟随 data.position 和更新血条
# 视觉表现由独立的 .tscn 场景直接配置
class_name BaseEntityView
extends Node2D

# 数据绑定
@export var data: EntityData = null

# 位置跟随速度
@export var follow_lerp_speed: float = 20.0

# 血条引用
var health_bar: ProgressBar = null

func _ready() -> void:
	# 获取血条节点
	health_bar = get_node_or_null("HealthBarContainer/HealthBar")

	# 加入实体视图组
	add_to_group("entity_views")

	# 宽容检查：允许稍后设置 data
	if data == null:
		push_warning("BaseEntityView created without initial data, will be assigned later")
		return

	# 初始位置同步
	_setup_from_data()


# 从 data 设置初始状态
func _setup_from_data() -> void:
	if data == null:
		return
	global_position = data.position

	# 初始化血条
	if health_bar != null:
		health_bar.max_value = data.max_health
		health_bar.value = data.health
		health_bar.show()

	# 注册到世界管理器
	WorldManager.register_entity(data)
	WorldManager.world_ticked.connect(_on_world_tick)

	# 连接受伤事件
	if not EventBus.entity_damaged.is_connected(_on_entity_damaged):
		EventBus.entity_damaged.connect(_on_entity_damaged)

func _process(delta: float) -> void:
	if data == null:
		return

	# 平滑位置跟随
	if global_position.distance_to(data.position) > 0.5:
		global_position = global_position.lerp(data.position, follow_lerp_speed * delta)
	else:
		global_position = data.position

func _on_world_tick(_tick: int) -> void:
	if data == null:
		return
	# 死亡清理
	if data.health <= 0.0:
		queue_free()

func _on_entity_damaged(target_data: EntityData, _damage_amount: float, attacker_pos: Vector2) -> void:
	if target_data != data:
		return
	_update_health_bar()

	# 击退效果
	if attacker_pos != Vector2.ZERO and WorldManager.tuning.combat_knockback_distance > 0:
		_apply_knockback(attacker_pos)

	# 受击红光效果
	_apply_hit_flash()

func _update_health_bar() -> void:
	if health_bar != null and data != null:
		health_bar.show()
		health_bar.max_value = data.max_health
		health_bar.value = clamp(data.health, 0.0, data.max_health)

# 应用击退效果
func _apply_knockback(attacker_pos: Vector2) -> void:
	if data == null:
		return

	# 计算击退方向（从攻击者指向受伤者）
	var knockback_dir: Vector2 = (data.position - attacker_pos).normalized()
	if knockback_dir == Vector2.ZERO:
		knockback_dir = Vector2.RIGHT

	# 击退目标位置
	var knockback_target: Vector2 = data.position + knockback_dir * WorldManager.tuning.combat_knockback_distance
	var knockback_duration: float = WorldManager.tuning.combat_knockback_duration

	# 使用 Tween 实现击退动画
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", knockback_target, knockback_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 更新数据位置（让逻辑位置也跟随）
	data.position = knockback_target

# 应用受击红光效果
func _apply_hit_flash() -> void:
	var tuning: WorldTuning = WorldManager.tuning
	var flash_duration: float = tuning.visual_hit_flash_duration
	var _flash_intensity: float = tuning.visual_hit_flash_intensity  # 用于调整亮度，当前使用固定值

	# 获取所有可变色节点
	var sprite: Node = get_node_or_null("Sprite2D")
	var anim_sprite: Node = get_node_or_null("AnimatedSprite2D")

	var original_modulates: Dictionary = {}

	# 应用更明显的红光 (亮红色)
	var red_color: Color = Color(1.0, 0.2, 0.2, 1.0)  # 纯红色，轻微保留绿色蓝色避免完全失色
	var bright_red: Color = Color(1.0, 0.5, 0.5)  # 高亮红色

	# 记录原始颜色并应用红光
	if sprite != null and sprite is CanvasItem:
		original_modulates["sprite"] = sprite.modulate
		sprite.modulate = bright_red

	if anim_sprite != null and anim_sprite is CanvasItem:
		original_modulates["anim_sprite"] = anim_sprite.modulate
		anim_sprite.modulate = bright_red

	# 使用 Tween 实现闪烁效果
	var tween: Tween = create_tween()
	if sprite != null and sprite is CanvasItem:
		tween.parallel().tween_property(sprite, "modulate", red_color, flash_duration * 0.5)
	if anim_sprite != null and anim_sprite is CanvasItem:
		tween.parallel().tween_property(anim_sprite, "modulate", red_color, flash_duration * 0.5)

	# 延迟恢复颜色
	tween.finished.connect(
		func() -> void:
			var restore_tween: Tween = create_tween()
			if is_instance_valid(sprite) and "sprite" in original_modulates:
				restore_tween.parallel().tween_property(sprite, "modulate", original_modulates["sprite"], flash_duration * 0.5)
			if is_instance_valid(anim_sprite) and "anim_sprite" in original_modulates:
				restore_tween.parallel().tween_property(anim_sprite, "modulate", original_modulates["anim_sprite"], flash_duration * 0.5)
	)

func _exit_tree() -> void:
	if data != null and WorldManager.world_ticked.is_connected(_on_world_tick):
		WorldManager.world_ticked.disconnect(_on_world_tick)
	if EventBus.entity_damaged.is_connected(_on_entity_damaged):
		EventBus.entity_damaged.disconnect(_on_entity_damaged)
	print("实体视图已清理: ", data.id if data != null else "unknown")