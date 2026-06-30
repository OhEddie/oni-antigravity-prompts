#!/bin/bash
# land-the-plane.sh — финальный скрипт сессии
#
# Использование:
#   ./scripts/land-the-plane.sh
#
# Что делает:
#   1. Находит текущий SESSION_BRIEF.md (по дате)
#   2. Показывает что в нём отмечено ✅ и что осталось
#   3. Напоминает: bd sync, git push, обновить docs
#   4. (Опционально) переименовывает SESSION_BRIEF в DONE-<date>

set -e

echo "🛬 Landing the plane..."
echo ""

# 1. Find current SESSION_BRIEF
SESSION_FILE="$(ls -t session/20*-*.md 2>/dev/null | head -1)"

if [ -z "$SESSION_FILE" ]; then
  echo "⚠️  Не найден SESSION_BRIEF в session/"
  echo "   Создай через: ./scripts/new-session.sh \"Цель\""
  echo ""
else
  echo "📋 Текущая сессия: $SESSION_FILE"
  echo ""
  echo "--- Содержимое ---"
  cat "$SESSION_FILE"
  echo "--- /Содержимое ---"
  echo ""

  # Count done vs pending
  DONE_COUNT=$(grep -c "^- \[x\]" "$SESSION_FILE" || echo 0)
  PENDING_COUNT=$(grep -c "^- \[ \]" "$SESSION_FILE" || echo 0)

  echo "✅ Сделано:    $DONE_COUNT"
  echo "⏳ Осталось:   $PENDING_COUNT"
  echo ""

  if [ "$PENDING_COUNT" -gt 0 ]; then
    echo "⚠️  Есть незавершённые задачи. Что делаем?"
    echo "   1) Закрыть сессию (незавершённое переедет в Beads или новый SESSION_BRIEF)"
    echo "   2) Продолжить работу"
    read -p "Выбор (1/2): " -n 1 -r
    echo
    if [[ $REPLY == "1" ]]; then
      echo "   Перенеси незавершённое в:"
      echo "   - Beads: bd create \"...\" -p P0..P3"
      echo "   - Или создай новый SESSION_BRIEF завтра"
    else
      echo "   Продолжаем. Не забудь запустить ./scripts/land-the-plane.sh снова когда закончишь."
      exit 0
    fi
  fi
fi

# 2. Reminders
echo ""
echo "📝 Чеклист закрытия:"
echo "   [ ] Тесты зелёные: npm run test"
echo "   [ ] Lint чистый:    npm run lint"
echo "   [ ] Build OK:       npm run build"
echo "   [ ] bd sync         (если используется Beads)"
echo "   [ ] git add . && git commit -m '...'"
echo "   [ ] git push"
echo "   [ ] PR создан       (если применимо)"
echo "   [ ] Сказал мне итог (что сделано / что нашёл / что осталось)"
echo ""

# 3. Beads reminder
if [ -d .beads ]; then
  echo "💎 Beads в этом проекте. Не забудь:"
  echo "   bd ready         # что осталось открытым"
  echo "   bd sync          # закоммитить markdown"
  echo ""
fi

# 4. Archive SESSION_BRIEF
if [ -n "$SESSION_FILE" ] && [ "$PENDING_COUNT" -eq 0 ]; then
  DATE="$(date +%Y-%m-%d)"
  ARCHIVE="session/DONE-${DATE}-${SLUG}.md"
  # SLUG from current session file
  SLUG="$(basename "$SESSION_FILE" | sed 's/^20[0-9-]*-//;s/\.md$//')"
  ARCHIVE="session/DONE-${DATE}-${SLUG}.md"

  read -p "Переименовать $SESSION_FILE в $ARCHIVE? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    mv "$SESSION_FILE" "$ARCHIVE"
    echo "✅ Переименовано в $ARCHIVE"
  fi
fi

echo ""
echo "✅ Session closed. До следующей."