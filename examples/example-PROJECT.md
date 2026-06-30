# Пример PROJECT.md

Это пример как может выглядеть заполненный `project/PROJECT.md`. Не копируй буквально — адаптируй под свой проект.

---

# PROJECT.md

## Что это

**Название:** AI OFM ERP
**Тип:** Internal SaaS (dashboard)
**Домен:** AI OFM (OnlyFans-model factory на AI-контенте)

## Зачем существует

AI OFM ERP — это **внутренний dashboard** для команды, которая управляет AI-моделями (виртуальные лица), контент-пайплайном (загрузка → ревью → публикация) и автоматизацией social media (X, Reddit, Instagram, TikTok). Первичная ценность — заменить связку операторов-людей связкой AI-генерация + RPA (GeeLark cloud phones + AdsPower anti-detect browsers).

## Кто пользователи

- **Primary:** admin (1 человек) — настраивает систему, мониторит, фиксит баги
- **Secondary:** creators (2-3 человека) — генерируют контент, ревьюят AI-выхлоп
- **Tertiary:** farmers (5-10 человек) — публикуют контент на аккаунты через RPA
- **Out of scope:** обычные пользователи, B2C

## Ключевые метрики успеха

| Метрика | Текущее | Цель |
|---|---|---|
| AI-моделей в каталоге | 15 | 50 |
| Постов в день через RPA | 200 | 1000 |
| Время от идеи до публикации | 4 часа | 30 минут |
| Стоимость генерации 1 изображения | $0.08 | $0.04 |

## Архитектура в одном абзаце

Next.js 14 монолит в подпапке `nextjs_space/`. UI + API routes + in-process workers, всё в одном приложении на Firebase App Hosting (Cloud Run). PostgreSQL managed через Supabase. S3 SDK поверх Supabase S3 endpoint. Авторизация NextAuth (credentials + JWT) для юзеров + Bearer token для агентских скриптов. Image generation через ComfyUI на RunPod Serverless. Cloud phones через GeeLark Open API. Scraping доноров через ScrapeCreators. Telegram для нотификаций.

## Что НЕ делаем (out of scope)

- ❌ Мобильное приложение — пока web-only, responsive design
- ❌ B2B self-service — это internal tool, не product
- ❌ Real-time коллаборация — auth + roles достаточно
- ❌ Multi-tenancy — одна команда, одна инстанция

## Связанные документы

- [ARCHITECTURE.md](ARCHITECTURE.md)
- [CONVENTIONS.md](CONVENTIONS.md)
- [docs/PROJECT_OVERVIEW.md](../docs/PROJECT_OVERVIEW.md) — high-level
- [docs/ARCHITECTURE_C4.md](../docs/ARCHITECTURE_C4.md) — C4-диаграммы
- [docs/adr/](../docs/adr/) — нету (TODO: создать, см. `../oni-antigravity-prompts` рекомендации)

## Стек этого проекта

Отличия от дефолтов в `.agent/STACK.md`:

- **Hosting:** Firebase App Hosting вместо Vercel (так исторически сложилось, см. ADR-0002 когда создадим)
- **DB:** Supabase managed PostgreSQL (eu-west-1)
- **Image generation:** ComfyUI через RunPod (vs просто OpenAI/Anthropic API)
- **Cloud phones:** GeeLark API (vs AdsPower-only)
- **Package manager:** npm only (per `.cursorrules`)
- **Monorepo:** нет, единственный Next.js в `nextjs_space/`