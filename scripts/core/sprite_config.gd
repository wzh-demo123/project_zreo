# res://scripts/core/sprite_config.gd
# 支持多帧动画的配置资源
# 每帧使用独立的PNG文件，便于处理不规则图片
class_name SpriteConfig
extends Resource

@export_group("Entity Info")
@export var entity_type: String = "" # organic, mechanical, player, static
@export var entity_id: String = "" # 具体实体标识

@export_group("Transform")
@export var scale: Vector2 = Vector2(1.0, 1.0) # 缩放比例
@export var offset: Vector2 = Vector2.ZERO # 位置偏移
@export var flip_h: bool = false # 默认是否水平翻转

@export_group("Animation")
@export var animation_fps: float = 8.0 # 动画帧率
@export var loop_animation: bool = true # 是否循环播放

# 多帧动画配置（独立PNG文件方案）
# 示例：{"idle": ["idle_0.png", "idle_1.png"]}
@export var animations: Dictionary = {}

@export_group("SpriteSheet Cutting")
@export var use_spritesheet: bool = false # 是否使用SpriteSheet切割
@export var spritesheet_path: String = "" # 默认SpriteSheet图片路径（当动画没有单独指定源时使用）

# SpriteSheet切割配置：动画名 -> 区域数组
# 每个区域是 Rect2(x, y, width, height)
# 示例：{"idle": [Rect2(0, 0, 32, 32), Rect2(32, 0, 32, 32)]}
@export var spritesheet_regions: Dictionary = {}

# 动画源图片配置（可选）：动画名 -> 源图片路径
# 允许不同动画使用不同的源图片
# 示例：{"idle": "res://player_idle.png", "move": "res://player_move.png"}
# 如果动画未在此指定，则使用默认的 spritesheet_path
@export var animation_sources: Dictionary = {}

# 静态图片路径（单帧时使用）
@export var sprite_path: String = "" # 已废弃，保留兼容

# 纹理缓存
var _texture_cache: Dictionary = {}

# 获取静态纹理（向后兼容）
func get_texture() -> Texture2D:
	if sprite_path != "":
		return _get_cached_texture(sprite_path)
	# 如果没有设置sprite_path，使用第一个动画的第一帧
	if not animations.is_empty():
		var first_anim: Array = animations.values()[0]
		if first_anim.size() > 0:
			return _get_cached_texture(first_anim[0])
	return null

# 获取指定动画的所有纹理
func get_animation_textures(anim_name: String) -> Array[Texture2D]:
	var textures: Array[Texture2D] = []
	if animations.has(anim_name):
		for path in animations[anim_name]:
			var tex := _get_cached_texture(path)
			if tex != null:
				textures.append(tex)
	return textures

# 获取所有动画名称
func get_animation_names() -> Array[String]:
	var names: Array[String] = []
	for key in animations.keys():
		names.append(key)
	return names

# 判断是否支持动画
func is_animated() -> bool:
	if not animations.is_empty():
		for frames in animations.values():
			if frames.size() > 1:
				return true
	return false

# 缓存纹理避免重复加载
func _get_cached_texture(path: String) -> Texture2D:
	if _texture_cache.has(path):
		return _texture_cache[path]
	
	var tex := load(path) as Texture2D
	if tex != null:
		_texture_cache[path] = tex
	return tex

# 创建SpriteFrames资源（用于AnimatedSprite2D）
func create_sprite_frames() -> SpriteFrames:
	var frames := SpriteFrames.new()
	
	# 方案1：独立PNG文件
	if not use_spritesheet:
		for anim_name in animations.keys():
			var paths: Array = animations[anim_name]
			for i in range(paths.size()):
				var tex := _get_cached_texture(paths[i])
				if tex != null:
					frames.add_frame(anim_name, tex)
			
			frames.set_animation_loop(anim_name, loop_animation)
			frames.set_animation_speed(anim_name, animation_fps)
	
	# 方案2：SpriteSheet切割（支持不同动画使用不同源图片）
	else:
		for anim_name in spritesheet_regions.keys():
			# 确定该动画的源图片路径
			var source_path: String = spritesheet_path
			if animation_sources.has(anim_name):
				source_path = animation_sources[anim_name]
			
			if source_path == "":
				push_warning("[SpriteConfig] 动画 '" + anim_name + "' 没有指定源图片路径")
				continue
			
			var sheet_tex := _get_cached_texture(source_path)
			if sheet_tex == null:
				push_warning("[SpriteConfig] 无法加载图片: " + source_path)
				continue
			
			# 添加该动画的所有帧
			var regions: Array = spritesheet_regions[anim_name]
			for region in regions:
				if region is Rect2:
					var atlas_tex := AtlasTexture.new()
					atlas_tex.atlas = sheet_tex
					atlas_tex.region = region
					frames.add_frame(anim_name, atlas_tex)
			
			frames.set_animation_loop(anim_name, loop_animation)
			frames.set_animation_speed(anim_name, animation_fps)
	
	return frames

# 获取默认动画名（第一个动画）
func get_default_animation() -> String:
	if use_spritesheet and not spritesheet_regions.is_empty():
		return spritesheet_regions.keys()[0]
	elif not animations.is_empty():
		return animations.keys()[0]
	return ""

# 获取指定动画的源图片路径
func get_animation_source(anim_name: String) -> String:
	if animation_sources.has(anim_name):
		return animation_sources[anim_name]
	return spritesheet_path
