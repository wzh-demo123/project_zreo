extends Node2D
# 这是一个桥接脚本，专门用来在编辑器里调数值，然后传给全局单例
@export var world_size: Vector2 = Vector2(1200, 800)

func _ready() -> void:
    # 启动时，把这里的设置同步给全局单例
    WorldManager.world_bounds = Rect2(-world_size/2, world_size)