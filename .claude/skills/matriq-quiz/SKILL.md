---
name: matriq-quiz
description: Create quizzes on any topic or document. Modes - daily quiz JSON/Markdown for the Telegram bot, or an interactive HTML quiz mixing multiple choice, true/false, and multiple select with explanations and a score breakdown. Use when asked for a quiz, daily quiz, kuis, or soal latihan.
argument-hint: "mode: telegram|quiz topic: <topic> count: <n> lang: id|en format: json|md|both"
---

# MATRIQ Quiz (MAterial TRaining Quiz)

## User arguments
$ARGUMENTS

Read these keys from the arguments above (or from the user's message when the skill is
triggered in conversation). Indonesian keys (`topik:`, `bahasa:`, `jumlah:`) and similar
variants are treated the same.

| Key | Values | Default |
|-----|--------|---------|
| `mode:` | `telegram`, `quiz` | see "Choosing the mode" |
| `topic:` | any topic, or a document the user attached/referenced | none: ask first (see "Missing topic") |
| `count:` | number of questions (quiz mode) | see mode file |
| `lang:` | `id`, `en` | `id` |
| `format:` | `json`, `md`, `both` (telegram mode only) | `json` |

## Choosing the mode
1. An explicit `mode:` always wins.
2. Otherwise, a quiz requested in a live conversation ("quiz interaktif", "interactive
   quiz", "buatkan kuis") → `quiz`.
3. No hint at all (e.g. a headless `claude -p` run from cron) → `telegram`.

Then read the matching instruction file in this skill folder and follow it:

| Mode | File |
|------|------|
| `telegram` | `modes/telegram.md` |
| `quiz` | `modes/quiz.md` (also read and follow `modes/html-rules.md`) |

Flashcards, fill-in-the-blank, and step-by-step guides are separate skills:
`matriq-flashcards`, `matriq-fill-blank`, and `matriq-stepper`.

## Missing topic
If there is no topic, no pasted material, and no attached/referenced document:
- In a live conversation, ask the user what topic (or material) they want, and wait for
  the answer before creating anything. You may also ask for the level/audience if it matters.
- In a non-interactive run (e.g. `claude -p` from cron or a scheduled task), do not guess:
  stop without writing files and report that a topic is required.

## Language
- `lang: id` (default) → all content and UI labels in Bahasa Indonesia
  (technical terms may stay in English)
- `lang: en` → all content and UI labels in English
- Variants such as `language: english`, `bahasa: inggris`, or `bahasa: en` mean `en`

## Content source
- If the user attached or referenced a document, base the content on that document only.
- Otherwise, if a `docs/` folder with documents exists, prefer content from it.
- Otherwise, write from your own knowledge on the topic.

## Content quality (all modes)
- Only use facts you are confident about; skip anything uncertain
- Double-check every answer key before output
- Explanations are short and say *why* the answer is right
- Commands, code, and formulas must be correct (and safe to copy)
- Match vocabulary and depth to the audience implied by the request
