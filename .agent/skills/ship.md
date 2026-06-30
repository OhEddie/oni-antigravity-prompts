# Skill: ship

## Когда вызывать
- "задеплой X"
- "release Y"
- "пушни в прод"
- (после `feature` или `debug` когда PR approved)

## Цель
Довести код до продакшна безопасным способом. Smoke tests, мониторинг, rollback plan.

## Процедура

### 1. Pre-deploy checks
- [ ] PR merged в main
- [ ] CI зелёный (build + tests + lint)
- [ ] CodeRabbit / review approved (если используется)
- [ ] Миграции БД проверены отдельно (если есть)
- [ ] Env vars / secrets настроены в Secret Manager

### 2. Определить тип деплоя
- **Hotfix** → экстренный, минимальный. Без фич, только багфикс.
- **Feature** → обычный. Feature branch → main → auto deploy.
- **Migration** → сначала миграция БД, потом код. Иначе слом.

### 3. **ОБЯЗАТЕЛЬНО**: backup если миграция
Если деплой включает миграцию БД:
```bash
# Сделай backup
pg_dump $DATABASE_URL > backups/$(date +%Y%m%d-%H%M%S).sql

# Проверь что файл не пустой
ls -lh backups/$(date +%Y%m%d-%H%M%S).sql
```

### 4. Trigger deploy
Зависит от хостинга:
- **Vercel:** push в main = auto-deploy. Проверь dashboard.
- **Firebase App Hosting:** push в main = auto-deploy. Проверь Console.
- **Railway:** push в main = auto-deploy. Проверь dashboard.
- **Manual:** запускай через CI или руками с явным подтверждением.

### 5. Дождаться deploy completion
Не проверять руками — настрой алерт:
- Vercel: Slack/Telegram integration
- Firebase: Cloud Build notifications
- Custom: cron job который стучит на `/health` каждые 30 сек пока не 200

### 6. **ОБЯЗАТЕЛЬНО**: smoke tests на проде
```bash
# Health check
curl https://your-app.com/api/health
# expect: {"status":"ok"}

# Critical endpoint
curl -H "Authorization: Bearer $PROD_API_KEY" \
  https://your-app.com/api/v1/models
# expect: 200 + валидный JSON

# Login flow
curl -X POST https://your-app.com/api/auth/callback/credentials \
  -d '{"email":"smoke@test.com","password":"smoke"}'
# expect: session cookie
```

**ЗАПРЕЩЕНО**: "выглядит работает" без curl/HTTP-проверки.

### 7. **ОБЯЗАТЕЛЬНО**: мониторинг 15 минут
После деплоя первые 15 минут самые опасные. Следи за:
- Sentry: новые ошибки?
- PostHog: воронки не сломались?
- Server logs: 5xx rate вырос?
- Бизнес-метрика (если есть): что-то аномальное?

Если что-то красное — **rollback сразу**, не "подожду посмотрю".

### 8. Rollback plan (знать заранее)
Для каждого типа деплоя знай как откатить:

| Тип | Rollback |
|---|---|
| **Vercel** | `vercel rollback` или в dashboard → promote предыдущий deploy |
| **Firebase App Hosting** | `firebase apphosting:rollbacks:create` или в Console |
| **Railway** | `railway rollback` или в dashboard → previous deployment |
| **Миграция БД** | **ОТДЕЛЬНЫЙ** down-миграция. НЕ reverse-кодить в коде. |
| **DNS/конфиг** | вернуть env vars / DNS на старые |

**ЗАПРЕЩЕНО**: "горячий фикс" миграции в проде. Откати миграцию, потом думай.

### 9. Announce (опционально)
Если команда / стейкхолдеры ждут:
```markdown
🚀 Deployed: OAuth Google (feat-014)

**Изменения:**
- Новый провайдер в NextAuth
- Кнопка "Sign in with Google" на /login

**Как проверить:**
- https://app.com/login → "Sign in with Google"

**Rollback:** Vercel dashboard → promote deploy #42

**Связанные:**
- Closes bd-014
- Refs ADR-0005
```

### 10. Close beads + update docs
```bash
bd update <id> --status done
bd sync

# Если менял env vars — обнови .env.example (не .env!)
```

## Выход
- Deploy в прод
- Smoke tests прошли
- 15 минут мониторинга без аномалий
- Bead → done
- Rollback plan зафиксирован (если новый тип деплоя)
- Мне: ✅ shipped, с ссылкой на PR и rollback инструкцию

## Когда прерваться
- Если smoke test красный → **не иди дальше**, откатывай
- Если error rate вырос > 5% за 5 минут → **rollback сразу**
- Если не уверен в типе миграции → **стоп**, спроси меня
- Если deploy занимает > 30 минут → что-то пошло не так, проверь

## ЗАПРЕЩЕНО
- Деплой в пятницу вечером (никто не мониторит)
- "Сначала задеплою, потом проверю"
- Skip smoke tests "потому что мелкий фикс"
- Деплой миграции + кода одним PR (если что-то сломается — откатывать что?)
- Force push в main чтобы "починить быстро" — лучше hotfix PR