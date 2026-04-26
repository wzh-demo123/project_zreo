# Project Zero 文档导航

该目录集中放置项目协作与记忆相关文档。

## 核心文档

- **WORLD_DESIGN.md**：世界观与硬约束宪法（项目哲学与规则）
- **PROJECT_STATUS.md**：项目状态、架构概览、优先级与里程碑、会话记录（动态状态中心）
- **IDEAS_SCRAPBOOK.md**：灵感碎片记录（创意储备）

## 根目录文件

- `flatten_code.py`：代码快照生成脚本（用于外部模型无法访问 GitHub 时生成全量代码快照）

## docs/md 目录文件

- `AI_CONTEXT_MAP.md`：全量快照主文件（由 `flatten_code.py` 脚本生成，用于外部云端AI协作）

## 使用建议

- **新会话启动**：按顺序读取 WORLD_DESIGN.md → PROJECT_STATUS.md
- **日常开发**：优先参考 PROJECT_STATUS.md 获取当前状态和优先级
- **创意扩展**：查阅 IDEAS_SCRAPBOOK.md
- **技术约束**：参考 WORLD_DESIGN.md 中的"技术约束"章节

## 文档规范

- **时间戳格式**：文档更新时需添加具体时间（格式：YYYY-MM-DD HH:MM:SS）

## 资产管理规范

### 资源目录结构规范

**禁止直接引用外部资源包路径**：
- ❌ 不要直接引用 `assets/Tiny Swords (Free Pack)/` 下的文件
- ✅ 如需使用外部资源包的图片，必须复制到 `assets/` 下的规范子目录中

### 规范的assets目录结构

```
assets/
├── entities/          # 实体精灵图
│   ├── organic/       # 有机体（怪物、NPC等）
│   ├── mechanical/    # 机械体（机器人、载具等）
│   ├── player/        # 玩家角色
│   └── static/        # 静态物体（岩石、树木等）
├── Character/         # 角色相关资源（保留）
├── Terrain/           # 地形相关资源（保留）
└── [其他外部资源包]/  # 外部资源包仅作为源文件，不直接引用
```

### 添加新资源的流程

1. **从外部资源包选择需要的图片**
2. **复制到对应的规范子目录**：
   - 有机体 → `assets/entities/organic/`
   - 机械体 → `assets/entities/mechanical/`
   - 玩家 → `assets/entities/player/`
   - 静态物体 → `assets/entities/static/`
3. **重命名为有意义的文件名**（如 `archer.png` 而非 `Archer_Idle_0.png`）
4. **在SpriteConfig中引用新路径**

### 示例

```gdscript
# 正确：引用规范目录
sprite_path = "res://assets/entities/organic/archer.png"

# 错误：直接引用外部资源包
sprite_path = "res://assets/Tiny Swords (Free Pack)/Units/Blue Units/Archer/Archer_Idle.png"
```

### 设计目的

- **路径清晰**：避免未来引入不同资源包时路径混乱
- **易于维护**：集中管理项目实际使用的资源
- **可替换性**：便于未来替换资源包而不影响代码
