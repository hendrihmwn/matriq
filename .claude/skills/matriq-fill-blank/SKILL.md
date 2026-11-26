---
name: matriq-fill-blank
description: Create an interactive fill-in-the-blank exercise (isian / isi titik-titik) on any topic or document, as a self-contained HTML page with per-answer feedback and a running score. Use when asked for fill-in-the-blank, isian, or a recall exercise where the learner types the missing word.
argument-hint: "topic: <topic> count: <n> lang: id|en verify: on|off"
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
| `verify:` | `on`, `off` (skip the second-model check) | `on` |

**Missing topic:** if there is no topic, pasted material, or document, ask the user what
topic they want (and the level/audience if it matters) and wait before creating anything.
In a non-interactive run, stop and report that a topic is required.

**Language:** `id` → all content and UI labels in Bahasa Indonesia (technical terms may
stay in English); `en` → everything in English.

**Content source:** an attached/referenced document first (use only that document, including a
path the user names), otherwise a `docs/` folder if it has documents (rules below), otherwise
your own knowledge.

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

## Role and task
Act as an expert instructional designer creating fill-in-the-blank exercises. Generate an
interactive exercise as a self-contained HTML + JavaScript page. Also read and follow
`html-rules.md` in this skill folder.

## Content
- Each statement has exactly one blank for a key word or short phrase (1–3 words)
- The blank must have one clear answer; list accepted variants (synonyms, spelling,
  with/without a hyphen) so correct answers are not marked wrong
- Each statement has a short explanation of why the answer is right
- Only facts you are confident about; verify every answer with a second model before output
  (see "Answer verification")
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

## Answer verification
Unless `verify: off`, read `verify.md` in this skill folder and follow it after drafting
the content and before writing the page: a different model checks the answers blind, and
every disagreement is resolved or the item is dropped. If no second model is reachable,
use the fallback in `verify.md` and say so in the reply.
