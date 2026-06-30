# Пример SESSION_BRIEF.md

Это пример заполненного session brief. Реальный путь будет `session/2026-06-30-oauth-google.md` (создаётся через `new-session.sh`).

---

# Сессия: 2026-06-30 — OAuth Google

## Метаданные

- **Дата:** Понедельник 30 июня 2026
- **Цель (1 строка):** Добавить вход через Google в AI OFM dashboard

## Контекст

Юзеры жалуются на пароли: 3 тикета за последний месяц, "забыл пароль", "не приходит reset email". OAuth Google — самое быстрое решение: 1 кнопка, безопаснее (2FA от Google), привычно юзерам.

Существующий credentials login НЕ ломаем — добавляем как второй провайдер. Это ADR-нужное решение (auth strategy меняется).

## Задачи

- [ ] Создать bead bd-014 "OAuth Google" (P1)
- [ ] Создать ADR-0005 "OAuth strategy" (status: Proposed → Accepted)
- [ ] Использовать skill `brainstorm` для уточнения требований
- [ ] Использовать skill `feature` для имплементации:
  - [ ] Зарегистрировать OAuth app в Google Cloud Console
  - [ ] Добавить GOOGLE_CLIENT_ID / GOOGLE_CLIENT_SECRET в Secret Manager
  - [ ] Добавить GoogleProvider в NextAuth config
  - [ ] Добавить кнопку "Sign in with Google" на /login
  - [ ] Миграция БД: добавить поле `accounts.provider` в User
  - [ ] Тесты (unit + integration)
  - [ ] 2-stage review (spec compliance + quality)
- [ ] Использовать skill `ship` для деплоя:
  - [ ] Smoke test на dev
  - [ ] Deploy в prod
  - [ ] 15 минут мониторинга Sentry

## Beads

- bd-014: OAuth Google (создать в начале сессии)
- bd-013: Track auth-related tickets (связь — закрыть после деплоя)

## Ограничения

- НЕ ломать существующий credentials login
- НЕ менять NextAuth core — только добавить провайдер
- Все env vars — в Google Cloud Secret Manager, НЕ в .env
- Не коммитить GOOGLE_CLIENT_SECRET (случайно закоммитил → ротировать немедленно)

## Definition of done

Когда я скажу "готово":
- [ ] Все задачи выше ✅
- [ ] `bd sync` сделан
- [ ] `git push` сделан
- [ ] PR создан и смержен (или готов к merge)
- [ ] Закрытие сессии через `./scripts/land-the-plane.sh`

---

**Удалить** этот файл в конце сессии (или перенести в `docs/features/oauth-google/` если важно сохранить как RFC).