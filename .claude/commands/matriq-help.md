---
description: Show help for the MATRIQ tools: skills, arguments, levels, languages, examples
argument-hint: "[quiz | material | flashcards | fill-blank | stepper | code | level | lang | verify | examples]"
disable-model-invocation: true
---

# MATRIQ help

Arguments: $ARGUMENTS

Answer from the cheat sheet below. This command only prints help: create no files and run no
commands. Keep the answer short (tables and one-line notes). Reply in the user's language
(Bahasa Indonesia by default; English if they write English).

| Argument | Answer with |
|----------|-------------|
| none | the overview: skill table, shared arguments (`lang`, `verify`, `level`), one example per skill |
| a skill name (with or without the `matriq-` prefix) | that skill's arguments, modes, defaults, and 2 example commands |
| `level` | the level tables (code and material) with English aliases |
| `lang` | the language rules |
| `verify` | how answer verification works and which skills have it |
| `examples` | one ready-to-copy command per skill |
| anything else | answer from the cheat sheet; if it is not covered, say so |

**Source of truth:** before answering, read the relevant `.claude/skills/matriq-*/SKILL.md` and
prefer it over this sheet if they disagree, so the help never goes stale.

## Cheat sheet


### Skills
| Skill | Makes | Output |
|-------|-------|--------|
| `matriq-quiz` | quizzes: interactive mixed quiz, or a daily quiz file for the Telegram bot | HTML page, or JSON/Markdown |
| `matriq-material` | learning-material summary: A4 textbook-style page, or a Telegram message | HTML page, or message |
| `matriq-flashcards` | flashcard deck with Easy/Medium/Hard self-rating | HTML page |
| `matriq-fill-blank` | fill-in-the-blank exercise with a running score | HTML page |
| `matriq-stepper` | step-by-step guide with progress bar, tips, and a recap | HTML page |
| `matriq-code` | coding exercises (write code, fix the bug, predict the output) | HTML page |

In Claude Code, pages are written to `output/<type>-YYYY-MM-DD-<topic>.html` and published as
an artifact. In claude.ai chat, the page is created as an artifact directly.

### Arguments per skill
Indonesian keys work too: `topik:`, `jumlah:`, `bahasa:`, `jenjang:`, `kirim:`, `materi:`, `tingkat:`.

| Skill | Arguments (default) |
|-------|---------------------|
| quiz | `topic:` (required), `mode:` `quiz` or `telegram`, `count:` (quiz mode 6; telegram mode always 5), `lang:`, `format:` `json`/`md`/`both` (telegram mode only, default `json`), `verify:` |
| material | `topic:` (required) or `materi:` (pasted text/document), `mode:` `page`/`telegram`/`both`, `level:`, `lang:`, `send:` `yes`/`no` (telegram mode, default `yes`) |
| flashcards | `topic:` (required), `count:` (10), `lang:`, `verify:` |
| fill-blank | `topic:` (required), `count:` (8), `lang:`, `verify:` |
| stepper | `topic:` (required), `count:` (as many as the process needs, usually 5-10), `lang:` |
| code | `topic:` (required), `code:` (`javascript`), `count:` (5), `level:` (`pemula`), `lang:`, `verify:` |

If `topic:` is missing, the skill asks for it (in a headless run it stops and reports that a
topic is required).

### Mode choice (quiz)
`mode:` always wins. Otherwise a quiz requested in a live conversation is `quiz`; a run with no
hint at all (such as a scheduled `claude -p`) is `telegram`.

### Levels
`matriq-code` (`level:`, default `pemula`):

| Level | English alias | Covers |
|-------|---------------|--------|
| `pemula` | `beginner` | variables, conditionals, loops, arrays, strings |
| `menengah` | `intermediate` | objects, higher-order functions, recursion |
| `lanjut` | `advanced` | algorithms, closures, edge-case-heavy tasks |

`matriq-material` (`level:`; inferred from the request, `Umum` if unclear):

| Level | English alias |
|-------|---------------|
| `SD` | `elementary` |
| `SMP` | `junior high` |
| `SMA` | `senior high` |
| `SMK` | `vocational` / `vocational high` |
| `Mahasiswa` | `university` / `college` |
| `Profesional` | `professional` |
| `Umum` | `general` |

Quiz, flashcards, fill-blank, and stepper have no `level:`; they match vocabulary and depth to
the audience implied by the request.

### Languages
- `lang:` is `id` (default) or `en`. It sets the language of all content and page labels.
  Variants such as `language: english`, `bahasa: inggris`, or `bahasa: en` mean `en`.
- In `matriq-code`, `lang:` is the human language of the instructions. The programming
  language is `code:` (`javascript` by default).
- `code: javascript` exercises run in the browser. Other languages (python, go, java, sql, ...)
  have no runner: only "predict the output" and "find the buggy line" exercises, checked
  against an answer key, and the page says the code is not executed.

### Content source (all skills)
An attached or referenced document first (only that document is used), otherwise documents in
`docs/` if the folder has any, otherwise the model's own knowledge.

### Verification (`verify:`, default `on`)
- quiz, flashcards, fill-blank: a different model answers the questions blind (without the key);
  disagreements are fixed, rewritten, or dropped. If no second model is reachable, the answers are
  re-solved without looking at the key and the report says "single-model".
- code: the answer keys are executed (reference solutions against tests, predict snippets against
  expected output) in Node, or in the language's own toolchain if it is installed (e.g. `go run`).
  If it is not installed, the keys are checked by hand and the report says so.
- material and stepper have no answer key, so no verification step.
- `verify: off` skips the step (faster, but unchecked).

### Example commands
```
/matriq-quiz topic: Real Madrid count: 8
/matriq-quiz mode: telegram topic: Linux networking format: both
/matriq-material topic: Fotosintesis level: SMP
/matriq-material topic: Docker level: professional lang: en
/matriq-flashcards topic: Git dasar count: 12
/matriq-fill-blank topic: HTTP dasar count: 6
/matriq-stepper topic: how to deploy a Go service lang: en
/matriq-code topic: if level: beginner
/matriq-code topic: slice code: go count: 4
```
