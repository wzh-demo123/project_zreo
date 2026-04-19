# res://scripts/core/map_generator.gd
# 地图生成器脚本 - 用于自动生成TileMapLayer的地板

extends TileMapLayer

# --- 配置属性 ---
@export_group("Map Generation")
@export var map_size: Vector2 = Vector2(3000, 2000)  # 地图大小（像素）
@export var tile_atlas_coords: Vector2i = Vector2i(0, 0)  # 瓷砖在图集中的坐标
@export var enabled_auto_generate: bool = true  # 是否启用自动生成

# --- 初始化 ---
func _ready() -> void:
	# 连接世界加载信号（使用call_deferred确保WorldManager完全准备好）
	WorldManager.world_loaded.connect(generate_floor)

	# 延迟执行自动生成，确保WorldManager已初始化
	if enabled_auto_generate:
		call_deferred("generate_floor")

# --- 核心生成逻辑 ---
func generate_floor() -> void:
	# 从WorldManager获取世界边界
	var bounds: Rect2 = WorldManager.world_bounds
	var current_map_size: Vector2 = bounds.size

	# 清除现有瓷砖
	clear()

	# 计算格子数量（瓷砖大小为64x64）
	var tile_size: int = 64
	var grid_width: int = ceil(current_map_size.x / tile_size)
	var grid_height: int = ceil(current_map_size.y / tile_size)

	# 计算偏移量，基于世界边界位置
	var offset_x: int = int(bounds.position.x / tile_size)
	var offset_y: int = int(bounds.position.y / tile_size)

	print("开始生成地板...")
	print("世界边界: ", bounds)
	print("地图大小: ", current_map_size, " 像素")
	print("格子数量: ", grid_width, " x ", grid_height)
	print("瓷砖坐标: ", tile_atlas_coords)
	print("偏移量: (", offset_x, ", ", offset_y, ")")

	# 使用嵌套循环填充地板
	var tiles_placed: int = 0
	var tiles_failed: int = 0

	for x in range(grid_width):
		for y in range(grid_height):
			# 计算世界坐标（基于边界位置）
			var world_x: int = offset_x + x
			var world_y: int = offset_y + y
			var cell_coords: Vector2i = Vector2i(world_x, world_y)

			# 设置瓷砖
			set_cell(cell_coords, 1, tile_atlas_coords)

			# 安全检查：确认瓷砖是否成功设置
			var source_id: int = get_cell_source_id(cell_coords)
			if source_id == -1:
				print("警告：瓷砖设置失败 at ", cell_coords)
				tiles_failed += 1
			else:
				tiles_placed += 1

	print("地板生成完成！")
	print("成功设置: ", tiles_placed, " 个瓷砖")
	if tiles_failed > 0:
		print("警告: ", tiles_failed, " 个瓷砖设置失败")
	print("覆盖范围: x[", offset_x, "到", offset_x + grid_width - 1, "] y[", offset_y, "到", offset_y + grid_height - 1, "]")

# --- 辅助函数 ---

# 获取地图边界（用于调试或其他系统）
func get_map_bounds() -> Rect2:
	# 直接返回WorldManager的世界边界，确保一致性
	return WorldManager.world_bounds

# 重新生成地板（可用于运行时更新）
func regenerate_floor() -> void:
	generate_floor()