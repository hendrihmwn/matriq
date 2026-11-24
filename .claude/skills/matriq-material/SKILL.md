---
name: matriq-material
description: Write a learning-material summary on any topic or pasted material, for any level from school to professional. Modes - an illustrated textbook-style summary page (A4, ruled paper) opened as an artifact, or a Telegram message sent to a group. Use when asked for a material summary, ringkasan materi, or a rangkuman page on a topic or pasted material.
argument-hint: "mode: page|telegram|both topic: <topic> level: <level> lang: id|en send: yes|no"
---

# MATRIQ Material (MAterial TRaining Quiz)

## User arguments
$ARGUMENTS

Read these keys from the arguments above (or from the user's message when the skill is
triggered in conversation). Indonesian keys (`topik:`, `bahasa:`, `jenjang:`, `kirim:`,
`materi:`) and similar variants are treated the same.

| Key | Values | Default |
|-----|--------|---------|
| `mode:` | `page`, `telegram`, `both` | see "Choosing the mode" |
| `topic:` | any topic | none: ask first (see "Missing topic") |
| `materi:` | pasted material text or an attached/referenced document | none |
| `level:` | `SD`, `SMP`, `SMA`, `SMK`, `Mahasiswa`, `Profesional`, `Umum` | inferred from the request; `Umum` if unclear |
| `lang:` | `id`, `en` | `id` |
| `send:` | `yes`, `no` (telegram mode) | `yes` |

## Choosing the mode
1. An explicit `mode:` always wins. `both` = make the page AND send the Telegram message,
   with the same content.
2. Otherwise: if the request mentions Telegram, `send:`, or sending to the group → `telegram`.
3. Otherwise → `page`.

Scheduled/cron runs that should post to the group must pass `mode: telegram`.

Then read and follow the matching file in this skill folder:

| Mode | File |
|------|------|
| `page` | `modes/page.md` |
| `telegram` | `modes/telegram.md` |

## Missing topic
If there is no topic, no pasted material, and no attached/referenced document:
- In a live conversation, ask the user what topic (or material) they want, and wait for
  the answer before creating anything. You may also ask for the level/audience if it matters.
- In a non-interactive run (e.g. `claude -p` from cron or a scheduled task), do not guess:
  stop without writing files and report that a topic is required.

## Language
- `lang: id` (default) → Bahasa Indonesia (technical terms may stay in English)
- `lang: en` → English
- Variants such as `language: english` or `bahasa: inggris` mean `en`

## Content source
- If the user pasted material or attached/referenced a document, summarize THAT material;
  do not add facts that contradict it.
- Otherwise write from your own knowledge on the topic.

## Content quality (all modes)
- Only state facts you are confident about; skip anything uncertain
- Do NOT include URLs or links
- Code, commands, and formulas must be correct (no destructive commands without a warning)
- Match vocabulary, depth, and examples to the level/audience
