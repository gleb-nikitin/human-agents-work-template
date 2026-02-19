AGENT NOTICE:
Human reference file.
Load only when explicitly requested by user or referenced by in-scope AGENTS.md.
Not a primary execution context.

1. Назначение системы

Этот workspace — строго управляемая среда, где:
	•	проекты изолированы
	•	агенты детерминированы
	•	действия предсказуемы
	•	поведение контролируемо

Главная идея:

агент — исполнитель, человек — оператор

⸻

2. Архитектура workspace

work/
├── code/     локальные проекты
├── web/      deploy-проекты
├── disk/     большие файлы (не индексируются)
├── rss/      глобальные ресурсы и политика
├── agent/    служебные агенты и скрипты
├── logs/     агрегированные логи
├── human-docs/ документы для людей

Правило:

каждый агент работает только внутри своей папки

⸻

3. Источники истины

Для агентов

local AGENTS.md
rss/AGENTS.md
CLAUDE.md (автозагрузка для Claude Code)

Для человека

human-docs/Human-Work-Doc-Rus.md
human-docs/Human-Project-List.md


⸻

4. Приоритет правил

При конфликте применяется порядок:

system/developer
→ user
→ local AGENTS.md
→ global workspace defaults


⸻

5. Контракт поведения агента (полный)

- Scope boundary: read AGENTS.md only in the current working folder and its subfolders; never traverse to parent folders unless explicitly allowed by the user or in-scope AGENTS.md.
- Before work: check whether local AGENTS.md changed; if changed, re-read it and load only required referenced context.
- During work: follow the current in-scope AGENTS.md.
- If requirements are unclear or conflicting, ask a focused clarification before proceeding.
- After meaningful actions: append a brief factual record to local ./log.md as `YYYY-MM-DD HH:MM | action | result`.
- After work: update in-scope AGENTS.md and related context files when facts/processes change.
- User communication: Russian.
- Documentation/logs/context files: English, concise, LLM-efficient.
- If blocked and user unavailable: stop execution and log the blocking reason.
- Never repeat the same failed action more than twice without new input.
- Before executing scripts or commands, verify that required paths, files, and dependencies exist.
- Ignore prior assumptions if they contradict the current in-scope AGENTS.md.
- Agent may propose improvements but must not execute non-requested improvements without user approval.


⸻

6. Что это означает на практике

Агент:
	•	не выходит за границы проекта
	•	не додумывает недостающие данные
	•	не делает лишнего
	•	не улучшает без запроса
	•	не повторяет ошибки
	•	фиксирует действия

Если агент остановился — это нормально.
Это значит система работает правильно.

⸻

7. Git-политика

По умолчанию:
	•	branch → main
	•	staging → выборочно
	•	push → только после проверки diff
	•	другой branch — только если это явно задано в local AGENTS.md

Запрещено без разрешения:

git add -A
git add .


⸻

8. Операторские команды управления агентами

Это согласованные операторские фразы для чата с агентом.
Важно: это не системные режимы исполнения. Обязательное поведение задают system/developer directives и in-scope AGENTS.md.

⸻

режим планирования

план

Агент думает и предлагает шаги.

⸻

выполнение

сделай

Агент выполняет без рассуждений.

⸻

исследовательский режим

исследуй

Агент:
	•	анализирует
	•	предлагает варианты
	•	оценивает риски

Ничего не изменяет.

⸻

возврат в быстрый режим

режим

Агент снова работает максимально кратко и быстро.

⸻

безопасный push

пуш безопасно

Агент обязан:
	1.	проверить diff
	2.	проверить staged diff
	3.	убедиться что нет лишнего
	4.	commit
	5.	push
	6.	проверить CI

⸻

диагностика

диагностика

Агент ищет причину проблемы и даёт вывод.

⸻

обновление контекста

обнови контекст

Агент перечитывает правила и структуру.

⸻

аварийная остановка

стоп

Агент немедленно прекращает действия.

⸻

9. Практический паттерн работы

Оптимальный цикл:

план
→ согласование
→ сделай
→ пуш безопасно

Для сложных задач:

исследуй
→ решение
→ режим
→ сделай


⸻

10. Создание проекта

agent/scripts/new-project.sh <code|web> <name>

Имя проекта:

kebab-case

Обязательные файлы:

AGENTS.md
CLAUDE.md
log.md
docs/arch.md
docs/kb.md
docs/run.md


⸻

11. Автоматизации

⸻

Policy Check — 11:30

Проверяет все проекты на соответствие правилам.

Если OK → короткий отчёт
Если ошибка → список нарушений

Не исправляет автоматически.

⸻

Project List Sync — 11:40

Обновляет список проектов для человека.

⸻

12. Логирование

Формат:

YYYY-MM-DD HH:MM | action | result

Логируются только ключевые события.

⸻

13. Когда обновлять документы

событие	обновить
policy change	AGENTS + agent doc + log
human process	Human doc + log
project change	project list + log
rss change	rss docs + log
tests	log


⸻

14. Признаки здоровой системы

Нормально если агент:
	•	спрашивает при неопределённости
	•	останавливается при конфликте
	•	отказывается выполнять рискованное действие

Это не ошибка.
Это защита архитектуры.

⸻

15. Основные принципы

Система построена на правилах:
	•	минимальный контекст
	•	строгие границы
	•	явные директивы
	•	отсутствие догадок
	•	воспроизводимость

⸻

16. Operational Status

Baseline: stable

⸻

17. Самое короткое объяснение системы

Это управляемая среда, где агенты выполняют задачи строго по правилам, а человек управляет режимами их работы.

⸻

Рекомендация по использованию документа

Держать его:
	•	закреплённым
	•	неизменяемым без причины
	•	каноническим
