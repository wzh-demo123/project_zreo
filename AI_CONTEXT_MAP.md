# 📂 Project Zero: 全量架构快照 (Full Context)
> **生成时间:** 2026-04-19 22:20:01
> **基础 Raw 路径:** `https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/`

## 🌳 完整目录结构
```text
└── ./
    ├── AI_CONTEXT_MAP.md
    ├── project.godot
    └── .vscode/
    └── scenes/
        ├── base_entity_view.tscn
        ├── main.tscn
    └── scripts/
        └── core/
            ├── base_entity_view.gd
            ├── camera.gd
            ├── entity_data.gd
            ├── event_bus.gd
            ├── map_generator.gd
            ├── player_controller.gd
            ├── world_manager.gd
            ├── world_save_data.gd
            ├── world_settings.gd
            ├── world_spawner.gd
```

---

## 📄 全量代码与配置索引
以下内容包含所有脚本和配置的完整代码，供 AI 建立深层逻辑关联。

### 🔗 文件: project.godot
- **Raw 链接:** [project.godot](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/project.godot)
```toml
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="Project_Zreo"
run/main_scene="res://scenes/main.tscn"
config/features=PackedStringArray("4.3", "GL Compatibility")
config/icon="res://icon.svg"

[autoload]

WorldManager="*res://scripts/core/world_manager.gd"
EventBus="*res://scripts/core/event_bus.gd"

[rendering]

textures/canvas_textures/default_texture_filter=0
renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
2d/snap/snap_2d_transforms_to_pixel=true

```

---

### 🔗 文件: scenes\base_entity_view.tscn
- **Raw 链接:** [scenes/base_entity_view.tscn](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scenes/base_entity_view.tscn)
```toml
[gd_scene load_steps=11 format=3 uid="uid://6h6gfsxf4xjv"]

[ext_resource type="Script" path="res://scripts/core/base_entity_view.gd" id="1_v8anl"]
[ext_resource type="Texture2D" uid="uid://73jt5ywc0mg5" path="res://assets/Character/Forest.png" id="2_7btyh"]
[ext_resource type="Texture2D" uid="uid://ts6tgh1335py" path="res://assets/Character/Dungeon_Character.png" id="2_uil4a"]
[ext_resource type="Texture2D" uid="uid://bjl43ydjd2hsj" path="res://assets/Character/player.png" id="4_afv6t"]
[ext_resource type="Texture2D" uid="uid://mn8gsdrg6yy0" path="res://assets/Terrain/Decorations/Rocks/Rock1.png" id="5_igl3s"]

[sub_resource type="AtlasTexture" id="AtlasTexture_iq2pf"]
atlas = ExtResource("2_7btyh")
region = Rect2(11, 143, 70, 98)

[sub_resource type="AtlasTexture" id="AtlasTexture_qh2ak"]
atlas = ExtResource("2_uil4a")
region = Rect2(96, 48, 16, 16)

[sub_resource type="AtlasTexture" id="AtlasTexture_y7eta"]
atlas = ExtResource("4_afv6t")
region = Rect2(115, 48, 69, 150)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_mvqol"]
bg_color = Color(0, 0, 0, 0.352941)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_sk1cq"]
bg_color = Color(0.870588, 0, 0, 1)

[node name="BaseEntityView" type="Node2D"]
script = ExtResource("1_v8anl")
tex_organic = SubResource("AtlasTexture_iq2pf")
tex_mechanical = SubResource("AtlasTexture_qh2ak")
tex_player = SubResource("AtlasTexture_y7eta")
tex_static = ExtResource("5_igl3s")
scale_mechanical = Vector2(3, 3)
scale_player = Vector2(0.8, 0.8)
scale_static = Vector2(2, 2)

[node name="Sprite2D" type="Sprite2D" parent="."]

[node name="HealthBar" type="ProgressBar" parent="."]
visible = false
custom_minimum_size = Vector2(32, 4)
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 1.0
grow_horizontal = 2
theme_override_styles/background = SubResource("StyleBoxFlat_mvqol")
theme_override_styles/fill = SubResource("StyleBoxFlat_sk1cq")
show_percentage = false

```

---

### 🔗 文件: scenes\main.tscn
- **Raw 链接:** [scenes/main.tscn](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scenes/main.tscn)
```toml
[gd_scene load_steps=12 format=4 uid="uid://c3pno5hr8r6jo"]

[ext_resource type="Texture2D" uid="uid://b13nwsa6xoxb" path="res://assets/Terrain/Tileset/Tilemap_color1.png" id="1_1fjc7"]
[ext_resource type="Script" path="res://scripts/core/world_spawner.gd" id="1_p6nn4"]
[ext_resource type="PackedScene" uid="uid://6h6gfsxf4xjv" path="res://scenes/base_entity_view.tscn" id="2_12kl3"]
[ext_resource type="Script" path="res://scripts/core/map_generator.gd" id="2_hissr"]
[ext_resource type="Script" path="res://scripts/core/player_controller.gd" id="3_22o7b"]
[ext_resource type="Script" path="res://scripts/core/camera.gd" id="4_ocl17"]
[ext_resource type="Script" path="res://scripts/core/entity_data.gd" id="4_q3diw"]
[ext_resource type="Script" path="res://scripts/core/world_settings.gd" id="5_qn0tx"]

[sub_resource type="TileSetAtlasSource" id="TileSetAtlasSource_63wuf"]
texture = ExtResource("1_1fjc7")
texture_region_size = Vector2i(64, 64)
0:0/0 = 0
1:0/0 = 0
2:0/0 = 0
3:0/0 = 0
5:0/0 = 0
6:0/0 = 0
7:0/0 = 0
8:0/0 = 0
0:1/0 = 0
1:1/0 = 0
2:1/0 = 0
3:1/0 = 0
5:1/0 = 0
6:1/0 = 0
7:1/0 = 0
8:1/0 = 0
0:2/0 = 0
1:2/0 = 0
2:2/0 = 0
3:2/0 = 0
5:2/0 = 0
6:2/0 = 0
7:2/0 = 0
8:2/0 = 0
0:3/0 = 0
1:3/0 = 0
2:3/0 = 0
3:3/0 = 0
5:3/0 = 0
6:3/0 = 0
7:3/0 = 0
8:3/0 = 0
0:4/0 = 0
3:4/0 = 0
5:4/0 = 0
6:4/0 = 0
7:4/0 = 0
8:4/0 = 0
0:5/0 = 0
3:5/0 = 0
5:5/0 = 0
6:5/0 = 0
7:5/0 = 0
8:5/0 = 0

[sub_resource type="TileSet" id="TileSet_jc3n5"]
tile_size = Vector2i(64, 64)
sources/1 = SubResource("TileSetAtlasSource_63wuf")

[sub_resource type="Resource" id="Resource_3or8t"]
script = ExtResource("4_q3diw")
id = "player_01"
entity_type = "player"
faction = "neutral"
health = 100.0
position = Vector2(0, 0)
age_ticks = 0
move_speed = 150.0
energy = 100.0
collision_radius = 20.0

[node name="Main" type="Node2D"]

[node name="TileMapLayer" type="TileMapLayer" parent="."]
tile_map_data = PackedByteArray("AAD7/wEAAQABAAEAAAD7/wIAAQABAAEAAAD7/wMAAQABAAEAAAD7/wQAAQABAAEAAAD8/wEAAQABAAEAAAD8/wIAAQABAAEAAAD8/wMAAQABAAEAAAD8/wQAAQABAAEAAAD9/wEAAQABAAEAAAD9/wIAAQABAAEAAAD9/wMAAQABAAEAAAD9/wQAAQABAAEAAAD+/wEAAQABAAEAAAD+/wIAAQABAAEAAAD+/wMAAQABAAEAAAD+/wQAAQABAAEAAAD//wEAAQABAAEAAAD//wIAAQABAAEAAAD//wMAAQABAAEAAAD//wQAAQABAAEAAAD7//z/AQABAAEAAAD7//3/AQABAAEAAAD7//7/AQABAAEAAAD7////AQABAAEAAAD7/wAAAQABAAEAAAD8//z/AQABAAEAAAD8//3/AQABAAEAAAD8//7/AQABAAEAAAD8////AQABAAEAAAD8/wAAAQABAAEAAAD9//z/AQABAAEAAAD9//3/AQABAAEAAAD9//7/AQABAAEAAAD9////AQABAAEAAAD9/wAAAQABAAEAAAD+//z/AQABAAEAAAD+//3/AQABAAEAAAD+//7/AQABAAEAAAD+////AQABAAEAAAD+/wAAAQABAAEAAAD///z/AQABAAEAAAD///3/AQABAAEAAAD///7/AQABAAEAAAD/////AQABAAEAAAD//wAAAQABAAEAAAAAAPz/AQABAAEAAAAAAP3/AQABAAEAAAAAAP7/AQABAAEAAAAAAP//AQABAAEAAAAAAAAAAQABAAEAAAAAAAEAAQABAAEAAAAAAAIAAQABAAEAAAAAAAMAAQABAAEAAAAAAAQAAQABAAEAAAABAPz/AQABAAEAAAABAP3/AQABAAEAAAABAP7/AQABAAEAAAABAP//AQABAAEAAAABAAAAAQABAAEAAAABAAEAAQABAAEAAAABAAIAAQABAAEAAAABAAMAAQABAAEAAAABAAQAAQABAAEAAAACAPz/AQABAAEAAAACAP3/AQABAAEAAAACAP7/AQABAAEAAAACAP//AQABAAEAAAACAAAAAQABAAEAAAACAAEAAQABAAEAAAACAAIAAQABAAEAAAACAAMAAQABAAEAAAACAAQAAQABAAEAAAADAPz/AQABAAEAAAADAP3/AQABAAEAAAADAP7/AQABAAEAAAADAP//AQABAAEAAAADAAAAAQABAAEAAAADAAEAAQABAAEAAAADAAIAAQABAAEAAAADAAMAAQABAAEAAAADAAQAAQABAAEAAAAEAPz/AQABAAEAAAAEAP3/AQABAAEAAAAEAP7/AQABAAEAAAAEAP//AQABAAEAAAAEAAAAAQABAAEAAAAEAAEAAQABAAEAAAAEAAIAAQABAAEAAAAEAAMAAQABAAEAAAAEAAQAAQABAAEAAAAFAPz/AQABAAEAAAAFAP3/AQABAAEAAAAFAP7/AQABAAEAAAAFAP//AQABAAEAAAAFAAAAAQABAAEAAAAFAAEAAQABAAEAAAAFAAIAAQABAAEAAAAFAAMAAQABAAEAAAAFAAQAAQABAAEAAAAGAPz/AQABAAEAAAAGAP3/AQABAAEAAAAGAP7/AQABAAEAAAAGAP//AQABAAEAAAAGAAAAAQABAAEAAAAGAAEAAQABAAEAAAAGAAIAAQABAAEAAAAGAAMAAQABAAEAAAAGAAQAAQABAAEAAAAHAPz/AQABAAEAAAAHAP3/AQABAAEAAAAHAP7/AQABAAEAAAAHAP//AQABAAEAAAAHAAAAAQABAAEAAAAHAAEAAQABAAEAAAAHAAIAAQABAAEAAAAHAAMAAQABAAEAAAAHAAQAAQABAAEAAAAIAPz/AQABAAEAAAAIAP3/AQABAAEAAAAIAP7/AQABAAEAAAAIAP//AQABAAEAAAAIAAAAAQABAAEAAAAIAAEAAQABAAEAAAAIAAIAAQABAAEAAAAIAAMAAQABAAEAAAAIAAQAAQABAAEAAAD2//n/AQABAAEAAAD2//r/AQABAAEAAAD2//v/AQABAAEAAAD2//z/AQABAAEAAAD2//3/AQABAAEAAAD2//7/AQABAAEAAAD2////AQABAAEAAAD2/wAAAQABAAEAAAD2/wEAAQABAAEAAAD2/wIAAQABAAEAAAD2/wMAAQABAAEAAAD2/wQAAQABAAEAAAD2/wUAAQABAAEAAAD3//n/AQABAAEAAAD3//r/AQABAAEAAAD3//v/AQABAAEAAAD3//z/AQABAAEAAAD3//3/AQABAAEAAAD3//7/AQABAAEAAAD3////AQABAAEAAAD3/wAAAQABAAEAAAD3/wEAAQABAAEAAAD3/wIAAQABAAEAAAD3/wMAAQABAAEAAAD3/wQAAQABAAEAAAD3/wUAAQABAAEAAAD4//n/AQABAAEAAAD4//r/AQABAAEAAAD4//v/AQABAAEAAAD4//z/AQABAAEAAAD4//3/AQABAAEAAAD4//7/AQABAAEAAAD4////AQABAAEAAAD4/wAAAQABAAEAAAD4/wEAAQABAAEAAAD4/wIAAQABAAEAAAD4/wMAAQABAAEAAAD4/wQAAQABAAEAAAD4/wUAAQABAAEAAAD5//n/AQABAAEAAAD5//r/AQABAAEAAAD5//v/AQABAAEAAAD5//z/AQABAAEAAAD5//3/AQABAAEAAAD5//7/AQABAAEAAAD5////AQABAAEAAAD5/wAAAQABAAEAAAD5/wEAAQABAAEAAAD5/wIAAQABAAEAAAD5/wMAAQABAAEAAAD5/wQAAQABAAEAAAD5/wUAAQABAAEAAAD6//n/AQABAAEAAAD6//r/AQABAAEAAAD6//v/AQABAAEAAAD6//z/AQABAAEAAAD6//3/AQABAAEAAAD6//7/AQABAAEAAAD6////AQABAAEAAAD6/wAAAQABAAEAAAD6/wEAAQABAAEAAAD6/wIAAQABAAEAAAD6/wMAAQABAAEAAAD6/wQAAQABAAEAAAD6/wUAAQABAAEAAAD7//n/AQABAAEAAAD7//r/AQABAAEAAAD7//v/AQABAAEAAAD7/wUAAQABAAEAAAD8//n/AQABAAEAAAD8//r/AQABAAEAAAD8//v/AQABAAEAAAD8/wUAAQABAAEAAAD9//n/AQABAAEAAAD9//r/AQABAAEAAAD9//v/AQABAAEAAAD9/wUAAQABAAEAAAD+//n/AQABAAEAAAD+//r/AQABAAEAAAD+//v/AQABAAEAAAD+/wUAAQABAAEAAAD///n/AQABAAEAAAD///r/AQABAAEAAAD///v/AQABAAEAAAD//wUAAQABAAEAAAAAAPn/AQABAAEAAAAAAPr/AQABAAEAAAAAAPv/AQABAAEAAAAAAAUAAQABAAEAAAABAPn/AQABAAEAAAABAPr/AQABAAEAAAABAPv/AQABAAEAAAABAAUAAQABAAEAAAACAPn/AQABAAEAAAACAPr/AQABAAEAAAACAPv/AQABAAEAAAACAAUAAQABAAEAAAADAPn/AQABAAEAAAADAPr/AQABAAEAAAADAPv/AQABAAEAAAADAAUAAQABAAEAAAAEAPn/AQABAAEAAAAEAPr/AQABAAEAAAAEAPv/AQABAAEAAAAEAAUAAQABAAEAAAAFAPn/AQABAAEAAAAFAPr/AQABAAEAAAAFAPv/AQABAAEAAAAFAAUAAQABAAEAAAAGAPn/AQABAAEAAAAGAPr/AQABAAEAAAAGAPv/AQABAAEAAAAGAAUAAQABAAEAAAAHAPn/AQABAAEAAAAHAPr/AQABAAEAAAAHAPv/AQABAAEAAAAHAAUAAQABAAEAAAAIAPn/AQABAAEAAAAIAPr/AQABAAEAAAAIAPv/AQABAAEAAAAIAAUAAQABAAEAAAAJAPn/AQABAAEAAAAJAPr/AQABAAEAAAAJAPv/AQABAAEAAAAJAPz/AQABAAEAAAAJAP3/AQABAAEAAAAJAP7/AQABAAEAAAAJAP//AQABAAEAAAAJAAAAAQABAAEAAAAJAAEAAQABAAEAAAAJAAIAAQABAAEAAAAJAAMAAQABAAEAAAAJAAQAAQABAAEAAAAJAAUAAQABAAEAAAAKAPn/AQABAAEAAAAKAPr/AQABAAEAAAAKAPv/AQABAAEAAAAKAPz/AQABAAEAAAAKAP3/AQABAAEAAAAKAP7/AQABAAEAAAAKAP//AQABAAEAAAAKAAAAAQABAAEAAAAKAAEAAQABAAEAAAAKAAIAAQABAAEAAAAKAAMAAQABAAEAAAAKAAQAAQABAAEAAAAKAAUAAQABAAEAAAALAPn/AQABAAEAAAALAPr/AQABAAEAAAALAPv/AQABAAEAAAALAPz/AQABAAEAAAALAP3/AQABAAEAAAALAP7/AQABAAEAAAALAP//AQABAAEAAAALAAAAAQABAAEAAAALAAEAAQABAAEAAAALAAIAAQABAAEAAAALAAMAAQABAAEAAAALAAQAAQABAAEAAAALAAUAAQABAAEAAAAMAPn/AQABAAEAAAAMAPr/AQABAAEAAAAMAPv/AQABAAEAAAAMAPz/AQABAAEAAAAMAP3/AQABAAEAAAAMAP7/AQABAAEAAAAMAP//AQABAAEAAAAMAAAAAQABAAEAAAAMAAEAAQABAAEAAAAMAAIAAQABAAEAAAAMAAMAAQABAAEAAAAMAAQAAQABAAEAAAAMAAUAAQABAAEAAADv//b/AQABAAEAAADv//f/AQABAAEAAADv//j/AQABAAEAAADv//n/AQABAAEAAADv//r/AQABAAEAAADv//v/AQABAAEAAADv//z/AQABAAEAAADv//3/AQABAAEAAADv//7/AQABAAEAAADv////AQABAAEAAADw//b/AQABAAEAAADw//f/AQABAAEAAADw//j/AQABAAEAAADw//n/AQABAAEAAADw//r/AQABAAEAAADw//v/AQABAAEAAADw//z/AQABAAEAAADw//3/AQABAAEAAADw//7/AQABAAEAAADw////AQABAAEAAADx//b/AQABAAEAAADx//f/AQABAAEAAADx//j/AQABAAEAAADx//n/AQABAAEAAADx//r/AQABAAEAAADx//v/AQABAAEAAADx//z/AQABAAEAAADx//3/AQABAAEAAADx//7/AQABAAEAAADx////AQABAAEAAADy//b/AQABAAEAAADy//f/AQABAAEAAADy//j/AQABAAEAAADy//n/AQABAAEAAADy//r/AQABAAEAAADy//v/AQABAAEAAADy//z/AQABAAEAAADy//3/AQABAAEAAADy//7/AQABAAEAAADy////AQABAAEAAADz//b/AQABAAEAAADz//f/AQABAAEAAADz//j/AQABAAEAAADz//n/AQABAAEAAADz//r/AQABAAEAAADz//v/AQABAAEAAADz//z/AQABAAEAAADz//3/AQABAAEAAADz//7/AQABAAEAAADz////AQABAAEAAAD0//b/AQABAAEAAAD0//f/AQABAAEAAAD0//j/AQABAAEAAAD0//n/AQABAAEAAAD0//r/AQABAAEAAAD0//v/AQABAAEAAAD0//z/AQABAAEAAAD0//3/AQABAAEAAAD0//7/AQABAAEAAAD0////AQABAAEAAAD1//b/AQABAAEAAAD1//f/AQABAAEAAAD1//j/AQABAAEAAAD1//n/AQABAAEAAAD1//r/AQABAAEAAAD1//v/AQABAAEAAAD1//z/AQABAAEAAAD1//3/AQABAAEAAAD1//7/AQABAAEAAAD1////AQABAAEAAAD2//b/AQABAAEAAAD2//f/AQABAAEAAAD2//j/AQABAAEAAAD3//b/AQABAAEAAAD3//f/AQABAAEAAAD3//j/AQABAAEAAADx/wAAAQABAAEAAADx/wEAAQABAAEAAADx/wIAAQABAAEAAADx/wMAAQABAAEAAADx/wQAAQABAAEAAADx/wUAAQABAAEAAADy/wAAAQABAAEAAADy/wEAAQABAAEAAADy/wIAAQABAAEAAADy/wMAAQABAAEAAADy/wQAAQABAAEAAADy/wUAAQABAAEAAADz/wAAAQABAAEAAADz/wEAAQABAAEAAADz/wIAAQABAAEAAADz/wMAAQABAAEAAADz/wQAAQABAAEAAADz/wUAAQABAAEAAAD0/wAAAQABAAEAAAD0/wEAAQABAAEAAAD0/wIAAQABAAEAAAD0/wMAAQABAAEAAAD0/wQAAQABAAEAAAD0/wUAAQABAAEAAAD1/wAAAQABAAEAAAD1/wEAAQABAAEAAAD1/wIAAQABAAEAAAD1/wMAAQABAAEAAAD1/wQAAQABAAEAAAD1/wUAAQABAAEAAADu//z/AQABAAEAAADu//3/AQABAAEAAADu//7/AQABAAEAAADu////AQABAAEAAADu/wAAAQABAAEAAADu/wEAAQABAAEAAADu/wIAAQABAAEAAADu/wMAAQABAAEAAADu/wQAAQABAAEAAADv/wAAAQABAAEAAADv/wEAAQABAAEAAADv/wIAAQABAAEAAADv/wMAAQABAAEAAADv/wQAAQABAAEAAADw/wAAAQABAAEAAADw/wEAAQABAAEAAADw/wIAAQABAAEAAADw/wMAAQABAAEAAADw/wQAAQABAAEAAAA=")
tile_set = SubResource("TileSet_jc3n5")
script = ExtResource("2_hissr")
map_size = Vector2(3000, 3000)
tile_atlas_coords = Vector2i(1, 1)

[node name="WorldLogic" type="Node" parent="."]

[node name="WorldSpawner" type="Node2D" parent="WorldLogic"]
script = ExtResource("1_p6nn4")
base_view_scene = ExtResource("2_12kl3")
organic_count = 30
mechanical_count = 5

[node name="PlayerController" type="Node" parent="WorldLogic" node_paths=PackedStringArray("target_view")]
script = ExtResource("3_22o7b")
target_view = NodePath("../../Entities/Player")
attack_radius = 100.0

[node name="WorldSettings" type="Node2D" parent="WorldLogic"]
script = ExtResource("5_qn0tx")
world_size = Vector2(3000, 3000)

[node name="Entities" type="Node2D" parent="."]

[node name="Player" parent="Entities" instance=ExtResource("2_12kl3")]
position = Vector2(-4, -10)
data = SubResource("Resource_3or8t")

[node name="Camera2D" type="Camera2D" parent="." node_paths=PackedStringArray("target_node")]
script = ExtResource("4_ocl17")
target_node = NodePath("../Entities/Player")

[node name="UI" type="CanvasLayer" parent="."]

```

---

### 🔗 文件: scripts\core\base_entity_view.gd
- **Raw 链接:** [scripts/core/base_entity_view.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/base_entity_view.gd)
```gdscript
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
```

---

### 🔗 文件: scripts\core\camera.gd
- **Raw 链接:** [scripts/core/camera.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/camera.gd)
```gdscript
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
```

---

### 🔗 文件: scripts\core\entity_data.gd
- **Raw 链接:** [scripts/core/entity_data.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/entity_data.gd)
```gdscript
# res://scripts/core/entity_data.gd
class_name EntityData
extends Resource

@export var id: String = ""
@export var entity_type: String = "unknown"
@export var faction: String = "neutral"
@export var health: float = 100.0
@export var position: Vector2 = Vector2.ZERO
@export var age_ticks: int = 0

# --- 新增：生存与博弈属性 ---
@export var move_speed: float = 50.0  # 移动速度
@export var energy: float = 100.0     # 能量值
@export var collision_radius: float = 20.0  # 碰撞半径

func age_step(ticks: int) -> void:
	age_ticks += ticks

	match entity_type:
		"organic":
			health = max(0.0, health - ticks * 0.01)
		"mechanical":
			# 机械体基础消耗
			energy = max(0.0, energy - ticks * 0.05)
			if energy <= 0:
				health -= ticks * 0.1
		"digital":
			pass
		"energy":
			var cycle = sin(age_ticks * 0.01)
			health = 100.0 + cycle * 20.0
```

---

### 🔗 文件: scripts\core\event_bus.gd
- **Raw 链接:** [scripts/core/event_bus.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/event_bus.gd)
```gdscript
# res://scripts/core/event_bus.gd
extends Node

## 全局信号中枢
## 作用：解耦战斗逻辑与视觉反馈

# 信号：目标数据，伤害值，攻击者位置
signal entity_damaged(target_data: EntityData, amount: float, attacker_pos: Vector2)
```

---

### 🔗 文件: scripts\core\map_generator.gd
- **Raw 链接:** [scripts/core/map_generator.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/map_generator.gd)
```gdscript
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
```

---

### 🔗 文件: scripts\core\player_controller.gd
- **Raw 链接:** [scripts/core/player_controller.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/player_controller.gd)
```gdscript
class_name PlayerController
extends Node

# 玩家输入控制器类
# 架构定位：输入处理层，直接操作数据模型（Model），不干预视图（View）
# 设计原则：遵循MVVM模式，保持输入逻辑与视觉表现的分离

# 目标实体视图绑定
@export var target_view: BaseEntityView = null

# 战斗属性配置
@export var attack_damage: float = 30.0  # 攻击伤害
@export var attack_cooldown: float = 0.4  # 攻击冷却时间
@export var attack_radius: float = 40.0  # 攻击判定扇形半径
@export var attack_angle: float = 90.0  # 攻击扇形张角（度）

# 内部状态变量
var last_direction: Vector2 = Vector2.RIGHT  # 最后朝向
var attack_timer: float = 0.0  # 攻击冷却计时器

# --- 初始化 ---
func _ready() -> void:
	# 加入玩家控制器组，便于Spawner查找
	add_to_group("player_controllers")

	# 连接世界加载信号，实现读档后的玩家重绑
	WorldManager.world_loaded.connect(_on_world_loaded)

	print("[PlayerController] 初始化完成")

# 世界加载完成后的处理
func _on_world_loaded() -> void:
	print("[PlayerController] 收到世界加载信号，开始重绑玩家...")

	# 等待一帧，确保Spawner已经完成视觉重建
	await get_tree().process_frame

	# 遍历所有实体视图，寻找玩家
	var player_view: BaseEntityView = null

	# 获取所有在"entity_views"组里的节点
	var entity_views: Array[Node] = get_tree().get_nodes_in_group("entity_views")

	for view in entity_views:
		if view is BaseEntityView and view.data != null and view.data.entity_type == "player":
			player_view = view
			print("[PlayerController] 找到玩家视图: ", view.data.id)
			break

	if player_view != null:
		# 更新目标视图
		target_view = player_view
		print("[PlayerController] 玩家重绑成功！")
	else:
		print("[PlayerController] 警告：未找到玩家实体视图")

# 外部调用的重绑函数（由Spawner调用）
func rebind_player(player_data: EntityData) -> void:
	print("[PlayerController] 收到外部重绑请求")
	_on_world_loaded()  # 直接调用内部重绑逻辑


# 每帧输入处理
func _process(delta: float) -> void:
	# 保存/加载功能（K键保存，L键加载） - 移动到最前，确保即使玩家死亡也能触发
	if Input.is_physical_key_pressed(KEY_K):
		print("[System] 正在保存世界状态...")
		WorldManager.save_world("test_slot")

	if Input.is_physical_key_pressed(KEY_L):
		print("[System] 正在读取存档...")
		WorldManager.load_world("test_slot")

	# 安全检查：确保目标视图和数据存在且存活
	if not _is_target_valid():
		return

	# 更新攻击冷却计时器
	if attack_timer > 0.0:
		attack_timer -= delta

	# 获取输入方向向量
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# 更新最后朝向（如果玩家有输入）
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()

	# 处理玩家移动
	if direction != Vector2.ZERO:
		_handle_player_movement(direction, delta)

	# 处理攻击输入
	if Input.is_action_just_pressed("ui_accept") and attack_timer <= 0.0:
		_handle_attack()

	# # 调试信息显示
	# _debug_attack_info()


# 检查目标有效性
func _is_target_valid() -> bool:
	if target_view == null:
		return false

	if target_view.data == null:
		return false

	# 检查实体是否存活
	if target_view.data.health <= 0.0:
		return false

	return true


# 处理玩家移动
func _handle_player_movement(direction: Vector2, delta: float) -> void:
	# 计算移动距离
	var move_distance: float = target_view.data.move_speed * delta

	# 直接修改数据层的位置 - 核心MVVM架构
	target_view.data.position += direction * move_distance

	# 限制玩家位置在世界边界内
	target_view.data.position = WorldManager.clamp_position(target_view.data.position)

	# 解决碰撞（防止穿墙）
	WorldManager.resolve_collisions(target_view.data)

	# 调试输出（可选）
	if Engine.is_editor_hint():
		print(
			"玩家移动: ",
			direction,
			" | 速度: ",
			target_view.data.move_speed,
			" | 新位置: ",
			target_view.data.position
		)


# 攻击处理逻辑
func _handle_attack() -> void:
	# 重置冷却计时器
	attack_timer = attack_cooldown

	# 攻击起点改为玩家自身位置
	var hit_origin: Vector2 = target_view.data.position

	# 触发攻击动画
	target_view.play_attack_anim(hit_origin, last_direction, attack_radius, attack_angle)

	# 直接访问全局 Autoload 单例
	var hit_count: int = 0
	for entity in WorldManager.entities:
		# 跳过无效实体
		if entity == null:
			continue

		# 跳过玩家自己
		if entity == target_view.data:
			continue

		# 跳过已死亡的实体
		if entity.health <= 0.0:
			continue

		# 第一关：距离过滤
		if entity.position.distance_to(hit_origin) > attack_radius:
			continue

		# 第二关：角度过滤
		var dir_to_enemy: Vector2 = (entity.position - hit_origin).normalized()
		var angle_diff: float = rad_to_deg(last_direction.angle_to(dir_to_enemy))

		if abs(angle_diff) > attack_angle / 2.0:
			continue

		# 通过两关判定，执行伤害
		entity.health -= attack_damage
		hit_count += 1
		EventBus.entity_damaged.emit(entity, attack_damage, hit_origin)
		print("攻击命中: ", entity.id, " | 伤害: ", attack_damage, " | 剩余生命: ", entity.health)

	# 攻击反馈
	if hit_count > 0:
		print("攻击成功！命中 ", hit_count, " 个目标")
	else:
		print("攻击落空")


# # 调试攻击信息
# func _debug_attack_info() -> void:
# 	if not Engine.is_editor_hint():
# 		return

# 	# 计算攻击圆心位置
# 	var hit_center: Vector2 = target_view.data.position + last_direction * attack_offset

# 	# 显示攻击范围信息
# 	print("攻击圆心: ", hit_center, " | 冷却: ", attack_timer, " | 朝向: ", last_direction)


# 限制玩家位置在世界边界内
func _clamp_position_to_world_bounds() -> void:
	# 这里可以添加世界边界限制逻辑
	pass
	# 例如：限制在特定区域内移动
	# target_view.data.position = target_view.data.position.clamp(Vector2.ZERO, world_size)
	pass


# 调试信息显示
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if target_view == null:
		warnings.append("target_view 未设置，玩家控制器将无法工作")

	return warnings


# 获取当前玩家状态信息（用于UI显示等）
func get_player_info() -> Dictionary:
	if not _is_target_valid():
		return {}

	return {
		"position": target_view.data.position,
		"health": target_view.data.health,
		"entity_type": target_view.data.entity_type,
		"faction": target_view.data.faction
	}


# 设置玩家移动速度（外部控制接口）
func set_move_speed(speed: float) -> void:
	if _is_target_valid():
		target_view.data.move_speed = speed


# 获取玩家移动速度
func get_move_speed() -> float:
	if _is_target_valid():
		return target_view.data.move_speed
	return 0.0
```

---

### 🔗 文件: scripts\core\world_manager.gd
- **Raw 链接:** [scripts/core/world_manager.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/world_manager.gd)
```gdscript
# res://scripts/core/world_manager.gd
# class_name WorldManager
extends Node

## 世界管理器单例
## 负责：时间步进、实体数据持有、存档序列化

# --- 信号 ---
signal world_ticked(tick_count: int)
signal world_loaded()  # 世界加载完成信号

# --- 配置 ---
@export_group("Simulation")
@export var ticks_per_second: float = 10.0
@export var world_bounds: Rect2 = Rect2(-600, -400, 1200, 800)  # 世界边界矩形

# --- 运行时数据 ---
var entities: Array[EntityData] = []
var current_tick: int = 0
var accumulator: float = 0.0

# --- 核心逻辑 ---

func _process(delta: float) -> void:
	# 使用累加器确保固定步进
	accumulator += delta
	var tick_interval: float = 1.0 / ticks_per_second

	while accumulator >= tick_interval:
		accumulator -= tick_interval
		tick_step()

# world_manager.gd 中的核心逻辑更新
func tick_step() -> void:
	current_tick += 1

	for entity in entities:
		if not is_instance_valid(entity): continue

		# 1. 基础演化 (变老)
		entity.age_step(1)

		# 2. 简单的 AI 决策：机械体捕食逻辑
		if entity.entity_type == "mechanical":
			_handle_mechanical_ai(entity)

	world_ticked.emit(current_tick)

# 针对 MX110 优化的数组查找逻辑
# world_manager.gd 中的修正版函数
func _handle_mechanical_ai(hunter: EntityData) -> void:
	# 1. 寻找最近的猎物（玩家优先级）
	var nearest_prey: EntityData = null
	var min_dist = 400.0 # 感知范围

	for target in entities:
		# 跳过无效目标
		if target.health <= 0:
			continue

		var d: float = hunter.position.distance_to(target.position)
		if d > min_dist:
			continue

		# 判断目标类型
		var is_player: bool = (target.entity_type == "player")
		var is_organic: bool = (target.entity_type == "organic")

		# 玩家优先级逻辑
		if is_player:
			# 锁定玩家：除非有更近的玩家，否则不切换目标
			nearest_prey = target
			min_dist = d
		elif is_organic and (nearest_prey == null or nearest_prey.entity_type != "player"):
			# 只有当前没有锁定玩家时，才考虑有机体
			if d < min_dist:
				nearest_prey = target
				min_dist = d

	# 2. 决策行为
	if nearest_prey:
		# --- 核心改进：移动逻辑 ---
		# 只有当距离大于 5 像素时才真正执行移动
		# 这样可以防止在目标点附近"反复横跳"
		if min_dist > 5.0:
			var dir = (nearest_prey.position - hunter.position).normalized()
			# 计算本次 tick 的位移量
			var movement = dir * hunter.move_speed * 0.1
			hunter.position += movement

		# --- 核心改进：伤害逻辑 ---
		# 只有足够近（小于 10 像素）才吸血
		if min_dist < 10.0:
			nearest_prey.health -= 5.0 # 有机体扣血
			hunter.health = min(100.0, hunter.health + 2.0) # 机械体回血

	# 【重要修复】无论有没有猎物，都得守法（不穿墙、不撞墙）
	hunter.position = clamp_position(hunter.position)
	resolve_collisions(hunter)

# --- 实体管理 ---
func register_entity(data: EntityData) -> void:
	if data != null and not entities.has(data):
		entities.append(data)
		print("实体已注册: ", data.id)

func unregister_entity(data: EntityData) -> void:
	if data != null and entities.has(data):
		entities.erase(data)
		print("实体已注销: ", data.id)

# --- 持久化逻辑 ---

func save_world(slot_name: String) -> void:
	# 创建临时资源容器
	var world_data: WorldSaveData = WorldSaveData.new()

	# 复制当前世界状态（避免引用问题）
	world_data.entities = entities.duplicate(true)
	world_data.current_tick = current_tick
	world_data.save_timestamp = Time.get_unix_time_from_system()

	# 构建保存路径
	var save_path: String = "user://saves/" + slot_name + ".res"

	# 确保保存目录存在
	var dir: DirAccess = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")

	# 保存资源文件
	var error: Error = ResourceSaver.save(world_data, save_path)
	if error == OK:
		print("世界状态已保存到: ", save_path)
	else:
		push_error("保存失败，错误码: " + str(error))

func load_world(slot_name: String) -> void:
	# 构建加载路径
	var load_path: String = "user://saves/" + slot_name + ".res"

	# 检查文件是否存在
	if not FileAccess.file_exists(load_path):
		push_error("存档文件不存在: " + load_path)
		return

	# 加载资源文件
	var world_data: WorldSaveData = ResourceLoader.load(
		load_path, "", ResourceLoader.CACHE_MODE_IGNORE)

	if world_data != null:
		# 恢复世界状态
		entities = world_data.entities.duplicate(true)
		current_tick = world_data.current_tick
		accumulator = 0.0  # 重置累加器

		print("世界状态已加载，实体数量: ", entities.size())
		print("当前tick: ", current_tick)
		print("保存时间: ", world_data.save_timestamp)

		# 发出世界加载完成信号
		world_loaded.emit()
	else:
		push_error("加载失败: " + load_path)

# 碰撞检测与解决函数
func resolve_collisions(subject: EntityData) -> void:
	# 遍历所有实体，检测与静态障碍物的碰撞
	for entity in entities:
		# 跳过无效实体和自己
		if entity == null or entity == subject:
			continue

		# 只检测与静态障碍物的碰撞
		if entity.entity_type == "static":
			# 计算两实体间的距离
			var d: float = subject.position.distance_to(entity.position)

			# 计算最小安全距离（半径之和）
			var min_dist: float = subject.collision_radius + entity.collision_radius

			# 如果发生碰撞
			if d < min_dist and d > 0.0:
				# 计算挤开向量
				var push: Vector2 = (subject.position - entity.position).normalized() * (min_dist - d)

				# 应用排斥力
				subject.position += push

				# 约束位置在世界边界内
				subject.position = clamp_position(subject.position)

# 位置限制函数
func clamp_position(pos: Vector2) -> Vector2:
	# 返回世界边界限制后的坐标
	return pos.clamp(world_bounds.position, world_bounds.position + world_bounds.size)

# 获取当前世界状态信息
func get_world_info() -> Dictionary:
	return {
		"current_tick": current_tick,
		"entity_count": entities.size(),
		"ticks_per_second": ticks_per_second,
		"world_bounds": world_bounds
	}

# 清空世界状态（用于重置或测试）
func clear_world() -> void:
	entities.clear()
	current_tick = 0
	accumulator = 0.0
	print("世界状态已清空")

# --- 辅助数据容器 ---

# ## 世界保存数据容器类
# class WorldSaveData extends Resource:
# 	@export var entities: Array[EntityData] = []
# 	@export var current_tick: int = 0
# 	@export var save_timestamp: int = 0
```

---

### 🔗 文件: scripts\core\world_save_data.gd
- **Raw 链接:** [scripts/core/world_save_data.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/world_save_data.gd)
```gdscript
# res://scripts/core/world_save_data.gd
class_name WorldSaveData
extends Resource

## 这个类专门负责承载存档数据，现在它是一个独立的全局类了
@export var entities: Array[EntityData] = []
@export var current_tick: int = 0
@export var save_timestamp: int = 0
```

---

### 🔗 文件: scripts\core\world_settings.gd
- **Raw 链接:** [scripts/core/world_settings.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/world_settings.gd)
```gdscript
extends Node2D
# 这是一个桥接脚本，专门用来在编辑器里调数值，然后传给全局单例
@export var world_size: Vector2 = Vector2(1200, 800)

func _ready() -> void:
    # 启动时，把这里的设置同步给全局单例
    WorldManager.world_bounds = Rect2(-world_size/2, world_size)
```

---

### 🔗 文件: scripts\core\world_spawner.gd
- **Raw 链接:** [scripts/core/world_spawner.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/world_spawner.gd)
```gdscript
class_name WorldSpawner
extends Node2D

# 世界生成器类
# 功能：在指定区域内生成不同类型的实体
# 设计目标：提供可配置的实体生成系统，支持动态世界构建

# 配置变量
@export var base_view_scene: PackedScene = null  # 基础实体视图场景
@export var organic_count: int = 20              # 有机体（食物）生成数量
@export var mechanical_count: int = 3            # 机械体（猎食者）生成数量
@export var static_obstacle_count: int = 15      # 静态障碍物数量
@export var spawn_range: Vector2 = Vector2(1000, 1000)  # 生成区域范围

# 内部计数器
var total_spawned: int = 0

# 节点初始化
func _ready() -> void:
	# 连接世界加载信号，实现读档后的视觉重建
	WorldManager.world_loaded.connect(_on_world_loaded)

	# 延迟一帧生成，确保所有系统已初始化
	call_deferred("spawn_all")

# 读档后的视觉重建逻辑
func _on_world_loaded() -> void:
	print("[Spawner] 开始读档后的视觉重建...")

	# 第一步：清场 - 瞬间杀掉地图上所有的旧肉身
	get_tree().call_group("entity_views", "queue_free")
	print("[Spawner] 已清理所有旧实体视图")

	# 第二步：等待一帧，确保旧肉身已经彻底清理干净
	await get_tree().process_frame

	# 第三步：重生 - 根据WorldManager中的新灵魂重新塑造肉身
	var player_entity: EntityData = null

	for entity_data in WorldManager.entities:
		if entity_data == null:
			continue

		# 实例化新的实体视图
		var entity_view: BaseEntityView = base_view_scene.instantiate()

		# 核心绑定：将新视图绑定到存档中的实体数据
		entity_view.data = entity_data

		# 添加为子节点
		add_child(entity_view)

		# 记录玩家实体，用于后续重绑
		if entity_data.entity_type == "player":
			player_entity = entity_data
			print("[Spawner] 找到玩家实体: ", entity_data.id)

	print("[Spawner] 视觉重建完成，共重生 ", WorldManager.entities.size(), " 个实体")

	# 第四步：通知PlayerController更新目标视图（如果找到玩家）
	if player_entity != null:
		# 通过EventBus或直接通知PlayerController
		call_deferred("_notify_player_rebind", player_entity)

# 延迟通知PlayerController重绑玩家
func _notify_player_rebind(player_data: EntityData) -> void:
	# 查找PlayerController节点并通知它
	var player_controller: PlayerController = get_tree().get_first_node_in_group("player_controllers")
	if player_controller != null:
		player_controller.call_deferred("rebind_player", player_data)
	else:
		print("[Spawner] 警告：未找到PlayerController节点")

# 重新生成所有实体（可用于重置或测试）
func respawn_all() -> void:
	# 清除现有实体
	for child in get_children():
		if child is BaseEntityView:
			child.queue_free()

	# 重置计数器
	total_spawned = 0

	# 重新生成
	spawn_all()

# 批量生成所有实体
func spawn_all() -> void:
	# 生成有机体（食物）
	for i in range(organic_count):
		_create_entity("organic", "food_" + str(i))

	# 生成机械体（猎食者）
	for i in range(mechanical_count):
		_create_entity("mechanical", "hunter_" + str(i))

	# 生成静态障碍物
	for i in range(static_obstacle_count):
		_create_static_obstacle("obstacle_" + str(i))

	# 打印统计信息
	print("世界生成完成 - 总计实体: ", total_spawned)
	print("有机体: ", organic_count, " | 机械体: ", mechanical_count, " | 障碍物: ", static_obstacle_count)
	print("生成区域: ", spawn_range)

# 创建单个实体
func _create_entity(entity_type: String, entity_id: String) -> void:
	# 安全检查
	if base_view_scene == null:
		push_error("WorldSpawner: base_view_scene 未设置")
		return

	# 实例化实体视图
	var entity_view: BaseEntityView = base_view_scene.instantiate()

	# 创建全新的实体数据（确保数据独立）
	var entity_data: EntityData = EntityData.new()

	# 设置实体数据属性
	entity_data.id = entity_id
	entity_data.entity_type = entity_type
	entity_data.faction = _get_faction_by_type(entity_type)
	entity_data.health = _get_initial_health(entity_type)
	entity_data.position = _get_random_position()

	# 绑定数据到视图
	entity_view.data = entity_data

	# 添加为子节点
	add_child(entity_view)

	# 更新计数器
	total_spawned += 1

	# 调试信息
	print("生成实体: ", entity_id, " | 类型: ", entity_type, " | 位置: ", entity_data.position)

# 根据实体类型获取初始生命值
func _get_initial_health(entity_type: String) -> float:
	match entity_type:
		"organic":
			return 50.0  # 食物生命值较低
		"mechanical":
			return 150.0  # 猎食者生命值较高
		_:
			return 100.0  # 默认值

# 根据实体类型获取阵营
func _get_faction_by_type(entity_type: String) -> String:
	match entity_type:
		"organic":
			return "prey"  # 猎物阵营
		"mechanical":
			return "predator"  # 捕食者阵营
		_:
			return "neutral"  # 默认阵营

# 创建静态障碍物
func _create_static_obstacle(obstacle_id: String) -> void:
	# 安全检查
	if base_view_scene == null:
		push_error("WorldSpawner: base_view_scene 未设置")
		return

	# 实例化实体视图
	var obstacle_view: BaseEntityView = base_view_scene.instantiate()

	# 创建全新的实体数据
	var obstacle_data: EntityData = EntityData.new()

	# 设置障碍物属性
	obstacle_data.id = obstacle_id
	obstacle_data.entity_type = "static"
	obstacle_data.faction = "neutral"
	obstacle_data.health = 9999.0  # 障碍物不可摧毁
	obstacle_data.collision_radius = randf_range(30.0, 50.0)  # 随机半径30-50
	obstacle_data.position = _get_random_position()

	# 绑定数据到视图
	obstacle_view.data = obstacle_data

	# 添加为子节点
	add_child(obstacle_view)

	# 更新计数器
	total_spawned += 1

	# 调试信息
	print("生成障碍物: ", obstacle_id, " | 半径: "
	, obstacle_data.collision_radius, " | 位置: ", obstacle_data.position)

# 获取随机生成位置
func _get_random_position() -> Vector2:
	var random_x: float = randf_range(-spawn_range.x / 2, spawn_range.x / 2)
	var random_y: float = randf_range(-spawn_range.y / 2, spawn_range.y / 2)

	# 相对于生成器的位置
	return global_position + Vector2(random_x, random_y)

# 调试信息显示
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if base_view_scene == null:
		warnings.append("base_view_scene 未设置，无法生成实体")

	return warnings
```

---

