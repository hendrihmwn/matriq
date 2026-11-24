---
name: matriq-flashcards
description: Create an interactive flashcard deck on any topic or document, as a self-contained HTML page with flip animation, Easy/Medium/Hard self-rating, and a session summary. Use when asked for flashcards, kartu hafalan, or active-recall practice.
argument-hint: "topic: <topic> count: <n> lang: id|en"
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

**Missing topic:** if there is no topic, pasted material, or document, ask the user what
topic they want (and the level/audience if it matters) and wait before creating anything.
In a non-interactive run, stop and report that a topic is required.

**Language:** `id` → all content and UI labels in Bahasa Indonesia (technical terms may
stay in English); `en` → everything in English.

**Content source:** an attached/referenced document first (use only that document),
otherwise a `docs/` folder if it has documents, otherwise your own knowledge.

## Role and task
Act as an expert learning coach specializing in active recall. Generate a complete
interactive flashcard deck as a self-contained HTML + JavaScript page. Also read and follow
`html-rules.md` in this skill folder.

## Content
- Front: a key term, concept, or question (short)
- Back: a clear and concise definition or explanation (1–3 sentences, optionally a short
  example, command, or formula)
- Only facts you are confident about; double-check every card back before output
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
