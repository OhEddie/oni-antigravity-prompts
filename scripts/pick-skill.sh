#!/bin/bash
# pick-skill.sh — интерактивно выбрать skill из каталога
#
# Использование:
#   ./scripts/pick-skill.sh
#
# Показывает список skills, выбираешь цифрой, выводит файл (или его summary).

set -e

SKILLS_DIR=".agent/skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "❌ Не найден $SKILLS_DIR"
  echo "   Запусти сначала setup.sh или скопируй .agent/ в проект"
  exit 1
fi

echo "📚 Доступные skills в $SKILLS_DIR:"
echo ""

# Build menu
SKILLS=()
i=1
for f in "$SKILLS_DIR"/*.md; do
  # Skip SKILL_FORMAT (it's meta)
  name=$(basename "$f" .md)
  if [ "$name" = "SKILL_FORMAT" ]; then
    continue
  fi

  # Extract first line of description (line after "# Skill: <name>")
  # and "Когда вызывать" section
  desc=$(awk '/^## Когда вызывать/{flag=1; next} /^## /{flag=0} flag' "$f" | head -3)

  SKILLS+=("$name")
  echo "  $i) $name"
  echo "$desc" | sed 's/^/     /'
  echo ""
  i=$((i+1))
done

# Ask
read -p "Выбери skill (1-$((i-1)) или q для выхода): " choice

if [ "$choice" = "q" ]; then
  exit 0
fi

# Validate
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -ge "$i" ]; then
  echo "❌ Неверный выбор"
  exit 1
fi

SELECTED="${SKILLS[$((choice-1))]}"
SELECTED_FILE="$SKILLS_DIR/$SELECTED.md"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📖 $SELECTED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Print full skill
cat "$SELECTED_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 Скопируй trigger phrase в Antigravity:"
echo ""

# Extract trigger example
awk '/^## Когда вызывать/{flag=1; next} /^## /{flag=0} flag' "$SELECTED_FILE" | grep -E '^\s*-\s*"' | head -3 | sed 's/^/   /'