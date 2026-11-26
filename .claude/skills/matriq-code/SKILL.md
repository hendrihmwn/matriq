---
name: matriq-code
description: Create interactive coding exercises on any programming topic, as a self-contained HTML page with a code editor and an in-browser JavaScript runner (write code, fix the bug, predict the output) with test cases, hints, and a score. Use when asked for soal coding, latihan pemrograman, coding exercises, or a code runner.
argument-hint: "topic: <topic> code: javascript|python|... count: <n> level: pemula|menengah|lanjut lang: id|en verify: on|off"
---

# MATRIQ Code (MAterial TRaining Quiz)

## User arguments
$ARGUMENTS

Read these keys from the arguments above (or from the user's message). Indonesian keys
(`topik:`, `jumlah:`, `bahasa:`, `tingkat:`) and similar variants are treated the same.

| Key | Values | Default |
|-----|--------|---------|
| `topic:` | a programming topic (e.g. array, loop, string, rekursi), or a document | none: ask first |
| `code:` | programming language: `javascript`, `python`, `sql`, ... | `javascript` |
| `count:` | number of exercises | 5 |
| `level:` | `pemula` (`beginner`), `menengah` (`intermediate`), `lanjut` (`advanced`) | `pemula` |
| `lang:` | human language of instructions and UI: `id`, `en` | `id` |
| `verify:` | `on`, `off` (skip running the answer keys) | `on` |

**Level aliases:** the English names `beginner`, `intermediate`, and `advanced` mean `pemula`,
`menengah`, and `lanjut`. Treat them the same, whatever `lang:` is.

**Missing topic:** if there is no topic, pasted material, or document, ask the user what
topic they want (and the programming language/level if it matters) and wait before
creating anything. In a non-interactive run, stop and report that a topic is required.

**Language:** `lang: id` → instructions, hints, explanations, and UI labels in Bahasa
Indonesia; `lang: en` → English. Code identifiers and comments may stay in English.

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

## What can run
- **`code: javascript`** → exercises run for real in the browser. Copy `runner.js` from this
  skill folder **verbatim** into the page's inline `<script>` and call `runCode()`. Do not
  write your own runner, and do not use `eval` or `new Function`.
- **Any other language** → there is no runner (artifacts cannot download language runtimes
  such as Pyodide). Use only the `predict` and `bug` types below, checked against a stored
  answer, and show a short note on the page: "Kode tidak dijalankan; jawaban dicek dengan
  kunci." / "Code is not executed; answers are checked against a key."

## Role and task
Act as an experienced programming instructor. Generate interactive coding exercises as a
self-contained HTML + JavaScript page. Also read and follow `html-rules.md` in this skill folder.

## Exercise types
Mix the types (for JavaScript, include at least one of each when `count` ≥ 3):

1. **`write` — Tulis kode:** a task description, a starter stub in the editor, and 3–5 test
   cases (include at least one edge case: empty input, zero, negative, etc.). Passed when
   every test passes.
2. **`bug` — Perbaiki bug:** short buggy code (one or two real bugs, e.g. off-by-one,
   wrong comparison, missing return) plus tests that fail before the fix. JavaScript:
   passed when every test passes. Other languages: the learner picks the buggy line
   (multiple choice) and the fix is explained.
3. **`predict` — Tebak output:** a short snippet; the learner types the exact console output.
   Compare after trimming each line and dropping empty trailing lines. JavaScript: a Run
   button shows the real output only after the learner has submitted a guess.

Every exercise has: a title, the instructions, 1–2 progressive hints (hidden until asked),
a reference solution (hidden until the exercise is passed or the learner gives up), and a
one- or two-sentence explanation of the key idea.

Data shape (one array at the top of the script):
```js
{ type: "write" | "bug" | "predict", title: "...", prompt: "...",
  starter: "code shown in the editor", tests: [{ expr: "fn(1, 2)", expected: 3 }],
  expectedOutput: "for predict", hints: ["...", "..."], solution: "...", explanation: "..." }
```

## Content rules
- Tasks are small: a solution fits in about 3–15 lines
- Match difficulty to `level:` (pemula: variables, conditionals, loops, arrays, strings;
  menengah: objects, higher-order functions, recursion; lanjut: algorithms, closures,
  edge-case heavy tasks)
- Before output, verify every answer key by running it (see "Answer verification by execution")
- Tests must be deterministic (no randomness, dates, or timing) and synchronous
- Test values must be JSON-serializable; for objects remember key order matters

## Page behaviour
- One exercise at a time, with "Soal 2 / 5", the type label (Tulis Kode / Perbaiki Bug /
  Tebak Output), and a running score
- **Editor:** a monospace `<textarea>` with line numbers in a gutter beside it, Tab inserts
  two spaces, Ctrl/Cmd+Enter runs, a "Reset kode" button restores the starter code
- **Run ("Jalankan"):** shows a console panel with captured logs, then a test list with
  ✓/✗, the expression, the expected value, and the actual value. Show errors with the
  line number in the learner's code and a timeout message for infinite loops
- An exercise is marked passed the first time all tests pass (or the prediction matches);
  attempts after that do not change the score
- **Hint ("Petunjuk")** reveals hints one at a time; **"Lihat solusi"** appears after the
  first failed attempt and marks the exercise as not passed
- Next / Previous buttons move between exercises; the learner may skip
- **Final screen:** passed count, percentage, a breakdown by type, a short feedback message
  tailored to the result, and a Restart button
- Label code areas for screen readers, and keep the editor usable on a phone (full width,
  horizontal scroll inside the editor only)

## Answer verification by execution
Code has an advantage over text answers: the key can be run, so no second model is needed.
Unless `verify: off`, do this after drafting and before writing the page. It applies to
`code: javascript` (run with `node`), and to other languages only when their toolchain is
installed (e.g. `python3`, `go run`, `javac` + `java`). Check with `which` first; a stub that
prints "Unable to locate a Java Runtime" counts as not installed. Otherwise fall back to a
careful mental run and say so in the report.

1. Write a throwaway script outside `output/` (the scratchpad or a temp folder) that loads
   the exercises' data and, for each exercise, checks:
   - **write / bug:** the reference solution passes every test. Evaluate each test's `expr`
     and compare with `expected` exactly as `runner.js` does (deep equality via
     `JSON.stringify`, so key order matters)
   - **write:** the starter code fails at least one test (no exercise is passed by default)
   - **bug:** the buggy code fails at least one test before the fix
   - **predict:** run the snippet, capture its printed output, and compare it with
     `expectedOutput` after trimming each line and dropping empty trailing lines
   - **bug (non-JavaScript, pick-the-line):** the buggy program fails (error, panic, or wrong
     output) and the fixed program gives the correct output
2. Run it with `node` (or the language's own tool). Any mismatch means the key is wrong: fix the key (or the code or
   test), then run again. Do not ship an exercise that still fails its own check.
3. Also confirm each test is deterministic: running the script twice gives the same result.
4. Report one line in the final reply:
   `Verifikasi: <n> soal dijalankan di <runtime>, <x> diperbaiki.`
   (`lang: en`: `Verification: <n> exercises executed in <runtime>, <x> fixed.`)
   If it could not be run: `Verifikasi: tidak dijalankan (tidak ada runtime), dicek manual.`

Never write the check script or its output into the page.
