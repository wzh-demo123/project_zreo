import os
import datetime

# --- 核心配置 (保持原版命名) ---
REPO_BASE_URL = "https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/"
OUTPUT_FILE = "docs/md/AI_CONTEXT_MAP.md"

# 优先级文档：这些文件将出现在生成的 MD 最顶端
PRIORITY_DOCS = [
    "docs/md/WORLD_DESIGN.md",
    "docs/md/PROJECT_STATUS.md",
    "docs/md/IDEAS_SCRAPBOOK.md",
    "docs/md/AI_CONTEXT_MAP.md"
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

    # 确保输出目录存在
    output_dir = os.path.dirname(OUTPUT_FILE)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
        print(f"📁 创建目录: {output_dir}")

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
                doc_dir = os.path.dirname(doc)
                doc_name = os.path.basename(doc)
                write_file_content(f, doc_dir if doc_dir else ".", doc_name)

        # 4. 遍历写入其余代码文件
        f.write("## 📄 全量代码与配置索引\n")
        for root, dirs, files in os.walk("."):
            dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
            for filename in files:
                # 排除已经置顶处理的文件和输出文件本身
                if any(filename.endswith(ext) for ext in INCLUDE_EXTS):
                    file_path = os.path.relpath(os.path.join(root, filename), ".")
                    if file_path in PRIORITY_DOCS or file_path == OUTPUT_FILE:
                        continue
                    write_file_content(f, root, filename)

    print(f"✅ 成功！全量地图已保存至: {OUTPUT_FILE}")
    print(f"💡 建议：git add . && git commit -m 'SYNC: 更新世界观与逻辑地图' && git push")

if __name__ == "__main__":
    generate_map()