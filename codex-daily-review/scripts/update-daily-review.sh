#!/bin/zsh
set -eu

export PATH="/usr/bin:/bin:/usr/sbin:/sbin"

REVIEW_DIR="${CODEX_REVIEW_DIR:-/Users/qiaoyu/Wiki/codex-daily-review}"
TEMPLATE_FILE="$REVIEW_DIR/TEMPLATE.md"
TODAY="${CODEX_REVIEW_DATE:-$(date '+%Y-%m-%d')}"
TARGET_FILE="$REVIEW_DIR/$TODAY.md"

mkdir -p "$REVIEW_DIR/logs"

if [[ -e "$TARGET_FILE" ]]; then
  exit 0
fi

if [[ -f "$TEMPLATE_FILE" ]]; then
  sed \
    -e "s/YYYY-MM-DD/$TODAY/g" \
    -e "s/# Codex 每日复盘模板/# Codex 日志 - $TODAY/" \
    "$TEMPLATE_FILE" > "$TARGET_FILE"
else
  cat > "$TARGET_FILE" <<EOF
# Codex 日志 - $TODAY

## 今天在 Codex 做了什么
- 

## 解决了什么问题
- 

## 学到了什么
- 

## 哪些地方卡住了
- 

## 有哪些提示词/工作流可以改进
- 

## 明天想继续做什么
- 

## 今日一句复盘
- 
EOF
fi
