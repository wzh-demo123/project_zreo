# res://scripts/core/event_bus.gd
extends Node

## 全局信号中枢
## 作用：解耦战斗逻辑与视觉反馈

# 战斗信号：目标数据，伤害值，攻击者位置
signal entity_damaged(target_data: EntityData, amount: float, attacker_pos: Vector2)

# 律法时钟信号：用于驱动 UI 与环境反馈
signal taboo_changed(new_taboo: int)      # 禁忌变更
signal time_phase_changed(is_night: bool) # 昼夜更替
signal announcement(text: String)         # 全局文字播报

# 状态同步信号：用于 UI 刷新
signal player_stat_updated(key: String, value: Variant)  # 玩家状态更新

# 静态实体信号：用于视觉层生成
signal static_entity_spawned(static_data: StaticEntityData)  # 静态实体生成