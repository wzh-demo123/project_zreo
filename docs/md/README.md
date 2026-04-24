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
