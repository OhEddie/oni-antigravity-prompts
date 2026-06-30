# CONVENTIONS.md

**Code style и конвенции этого проекта. Дополняет `.agent/STYLE.md`.**

`STYLE.md` — общие правила (одинаковые для всех проектов).
`CONVENTIONS.md` — специфика этого проекта (только здесь).

---

## File structure

```
project/
├── src/
│   ├── components/      ← React компоненты (только UI)
│   ├── lib/             ← бизнес-логика, утилиты
│   ├── api/             ← API routes (или routes/)
│   ├── types/           ← TypeScript типы
│   └── config/          ← конфигурация (env validation)
├── tests/               ← unit + integration тесты
├── docs/                ← документация
│   ├── adr/             ← Architecture Decision Records
│   └── features/        ← RFC per feature
└── scripts/             ← dev/build/deploy скрипты
```

## Naming

| Что | Конвенция | Пример |
|---|---|---|
| Файлы | kebab-case | `user-avatar.tsx` |
| React компоненты | PascalCase | `UserAvatar.tsx` |
| Функции | camelCase, глагол | `getUserById` |
| Типы / интерфейсы | PascalCase | `UserProfile` |
| Constants | SCREAMING_SNAKE | `MAX_RETRY_COUNT` |
| DB таблицы | snake_case + plural | `user_profiles` |
| API routes | kebab-case + plural | `/api/v1/user-profiles` |
| Env vars | SCREAMING_SNAKE | `DATABASE_URL` |

## Imports

Сортированы в 3 группы (eslint-plugin-import):
1. External (npm пакеты)
2. Internal (absolute paths через `@/`)
3. Relative (`./`, `../`)

```typescript
// 1. External
import { useState } from 'react';
import { z } from 'zod';

// 2. Internal
import { Button } from '@/components/ui/button';
import { db } from '@/lib/db';

// 3. Relative
import { validateEmail } from './validation';
```

## TypeScript

- **Strict mode:** ВСЕГДА
- **Никаких `any`** без комментария почему
- **Предпочитай `unknown`** вместо `any` когда тип заранее неизвестен
- **Discriminated unions** вместо optional chaining где возможно
- **Zod для runtime validation** на границах системы (API, env)

## Error handling

- **Custom error classes** для разных доменов (`NotFoundError`, `ValidationError`)
- **Throw, не return null**, для неожиданных ошибок
- **Result type** для ожидаемых ошибок (например "юзера нет" — это норма)
- **Логируй с контекстом** (что пытались сделать, с какими параметрами)

```typescript
// Custom error
class UserNotFoundError extends Error {
  constructor(public userId: string) {
    super(`User not found: ${userId}`);
    this.name = 'UserNotFoundError';
  }
}

// Throw
if (!user) throw new UserNotFoundError(id);

// Result type (для ожидаемых ошибок)
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };
```

## Testing

- **Unit:** Vitest, файл рядом с кодом (`user.test.ts`)
- **Integration:** Vitest + реальная БД (через docker-compose в CI)
- **E2E:** Playwright, в папке `tests/e2e/`
- **Coverage:** ≥ 70% для нового кода, ≥ 80% для критических путей

## Logging

- **Structured JSON** в проде
- **Levels:** error (только реальные ошибки), warn (странности), info (бизнес-события), debug (dev only)
- **Не логируй секреты** никогда
- **Include requestId** во всех логах одного запроса

## Безопасность

- **Все env vars валидируются** через zod schema при старте
- **API keys с минимальными scopes**
- **CORS настроен явно**, не `*` в проде
- **Rate limiting** на auth endpoints
- **SQL queries только через ORM** или parameterized raw queries

## Что запрещено в этом проекте

- ❌ `console.log()` / `print()` — только `logger.*`
- ❌ `as any` без комментария
- ❌ `// @ts-ignore` без обоснования
- ❌ `try { ... } catch {}` (swallow)
- ❌ Коммитить `.env`, `*.db`, секреты
- ❌ Коммитить vendor-specific код (только если обсудили)
- ❌ Force push в main
- ❌ Merge без approval (если есть команда)

## Git workflow

- **Branch naming:** `<type>/<short-name>`
  - `feat/oauth-google`
  - `fix/login-500`
  - `refactor/extract-auth`
  - `docs/update-readme`
- **PR title:** conventional commit format
- **PR template:** обязательный чеклист (см. `.github/PULL_REQUEST_TEMPLATE.md`)
- **Squash merge** для фич в main (один коммит = одна логическая единица)