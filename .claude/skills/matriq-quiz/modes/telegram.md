# Mode: telegram (daily quiz for the bot)

Used by the cron job (`claude -p "/matriq-quiz ..."`) to produce the file that `bot.py` sends.

## Task
Create 5 multiple-choice questions on the requested topic (`count:` is ignored in this mode).

## Question rules
- Language follows `lang:`
- 4 options (A–D), exactly one correct answer
- Mix: 2 easy (`mudah`), 2 medium (`sedang`), 1 hard (`sulit`)
- Question max 250 characters, each option max 90 characters, explanation max 180 characters
  (Telegram quiz poll limits)
- Avoid questions already listed in `.claude/skills/matriq-quiz/history.json`

The `difficulty` value is always `mudah` / `sedang` / `sulit`, regardless of language
(the bot uses it as a code).

## Output format
Read the `format:` argument:
- `format: json` (default) → JSON file only (used by the bot)
- `format: md` → Markdown file only (for people to read/share)
- `format: both` → write both, with exactly the same questions

Example: `/matriq-quiz mode: telegram topic: Linux format: both lang: en`

If there is no file system (e.g. running in claude.ai chat), show the JSON and/or
Markdown in a code block in the reply instead of writing files.

### JSON format
Write to `output/quiz-YYYY-MM-DD.json` (today's date), containing only a JSON array:
[{"question": "...", "options": ["A. ...", "B. ...", "C. ...", "D. ..."],
  "answer": "B", "explanation": "...", "difficulty": "mudah", "language": "id"}]

Set `language` to `id` or `en` according to `lang:` (the bot uses it to translate
the difficulty label).

### Markdown format
Write to `output/quiz-YYYY-MM-DD.md` with the structure below. The answer key goes
in a separate section at the bottom so the file can be used as a question sheet.

For `lang: id`:

```markdown
# Daily Quiz — YYYY-MM-DD
**Topik:** <topic>

## Soal 1 (mudah)
<question>

- A. ...
- B. ...
- C. ...
- D. ...

## Soal 2 (sedang)
...

---

## Kunci Jawaban
| No | Jawaban | Penjelasan |
|----|---------|------------|
| 1  | B       | ...        |
```

For `lang: en`, use English headings and labels: `Topic`, `Question 1 (easy|medium|hard)`,
`Answer Key`, and columns `No | Answer | Explanation`.

Escape `|` inside explanations as `\|` so the table does not break.

## After writing output
Append the new question texts to `history.json` (create it if missing; format: array of strings).
Do this only once, even with `format: both`.
