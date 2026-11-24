---
name: matriq-stepper
description: Create an interactive step-by-step guide (stepper) for any process, procedure, or topic, as a self-contained HTML page with a progress bar, Next/Back navigation, tips, common mistakes, and a completion recap. Use when asked for step-by-step, langkah-langkah, a tutorial, or how a process works.
argument-hint: "topic: <topic or process> count: <n> lang: id|en"
---

# MATRIQ Stepper (MAterial TRaining Quiz)

## User arguments
$ARGUMENTS

Read these keys from the arguments above (or from the user's message). Indonesian keys
(`topik:`, `jumlah:`, `bahasa:`) and similar variants are treated the same.

| Key | Values | Default |
|-----|--------|---------|
| `topic:` | a topic, process, or a document the user attached/referenced | none: ask first |
| `count:` | number of steps | as many as the process needs (usually 5–10) |
| `lang:` | `id`, `en` (`language: english`, `bahasa: inggris` mean `en`) | `id` |

**Missing topic:** if there is no topic, pasted material, or document, ask the user what
topic or process they want (and the level/audience if it matters) and wait before creating
anything. In a non-interactive run, stop and report that a topic is required.

**Topic that is not a process:** if the topic is a subject rather than a process (e.g.
"Mamalia"), turn it into a meaningful sequence (e.g. an identification key, a learning
path, or a historical timeline) and say in the reply which framing you chose.

**Language:** `id` → all content and UI labels in Bahasa Indonesia (technical terms may
stay in English); `en` → everything in English.

**Content source:** an attached/referenced document first (use only that document),
otherwise a `docs/` folder if it has documents, otherwise your own knowledge.

## Role and task
Act as an expert instructional guide who breaks complex processes into clear sequential
steps. Generate an interactive stepper as a self-contained HTML + JavaScript page. Also
read and follow `html-rules.md` in this skill folder.

## Content
- Do not pad or merge steps just to hit a number
- Each step has: a short descriptive title, a detailed explanation of what happens at that
  stage, and optionally one tip or one common mistake to avoid
- Include a concrete example in a step when it helps (a command, formula, or short case)
- Each step has a one-line recap for the completion screen
- Only facts you are confident about; commands and formulas must be correct
- Match vocabulary and depth to the audience implied by the request

Data shape (one array at the top of the script):
```js
{ title: "...", body: "...", recap: "...", example: "optional", tip: "optional", mistake: "optional" }
```

## Behaviour
- Show one step at a time with a prominent step number and the title
- A progress bar or indicator at the top shows the current step out of the total
- Clearly labeled Next and Back buttons move freely in either direction
  (Back disabled on step 1; Next on the last step leads to the completion screen)
- Left/right arrow keys also navigate

## Completion screen
- A summary of the full process: numbered list of every step title with its one-line recap
- A Restart button that returns to step 1
