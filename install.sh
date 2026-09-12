#!/usr/bin/env bash
# 菜狗军师 Skills · 一键安装 / Caigou Junshi Skills · One-line install
#
# 用法 / Usage:
#   curl -sL https://raw.githubusercontent.com/medgrey123-prog/caigou-junshi-skills/main/install.sh | bash
#   bash install.sh --dir ~/.hermes/skills/cangjie
#
# 安装 4 个 skill（统一入口 + 概念 + 方法论 + 表达）到你的 Agent skills 目录。
set -euo pipefail

REPO="https://github.com/medgrey123-prog/caigou-junshi-skills.git"
SUB="skills/cangjie"
TARGET=""
EXPLICIT=0

while [ $# -gt 0 ]; do
  case "$1" in
    --dir) TARGET="${2:-}"; EXPLICIT=1; shift 2 ;;
    --dir=*) TARGET="${1#*=}"; EXPLICIT=1; shift ;;
    -h|--help)
      echo "用法: install.sh [--dir <skills-dir>]"
      exit 0 ;;
    *) shift ;;
  esac
done

if [ "$EXPLICIT" = "0" ]; then
  for cand in \
    "${HERMES_HOME:-}/skills/cangjie" \
    "$HOME/.hermes/skills/cangjie" \
    "$HOME/.codex/skills/cangjie" \
    "$HOME/.claude/skills/cangjie" \
    "$HOME/.config/hermes/skills/cangjie"; do
    if [ -n "$cand" ] && [ -d "$(dirname "$cand")" ]; then TARGET="$cand"; break; fi
  done
fi

if [ -z "$TARGET" ]; then
  TARGET="$HOME/.hermes/skills/cangjie"
  echo "未探测到已有 skills 目录，默认安装到: $TARGET"
fi
mkdir -p "$TARGET"

command -v git >/dev/null 2>&1 || { echo "❌ 需要 git，请先安装 git"; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "⬇️  下载 caigou-junshi-skills ..."
git clone --depth 1 "$REPO" "$TMP/repo" >/dev/null 2>&1

cp -R "$TMP/repo/$SUB/." "$TARGET/"

echo ""
echo "✅ 安装完成 / Installed: $TARGET"
echo ""
echo "包含 / Included:"
echo "  • caigou-junshi             统一入口（询问式三层流程）"
echo "  • caigou-junshi-concepts    概念层（56 个概念）"
echo "  • caigou-junshi-methodology 方法层（63 条方法论）"
echo "  • caigou-junshi-expression  表达层（钩子/句式/金句库）"
echo ""
echo "重启或新开一个 Agent 会话即可使用。试试说："
echo "  「用菜狗军师的询问式流程帮我分析：我做了很多干货短视频，但没有流量」"
