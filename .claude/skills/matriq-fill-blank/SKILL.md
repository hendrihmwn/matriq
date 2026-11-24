---
name: matriq-fill-blank
description: Create an interactive fill-in-the-blank exercise (isian / isi titik-titik) on any topic or document, as a self-contained HTML page with per-answer feedback and a running score. Use when asked for fill-in-the-blank, isian, or a recall exercise where the learner types the missing word.
argument-hint: "topic: <topic> count: <n> lang: id|en"
---

# MATRIQ Fill-in-the-Blank (MAterial TRaining Quiz)

## User arguments
$ARGUMENTS

Read these keys from the arguments above (or from the user's message). Indonesian keys
(`topik:`, `jumlah:`, `bahasa:`) and similar variants are treated the same.

| Key | Values | Default |
|-----|--------|---------|
| `topic:` | any topic, or a document the user attached/referenced | none: ask first |
| `count:` | number of statements | 8 |
| `lang:` | `id`, `en` (`language: english`, `bahasa: inggris` mean `en`) | `id` |

**Missing topic:** if there is no topic, pasted material, or document, ask the user what
topic they want (and the level/audience if it matters) and wait before creating anything.
In a non-interactive run, stop and report that a topic is required.

**Language:** `id` → all content and UI labels in Bahasa Indonesia (technical terms may
stay in English); `en` → everything in English.

**Content source:** an attached/referenced document first (use only that document),
otherwise a `docs/` folder if it has documents, otherwise your own knowledge.

## Role and task
Act as an expert instructional designer creating fill-in-the-blank exercises. Generate an
interactive exercise as a self-contained HTML + JavaScript page. Also read and follow
`html-rules.md` in this skill folder.

## Content
- Each statement has exactly one blank for a key word or short phrase (1–3 words)
- The blank must have one clear answer; list accepted variants (synonyms, spelling,
  with/without a hyphen) so correct answers are not marked wrong
- Each statement has a short explanation of why the answer is right
- Only facts you are confident about; double-check every answer before output
- Match vocabulary and depth to the audience implied by the request

Data shape (one array at the top of the script):
```js
{ before: "text before the blank", after: "text after the blank",
  answers: ["accepted", "variants"], explanation: "..." }
```

## Behaviour
- Show one statement at a time, with an inline input field where the blank belongs
- Submit button (Enter also submits) checks the answer: compare after trimming,
  lowercasing, and collapsing spaces against every accepted variant
- Correct → input turns green and a brief reinforcement message is shown
- Incorrect → input turns red, the correct answer is revealed, and a short explanation is shown
- A Next button advances to the following statement (only enabled after Submit)
- A running score is visible at all times (e.g. "Skor: 3 / 5")

## Final screen
- Total score, percentage, and an encouraging feedback message tailored to the result
- A Restart button
