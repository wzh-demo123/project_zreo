# Project Zero 项目状态

最后更新：2026-04-24

## 项目快照

- **当前阶段**：V0 可玩原型（核心生存闭环已打通）
- **核心单例**：`WorldManager`、`CalendarManager`、`EventBus`（autoload）
- **运行主线**：10Hz 逻辑步进 + UI 事件广播 + 存读档重建视图
- **已有玩法**：移动/攻击/采集/昼夜/禁忌/体温/热源/资源耗尽
- **代码规模**：13个脚本文件（核心12个 + UI 1个），约2500行代码
- **主要风险**：系统耦合仍集中在 `WorldManager`，参数散落

## 架构概览

### 已完成功能

- 世界主循环：`WorldManager` 在 `_physics_process` 中以 10Hz 驱动逻辑
- 核心生存参数：生命、能量、体温、昼夜、禁忌、采集收益已接入计算
- 数据与表现解耦：`EntityData/StaticEntityData` 作为 Model，`BaseEntityView` 做 View
- 交互链路完整：移动、攻击、采集、受击反馈、HUD 同步已贯通
- 世界内容生成：`WorldSpawner` 可批量生成有机体/机械体/障碍物
- 存读档闭环：`K/L` 测试存档读取，读档后重建视图和相机绑定

### 架构优势

- 逻辑与视觉分离方向正确，符合 `WORLD_DESIGN.md` 的"以数代形"原则
- 使用 `EventBus` 做全局广播，避免 UI/特效反向污染核心逻辑
- 主要生存逻辑集中在 `WorldManager`，便于后续统一调度和性能控制
- 没有依赖 Godot 物理节点做核心判定，符合纯数学约束

### 技术债务

- 常量分散：代谢、伤害、体温阈值等魔法数散落在多个脚本
- 子系统边界偏松：`WorldManager` 同时承担 Tick、战斗、采集、温度、AI，后续会膨胀
- 规则可配置性不足：禁忌效果仍是硬编码，难以快速迭代平衡
- 自动化验证不足：缺少最小回归测试清单

## 优先级与里程碑

### 当前优先级（Top 3）

1. **玩法扩展**：生物群落律法接入、资源再生曲线、行为状态机
2. **自动化测试**：建立自动化回归测试，替代手测清单
3. **性能优化**：优化实体查找算法，考虑空间分区

### 里程碑规划

**Milestone A：稳定化（1-2 天）** ✅ 已完成
- 抽离平衡参数到统一配置（例如 `WorldTuning` 资源）✅
- 固化手测清单：移动、攻击、采集、昼夜切换、禁忌生效、存读档重绑 ✅
- 给 `WorldManager` 增加最小 debug 统计（tick 耗时、实体数量、静态实体数量）✅

**Milestone B：系统拆分（2-4 天）** ✅ 已完成
将 `WorldManager` 内部拆为独立系统函数/模块：
- `MetabolismSystem` - 代谢系统 ✅
- `CombatSystem` - 战斗系统 ✅
- `HarvestSystem` - 采集系统 ✅
- `TemperatureSystem` - 温度系统 ✅
- `SimpleAISystem` - 简单AI系统 ✅

保持统一入口仍在 `WorldManager.tick_step()`，但职责清晰、可替换。

**Milestone C：玩法扩展（并行推进）**
- 生物群落律法（Biome Law）接入地图区域
- 资源再生/衰减曲线（避免资源点一次采空后无玩法）
- 机械体/有机体更清晰的行为状态机（巡逻、追击、撤退）

## 代码结构

```
scripts/
├── core/           # 核心系统（12个文件）
│   ├── base_entity_view.gd      # 实体视图基类
│   ├── calendar_manager.gd      # 律法时钟管理器
│   ├── camera.gd                # 平滑跟随摄像机
│   ├── entity_data.gd           # 实体数据模型
│   ├── event_bus.gd             # 全局信号中枢
│   ├── map_generator.gd         # 地图生成器
│   ├── player_controller.gd     # 玩家输入控制器
│   ├── static_entity_data.gd    # 静态实体数据模型
│   ├── world_manager.gd         # 世界管理器（核心单例）
│   ├── world_save_data.gd       # 存档数据容器
│   ├── world_settings.gd        # 世界设置桥接
│   ├── world_spawner.gd         # 世界生成器
│   ├── world_tuning.gd          # 平衡参数资源
│   └── systems/                 # 系统模块（5个文件）
│       ├── temperature_system.gd    # 温度系统
│       ├── metabolism_system.gd     # 代谢系统
│       ├── combat_system.gd         # 战斗系统
│       ├── harvest_system.gd        # 采集系统
│       └── simple_ai_system.gd      # AI系统
└── ui/             # UI系统（1个文件）
    └── debug_hud.gd             # 调试HUD界面
```

## 会话记录

### [2026-04-24]

- 完成：项目全量代码读取与文档整合
- 优化：重构文档结构，合并 WORKING_MEMORY.md 和 ARCHITECTURE_ROADMAP.md
- 状态：文档结构简化，职责清晰
- 完成：抽离平衡参数到 WorldTuning 资源类
- 更新：WorldManager、PlayerController、WorldSpawner 使用 WorldTuning 参数
- 新增：`scripts/core/world_tuning.gd`（包含代谢、温度、战斗、采集、生成等所有平衡参数）
- 状态：魔法数问题解决，参数可在编辑器中调整
- 完成：Milestone A 稳定化任务
  - 固化手测清单（基础功能、系统交互、实体行为、参数验证）
  - 给 WorldManager 增加 debug 统计（tick 耗时、实体数量统计，每秒输出）
- 完成：Milestone B 系统拆分任务
  - 新增：`scripts/core/systems/temperature_system.gd`（温度系统）
  - 新增：`scripts/core/systems/metabolism_system.gd`（代谢系统）
  - 新增：`scripts/core/systems/combat_system.gd`（战斗系统）
  - 新增：`scripts/core/systems/harvest_system.gd`（采集系统）
  - 新增：`scripts/core/systems/simple_ai_system.gd`（AI系统）
  - 更新：WorldManager 使用所有系统类，职责清晰化
  - 删除：WorldManager 中的旧函数（_handle_temperature、_handle_metabolism、_handle_mechanical_ai、_find_nearest_resource）
- 修复：SimpleAISystem 中硬编码的 tick 间隔（0.1），改为从 ticks_per_second 动态计算
- 状态：系统拆分完成，WorldManager 从 600+ 行缩减至约 400 行

### [2026-04-23]

- 完成：全量代码与架构状态盘点
- 新增：`docs/md/ARCHITECTURE_ROADMAP.md`、`WORKING_MEMORY.md`
- 结论：进入"稳定化 + 系统拆分"阶段最合适

## 回归测试清单（最小必跑）

### 基础功能测试
- [ ] **移动测试**：玩家可用WASD/方向键移动，受世界边界约束不穿墙
- [ ] **碰撞测试**：移动时会被静态障碍物阻挡，不会穿透
- [ ] **攻击测试**：按空格键可攻击，有冷却时间
- [ ] **采集测试**：按E键可采集附近资源，获得能量并更新HUD
- [ ] **存档测试**：按K键保存世界状态，控制台显示保存成功
- [ ] **读档测试**：按L键读取存档，玩家/相机/静态实体重绑成功

### 系统交互测试
- [ ] **昼夜切换**：时间流逝，夜晚/白天切换正确，有公告提示
- [ ] **禁忌系统**：忌出行时移动能量消耗增加5倍
- [ ] **禁忌系统**：忌杀生时攻击伤害降低50%
- [ ] **禁忌系统**：宜挖掘时采集收益翻倍
- [ ] **体温系统**：夜晚体温下降，靠近热源时体温回升
- [ ] **失温伤害**：体温低于30度时持续扣除生命值
- [ ] **空腹伤害**：能量耗尽时持续扣除生命值

### 实体行为测试
- [ ] **机械体AI**：机械体会追击玩家和有机体
- [ ] **机械体攻击**：靠近目标时造成伤害并吸血
- [ ] **资源耗尽**：资源点采集完毕后消失
- [ ] **能量上限**：采集能量不超过100上限

### 参数调整验证（使用WorldTuning）
- [ ] 修改 `tuning.combat_player_damage` 后攻击伤害变化
- [ ] 修改 `tuning.metabolism_base_rate` 后能量消耗变化
- [ ] 修改 `tuning.harvest_base_gain` 后采集收益变化

## 开发协作原则

- 每个会话只做一个小闭环（一个系统、一个缺陷、一个可见效果）
- 每次完成后必须更新本文件的"会话记录"部分
- 不在长对话里堆积所有细节，把细节沉淀到文档，再在新会话引用文档

## 会话启动模板

```text
请先读取以下文件并按优先级理解项目：
1) docs/md/WORLD_DESIGN.md
2) docs/md/PROJECT_STATUS.md
3) （可选）相关模块源码

目标：
- 先用 5 条以内总结当前阶段
- 给出本次只做一个小闭环的实现方案
- 完成后更新 docs/md/PROJECT_STATUS.md 的会话记录
```
