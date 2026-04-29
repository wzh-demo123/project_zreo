extends BaseEntityView
class_name PlayerView

@onready var anim_sprite = $AnimatedSprite2D
var is_attacking: bool = false
var attack_fan: Polygon2D = null  # 攻击扇形指示器

func _ready():
    super._ready() # 不要忘了基类的初始化
    # 监听动画播放完毕信号，用来解除攻击锁定
    if anim_sprite:
        anim_sprite.animation_finished.connect(_on_animation_finished)
        anim_sprite.play("idle")

func _process(delta):
    super._process(delta) # 基类处理平滑位移 (lerp)
    
    if not anim_sprite or not data: return
    if is_attacking: return # 攻击时锁定状态，不要切回走路
    
    # 计算视图当前是否在发生物理位移 (通过比较目标数据点和当前视图点)
    var move_delta = data.position - global_position
    
    # 容差值设为 1.0，防止由于浮点数精度导致的原地抽搐
    if move_delta.length() > 1.0:
        anim_sprite.play("run")
        # 根据移动方向翻转 Sprite
        if move_delta.x < -0.1:
            anim_sprite.flip_h = true
        elif move_delta.x > 0.1:
            anim_sprite.flip_h = false
    else:
        anim_sprite.play("idle")

func play_attack_anim(_hit_origin: Vector2, direction: Vector2, radius: float, angle_deg: float) -> void:
    if not anim_sprite: return
    
    is_attacking = true
    
    # 显示攻击扇形
    _show_attack_fan(direction, radius, angle_deg)
    
    # 根据攻击方向选择对应的动画
    # 优先判断左右，再判断上下
    if abs(direction.x) >= abs(direction.y):
        # 水平方向攻击
        anim_sprite.play("right_attack")
        # 根据方向翻转（左攻击时翻转right_attack）
        anim_sprite.flip_h = direction.x < 0
    else:
        # 垂直方向攻击
        anim_sprite.flip_h = false  # 垂直攻击不翻转
        if direction.y > 0:
            anim_sprite.play("down_attack")
        else:
            anim_sprite.play("up_attack")

# 显示攻击扇形指示器
func _show_attack_fan(direction: Vector2, radius: float, angle_deg: float) -> void:
    # 移除旧的扇形
    if attack_fan != null and is_instance_valid(attack_fan):
        attack_fan.queue_free()
    
    # 创建扇形多边形
    attack_fan = Polygon2D.new()
    attack_fan.color = Color(1.0, 0.0, 0.0, 0.3)  # 半透明红色
    
    # 构建扇形顶点
    var points: PackedVector2Array = PackedVector2Array()
    points.append(Vector2.ZERO)  # 扇形中心
    
    var angle_rad: float = deg_to_rad(angle_deg)
    var base_angle: float = direction.angle()
    var segments: int = 10  # 扇形分段数
    
    for i in range(segments + 1):
        var t: float = float(i) / segments
        var angle: float = base_angle - angle_rad / 2.0 + angle_rad * t
        var point: Vector2 = Vector2(cos(angle), sin(angle)) * radius
        points.append(point)
    
    attack_fan.polygon = points
    add_child(attack_fan)
    
    # 延迟移除扇形
    var timer: SceneTreeTimer = get_tree().create_timer(0.15)
    timer.timeout.connect(
        func() -> void:
            if is_instance_valid(attack_fan):
                attack_fan.queue_free()
                attack_fan = null
    )

# 动画结束的回调
func _on_animation_finished():
    # 检查是否攻击动画结束（支持多种攻击动画命名）
    var current_anim = anim_sprite.animation
    if current_anim in ["right_attack", "down_attack", "up_attack", "left_attack", "attack"]:
        is_attacking = false # 攻击动作播完，解开锁定，交还给 _process 的行走判定