# res://scripts/core/sprite_manager.gd
# 注意：此类通过Autoload注册为全局单例，不要直接使用class_name
extends Node

# 单例引用（通过Autoload自动设置）
static var instance: Node = null

# Sprite配置字典: key = "entity_type:entity_id", value = SpriteConfig
var sprite_configs: Dictionary = {}

func _ready() -> void:
	if instance == null:
		instance = self
		# 自动加载所有预设的Sprite配置
		_load_default_configs()
	else:
		queue_free()

# 加载默认配置（从.tres资源文件）
func _load_default_configs() -> void:
	var loaded_count := 0
	
	# 方案A：扫描resources/sprite_configs/目录下的.tres文件
	loaded_count += _load_tres_configs_from_dir("res://resources/sprite_configs/")
	
	# 方案B：如果目录扫描失败，使用硬编码默认配置作为fallback
	if loaded_count == 0:
		loaded_count += _load_hardcoded_fallbacks()
	
	print("[SpriteManager] 已加载 ", loaded_count, " 个Sprite配置")

# 从.tres文件加载配置（Godot编辑器可视化方案）
func _load_tres_configs_from_dir(dir_path: String) -> int:
	var count := 0
	var dir := DirAccess.open(dir_path)
	
	if dir == null:
		push_warning("[SpriteManager] 无法打开配置目录: " + dir_path)
		return 0
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var full_path := dir_path + file_name
			var config := load(full_path) as SpriteConfig
			
			if config != null:
				register_sprite_config(config.entity_type, config.entity_id, config)
				count += 1
				print("[SpriteManager] 加载配置: ", file_name, " -> ", config.entity_type, ":", config.entity_id)
			else:
				push_warning("[SpriteManager] 无法加载配置: " + full_path)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()
	return count

# 硬编码fallback配置（当没有.tres文件时使用）
func _load_hardcoded_fallbacks() -> int:
	var fallbacks := [
		["organic", "organic", "res://assets/entities/organic/archer.png", Vector2(2, 2)],
		["mechanical", "mechanical", "res://assets/entities/mechanical/warrior.png", Vector2(3, 3)],
		["player", "player", "res://assets/entities/player/player.png", Vector2(1, 1)],
		["static", "static", "res://assets/entities/static/rock.png", Vector2(2, 2)],
	]
	
	for data in fallbacks:
		var config := SpriteConfig.new()
		config.entity_type = data[0]
		config.entity_id = data[1]
		config.sprite_path = data[2]
		config.scale = data[3]
		register_sprite_config(config.entity_type, config.entity_id, config)
	
	print("[SpriteManager] 使用硬编码fallback配置")
	return fallbacks.size()

# 注册Sprite配置
func register_sprite_config(entity_type: String, entity_id: String, config: SpriteConfig) -> void:
	var key = _get_key(entity_type, entity_id)
	sprite_configs[key] = config

# 获取Sprite配置
func get_sprite_config(entity_type: String, entity_id: String) -> SpriteConfig:
	var key = _get_key(entity_type, entity_id)
	return sprite_configs.get(key, null)

# 获取Sprite纹理
func get_sprite_texture(entity_type: String, entity_id: String) -> Texture2D:
	var config = get_sprite_config(entity_type, entity_id)
	if config != null:
		return config.get_texture()
	return null

# 获取Sprite缩放
func get_sprite_scale(entity_type: String, entity_id: String) -> Vector2:
	var config = get_sprite_config(entity_type, entity_id)
	if config != null:
		return config.scale
	return Vector2(1.0, 1.0)

# 获取Sprite偏移
func get_sprite_offset(entity_type: String, entity_id: String) -> Vector2:
	var config = get_sprite_config(entity_type, entity_id)
	if config != null:
		return config.offset
	return Vector2.ZERO

# 生成字典键
func _get_key(entity_type: String, entity_id: String) -> String:
	return entity_type + ":" + entity_id
