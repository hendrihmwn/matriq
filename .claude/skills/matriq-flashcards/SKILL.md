---
name: matriq-flashcards
description: Create an interactive flashcard deck on any topic or document, as a self-contained HTML page with flip animation, Easy/Medium/Hard self-rating, and a session summary. Use when asked for flashcards, kartu hafalan, or active-recall practice.
argument-hint: "topic: <topic> count: <n> lang: id|en verify: on|off"
---

# MATRIQ Flashcards (MAterial TRaining Quiz)

## User arguments
$ARGUMENTS

Read these keys from the arguments above (or from the user's message). Indonesian keys
(`topik:`, `jumlah:`, `bahasa:`) and similar variants are treated the same.

| Key | Values | Default |
|-----|--------|---------|
| `topic:` | any topic, or a document the user attached/referenced | none: ask first |
| `count:` | number of cards | 10 |
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
Act as an expert learning coach specializing in active recall. Generate a complete
interactive flashcard deck as a self-contained HTML + JavaScript page. Also read and follow
`html-rules.md` in this skill folder.

## Content
- Front: a key term, concept, or question (short)
- Back: a clear and concise definition or explanation (1–3 sentences, optionally a short
  example, command, or formula)
- Only facts you are confident about; verify every card back with a second model before
  output (see "Answer verification")
- Match vocabulary and depth to the audience implied by the request

Data shape (one array at the top of the script):
```js
{ front: "...", back: "...", code: "optional example/command/formula" }
```

## Behaviour
- Show one card at a time with a card counter ("4 / 10")
- A Flip button turns the card over with a smooth 3D flip animation (CSS `transform:
  rotateY(180deg)`, `backface-visibility: hidden`); flipping again shows the front
- When moving to another card, reset it to the front without animating, so the next
  card's answer never flashes
- Previous and Next buttons let the user move freely between cards
- After the back is revealed, show three confidence buttons: Easy, Medium, Hard
  (localized per `html-rules.md`). Rating a card records it and moves to the next unrated
  card; re-rating a card replaces its earlier rating
- A card counts as completed once it has a rating

## Session summary
- Shown when every card has a rating
- Total cards completed and a count breakdown by Easy / Medium / Hard
- A Restart button that resets ratings and returns to card 1, plus an option to
  review only the cards rated Hard (if any)

## Answer verification
Unless `verify: off`, read `verify.md` in this skill folder and follow it after drafting
the content and before writing the page: a different model checks the answers blind, and
every disagreement is resolved or the item is dropped. If no second model is reachable,
use the fallback in `verify.md` and say so in the reply.
