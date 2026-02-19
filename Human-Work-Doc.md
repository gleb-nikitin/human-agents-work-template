# Правила работы в `$WORKSPACE_ROOT` (для человека)

## Языковые версии
- RU (этот файл): `$WORKSPACE_ROOT/Human-Work-Doc.md`
- EN: `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`

## Ежедневный чеклист (короткая версия)
- Убедиться, что задача запускается в правильной зоне: `code/` или `web/`.
- Проверить, что агент работает в нужном scope и не выходит в соседние папки.
- Для новых проектов использовать только: `$WORKSPACE_ROOT/agent/scripts/new-project.sh`.
- Проверить имя нового проекта: только `kebab-case`.
- Убедиться, что в проекте есть `AGENTS.md`, `log.md`, `docs/arch.md`, `docs/kb.md`, `docs/run.md`.
- Убедиться, что после значимых действий есть запись в `log.md`.
- Если агент заблокирован или требования конфликтуют: остановка и уточнение у пользователя.
- Любые улучшения вне запроса: только после согласования.

## Назначение
- Этот файл должен позволять человеку полностью понять текущую систему: что задано глобально, что задано локально, зачем это нужно и как применять на практике.

## Карта workspace
- `code/` - локальные проекты разработки.
- `web/` - веб-проекты, ориентированные на запуск и деплой.
- `disk/` - большие данные, кэши, временные файлы; по умолчанию не сканируется.
- `rss/` - общие глобальные ресурсы и глобальный `AGENTS.md` для всех проектов.
- `logs/` - агрегированный индекс логов (вторичный источник).
- `agent/` - рабочая зона overseer-агента, может расширяться подпапками.

## Глобальный текст персонализации (действующий)
- Scope boundary: read AGENTS.md only in the current working folder and its subfolders; never traverse to parent folders unless explicitly allowed by the user or in-scope AGENTS.md.
- Зачем: ограничивает самовольный выход за границы проекта и снижает риск случайных действий не там.
- Before work: check whether local AGENTS.md changed; if changed, re-read it and load only required referenced context.
- Зачем: агент не работает по устаревшим правилам и не тянет лишний контекст.
- During work: follow the current in-scope AGENTS.md.
- Зачем: локальные правила проекта имеют прямое прикладное значение во время выполнения задачи.
- If requirements are unclear or conflicting, ask a focused clarification before proceeding.
- Зачем: уменьшает число неверных действий из-за догадок.
- After meaningful actions: append a brief factual record to local ./log.md as `YYYY-MM-DD HH:MM | action | result`.
- Зачем: обеспечивает трассировку решений и действий.
- After work: update in-scope AGENTS.md and related context files when facts/processes change.
- Зачем: правила и контекст остаются актуальными после изменений.
- User communication: Russian.
- Зачем: единый язык общения с пользователем.
- Documentation/logs/context files: English, concise, LLM-efficient.
- Зачем: технические документы легче поддерживать и переиспользовать агентами.
- If blocked and user unavailable: stop execution and log the blocking reason.
- Зачем: предотвращает хаотичные попытки “додумать” без подтверждения.
- Never repeat the same failed action more than twice without new input.
- Зачем: убирает бесполезные циклы и экономит время.
- Before executing scripts or commands, verify that required paths, files, and dependencies exist.
- Зачем: уменьшает число предсказуемых технических ошибок.
- Ignore prior assumptions if they contradict the current in-scope AGENTS.md.
- Зачем: актуальные правила важнее старых предположений.
- Agent may propose improvements but must not execute non-requested improvements without user approval.
- Зачем: сохраняет контроль пользователя над изменениями вне исходной задачи.

## Текущий стандартный `AGENTS.md` workspace (с пояснениями)
- Принцип: `AGENTS.md` содержит только минимально достаточные рабочие правила.

- `## Scope`
- Зачем: задает границы работы (`$WORKSPACE_ROOT` + subfolders).

- `## Core Rules`
- Зачем: фиксирует короткий рабочий цикл и anti-noise фильтр перед добавлениями в `AGENTS.md`.

- `## Context Loading Priority`
- Зачем: порядок загрузки без лишнего сканирования.
- Всегда читаются:
- локальный `AGENTS.md` текущего scope;
- глобальный `$WORKSPACE_ROOT/rss/AGENTS.md`.

- `## Bootstrap Rules`
- Зачем: единый способ старта и проверки проектов (`new-project.sh` + `policy-check.sh`).

- `## Context Sync`
- Зачем: синхронное ведение двух контуров:
- human: `$WORKSPACE_ROOT/Human-Work-Doc.md`
- agent: `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`

- `## Auto Update Agents`
- Зачем: append-only зона для automation-обновлений.

## Практика создания проекта
- Команда: `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`
- Пример: `$WORKSPACE_ROOT/agent/scripts/new-project.sh code billing-api --purpose "Billing backend" --stack "go, postgres" --boundaries "api only"`
- Пример: `$WORKSPACE_ROOT/agent/scripts/new-project.sh web landing-site --purpose "Marketing site" --stack "nextjs" --boundaries "frontend only" --deployment "docker"`
- `kebab-case` означает: строчные буквы/цифры и дефисы между словами, без пробелов и `_`.

## Автопроверка политики (для стабильного 10/10)
- Команда: `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`
- Что проверяется автоматически:
- имя проекта в `kebab-case`;
- обязательные файлы (`AGENTS.md`, `log.md`, `docs/*`, `scripts/*`, `src/.gitkeep`);
- формат записей в `log.md`;
- структура web-проекта (наличие каталога `web/`).
- Результат: детерминированный вывод `SUCCESS` или `FAIL` с причинами.

## Активные автоматизации Codex
- Ниже зафиксированы две регулярные automation-задачи, которые ты поставил.
- Зачем: чтобы важные проверки и поддержка человеко-ориентированных файлов выполнялись по расписанию и без ручной рутины.

### 1) Workspace Policy Check
- Время: ежедневно в `11:30`.
- Зачем: автоматически контролировать соответствие проектов правилам workspace.
- Что делает: запускает policy check, сообщает статус/ошибки, при необходимости фиксирует только минимальные и доказуемые обновления в `AGENTS.md`.
- Prompt:
```text
Run `$WORKSPACE_ROOT/agent/scripts/policy-check.sh` in `$WORKSPACE_ROOT`.
If SUCCESS: report short status only.
If FAIL: report each violation with absolute path and reason.
Do not modify project files automatically.
You may update `$WORKSPACE_ROOT/AGENTS.md` only by appending at the end under `## Auto Update Agents`, and only for proven recurring workflow gaps.
Keep changes minimal and factual.
Append one line to `$WORKSPACE_ROOT/log.md` as `YYYY-MM-DD HH:MM | action | result`.
```

### 2) Human Project List Sync
- Время: ежедневно в `11:40`.
- Зачем: поддерживать актуальный список проектов для человека без ручного обновления.
- Что делает: сканирует `code/` и `web/` (без шаблонов), обновляет `Human-Project-List.md`, пишет запись в `log.md`.
- Prompt:
```text
Scan `$WORKSPACE_ROOT/code` and `$WORKSPACE_ROOT/web` for real projects (exclude names starting with `_`).
Update `$WORKSPACE_ROOT/Human-Project-List.md` to reflect current state.
Keep format stable and concise.
Do not modify unrelated files.
Append one line to `$WORKSPACE_ROOT/log.md` as `YYYY-MM-DD HH:MM | action | result`.
```

## Где смотреть актуальные версии
- Workspace policy: `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy: `$WORKSPACE_ROOT/rss/AGENTS.md`
- Overseer compact doc: `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`
- Human quickstart: `$WORKSPACE_ROOT/Human-README-Rus.md`
- Human quickstart (EN): `$WORKSPACE_ROOT/Human-README-Eng.md`
- Human project index: `$WORKSPACE_ROOT/Human-Project-List.md`
- Human policy (EN): `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`

## Формальная матрица post-work обновлений
- `policy change` -> обновлять: `$WORKSPACE_ROOT/AGENTS.md`, `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`, `$WORKSPACE_ROOT/log.md`.
- `human-facing process change` -> обновлять: `$WORKSPACE_ROOT/Human-Work-Doc.md`, `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`, `$WORKSPACE_ROOT/log.md`.
- `project create/remove/rename` -> обновлять: `$WORKSPACE_ROOT/Human-Project-List.md`, `$WORKSPACE_ROOT/log.md`.
- `rss resource availability change` -> обновлять: `$WORKSPACE_ROOT/rss/AGENTS.md`, соответствующие `$WORKSPACE_ROOT/rss/docs/*.md`, `$WORKSPACE_ROOT/log.md`.
- `explicit test run` -> по умолчанию обновлять только `$WORKSPACE_ROOT/log.md`, если пользователь отдельно не попросил обновлять документы.
- Гранулярность логов: только ключевые этапы (`context load`, `execution milestone`, `validation`, `context sync`), без микрошагов.
