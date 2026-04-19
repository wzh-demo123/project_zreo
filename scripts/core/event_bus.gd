# res://scripts/core/event_bus.gd
extends Node

## 全局信号中枢
## 作用：解耦战斗逻辑与视觉反馈

# 信号：目标数据，伤害值，攻击者位置
signal entity_damaged(target_data: EntityData, amount: float, attacker_pos: Vector2)