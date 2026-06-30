#!/bin/bash
# setup.sh — инициализация нового проекта из шаблона oni-antigravity-prompts
#
# Использование:
#   cd ~/my-new-project
#   /path/to/oni-antigravity-prompts/scripts/setup.sh
#
# Что делает:
#   1. Копирует .agent/ в текущий проект
#   2. Копирует scripts/ в текущий проект
#   3. Создаёт project/ и session/ директории с шаблонами
#   4. Добавляет .agent/ в .gitignore (опционально, для IDE-specific файлов)
#   5. Подсказывает следующие шаги

set -e

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$(pwd)"

echo "🚀 Инициализация oni-antigravity-prompts"
echo "   Template: $TEMPLATE_DIR"
echo "   Target:   $TARGET_DIR"
echo ""

# Sanity check
if [ ! -d .git ]; then
  echo "⚠️  Текущая директория — НЕ git репозиторий."
  echo "   Рекомендую: git init && git add . && git commit -m 'initial'"
  echo ""
  read -p "Продолжить всё равно? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# 1. Copy .agent/
if [ -d .agent ]; then
  echo "⚠️  .agent/ уже существует. Пропускаю."
else
  echo "1️⃣  Копирую .agent/..."
  cp -r "$TEMPLATE_DIR/.agent" .agent
  echo "   ✅ .agent/ скопирован"
fi
echo ""

# 2. Copy scripts/
if [ -d scripts ]; then
  echo "⚠️  scripts/ уже существует. Пропускаю."
else
  echo "2️⃣  Копирую scripts/..."
  mkdir -p scripts
  cp "$TEMPLATE_DIR/scripts/"*.sh scripts/
  chmod +x scripts/*.sh
  echo "   ✅ scripts/ скопирован"
fi
echo ""

# 3. Create project/ + session/ with templates
echo "3️⃣  Создаю project/ и session/ с шаблонами..."
mkdir -p project session

if [ ! -f project/PROJECT.md ]; then
  cp "$TEMPLATE_DIR/project/PROJECT.md" project/PROJECT.md
  echo "   ✅ project/PROJECT.md"
else
  echo "   ⚠️  project/PROJECT.md уже есть, пропускаю"
fi

if [ ! -f project/ARCHITECTURE.md ]; then
  cp "$TEMPLATE_DIR/project/ARCHITECTURE.md" project/ARCHITECTURE.md
  echo "   ✅ project/ARCHITECTURE.md"
fi

if [ ! -f project/CONVENTIONS.md ]; then
  cp "$TEMPLATE_DIR/project/CONVENTIONS.md" project/CONVENTIONS.md
  echo "   ✅ project/CONVENTIONS.md"
fi

if [ ! -f session/SESSION_BRIEF_TEMPLATE.md ]; then
  cp "$TEMPLATE_DIR/session/SESSION_BRIEF_TEMPLATE.md" session/SESSION_BRIEF_TEMPLATE.md
  echo "   ✅ session/SESSION_BRIEF_TEMPLATE.md"
fi
echo ""

# 4. Update .gitignore
echo "4️⃣  Обновляю .gitignore..."
touch .gitignore
if ! grep -q "^session/.*\.md$" .gitignore 2>/dev/null; then
  # Не добавляем session/ в gitignore — брифы нужны в git для истории
  echo "   ℹ️  session/*.md коммитятся (для истории). Если не хочешь — добавь в .gitignore вручную."
else
  echo "   ⚠️  session/ уже в .gitignore — убедись что это намеренно"
fi
echo ""

echo "🎉 Готово!"
echo ""
echo "Следующие шаги:"
echo "  1. Отредактируй .agent/IDENTITY.md (заполни профиль)"
echo "  2. Заполни project/PROJECT.md (что за проект, зачем)"
echo "  3. Заполни project/ARCHITECTURE.md (как устроен)"
echo "  4. Создай первую сессию:"
echo "       ./scripts/new-session.sh \"Добавить X\""
echo "  5. Открой Antigravity, скажи:"
echo '       "Прочитай .agent/ и session/SESSION_BRIEF.md. Используй skill feature."'
echo ""
echo "Когда закончишь сессию:"
echo "  ./scripts/land-the-plane.sh"