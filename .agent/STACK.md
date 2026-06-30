# STACK.md

**Какие технологии и сервисы я использую по умолчанию.**

Если проект требует другого — это исключение, не правило. Указывай явно в `project/PROJECT.md`.

---

## Frontend (по умолчанию)

- **Framework:** Next.js 14+ App Router, TypeScript strict
- **UI:** Tailwind CSS + Radix UI + shadcn/ui
- **Forms:** react-hook-form + zod
- **Data fetching:** SWR (или TanStack Query если сложнее)
- **Charts:** Recharts (для простых), Plotly (для сложных)

## Backend (по умолчанию)

- **API style:** REST в `/api/v1/*` (Next.js Route Handlers) + Server Actions где удобно
- **Language:** TypeScript (если Next.js) или Python 3.12+ (если отдельный backend)
- **Python framework:** FastAPI + SQLAlchemy 2 + Alembic
- **Validation:** zod (TS) / pydantic (Python)

## Database (по умолчанию)

- **Primary:** PostgreSQL 15+
- **Hosting:** Supabase (eu-west-1 для EU-юзеров) или Neon
- **ORM:** Prisma (TS) / SQLAlchemy (Python)
- **Не использовать:** Firebase Firestore, MongoDB (без обсуждения)

## Auth (по умолчанию)

- **Users:** NextAuth.js (credentials + JWT) или Supabase Auth
- **API keys:** отдельный Bearer auth для агентов/скриптов
- **Password hashing:** bcrypt или argon2

## Storage (по умолчанию)

- **Files/images:** S3-compatible API (Supabase Storage или Cloudflare R2)
- **CDN:** Cloudflare (если нужен)

## Hosting (по умолчанию)

- **Frontend + Next.js fullstack:** Vercel или Firebase App Hosting
- **Python backend:** Railway или Fly.io
- **Не использовать:** AWS EC2 напрямую (overkill), Kubernetes (никогда не для соло)

## AI / Agentic (по умолчанию)

- **IDE:** Antigravity 2.0 (Google)
- **Методология:** Superpowers (obra)
- **Specs:** OpenSpec (для больших фич)
- **Память:** Beads (Steve Yegge)
- **Decisions:** ADR (Nygard format) в `docs/adr/`

## Monitoring (по умолчанию)

- **Errors:** Sentry
- **Analytics:** PostHog
- **Logs:** стандартный stdout → log drain (Vercel/Railway)

## CI/CD (по умолчанию)

- **CI:** GitHub Actions
- **Lint:** ESLint + Prettier (TS), ruff + black (Python)
- **Type check:** tsc --noEmit (TS), mypy (Python)
- **Tests:** Vitest (TS), pytest (Python)
- **Security:** CodeQL + dependency-review
- **Pre-commit:** husky + lint-staged

## Когда добавлять новый сервис

1. Задачу нельзя решить скриптом за 1 час?
2. Есть разумный free tier?
3. Посчитай monthly cost при 10x масштабе.
4. Если всё ок — добавь в этот файл + создай ADR.

Конкретные сервисы которые уже используются в проектах — указывай в `project/PROJECT.md` (не здесь).