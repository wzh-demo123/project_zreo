import os
import datetime

# --- 核心配置 (根据你的仓库修改) ---
REPO_BASE_URL = "https://raw.githubusercontent.com/wzh-demo123/project_zreo/main/"
OUTPUT_FILE = "AI_CONTEXT_MAP.md"

# 定义需要包含的文件后缀
INCLUDE_EXTS = [
    '.gd',      # GDScript 逻辑
    '.tscn',    # 场景结构 (极其重要，AI 需要看节点关系)
    '.godot',   # 项目全局配置 (单例注册、输入映射等)
    '.md',      # 文档说明
    '.cfg'      # 配置文件
]

# 定义绝对需要排除的目录 (防止 Token 爆炸)
EXCLUDE_DIRS = {
    '.git',
    '.godot',
    '.history',
    'assets',   # 排除图片/音频资源
    'addons',   # 排除第三方插件（除非你有自建插件需求）
    'export'    # 排除导出目录
}

def get_dir_tree(startpath):
    """生成可视化的目录树结构"""
    tree = []
    for root, dirs, files in os.walk(startpath):
        # 实时过滤排除目录
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
        level = root.replace(startpath, '').count(os.sep)
        indent = ' ' * 4 * level
        tree.append(f"{indent}└── {os.path.basename(root) or startpath}/")
        sub_indent = ' ' * 4 * (level + 1)
        for f in files:
            if any(f.endswith(ext) for ext in INCLUDE_EXTS):
                tree.append(f"{sub_indent}├── {f}")
    return "\n".join(tree)

def generate_map():
    print("🚀 正在生成全量项目逻辑地图...")

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        # 1. 写入元数据和说明
        f.write("# 📂 Project Zero: 全量架构快照 (Full Context)\n")
        f.write(f"> **生成时间:** {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"> **基础 Raw 路径:** `{REPO_BASE_URL}`\n\n")

        f.write("## 🌳 完整目录结构\n")
        f.write("```text\n")
        f.write(get_dir_tree("."))
        f.write("\n```\n\n")
        f.write("---\n\n")

        # 2. 遍历并写入所有匹配文件的全量内容
        f.write("## 📄 全量代码与配置索引\n")
        f.write("以下内容包含所有脚本和配置的完整代码，供 AI 建立深层逻辑关联。\n\n")

        for root, dirs, files in os.walk("."):
            dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
            for filename in files:
                if any(filename.endswith(ext) for ext in INCLUDE_EXTS):
                    if filename in [OUTPUT_FILE, "ProjectZero_FullSync.py"]:
                        continue

                    file_path = os.path.relpath(os.path.join(root, filename), ".")
                    url_path = file_path.replace(os.sep, "/")
                    raw_link = f"{REPO_BASE_URL}{url_path}"

                    f.write(f"### 🔗 文件: {file_path}\n")
                    f.write(f"- **Raw 链接:** [{url_path}]({raw_link})\n")

                    # 确定语法高亮类型
                    lang = "gdscript"
                    if filename.endswith(".tscn") or filename.endswith(".godot"):
                        lang = "toml" # Godot 的这些文件本质上是类 TOML 格式
                    elif filename.endswith(".md"):
                        lang = "markdown"

                    f.write(f"```{lang}\n")
                    try:
                        # 核心修正：使用 utf-8 并加上 errors='ignore' 防止因为特殊字符中断
                        with open(os.path.join(root, filename), "r", encoding="utf-8", errors="ignore") as src:
                            f.write(src.read())
                    except Exception as e:
                        f.write(f"读取失败: {str(e)}")
                    f.write("\n```\n\n")
                    f.write("---\n\n")

    print(f"✅ 成功！全量地图已保存至: {OUTPUT_FILE}")
    print(f"💡 建议：git add {OUTPUT_FILE} && git commit -m 'SYNC: 更新全量逻辑地图' && git push")

if __name__ == "__main__":
    generate_map()