# Human README (RU)

## Язык
- RU (этот файл): `$WORKSPACE_ROOT/human-docs/Human-README-Rus.md`
- EN: `$WORKSPACE_ROOT/human-docs/Human-README-Eng.md`

## Что это
- Это короткая стартовая страница для человека по workspace `$WORKSPACE_ROOT`.
- `$WORKSPACE_ROOT` в документации означает путь к корню этого репозитория на вашей машине.

## Установка на новый компьютер
- Клонируйте репозиторий в нужную папку.
- Определите абсолютный путь до корня репозитория.
- Во всех командах и путях из документации заменяйте `$WORKSPACE_ROOT` на этот абсолютный путь.

## Какие файлы читать
- Основной подробный документ: `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md`
- English version: `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md`
- Список проектов: `$WORKSPACE_ROOT/human-docs/Human-Project-List.md`
- Политика workspace для агентов: `$WORKSPACE_ROOT/AGENTS.md`

## Канонические источники
- Для агентов (English): `$WORKSPACE_ROOT/AGENTS.md` и `$WORKSPACE_ROOT/rss/AGENTS.md`
- Для человека (Russian): `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md`
- For humans (English): `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md`

## Быстрые действия
- Создать проект: `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`
- Проверить соответствие политике: `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`
- Запуск Claude (опционально): используйте локальную настройку Claude CLI/app.

## Важно
- Для людей документация в human-файлах доступна на RU и EN.
- Для агентов основные рабочие контексты и логи ведутся компактно.
- Для Claude используется `$WORKSPACE_ROOT/CLAUDE.md`.
