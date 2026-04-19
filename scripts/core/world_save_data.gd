# res://scripts/core/world_save_data.gd
class_name WorldSaveData
extends Resource

## 这个类专门负责承载存档数据，现在它是一个独立的全局类了
@export var entities: Array[EntityData] = []
@export var current_tick: int = 0
@export var save_timestamp: int = 0