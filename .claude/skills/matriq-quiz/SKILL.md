---
name: matriq-quiz
description: Create quizzes on any topic or document. Modes - daily quiz JSON/Markdown for the Telegram bot, or an interactive HTML quiz mixing multiple choice, true/false, and multiple select with explanations and a score breakdown. Use when asked for a quiz, daily quiz, kuis, or soal latihan.
argument-hint: "mode: telegram|quiz topic: <topic> count: <n> lang: id|en format: json|md|both verify: on|off"
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
| `verify:` | `on`, `off` (skip the second-model check) | `on` |

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
- If the user attached or referenced a document (including a path they name), base the content
  on that document only.
- Otherwise, if a `docs/` folder with documents exists, choose from it (rules below).
- Otherwise, write from your own knowledge on the topic.

**Choosing from `docs/`** (only when no document was named):
- List the files. Skip hidden files and formats you cannot read (`.docx`, `.pptx`, `.xlsx`);
  tell the user those need converting to PDF or Markdown.
- Match the files to `topic:` by file name first. If the names do not settle it, read the start
  of each candidate (the first page or about 50 lines).
- One clear match: use it. Several matches: use all of them. No clear match: do not force a
  document; use your own knowledge and say so in one line.
- Live conversation and unclear (several unrelated candidates, or only a partial match): ask
  which file to use before creating anything. Headless run: never ask; use the clear matches,
  otherwise your own knowledge, and name what you used.
- Content taken from `docs/` is based on those files only (same as a referenced document).
  Read large PDFs in page ranges, only the parts relevant to the topic.
- End the reply with one line naming the files used: `Sumber: docs/<file>`
  (`lang: en`: `Source: docs/<file>`).

## Content quality (all modes)
- Only use facts you are confident about; skip anything uncertain
- Verify every answer key with a second model before output (see "Answer verification")
- Explanations are short and say *why* the answer is right
- Commands, code, and formulas must be correct (and safe to copy)
- Match vocabulary and depth to the audience implied by the request

## Answer verification (all modes)
Unless `verify: off`, read `verify.md` in this skill folder and follow it after drafting
the questions and before writing any file: a different model answers the questions blind
(without the key), and every disagreement is resolved or the question is dropped.
Do not skip this step in headless runs; if no second model is reachable, use the
fallback in `verify.md` and say so in the report.
