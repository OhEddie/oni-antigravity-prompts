#!/bin/bash
# new-session.sh — создать SESSION_BRIEF.md для новой сессии
#
# Использование:
#   ./scripts/new-session.sh "Добавить OAuth Google"
#   ./scripts/new-session.sh "Починить баг с оплатой"
#
# Создаёт session/YYYY-MM-DD-<slug>.md из шаблона,
# открывает в $EDITOR (или просто выводит путь).

set -e

if [ -z "$1" ]; then
  echo "Использование: $0 <цель сессии>"
  echo ""
  echo "Пример:"
  echo "  $0 \"Добавить OAuth Google\""
  exit 1
fi

GOAL="$1"
DATE="$(date +%Y-%m-%d)"
SLUG="$(echo "$GOAL" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-' | head -c 50)"
FILENAME="session/${DATE}-${SLUG}.md"

# Create session/ if needed
mkdir -p session

# Check if exists
if [ -f "$FILENAME" ]; then
  echo "⚠️  $FILENAME уже существует."
  echo "   Если хочешь новый бриф — удали старый или измени цель."
  exit 1
fi

# Find template
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$TEMPLATE_DIR/session/SESSION_BRIEF_TEMPLATE.md"

if [ ! -f "$TEMPLATE" ]; then
  echo "❌ Не найден шаблон: $TEMPLATE"
  exit 1
fi

# Create from template
DATE_LONG="$(date '+%A %d %B %Y')"
sed "s/YYYY-MM-DD/$DATE/g; s/<цель сессии>/$GOAL/g; s/^## Метаданные/## Метаданные\n- **Дата:** $DATE_LONG/" "$TEMPLATE" > "$FILENAME"

echo "✅ Создан: $FILENAME"
echo ""
echo "Открой и заполни:"
echo "  - Контекст (2-3 строки)"
echo "  - Задачи (чекбоксы)"
echo "  - Beads (если есть)"
echo "  - Ограничения"
echo "  - Definition of done"
echo ""
echo "После заполнения — открой Antigravity и скажи:"
echo '  "Прочитай .agent/ и '"$FILENAME"'. Используй skill feature."'

# Open in editor if available
if [ -n "$EDITOR" ]; then
  $EDITOR "$FILENAME"
elif command -v code &> /dev/null; then
  code "$FILENAME"
elif command -v cursor &> /dev/null; then
  cursor "$FILENAME"
fi