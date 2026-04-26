# 📂 Project Zero: 全量架构快照 (Full Context)
> **生成时间:** 2026-04-24 22:31:43
> **基础 Raw 路径:** `https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/`

## 🌳 完整目录结构
```text
└── ./
    ├── AI_CONTEXT_MAP.md
    ├── flatten_code.py
    ├── project.godot
    └── .cursor/
    └── .vscode/
    └── docs/
        └── md/
            ├── IDEAS_SCRAPBOOK.md
            ├── PROJECT_STATUS.md
            ├── README.md
            ├── WORLD_DESIGN.md
    └── scenes/
        ├── base_entity_view.tscn
        ├── main.tscn
        └── ui/
            ├── debug_hud.tscn
    └── scripts/
        └── core/
            ├── base_entity_view.gd
            ├── calendar_manager.gd
            ├── camera.gd
            ├── entity_data.gd
            ├── event_bus.gd
            ├── map_generator.gd
            ├── player_controller.gd
            ├── static_entity_data.gd
            ├── world_manager.gd
            ├── world_save_data.gd
            ├── world_settings.gd
            ├── world_spawner.gd
            ├── world_tuning.gd
            └── systems/
                ├── combat_system.gd
                ├── harvest_system.gd
                ├── metabolism_system.gd
                ├── simple_ai_system.gd
                ├── temperature_system.gd
        └── ui/
            ├── debug_hud.gd
```

---

## 📜 核心设计文档 (Priority Docs)
AI 协作前请务必先读取此部分的世界观约束。

### 🔗 文件: docs\md\WORLD_DESIGN.md
- **Raw 链接:** [docs/md/WORLD_DESIGN.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/WORLD_DESIGN.md)
```markdown
# 零号协议 (Project Zero) - 世界观与核心规则宪法 (V1.0)

**最后更新**: 2026-04-21 22:15
**核心哲学**: 以数代形 (MX110 优化), 逻辑渲染分离, 电子民俗生存。可以参考饥荒，僵尸毁灭工程的一些设计思路元素。

## 一、 核心支柱

1. **时空律法 (Chronos-Spatial Laws)**: 世界由“禁忌”统治。每一天、每一块土地都有其特定的物理/逻辑修正。
2. **电子民俗 (Cyber-Folkloric)**: 将中式黄历（宜/忌）、纸扎美学与机械末日结合。
3. **动态生态链 (Dynamic Ecosystem)**: 机械体(Mechanoids)与有机体(Organics)存在真实的资源竞争、领地扩张与种群兴衰。

## 二、 律法系统

- **黄历禁忌 (The Almanac)**: 全局随机。影响代谢速率、仇恨距离、采集收益。
- **生物群落律法 (Biome Laws)**: 区域固定。
  - _机械荒原_: 忌金属（穿戴金属受损）。
  - _猩红湿地_: 宜斋戒（肉食降理智）。

## 三、 世代与演化

- 死亡不重置世界。前世遗骸会转化为后世的资源、防御塔或“数据鬼魂”。
- 生态系统会根据统治度 (Dominance) 自主进行网格同化。

```

---

### 🔗 文件: docs\md\PROJECT_STATUS.md
- **Raw 链接:** [docs/md/PROJECT_STATUS.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/PROJECT_STATUS.md)
```markdown
# Project Zero 项目状态

最后更新：2026-04-24 22:04:00

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
- 更新：flatten_code.py 添加 PROJECT_STATUS.md 到优先级文档列表
- 更新：README.md 添加文档规范（时间戳格式）和 flatten_code.py 说明

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

```

---

### 🔗 文件: docs\md\IDEAS_SCRAPBOOK.md
- **Raw 链接:** [docs/md/IDEAS_SCRAPBOOK.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/IDEAS_SCRAPBOOK.md)
```markdown
# 零号协议：灵感剪贴簿 (Scrapbook)

## [2026-04-21 22:10] - 碎片化灵感录入

- **生态演化**: 网格统治度模型。机械化(Grey) vs 血肉化(Crimson)。
- **中西民俗**: 耶稣/圣餐仪式作为“逻辑清洗协议”？黄历宜忌作为“代码执行补丁”？
- **地图边界**: 采用“虚空噪声”效果，而非空气墙。进入边界产生代码报错式的掉血。
- **食物链**: 机械体收割有机生物作为“生物电池”；有机体通过氧化反应寄生并分解机械。
- **可持续性**: 装备材质系统。为了去特定区域，玩家必须放弃强力金属装，换上草编或陶瓷装。

```

---

## 📄 全量代码与配置索引
### 🔗 文件: flatten_code.py
- **Raw 链接:** [flatten_code.py](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/flatten_code.py)
```python
import os
import datetime

# --- 核心配置 (保持原版命名) ---
REPO_BASE_URL = "https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/"
OUTPUT_FILE = "AI_CONTEXT_MAP.md"

# 优先级文档：这些文件将出现在生成的 MD 最顶端
PRIORITY_DOCS = [
    "docs/md/WORLD_DESIGN.md",
    "docs/md/PROJECT_STATUS.md",
    "docs/md/IDEAS_SCRAPBOOK.md",
    "AI_CONTEXT_MAP.md"
]

# 定义需要包含的文件后缀
INCLUDE_EXTS = [
    '.gd',    # GDScript 逻辑
    '.tscn',  # 场景结构
    '.godot', # 项目配置
    '.md',    # 文档说明
    '.cfg',   # 配置文件
    '.py'     # 脚本工具
]

# 定义排除的目录
EXCLUDE_DIRS = {
    '.git',
    '.godot',
    '.history',
    'assets',
    'addons',
    'export'
}

def get_dir_tree(startpath):
    """生成可视化的目录树结构 (保持原版逻辑)"""
    tree = []
    for root, dirs, files in os.walk(startpath):
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * level
        tree.append(f"{indent}└── {os.path.basename(root) or startpath}/")
        sub_indent = ' ' * 4 * (level + 1)
        for f in files:
            if any(f.endswith(ext) for ext in INCLUDE_EXTS):
                tree.append(f"{sub_indent}├── {f}")
    return "\n".join(tree)

def write_file_content(f, root, filename):
    """内部工具函数：统一写入文件内容块"""
    file_path = os.path.relpath(os.path.join(root, filename), ".")
    url_path = file_path.replace(os.sep, "/")
    raw_link = f"{REPO_BASE_URL}{url_path}"

    f.write(f"### 🔗 文件: {file_path}\n")
    f.write(f"- **Raw 链接:** [{url_path}]({raw_link})\n")

    # 确定语法高亮类型
    lang = "gdscript"
    if filename.endswith(".tscn") or filename.endswith(".godot"):
        lang = "toml"
    elif filename.endswith(".md"):
        lang = "markdown"
    elif filename.endswith(".py"):
        lang = "python"

    f.write(f"```{lang}\n")
    try:
        with open(os.path.join(root, filename), "r", encoding="utf-8", errors="ignore") as src:
            f.write(src.read())
    except Exception as e:
        f.write(f"读取失败: {str(e)}")
    f.write("\n```\n\n---\n\n")

def generate_map():
    print("🚀 正在生成全量项目逻辑地图 (含世界观置顶)...")

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        # 1. 写入元数据
        f.write("# 📂 Project Zero: 全量架构快照 (Full Context)\n")
        f.write(f"> **生成时间:** {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"> **基础 Raw 路径:** `{REPO_BASE_URL}`\n\n")

        # 2. 写入目录树
        f.write("## 🌳 完整目录结构\n")
        f.write("```text\n")
        f.write(get_dir_tree("."))
        f.write("\n```\n\n---\n\n")

        # 3. 优先处理设计文档 (这是本次的核心改动)
        f.write("## 📜 核心设计文档 (Priority Docs)\n")
        f.write("AI 协作前请务必先读取此部分的世界观约束。\n\n")
        for doc in PRIORITY_DOCS:
            if os.path.exists(doc) and doc != OUTPUT_FILE:
                write_file_content(f, ".", doc)

        # 4. 遍历写入其余代码文件
        f.write("## 📄 全量代码与配置索引\n")
        for root, dirs, files in os.walk("."):
            dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
            for filename in files:
                # 排除已经置顶处理的文件和输出文件本身
                if any(filename.endswith(ext) for ext in INCLUDE_EXTS):
                    if filename in PRIORITY_DOCS or filename == OUTPUT_FILE:
                        continue
                    write_file_content(f, root, filename)

    print(f"✅ 成功！全量地图已保存至: {OUTPUT_FILE}")
    print(f"💡 建议：git add . && git commit -m 'SYNC: 更新世界观与逻辑地图' && git push")

if __name__ == "__main__":
    generate_map()
```

---

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
CalendarManager="*res://scripts/core/calendar_manager.gd"

[rendering]

textures/canvas_textures/default_texture_filter=0
renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
2d/snap/snap_2d_transforms_to_pixel=true

```

---

### 🔗 文件: docs\md\IDEAS_SCRAPBOOK.md
- **Raw 链接:** [docs/md/IDEAS_SCRAPBOOK.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/IDEAS_SCRAPBOOK.md)
```markdown
# 零号协议：灵感剪贴簿 (Scrapbook)

## [2026-04-21 22:10] - 碎片化灵感录入

- **生态演化**: 网格统治度模型。机械化(Grey) vs 血肉化(Crimson)。
- **中西民俗**: 耶稣/圣餐仪式作为“逻辑清洗协议”？黄历宜忌作为“代码执行补丁”？
- **地图边界**: 采用“虚空噪声”效果，而非空气墙。进入边界产生代码报错式的掉血。
- **食物链**: 机械体收割有机生物作为“生物电池”；有机体通过氧化反应寄生并分解机械。
- **可持续性**: 装备材质系统。为了去特定区域，玩家必须放弃强力金属装，换上草编或陶瓷装。

```

---

### 🔗 文件: docs\md\PROJECT_STATUS.md
- **Raw 链接:** [docs/md/PROJECT_STATUS.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/PROJECT_STATUS.md)
```markdown
# Project Zero 项目状态

最后更新：2026-04-24 22:04:00

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
- 更新：flatten_code.py 添加 PROJECT_STATUS.md 到优先级文档列表
- 更新：README.md 添加文档规范（时间戳格式）和 flatten_code.py 说明

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

```

---

### 🔗 文件: docs\md\README.md
- **Raw 链接:** [docs/md/README.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/README.md)
```markdown
# Project Zero 文档导航

该目录集中放置项目协作与记忆相关文档。

## 核心文档

- **WORLD_DESIGN.md**：世界观与硬约束宪法（项目哲学与规则）
- **PROJECT_STATUS.md**：项目状态、架构概览、优先级与里程碑、会话记录（动态状态中心）
- **IDEAS_SCRAPBOOK.md**：灵感碎片记录（创意储备）

## 根目录文件

- `.cursorrules`：Cursor 实际生效规则入口（必须在根目录）
- `AI_CONTEXT_MAP.md`：全量快照主文件（由 `flatten_code.py` 脚本生成，默认根目录）
- `flatten_code.py`：代码快照生成脚本（用于外部模型无法访问 GitHub 时生成全量代码快照）

## 使用建议

- **新会话启动**：按顺序读取 WORLD_DESIGN.md → PROJECT_STATUS.md
- **日常开发**：优先参考 PROJECT_STATUS.md 获取当前状态和优先级
- **创意扩展**：查阅 IDEAS_SCRAPBOOK.md
- **开发规则**：参考根目录 `.cursorrules` 文件

## 文档规范

- **时间戳格式**：文档更新时需添加具体时间（格式：YYYY-MM-DD HH:MM:SS）

```

---

### 🔗 文件: docs\md\WORLD_DESIGN.md
- **Raw 链接:** [docs/md/WORLD_DESIGN.md](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/docs/md/WORLD_DESIGN.md)
```markdown
# 零号协议 (Project Zero) - 世界观与核心规则宪法 (V1.0)

**最后更新**: 2026-04-21 22:15
**核心哲学**: 以数代形 (MX110 优化), 逻辑渲染分离, 电子民俗生存。可以参考饥荒，僵尸毁灭工程的一些设计思路元素。

## 一、 核心支柱

1. **时空律法 (Chronos-Spatial Laws)**: 世界由“禁忌”统治。每一天、每一块土地都有其特定的物理/逻辑修正。
2. **电子民俗 (Cyber-Folkloric)**: 将中式黄历（宜/忌）、纸扎美学与机械末日结合。
3. **动态生态链 (Dynamic Ecosystem)**: 机械体(Mechanoids)与有机体(Organics)存在真实的资源竞争、领地扩张与种群兴衰。

## 二、 律法系统

- **黄历禁忌 (The Almanac)**: 全局随机。影响代谢速率、仇恨距离、采集收益。
- **生物群落律法 (Biome Laws)**: 区域固定。
  - _机械荒原_: 忌金属（穿戴金属受损）。
  - _猩红湿地_: 宜斋戒（肉食降理智）。

## 三、 世代与演化

- 死亡不重置世界。前世遗骸会转化为后世的资源、防御塔或“数据鬼魂”。
- 生态系统会根据统治度 (Dominance) 自主进行网格同化。

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
[gd_scene load_steps=13 format=4 uid="uid://c3pno5hr8r6jo"]

[ext_resource type="Texture2D" uid="uid://b13nwsa6xoxb" path="res://assets/Terrain/Tileset/Tilemap_color1.png" id="1_1fjc7"]
[ext_resource type="Script" path="res://scripts/core/world_spawner.gd" id="1_p6nn4"]
[ext_resource type="PackedScene" uid="uid://6h6gfsxf4xjv" path="res://scenes/base_entity_view.tscn" id="2_12kl3"]
[ext_resource type="Script" path="res://scripts/core/map_generator.gd" id="2_hissr"]
[ext_resource type="Script" path="res://scripts/core/player_controller.gd" id="3_22o7b"]
[ext_resource type="Script" path="res://scripts/core/camera.gd" id="4_ocl17"]
[ext_resource type="Script" path="res://scripts/core/entity_data.gd" id="4_q3diw"]
[ext_resource type="Script" path="res://scripts/core/world_settings.gd" id="5_qn0tx"]
[ext_resource type="PackedScene" path="res://scenes/ui/debug_hud.tscn" id="6_debug"]

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
max_energy = 100.0
collision_radius = 20.0
last_position = Vector2(0, 0)
temperature = 36.5
is_near_heat_source = false

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

[node name="DebugHUD" parent="." instance=ExtResource("6_debug")]

```

---

### 🔗 文件: scenes\ui\debug_hud.tscn
- **Raw 链接:** [scenes/ui/debug_hud.tscn](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scenes/ui/debug_hud.tscn)
```toml
[gd_scene load_steps=3 format=4 uid="uid://debug_hud_tscn"]

[ext_resource type="Script" path="res://scripts/ui/debug_hud.gd" id="1_debug"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_bg"]
bg_color = Color(0, 0, 0, 0.7)
corner_radius_top_left = 5
corner_radius_top_right = 5
corner_radius_bottom_right = 0
corner_radius_bottom_left = 0

[node name="DebugHUD" type="CanvasLayer"]
layer = 10
script = ExtResource("1_debug")

[node name="VBoxContainer" type="VBoxContainer" parent="."]
anchors_preset = 0
anchor_top = 0.0
anchor_left = 0.0
anchor_right = 0.0
anchor_bottom = 0.0
margin_left = 10.0
margin_top = 10.0
margin_right = -10.0
margin_bottom = -10.0

[node name="TimeLabel" type="Label" parent="VBoxContainer"]
text = "时间: 第1天 - 00:00"
label_settings = null

[node name="TabooLabel" type="Label" parent="VBoxContainer"]
text = "今日禁忌: 无禁忌"
label_settings = null

[node name="HealthLabel" type="Label" parent="VBoxContainer"]
text = "生命: 100.0"
label_settings = null

[node name="EnergyLabel" type="Label" parent="VBoxContainer"]
text = "能量: 100.0"
label_settings = null

[node name="TempLabel" type="Label" parent="VBoxContainer"]
text = "体温: 36.5°C"
label_settings = null

[node name="AnnouncementLabel" type="Label" parent="VBoxContainer"]
text = ""
label_settings = null
self_modulate = Color(1, 0.8, 0.2, 0.9)

[node name="Panel" type="Panel" parent="VBoxContainer"]
custom_minimum_size = Vector2(0, 5)

[node name="PanelContainer" type="PanelContainer" parent="VBoxContainer"]
anchors_preset = 0
anchor_top = 0.0
anchor_left = 0.0
anchor_right = 0.0
anchor_bottom = 0.0
custom_minimum_size = Vector2(300, 0)
theme_override_styles/panel = SubResource("StyleBoxFlat_bg")
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
@export var follow_lerp_speed: float = 20.0 # 位置跟随速度
@export var rotation_speed: float = 10.0 # 转向速度

# 动态贴图配置组
@export_group("Visual Textures")
@export var tex_organic: Texture2D = null # 有机体贴图
@export var tex_mechanical: Texture2D = null # 机械体贴图
@export var tex_player: Texture2D = null # 玩家贴图
@export var tex_static: Texture2D = null # 静态障碍物贴图

# 贴图缩放配置
@export var scale_organic: Vector2 = Vector2(1.0, 1.0) # 有机体缩放
@export var scale_mechanical: Vector2 = Vector2(1.0, 1.0) # 机械体缩放
@export var scale_player: Vector2 = Vector2(1.0, 1.0) # 玩家缩放
@export var scale_static: Vector2 = Vector2(1.0, 1.0) # 静态障碍物缩放

# 缓存的节点引用
var sprite_node: Sprite2D = null
var health_bar: ProgressBar = null

# 动画和调试状态
var attack_tween: Tween = null
var damage_tween: Tween = null
var harvest_tween: Tween = null
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
		health_bar.show() # <--- 关键：启动游戏时强制让它显示出来
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
		queue_redraw() # 触发重绘


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
				sprite_node.scale = scale_organic # 应用有机体缩放
				texture_applied = true
		"mechanical":
			if tex_mechanical != null:
				sprite_node.texture = tex_mechanical
				sprite_node.scale = scale_mechanical # 应用机械体缩放
				texture_applied = true
		"player":
			if tex_player != null:
				sprite_node.texture = tex_player
				sprite_node.scale = scale_player # 应用玩家缩放
				texture_applied = true

			# 给玩家视图添加特殊标签，便于摄像机识别
			add_to_group("player_view")
		"static":
			if tex_static != null:
				sprite_node.texture = tex_static
				sprite_node.scale = scale_static # 应用静态障碍物缩放
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
	debug_timer = 0.1 # 显示0.1秒

	# 创建Tween动画
	if attack_tween != null:
		attack_tween.kill()

	attack_tween = create_tween()
	attack_tween.set_parallel(true) # 并行执行多个动画

	# 计算攻击方向（确保使用单位向量）
	var attack_dir: Vector2 = direction.normalized()

	# 动画1：只让图片节点移动，避免干扰父节点的位置同步逻辑
	var shake_offset: Vector2 = attack_dir * 8.0 # 抖动幅度

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
	if EventBus.entity_damaged.is_connected(_on_entity_damaged):
		EventBus.entity_damaged.disconnect(_on_entity_damaged)
	if EventBus.resource_harvested.is_connected(_on_resource_harvested):
		EventBus.resource_harvested.disconnect(_on_resource_harvested)

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
	if not EventBus.resource_harvested.is_connected(_on_resource_harvested):
		EventBus.resource_harvested.connect(_on_resource_harvested)


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
	damage_tween.set_parallel(false) # 顺序执行

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


# 采集动作动画（轻微压缩回弹）
func play_harvest_anim() -> void:
	if sprite_node == null:
		return

	if harvest_tween != null:
		harvest_tween.kill()

	harvest_tween = create_tween()
	var original_scale: Vector2 = sprite_node.scale
	harvest_tween.tween_property(sprite_node, "scale", original_scale * 1.08, 0.06)
	harvest_tween.tween_property(sprite_node, "scale", original_scale, 0.08)


# 玩家采集成功后的浮动数字反馈
func _on_resource_harvested(harvester: EntityData, amount: float) -> void:
	if data == null or harvester == null:
		return
	if data.entity_type != "player":
		return
	if data != harvester:
		return

	_spawn_floating_gain_text(amount)


func _spawn_floating_gain_text(amount: float) -> void:
	var gain_label := Label.new()
	gain_label.text = "+" + str(int(round(amount)))
	gain_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gain_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	gain_label.z_index = 20
	gain_label.position = Vector2(-20, -110)
	gain_label.modulate = Color(1.0, 0.95, 0.4, 1.0)
	add_child(gain_label)

	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(gain_label, "position", gain_label.position + Vector2(0, -35), 0.45)
	tween.tween_property(gain_label, "modulate:a", 0.0, 0.45)
	var cleanup := func() -> void:
		if is_instance_valid(gain_label):
			gain_label.queue_free()
	tween.finished.connect(cleanup)
```

---

### 🔗 文件: scripts\core\calendar_manager.gd
- **Raw 链接:** [scripts/core/calendar_manager.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/calendar_manager.gd)
```gdscript
# res://scripts/core/calendar_manager.gd
# 律法时钟管理器 - 零号协议 V0.2 核心组件
extends Node

## 律法时钟中枢
## 作用：管理世界时间、禁忌历法、昼夜交替，为硬核生存系统提供数学基础

# --- 禁忌枚举定义 ---
enum Taboo {
	NONE = 0,           # 无禁忌
	AVOID_TRAVEL = 1,   # 忌出行
	AVOID_KILLING = 2,  # 忌杀生
	SUIT_DIGGING = 3    # 宜挖掘
}

# --- 运行时状态 ---
var day_count: int = 1              # 当前天数
var current_taboo: Taboo = Taboo.NONE  # 当前禁忌
var is_night: bool = false          # 是否为夜晚

# --- 初始化 ---
func _ready() -> void:
	# 初始化随机种子
	randomize()

	# 生成初始禁忌（不推进天数，只做首日初始化）
	_roll_taboo_for_current_day()
	EventBus.taboo_changed.emit(current_taboo)
	EventBus.announcement.emit("第" + str(day_count) + "天 - " + _get_taboo_name(current_taboo))

	print("[CalendarManager] 律法时钟初始化完成")
	print("[CalendarManager] 初始天数: ", day_count, " | 初始禁忌: ", _get_taboo_name(current_taboo))

# --- 核心逻辑 ---

# 推进一天，生成新的禁忌
func advance_day() -> void:
	# 递增天数
	day_count += 1

	# 随机生成新禁忌
	_roll_taboo_for_current_day()

	# 通过EventBus广播禁忌变更
	EventBus.taboo_changed.emit(current_taboo)

	# 发送全局公告
	var announcement_text: String = "第" + str(day_count) + "天 - " + _get_taboo_name(current_taboo)
	EventBus.announcement.emit(announcement_text)

	print("[CalendarManager] 新的一天开始: ", announcement_text)


func _roll_taboo_for_current_day() -> void:
	current_taboo = Taboo.values()[randi() % Taboo.size()]

# 更新昼夜状态
func update_time_phase(time_ratio: float) -> void:
	# 时间比例范围: 0.0-1.0 (0.0=日出, 0.5=正午, 1.0=次日日出)
	# 夜晚判定: 0.75-1.0 和 0.0-0.25 为夜晚
	var new_is_night: bool = (time_ratio > 0.75 or time_ratio < 0.25)

	# 如果昼夜状态发生变化
	if new_is_night != is_night:
		is_night = new_is_night

		# 通过EventBus广播昼夜变更
		EventBus.time_phase_changed.emit(is_night)

		# 发送昼夜变更公告
		var phase_name: String = "夜晚" if is_night else "白天"
		EventBus.announcement.emit("进入" + phase_name)

		print("[CalendarManager] 昼夜变更: ", phase_name)

# --- 辅助函数 ---

# 获取禁忌名称
func _get_taboo_name(taboo: Taboo) -> String:
	match taboo:
		Taboo.NONE:
			return "无禁忌"
		Taboo.AVOID_TRAVEL:
			return "忌出行"
		Taboo.AVOID_KILLING:
			return "忌杀生"
		Taboo.SUIT_DIGGING:
			return "宜挖掘"
		_:
			return "未知禁忌"

# 获取当前禁忌效果描述
func get_current_taboo_effects() -> Dictionary:
	match current_taboo:
		Taboo.AVOID_TRAVEL:
			return {"移动速度惩罚": 0.7, "说明": "今日不宜远行"}
		Taboo.AVOID_KILLING:
			return {"攻击伤害惩罚": 0.5, "说明": "今日忌杀生"}
		Taboo.SUIT_DIGGING:
			return {"采集效率加成": 1.5, "说明": "今日宜挖掘"}
		Taboo.NONE:
			return {"无效果": 1.0, "说明": "今日诸事皆宜"}
		_:
			return {}

# 获取当前时间信息
func get_time_info() -> Dictionary:
	return {
		"day_count": day_count,
		"current_taboo": current_taboo,
		"taboo_name": _get_taboo_name(current_taboo),
		"is_night": is_night,
		"time_phase": "夜晚" if is_night else "白天"
	}

# 调试信息输出
func print_debug_info() -> void:
	var info: Dictionary = get_time_info()
	print("[CalendarManager] 调试信息: ", info)
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
@export var energy: float = 100.0     # 饥饿/能量
@export var max_energy: float = 100.0 # 最大能量值
@export var collision_radius: float = 20.0  # 碰撞半径

# --- 新增：速度检测与体温系统 ---
@export var last_position: Vector2 = Vector2.ZERO # 用于计算真实位移
@export var temperature: float = 36.5              # 当前体温
@export var is_near_heat_source: bool = false      # 是否靠近热源（由 WorldManager 判定）

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
signal static_entity_depleted(static_data: StaticEntityData)  # 静态实体耗尽

# 采集反馈信号：用于驱动UI与浮动数字
signal resource_harvested(harvester: EntityData, amount: float)
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

# --- 平衡参数配置 ---
@export var tuning: WorldTuning = WorldTuning.new()  # 平衡参数资源

# --- 战斗系统 ---
@export_group("Combat")
@export var attack_damage: float = 30.0  # 已废弃，使用 tuning.combat_player_damage
@export var attack_cooldown: float = 0.4  # 已废弃，使用 tuning.combat_cooldown
@export var attack_radius: float = 40.0  # 已废弃，使用 tuning.combat_radius
@export var attack_angle: float = 90.0  # 已废弃，使用 tuning.combat_angle

# --- 采集系统 ---
@export_group("Harvest")
@export var harvest_key: Key = KEY_E  # 采集按键

# 内部状态变量
var last_direction: Vector2 = Vector2.RIGHT  # 最后朝向
var attack_timer: float = 0.0  # 攻击冷却计时器
var _prev_save_key_down: bool = false
var _prev_load_key_down: bool = false
var _prev_harvest_key_down: bool = false

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
func rebind_player(_player_data: EntityData) -> void:
	print("[PlayerController] 收到外部重绑请求")
	_on_world_loaded()  # 直接调用内部重绑逻辑


# 每帧输入处理
func _process(delta: float) -> void:
	# 保存/加载功能（K键保存，L键加载） - 移动到最前，确保即使玩家死亡也能触发
	var save_key_down: bool = Input.is_physical_key_pressed(KEY_K)
	var load_key_down: bool = Input.is_physical_key_pressed(KEY_L)
	if save_key_down and not _prev_save_key_down:
		print("[System] 正在保存世界状态...")
		WorldManager.save_world("test_slot")
	if load_key_down and not _prev_load_key_down:
		print("[System] 正在读取存档...")
		WorldManager.load_world("test_slot")
	_prev_save_key_down = save_key_down
	_prev_load_key_down = load_key_down

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

	# 处理采集输入（单次触发，避免长按一帧多次采集）
	var harvest_key_down: bool = Input.is_physical_key_pressed(harvest_key)
	if harvest_key_down and not _prev_harvest_key_down:
		_trigger_harvest()
	_prev_harvest_key_down = harvest_key_down

# 触发采集
func _trigger_harvest() -> void:
	if not _is_target_valid():
		return

	# 调用WorldManager的采集函数
	WorldManager.harvest_resource(target_view.data)

	# 发送采集动画信号（可选）
	target_view.play_harvest_anim()

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
	attack_timer = tuning.combat_cooldown

	# 攻击起点改为玩家自身位置
	var hit_origin: Vector2 = target_view.data.position

	# 触发攻击动画
	target_view.play_attack_anim(hit_origin, last_direction, tuning.combat_radius, tuning.combat_angle)

	# 战斗结算下沉到WorldManager，Controller只负责输入与触发
	var hit_count: int = WorldManager.player_attack(
		target_view.data,
		last_direction,
		tuning.combat_radius,
		tuning.combat_angle,
		tuning.combat_player_damage
	)

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

### 🔗 文件: scripts\core\static_entity_data.gd
- **Raw 链接:** [scripts/core/static_entity_data.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/static_entity_data.gd)
```gdscript
# res://scripts/core/static_entity_data.gd
class_name StaticEntityData
extends Resource

## 静态实体数据模型
## 作用：定义不可移动的资源/设施数据，如热源、祭坛、资源点等

# --- 基础属性 ---
@export var id: String = ""                    # 实体唯一标识
@export var position: Vector2 = Vector2.ZERO    # 世界坐标位置
@export var type: String = "heat_source"        # 实体类型：热源、资源、祭坛等
@export var effect_radius: float = 100.0        # 作用半径

# --- 类型特定属性 ---
@export var heat_strength: float = 1.0          # 热源强度（仅热源类型）
@export var resource_type: String = "wood"      # 资源类型（仅资源类型）
@export var resource_amount: float = 10.0       # 资源储量（仅资源类型）
@export var is_depleted: bool = false           # 是否已耗尽

# --- 初始化函数 ---
func _init() -> void:
	# 自动生成ID（如果未设置）
	if id.is_empty():
		id = "static_" + str(randi() % 10000)

# --- 辅助函数 ---

# 获取实体类型描述
func get_type_description() -> String:
	match type:
		"heat_source":
			return "热源（温暖区域）"
		"resource":
			return "资源点（" + resource_type + "）"
		"altar":
			return "祭坛（神秘力量）"
		_:
			return "未知类型"

# 检查位置是否在作用范围内
func is_position_in_range(check_pos: Vector2) -> bool:
	return position.distance_to(check_pos) <= effect_radius

# 获取调试信息
func get_debug_info() -> Dictionary:
	return {
		"id": id,
		"type": type,
		"position": position,
		"radius": effect_radius,
		"description": get_type_description()
	}
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
signal world_loaded  # 世界加载完成信号
signal world_clock_updated(day_count: int, time_ratio: float, is_night: bool)

# --- 配置 ---
@export_group("Simulation")
@export var ticks_per_second: float = 10.0
@export var world_bounds: Rect2 = Rect2(-600, -400, 1200, 800)  # 世界边界矩形

# --- 律法时钟配置 ---
@export_group("Time System")
@export var day_length_seconds: float = 600.0  # 10分钟一个昼夜周期

# --- 资源系统配置 ---
@export_group("Resource System")
@export var harvest_distance: float = 100.0  # 采集距离（已废弃，使用 WorldTuning）
@export var base_harvest_gain: float = 10.0  # 基础采集收益（已废弃，使用 WorldTuning）

# --- 平衡参数配置 ---
@export var tuning: WorldTuning = WorldTuning.new()  # 平衡参数资源

# --- 系统实例 ---
var temperature_system: RefCounted = null
var metabolism_system: RefCounted = null
var combat_system: RefCounted = null
var harvest_system: RefCounted = null
var ai_system: RefCounted = null

# --- 运行时数据 ---
var entities: Array[EntityData] = []
var static_entities: Array[StaticEntityData] = []  # 静态实体数组
var current_tick: int = 0
var accumulator: float = 0.0
var world_time: float = 0.0  # 世界时间（秒）

# --- Debug 统计 ---
var last_tick_time: float = 0.0
var tick_time_accumulator: float = 0.0
var tick_time_samples: int = 0
var debug_update_interval: float = 1.0  # 每秒更新一次统计
var debug_timer: float = 0.0

# --- 初始化 ---
func _ready() -> void:
	# 初始化系统
	temperature_system = load("res://scripts/core/systems/temperature_system.gd").new(tuning, CalendarManager)
	metabolism_system = load("res://scripts/core/systems/metabolism_system.gd").new(tuning, CalendarManager)
	combat_system = load("res://scripts/core/systems/combat_system.gd").new(tuning, CalendarManager, EventBus)
	harvest_system = load("res://scripts/core/systems/harvest_system.gd").new(tuning, CalendarManager, EventBus)
	ai_system = load("res://scripts/core/systems/simple_ai_system.gd").new(tuning, world_bounds, ticks_per_second)

	# 生成静态实体
	_generate_static_entities()

	print("WorldManager 初始化完成")
	print("固定Tick频率: ", ticks_per_second, " Hz")
	print("世界边界: ", world_bounds)
	print("静态实体数量: ", static_entities.size())

# --- 核心逻辑 ---

func _physics_process(delta: float) -> void:
	# 10Hz物理步进：所有生存逻辑在此运行
	_on_logic_tick(delta)

# 废弃旧的_process，所有逻辑迁移到_physics_process
func _process(_delta: float) -> void:
	# 保留空函数，避免Godot警告
	pass

# 10Hz逻辑步进中枢
func _on_logic_tick(delta: float) -> void:
	# 使用累加器确保固定步进
	accumulator += delta
	var tick_interval: float = 1.0 / ticks_per_second

	while accumulator >= tick_interval:
		accumulator -= tick_interval
		var start_time: float = Time.get_ticks_usec()
		tick_step()
		var end_time: float = Time.get_ticks_usec()
		var tick_duration: float = (end_time - start_time) / 1000.0  # 转换为毫秒

		# 统计 tick 耗时
		tick_time_accumulator += tick_duration
		tick_time_samples += 1

	# 律法时钟步进（基于真实时间，不受固定tick影响）
	_step_world_clock(delta)

	# 定期输出 debug 统计
	debug_timer += delta
	if debug_timer >= debug_update_interval:
		debug_timer = 0.0
		_print_debug_stats()

# --- 静态实体系统 ---

# 生成静态实体（热源、资源点等）
func _generate_static_entities() -> void:
	# 清空现有静态实体
	static_entities.clear()

	# 生成热源
	_generate_heat_sources()

	# 生成资源点
	_generate_resource_entities()

	print("[WorldManager] 静态实体生成完成，共生成 ", static_entities.size(), " 个静态实体")

# 生成热源
func _generate_heat_sources() -> void:
	# 随机生成热源
	var heat_source_count: int = randi() % (tuning.spawn_heat_source_count_max - tuning.spawn_heat_source_count_min + 1) + tuning.spawn_heat_source_count_min

	for i in range(heat_source_count):
		var heat_source: StaticEntityData = StaticEntityData.new()
		heat_source.type = "heat_source"
		heat_source.position = _get_random_position_within_bounds()
		heat_source.effect_radius = randf_range(80.0, 120.0)  # 随机半径80-120
		heat_source.heat_strength = randf_range(0.8, 1.2)     # 随机强度0.8-1.2

		static_entities.append(heat_source)

		# 发送信号通知View层生成视觉表现
		EventBus.static_entity_spawned.emit(heat_source)

		print("[WorldManager] 生成热源: ", heat_source.get_debug_info())

# 获取世界边界内的随机位置
func _get_random_position_within_bounds() -> Vector2:
	var x: float = randf_range(world_bounds.position.x + 50, world_bounds.position.x + world_bounds.size.x - 50)
	var y: float = randf_range(world_bounds.position.y + 50, world_bounds.position.y + world_bounds.size.y - 50)
	return Vector2(x, y)

# 更新玩家与静态实体的邻近效果
func _update_proximity_effects(player_data: EntityData) -> void:
	# 热源检测
	var found_heat: bool = false

	for static_ent in static_entities:
		if static_ent.type == "heat_source":
			var dist: float = player_data.position.distance_to(static_ent.position)
			if dist < static_ent.effect_radius:
				found_heat = true
				break

	# 更新玩家热源状态
	var was_near_heat: bool = player_data.is_near_heat_source
	player_data.is_near_heat_source = found_heat

	# 状态变更反馈
	if was_near_heat != found_heat:
		if found_heat:
			print("[WorldManager] 玩家进入热源范围，体温开始回升")
			EventBus.announcement.emit("感受到温暖，体温回升中...")
		else:
			print("[WorldManager] 玩家离开热源范围")
			EventBus.announcement.emit("离开温暖区域，注意体温")

# 获取玩家实体（辅助函数）
func _get_player_entity() -> EntityData:
	for entity in entities:
		if entity.entity_type == "player":
			return entity
	return null

# --- 资源采集系统（已拆分到 HarvestSystem）---

# 采集资源
func harvest_resource(player_data: EntityData) -> void:
	if harvest_system != null:
		harvest_system.harvest_resource(player_data, static_entities)

# 生成资源点（在静态实体生成函数中添加）
func _generate_resource_entities() -> void:
	# 生成资源点
	var resource_count: int = randi() % (tuning.spawn_resource_count_max - tuning.spawn_resource_count_min + 1) + tuning.spawn_resource_count_min

	for i in range(resource_count):
		var resource: StaticEntityData = StaticEntityData.new()
		resource.type = "resource"
		resource.position = _get_random_position_within_bounds()
		resource.resource_amount = randf_range(50.0, 100.0)  # 随机储量
		resource.resource_type = "wood"  # 暂时固定为木材

		static_entities.append(resource)

		# 发送信号通知View层生成视觉表现
		EventBus.static_entity_spawned.emit(resource)

		print("[WorldManager] 生成资源点: ", resource.get_debug_info())

	print("[WorldManager] 资源点生成完成，共生成 ", resource_count, " 个资源点")


# world_manager.gd 中的核心逻辑更新
func tick_step() -> void:
	current_tick += 1

	# 使用代谢系统处理所有实体
	if metabolism_system != null:
		metabolism_system.process_entities(entities, ticks_per_second)

	# 使用温度系统处理所有实体
	if temperature_system != null:
		temperature_system.process_entities(entities, ticks_per_second)

	# 使用AI系统处理机械体
	if ai_system != null:
		ai_system.process_entities(entities)

	# 处理其他逻辑
	for entity in entities:
		if not is_instance_valid(entity):
			continue

		# 1. 基础演化 (变老)
		entity.age_step(1)

		# 2. 玩家状态同步（仅对玩家实体）
		if entity.entity_type == "player":
			EventBus.player_stat_updated.emit("energy", entity.energy)
			EventBus.player_stat_updated.emit("health", entity.health)
			EventBus.player_stat_updated.emit("temperature", entity.temperature)

	world_ticked.emit(current_tick)

	# 更新玩家与静态实体的邻近效果
	var player_entity: EntityData = _get_player_entity()
	if player_entity != null:
		_update_proximity_effects(player_entity)

# --- 律法时钟系统 ---


# 世界时钟步进函数
func _step_world_clock(delta: float) -> void:
	# 累加世界时间
	world_time += delta

	# 检查是否到达新的一天
	if world_time >= day_length_seconds:
		world_time = 0.0
		CalendarManager.advance_day()

	# 计算时间比例并更新昼夜状态
	var time_ratio: float = world_time / day_length_seconds
	CalendarManager.update_time_phase(time_ratio)
	world_clock_updated.emit(CalendarManager.day_count, time_ratio, CalendarManager.is_night)


func player_attack(
	attacker: EntityData,
	facing_direction: Vector2,
	attack_radius: float,
	attack_angle: float,
	base_damage: float
) -> int:
	if combat_system != null:
		return combat_system.player_attack(attacker, facing_direction, attack_radius, attack_angle, base_damage, entities)
	return 0


# --- 代谢系统（已拆分到 MetabolismSystem）---
# --- 体温系统（已拆分到 TemperatureSystem）---

# --- AI系统（已拆分到 SimpleAISystem）---


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
	world_data.save_timestamp = int(Time.get_unix_time_from_system())

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
		load_path, "", ResourceLoader.CACHE_MODE_IGNORE
	)

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
				var push: Vector2 = (
					(subject.position - entity.position).normalized() * (min_dist - d)
				)

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

# --- Debug 统计函数 ---

# 打印 debug 统计信息
func _print_debug_stats() -> void:
	if tick_time_samples == 0:
		return

	var avg_tick_time: float = tick_time_accumulator / tick_time_samples
	var total_entity_count: int = entities.size()
	var player_count: int = 0
	var organic_count: int = 0
	var mechanical_count: int = 0
	var static_count: int = 0

	# 统计各类型实体数量
	for entity in entities:
		if entity.entity_type == "player":
			player_count += 1
		elif entity.entity_type == "organic":
			organic_count += 1
		elif entity.entity_type == "mechanical":
			mechanical_count += 1
		elif entity.entity_type == "static":
			static_count += 1

	static_count += static_entities.size()

	print("--- WorldManager Debug Stats ---")
	print("Tick: ", current_tick, " | Avg Tick Time: ", "%.3f" % avg_tick_time, "ms")
	print("Entities: ", total_entity_count, " (Player:", player_count, " Organic:", organic_count, " Mechanical:", mechanical_count, " Static:", static_count, ")")
	print("--------------------------------")

	# 重置统计器
	tick_time_accumulator = 0.0
	tick_time_samples = 0

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
@export var organic_count: int = 20  # 已废弃，使用 tuning.spawn_organic_count
@export var mechanical_count: int = 3  # 已废弃，使用 tuning.spawn_mechanical_count
@export var static_obstacle_count: int = 15  # 已废弃，使用 tuning.spawn_static_obstacle_count
@export var spawn_range: Vector2 = Vector2(1000, 1000)  # 已废弃，使用 tuning.spawn_range

# --- 平衡参数配置 ---
@export var tuning: WorldTuning = WorldTuning.new()  # 平衡参数资源

# 内部计数器
var total_spawned: int = 0
var static_entity_views: Dictionary = {}  # key: static id, value: Node2D
const STATIC_VIEW_TEXTURE: Texture2D = preload("res://assets/Terrain/Decorations/Rocks/Rock1.png")

# 节点初始化
func _ready() -> void:
	# 连接世界加载信号，实现读档后的视觉重建
	WorldManager.world_loaded.connect(_on_world_loaded)
	if not EventBus.static_entity_spawned.is_connected(_on_static_entity_spawned):
		EventBus.static_entity_spawned.connect(_on_static_entity_spawned)
	if not EventBus.static_entity_depleted.is_connected(_on_static_entity_depleted):
		EventBus.static_entity_depleted.connect(_on_static_entity_depleted)

	# 延迟一帧生成，确保所有系统已初始化
	call_deferred("spawn_all")
	call_deferred("_rebuild_static_entity_views")

# 读档后的视觉重建逻辑
func _on_world_loaded() -> void:
	print("[Spawner] 开始读档后的视觉重建...")

	# 第一步：清场 - 瞬间杀掉地图上所有的旧肉身
	get_tree().call_group("entity_views", "queue_free")
	print("[Spawner] 已清理所有旧实体视图")

	# 第二步：等待一帧，确保旧肉身已经彻底清理干净
	await get_tree().process_frame
	_clear_static_entity_views()
	_rebuild_static_entity_views()

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


# 静态实体生成后创建对应View
func _on_static_entity_spawned(static_data: StaticEntityData) -> void:
	_create_static_entity_view(static_data)


# 资源耗尽后播放缩放消失动画并清理
func _on_static_entity_depleted(static_data: StaticEntityData) -> void:
	var view_node: Node2D = static_entity_views.get(static_data.id, null)
	if view_node == null or not is_instance_valid(view_node):
		return

	var tween: Tween = create_tween()
	tween.tween_property(view_node, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.finished.connect(
		func() -> void:
			if is_instance_valid(view_node):
				view_node.queue_free()
			static_entity_views.erase(static_data.id)
	)


# 重建所有静态实体视图（用于首帧补齐和读档重建）
func _rebuild_static_entity_views() -> void:
	for static_data in WorldManager.static_entities:
		_create_static_entity_view(static_data)


# 统一创建静态实体视图
func _create_static_entity_view(static_data: StaticEntityData) -> void:
	if static_data == null or static_data.is_depleted:
		return
	if static_entity_views.has(static_data.id):
		return

	var view_root: Node2D = Node2D.new()
	view_root.name = "StaticView_" + static_data.id
	view_root.position = static_data.position
	view_root.set_meta("static_entity_id", static_data.id)

	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = STATIC_VIEW_TEXTURE
	sprite.centered = true
	view_root.add_child(sprite)

	match static_data.type:
		"heat_source":
			view_root.scale = Vector2(1.6, 1.6)
			sprite.modulate = Color(1.0, 0.55, 0.2, 0.95)
		"resource":
			view_root.scale = Vector2(1.8, 1.8)
			sprite.modulate = Color(0.7, 1.0, 0.65, 1.0)
		_:
			view_root.scale = Vector2(1.6, 1.6)
			sprite.modulate = Color.WHITE

	add_child(view_root)
	static_entity_views[static_data.id] = view_root


# 清理静态实体视图缓存
func _clear_static_entity_views() -> void:
	for view_node in static_entity_views.values():
		if is_instance_valid(view_node):
			view_node.queue_free()
	static_entity_views.clear()

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
	for i in range(tuning.spawn_organic_count):
		_create_entity("organic", "food_" + str(i))

	# 生成机械体（猎食者）
	for i in range(tuning.spawn_mechanical_count):
		_create_entity("mechanical", "hunter_" + str(i))

	# 生成静态障碍物
	for i in range(tuning.spawn_static_obstacle_count):
		_create_static_obstacle("obstacle_" + str(i))

	# 打印统计信息
	print("世界生成完成 - 总计实体: ", total_spawned)
	print("有机体: ", tuning.spawn_organic_count, " | 机械体: ", tuning.spawn_mechanical_count, " | 障碍物: ", tuning.spawn_static_obstacle_count)
	print("生成区域: ", tuning.spawn_range)

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
			return tuning.entity_organic_health
		"mechanical":
			return tuning.entity_mechanical_health
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
	obstacle_data.health = tuning.entity_static_health  # 障碍物不可摧毁
	obstacle_data.collision_radius = randf_range(tuning.entity_collision_radius_min, tuning.entity_collision_radius_max)
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
	var random_x: float = randf_range(-tuning.spawn_range.x / 2, tuning.spawn_range.x / 2)
	var random_y: float = randf_range(-tuning.spawn_range.y / 2, tuning.spawn_range.y / 2)

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

### 🔗 文件: scripts\core\world_tuning.gd
- **Raw 链接:** [scripts/core/world_tuning.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/world_tuning.gd)
```gdscript
# res://scripts/core/world_tuning.gd
class_name WorldTuning
extends Resource

## 世界平衡参数配置
## 作用：集中管理所有游戏平衡参数，支持编辑器内调整

# --- 代谢系统参数 ---
@export_group("Metabolism", "metabolism_")
@export var metabolism_base_rate: float = 0.05          # 基础代谢速率（每秒能量消耗）
@export var metabolism_night_multiplier: float = 1.5    # 夜晚代谢倍率
@export var metabolism_travel_penalty: float = 5.0      # 忌出行时的移动惩罚倍率
@export var metabolism_starvation_damage: float = 0.1   # 空腹伤害（每秒生命扣除）

# --- 温度系统参数 ---
@export_group("Temperature", "temp_")
@export var temp_night_change: float = -0.5             # 夜晚体温变化（每秒）
@export var temp_heat_source_change: float = 1.0        # 热源附近体温变化（每秒）
@export var temp_min: float = 20.0                      # 最低体温限制
@export var temp_max: float = 36.5                      # 最高体温限制
@export var temp_hypothermia_threshold: float = 30.0    # 失温伤害阈值
@export var temp_hypothermia_damage_multiplier: float = 0.05  # 失温伤害系数

# --- 战斗系统参数 ---
@export_group("Combat", "combat_")
@export var combat_player_damage: float = 30.0          # 玩家基础伤害
@export var combat_cooldown: float = 0.4                # 攻击冷却时间
@export var combat_radius: float = 40.0                 # 攻击半径
@export var combat_angle: float = 90.0                  # 攻击角度
@export var combat_mechanical_damage: float = 5.0       # 机械体伤害
@export var combat_mechanical_heal: float = 2.0         # 机械体吸血量
@export var combat_mechanical_detection_range: float = 400.0  # 机械体感知范围
@export var combat_mechanical_attack_range: float = 10.0     # 机械体攻击范围
@export var combat_mechanical_move_threshold: float = 5.0     # 机械体移动阈值

# --- 采集系统参数 ---
@export_group("Harvest", "harvest_")
@export var harvest_distance: float = 100.0             # 采集距离
@export var harvest_base_gain: float = 10.0             # 基础采集收益
@export var harvest_taboo_bonus_multiplier: float = 2.0 # 宜挖掘加成倍率
@export var harvest_energy_max: float = 100.0           # 能量上限

# --- 禁忌系统参数 ---
@export_group("Taboo", "taboo_")
@export var taboo_killing_damage_penalty: float = 0.5   # 忌杀生伤害惩罚倍率

# --- 实体生成参数 ---
@export_group("Spawn", "spawn_")
@export var spawn_organic_count: int = 20               # 有机体生成数量
@export var spawn_mechanical_count: int = 3             # 机械体生成数量
@export var spawn_static_obstacle_count: int = 15       # 静态障碍物数量
@export var spawn_heat_source_count_min: int = 3        # 热源最小数量
@export var spawn_heat_source_count_max: int = 5        # 热源最大数量
@export var spawn_resource_count_min: int = 2           # 资源点最小数量
@export var spawn_resource_count_max: int = 4           # 资源点最大数量
@export var spawn_range: Vector2 = Vector2(1000, 1000)  # 生成区域范围

# --- 实体属性参数 ---
@export_group("Entity", "entity_")
@export var entity_organic_health: float = 50.0         # 有机体初始生命
@export var entity_mechanical_health: float = 150.0     # 机械体初始生命
@export var entity_static_health: float = 9999.0        # 静态障碍物生命
@export var entity_collision_radius_min: float = 30.0   # 障碍物最小碰撞半径
@export var entity_collision_radius_max: float = 50.0   # 障碍物最大碰撞半径

```

---

### 🔗 文件: scripts\core\systems\combat_system.gd
- **Raw 链接:** [scripts/core/systems/combat_system.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/systems/combat_system.gd)
```gdscript
# res://scripts/core/systems/combat_system.gd
class_name CombatSystem
extends RefCounted

## 战斗系统
## 负责处理攻击判定、伤害计算等逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager
var event_bus: EventBus

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager, p_event_bus: EventBus):
	tuning = p_tuning
	calendar_manager = p_calendar_manager
	event_bus = p_event_bus

## 处理玩家攻击
func player_attack(
	attacker: EntityData,
	facing_direction: Vector2,
	attack_radius: float,
	attack_angle: float,
	base_damage: float,
	entities: Array[EntityData]
) -> int:
	if attacker == null or attacker.health <= 0.0:
		return 0

	var hit_origin: Vector2 = attacker.position
	var hit_dir: Vector2 = facing_direction.normalized()
	if hit_dir == Vector2.ZERO:
		hit_dir = Vector2.RIGHT

	var final_damage: float = base_damage
	if calendar_manager.current_taboo == CalendarManager.Taboo.AVOID_KILLING:
		final_damage *= tuning.taboo_killing_damage_penalty

	var hit_count: int = 0
	for entity in entities:
		if entity == null or entity == attacker or entity.health <= 0.0:
			continue
		if entity.position.distance_to(hit_origin) > attack_radius:
			continue

		var dir_to_enemy: Vector2 = (entity.position - hit_origin).normalized()
		var angle_diff: float = rad_to_deg(hit_dir.angle_to(dir_to_enemy))
		if abs(angle_diff) > attack_angle / 2.0:
			continue

		entity.health -= final_damage
		hit_count += 1
		event_bus.entity_damaged.emit(entity, final_damage, hit_origin)

	return hit_count

```

---

### 🔗 文件: scripts\core\systems\harvest_system.gd
- **Raw 链接:** [scripts/core/systems/harvest_system.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/systems/harvest_system.gd)
```gdscript
# res://scripts/core/systems/harvest_system.gd
class_name HarvestSystem
extends RefCounted

## 采集系统
## 负责处理资源采集逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager
var event_bus: EventBus

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager, p_event_bus: EventBus):
	tuning = p_tuning
	calendar_manager = p_calendar_manager
	event_bus = p_event_bus

## 查找最近的资源点
func _find_nearest_resource(player_pos: Vector2, static_entities: Array[StaticEntityData]) -> StaticEntityData:
	var nearest_resource: StaticEntityData = null
	var min_distance: float = tuning.harvest_distance

	for static_ent in static_entities:
		# 只检查资源类型且未耗尽的实体
		if static_ent.type == "resource" and not static_ent.is_depleted:
			var distance: float = player_pos.distance_to(static_ent.position)
			if distance < min_distance:
				min_distance = distance
				nearest_resource = static_ent

	return nearest_resource

## 采集资源
func harvest_resource(player_data: EntityData, static_entities: Array[StaticEntityData]) -> void:
	var nearest_resource: StaticEntityData = _find_nearest_resource(player_data.position, static_entities)

	if nearest_resource == null:
		print("[HarvestSystem] 附近没有可采集的资源")
		event_bus.announcement.emit("附近没有可采集的资源")
		return

	# 计算采集收益
	var harvest_gain: float = tuning.harvest_base_gain

	# 禁忌加成：宜挖掘时收益翻倍
	if calendar_manager.current_taboo == CalendarManager.Taboo.SUIT_DIGGING:
		harvest_gain *= tuning.harvest_taboo_bonus_multiplier
		print("[HarvestSystem] 禁忌加成：采集收益翻倍！")
		event_bus.announcement.emit("宜挖掘：采集效率翻倍！")

	# 采集资源
	nearest_resource.resource_amount -= harvest_gain

	# 更新玩家能量
	player_data.energy += harvest_gain
	player_data.energy = min(player_data.energy, tuning.harvest_energy_max)

	# 发送状态更新信号
	event_bus.player_stat_updated.emit("energy", player_data.energy)
	event_bus.resource_harvested.emit(player_data, harvest_gain)

	print("[HarvestSystem] 采集成功！获得能量: ", harvest_gain, " 剩余资源: ", nearest_resource.resource_amount)
	event_bus.announcement.emit("采集成功！获得能量: " + str(harvest_gain))

	# 检查资源是否耗尽
	if nearest_resource.resource_amount <= 0.0:
		nearest_resource.is_depleted = true
		print("[HarvestSystem] 资源耗尽: ", nearest_resource.id)
		event_bus.static_entity_depleted.emit(nearest_resource)
		event_bus.announcement.emit("资源已耗尽")

```

---

### 🔗 文件: scripts\core\systems\metabolism_system.gd
- **Raw 链接:** [scripts/core/systems/metabolism_system.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/systems/metabolism_system.gd)
```gdscript
# res://scripts/core/systems/metabolism_system.gd
class_name MetabolismSystem
extends RefCounted

## 代谢系统
## 负责处理实体的能量消耗、空腹伤害等逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager):
	tuning = p_tuning
	calendar_manager = p_calendar_manager

## 计算实体速度（通过前后帧位置差）
func _calculate_entity_velocity(entity: EntityData, ticks_per_second: float) -> Vector2:
	# 计算当前位置与上一帧位置的差值
	var displacement: Vector2 = entity.position - entity.last_position

	# 更新上一帧位置（为下一帧计算做准备）
	entity.last_position = entity.position

	# 返回位移向量（每秒位移量）
	return displacement * ticks_per_second

## 处理单个实体的代谢逻辑
func process_metabolism(entity: EntityData, ticks_per_second: float) -> void:
	# 跳过静态障碍物
	if entity.entity_type == "static":
		return

	# 计算真实位移速度（基于前后帧位置差）
	var velocity: Vector2 = _calculate_entity_velocity(entity, ticks_per_second)

	# 基础代谢速率（每秒消耗）
	var base_metabolic_rate: float = tuning.metabolism_base_rate

	# 环境压迫：夜晚代谢加速
	if calendar_manager.is_night:
		base_metabolic_rate *= tuning.metabolism_night_multiplier

	# 禁忌惩罚：忌出行时的移动惩罚
	var movement_multiplier: float = 1.0
	if calendar_manager.current_taboo == CalendarManager.Taboo.AVOID_TRAVEL:
		if velocity.length() > 0.1:  # 如果实体正在移动
			movement_multiplier = tuning.metabolism_travel_penalty

	# 计算总能量消耗
	var energy_consumption: float = base_metabolic_rate * movement_multiplier

	# 应用能量消耗
	entity.energy = max(0.0, entity.energy - energy_consumption)

	# 空腹惩罚：能量耗尽时扣除生命值
	if entity.energy <= 0.0:
		entity.health -= tuning.metabolism_starvation_damage  # 每秒扣除生命值
		entity.health = max(0.0, entity.health)

## 处理多个实体的代谢逻辑
func process_entities(entities: Array[EntityData], ticks_per_second: float) -> void:
	for entity in entities:
		if not is_instance_valid(entity):
			continue
		process_metabolism(entity, ticks_per_second)

```

---

### 🔗 文件: scripts\core\systems\simple_ai_system.gd
- **Raw 链接:** [scripts/core/systems/simple_ai_system.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/systems/simple_ai_system.gd)
```gdscript
# res://scripts/core/systems/simple_ai_system.gd
class_name SimpleAISystem
extends RefCounted

## 简单AI系统
## 负责处理机械体的AI行为

var tuning: WorldTuning
var world_bounds: Rect2
var ticks_per_second: float

func _init(p_tuning: WorldTuning, p_world_bounds: Rect2, p_ticks_per_second: float):
	tuning = p_tuning
	world_bounds = p_world_bounds
	ticks_per_second = p_ticks_per_second

## 处理机械体AI（针对 MX110 优化的数组查找逻辑）
func process_mechanical_ai(hunter: EntityData, entities: Array[EntityData]) -> void:
	# 1. 寻找最近的猎物（玩家优先级）
	var nearest_prey: EntityData = null
	var min_dist = tuning.combat_mechanical_detection_range  # 感知范围

	for target in entities:
		# 跳过无效目标
		if target.health <= 0:
			continue

		var d: float = hunter.position.distance_to(target.position)
		if d > min_dist:
			continue

		# 判断目标类型
		var is_player: bool = target.entity_type == "player"
		var is_organic: bool = target.entity_type == "organic"

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
		# 只有当距离大于阈值时才真正执行移动
		# 这样可以防止在目标点附近"反复横跳"
		if min_dist > tuning.combat_mechanical_move_threshold:
			var dir = (nearest_prey.position - hunter.position).normalized()
			# 计算本次 tick 的位移量
			var tick_interval: float = 1.0 / ticks_per_second
			var movement = dir * hunter.move_speed * tick_interval
			hunter.position += movement

		# --- 核心改进：伤害逻辑 ---
		# 只有足够近才吸血
		if min_dist < tuning.combat_mechanical_attack_range:
			nearest_prey.health -= tuning.combat_mechanical_damage  # 有机体扣血
			hunter.health = min(100.0, hunter.health + tuning.combat_mechanical_heal)  # 机械体回血

	# 【重要修复】无论有没有猎物，都得守法（不穿墙、不撞墙）
	hunter.position = _clamp_position(hunter.position)

## 处理所有机械体AI
func process_entities(entities: Array[EntityData]) -> void:
	for entity in entities:
		if not is_instance_valid(entity):
			continue
		if entity.entity_type == "mechanical":
			process_mechanical_ai(entity, entities)

## 位置限制函数
func _clamp_position(pos: Vector2) -> Vector2:
	# 返回世界边界限制后的坐标
	return pos.clamp(world_bounds.position, world_bounds.position + world_bounds.size)

```

---

### 🔗 文件: scripts\core\systems\temperature_system.gd
- **Raw 链接:** [scripts/core/systems/temperature_system.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/core/systems/temperature_system.gd)
```gdscript
# res://scripts/core/systems/temperature_system.gd
class_name TemperatureSystem
extends RefCounted

## 温度系统
## 负责处理实体的体温变化、失温伤害等逻辑

var tuning: WorldTuning
var calendar_manager: CalendarManager

func _init(p_tuning: WorldTuning, p_calendar_manager: CalendarManager):
	tuning = p_tuning
	calendar_manager = p_calendar_manager

## 处理单个实体的温度逻辑
func process_temperature(entity: EntityData, ticks_per_second: float) -> void:
	# 跳过静态障碍物
	if entity.entity_type == "static":
		return

	# 体温变化速率（每秒）
	var temperature_change: float = 0.0

	# 环境影响：夜晚失温
	if calendar_manager.is_night and not entity.is_near_heat_source:
		temperature_change = tuning.temp_night_change

	# 热源恢复：靠近热源时回温
	if entity.is_near_heat_source:
		temperature_change = tuning.temp_heat_source_change

	# 应用体温变化
	entity.temperature += temperature_change / ticks_per_second

	# 体温限制：正常体温范围
	entity.temperature = clamp(entity.temperature, tuning.temp_min, tuning.temp_max)

	# 失温惩罚：体温过低时扣除生命值
	if entity.temperature < tuning.temp_hypothermia_threshold:
		var hypothermia_damage: float = (tuning.temp_hypothermia_threshold - entity.temperature) * tuning.temp_hypothermia_damage_multiplier
		entity.health -= hypothermia_damage
		entity.health = max(0.0, entity.health)

## 处理多个实体的温度逻辑
func process_entities(entities: Array[EntityData], ticks_per_second: float) -> void:
	for entity in entities:
		if not is_instance_valid(entity):
			continue
		process_temperature(entity, ticks_per_second)

```

---

### 🔗 文件: scripts\ui\debug_hud.gd
- **Raw 链接:** [scripts/ui/debug_hud.gd](https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/scripts/ui/debug_hud.gd)
```gdscript
# res://scripts/ui/debug_hud.gd
extends CanvasLayer

## 调试HUD界面
## 作用：实时显示玩家生存状态数据，用于开发和调试

# --- 内部状态 ---
var announcement_timer: float = 0.0
var current_day: int = 1
var current_time_ratio: float = 0.0
var has_world_clock_data: bool = false

# --- UI节点引用 ---
@onready var time_label: Label = $VBoxContainer/TimeLabel
@onready var taboo_label: Label = $VBoxContainer/TabooLabel
@onready var health_label: Label = $VBoxContainer/HealthLabel
@onready var energy_label: Label = $VBoxContainer/EnergyLabel
@onready var temp_label: Label = $VBoxContainer/TempLabel
@onready var announcement_label: Label = $VBoxContainer/AnnouncementLabel

# --- 初始化 ---
func _ready() -> void:
	# 订阅EventBus信号
	EventBus.player_stat_updated.connect(_on_stat_updated)
	EventBus.taboo_changed.connect(_on_taboo_updated)
	EventBus.time_phase_changed.connect(_on_time_phase_changed)
	EventBus.announcement.connect(_on_announcement)
	if not WorldManager.world_clock_updated.is_connected(_on_world_clock_updated):
		WorldManager.world_clock_updated.connect(_on_world_clock_updated)

	# 初始化UI状态
	_update_time_display()

	print("[DebugHUD] 调试界面初始化完成")

# --- 每帧更新 ---
func _process(delta: float) -> void:
	# 更新公告显示计时器
	if announcement_timer > 0.0:
		announcement_timer -= delta
		if announcement_timer <= 0.0:
			announcement_label.text = ""

	# 仅在世界时钟尚未推送数据时做一次兜底显示
	if not has_world_clock_data:
		_update_time_display()

# --- 信号处理函数 ---

# 玩家状态更新
func _on_stat_updated(key: String, value: float) -> void:
	match key:
		"health":
			health_label.text = "生命: %.1f" % value
			# 血量低于30%时变红色警告
			if value < 30.0:
				health_label.modulate = Color(1.0, 0.3, 0.3)
			else:
				health_label.modulate = Color(1.0, 1.0, 1.0)

		"energy":
			energy_label.text = "能量: %.1f" % value
			# 能量低于20%时变黄色警告
			if value < 20.0:
				energy_label.modulate = Color(1.0, 1.0, 0.3)
			else:
				energy_label.modulate = Color(1.0, 1.0, 1.0)

		"temperature":
			temp_label.text = "体温: %.1f°C" % value
			# 体温低于30°C时变蓝色警告
			if value < 30.0:
				temp_label.modulate = Color(0.3, 0.3, 1.0)
			else:
				temp_label.modulate = Color(1.0, 1.0, 1.0)

# 禁忌更新
func _on_taboo_updated(taboo: int) -> void:
	var taboo_name: String = _get_taboo_name(taboo)
	taboo_label.text = "今日禁忌: " + taboo_name

	# 禁忌变更时显示特殊颜色
	taboo_label.modulate = Color(1.0, 0.8, 0.2)

	# 3秒后恢复原色
	var timer: SceneTreeTimer = get_tree().create_timer(3.0)
	timer.timeout.connect(_reset_taboo_color)

# 昼夜变更
func _on_time_phase_changed(is_night: bool) -> void:
	# 更新背景颜色表示昼夜
	if is_night:
		time_label.modulate = Color(0.7, 0.7, 1.0)  # 夜晚蓝色
	else:
		time_label.modulate = Color(1.0, 1.0, 1.0)  # 白天白色

# 公告信息
func _on_announcement(text: String) -> void:
	announcement_label.text = text
	announcement_timer = 5.0  # 显示5秒

# --- 辅助函数 ---

# 更新时间显示
func _update_time_display() -> void:
	# 由WorldManager推送的真实时间比率转换为时钟显示
	var minutes: int = int(current_time_ratio * 24 * 60) % (24 * 60)
	var hours: int = int(minutes / 60.0)
	var mins: int = minutes % 60

	time_label.text = "时间: 第%d天 - %02d:%02d" % [current_day, hours, mins]


func _on_world_clock_updated(day_count: int, time_ratio: float, _is_night: bool) -> void:
	has_world_clock_data = true
	current_day = day_count
	current_time_ratio = clampf(time_ratio, 0.0, 1.0)
	_update_time_display()

# 获取禁忌名称
func _get_taboo_name(taboo: int) -> String:
	match taboo:
		0:
			return "无禁忌"
		1:
			return "忌出行"
		2:
			return "忌杀生"
		3:
			return "宜挖掘"
		_:
			return "未知禁忌"

# 重置禁忌标签颜色
func _reset_taboo_color() -> void:
	taboo_label.modulate = Color(1.0, 1.0, 1.0)

# 调试功能：手动更新状态（用于测试）
func update_debug_info(health: float, energy: float, temp: float) -> void:
	health_label.text = "生命: %.1f" % health
	energy_label.text = "能量: %.1f" % energy
	temp_label.text = "体温: %.1f°C" % temp
```

---

