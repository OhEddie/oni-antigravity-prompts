# Skill: feature

## Когда вызывать
- "сделай фичу X"
- "implement X"
- "build X"
- "добавь X"
- (после `brainstorm` когда spec готов)

## Цель
Реализовать фичу строго по spec, с тестами, ревью, и PR. От начала до PR за одну сессию (или явно сказать что не уложился).

## Процедура

### 1. Проверить готовность
- Spec из `brainstorm` или issue с acceptance criteria — должен быть
- Bead создан — должен быть (если нет — создать)
- Знаешь какие файлы тронешь — если нет, вернись к brainstorm

### 2. Branch
```bash
git checkout main
git pull
git checkout -b feat/<short-name>
```

### 3. TDD-цикл для КАЖДОЙ порции
Для каждой единицы работы:

**а) RED — сначала тест**
```typescript
// пишешь тест который сейчас падает
test('returns user by id', async () => {
  const user = await getUser('123');
  expect(user.id).toBe('123');
});
```

**б) GREEN — минимум кода чтобы прошло**
Пишешь код.

**в) REFACTOR — почисти**
Убери дублирование, вынеси в helper. Тесты должны остаться зелёными.

### 4. **ОБЯЗАТЕЛЬНО**: написать unit-тесты
- Happy path
- 2-3 edge cases (null, empty, invalid input)
- 1 error case (что должно произойти при ошибке)
- Coverage минимум 70% для нового кода

### 5. **ОБЯЗАТЕЛЬНО**: прогнать тесты + lint
```bash
npm run test      # все зелёные
npm run lint      # 0 errors
npm run typecheck # 0 errors
```

### 6. **ОБЯЗАТЕЛЬНО**: 2-stage review
Перед коммитом проверь сам себя:

**Stage 1 — Spec compliance:**
- [ ] Все acceptance criteria выполнены?
- [ ] Ничего лишнего из out-of-scope?
- [ ] Edge cases покрыты?

**Stage 2 — Quality:**
- [ ] Код читаемый (функции ≤ 50 строк, файлы ≤ 300)?
- [ ] Нет дублирования?
- [ ] Нет `console.log` / `print` / TODO без bead?
- [ ] Нет секретов в коде?
- [ ] Error handling корректный (не swallow exceptions)?
- [ ] Нет race conditions (async правильно)?

Если хоть один ❌ — почини до коммита.

### 7. Commit + push
```bash
git add <только_свои_файлы>
git commit -m "feat(<scope>): <description>

<body>

Refs: bd-NNN"
git push -u origin feat/<short-name>
```

### 8. PR
```bash
gh pr create --title "<conventional commit title>" \
  --body "Closes bd-NNN

## Что сделано
- ...

## Как проверить
1. ..."

# Подождать ~30 сек, потом:
gh pr view --web
```

### 9. Обновить Bead
```bash
bd update <id> --status done
bd sync
```

## Выход
- Branch `feat/<name>` запушен
- PR создан
- Все тесты зелёные, lint чистый, typecheck OK
- Bead → done
- Мне скажи: ✅ что сделано, 📋 что изменил, 🐛 что нашёл (если есть bead на это)

## Когда прерваться и спросить
- Если acceptance criteria неоднозначные — вернись к brainstorm
- Если трогаешь > 5 файлов и не уверен в подходе — спроси
- Если нашёл серьёзный баг в существующем коде (не в твоём) — создай bead, НЕ чини в этом PR
- Если нужен новый пакет — обсуди со мной
- Если меняешь публичный API — стоп, нужен ADR

## ЗАПРЕЩЕНО
- Коммитить в main
- Коммитить `.env`, `*.db`, секреты
- Force push
- Один коммит на 1000 строк (разбивай)
- "Потом поправлю" / "TODO: разобраться" — создай bead или сделай сейчас