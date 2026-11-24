# Mode: quiz (interactive mixed-type quiz)

Act as an expert educator and quiz designer. From the topic or document, generate an
interactive quiz as a self-contained HTML + JavaScript page (see `html-rules.md`).

## Content
- Number of questions = `count:` (default 6)
- Mix three question types, distributed as evenly as possible across the total
  (e.g. 6 → 2/2/2, 7 → 3/2/2), and interleave them instead of grouping by type:
  1. **Multiple choice** — options A, B, C, D; exactly one correct answer
  2. **True or false** — a statement the user marks as true or false
  3. **Multiple select** — 4–6 options, two or more correct; show a note that more than
     one answer may apply
- Every question has an explanation of why the correct answer(s) are right

Data shape (one array in the script):
```js
{ type: "mc" | "tf" | "multi", question: "...", options: [...], answer: [indexes], explanation: "..." }
```
For `tf`, options are the localized True/False labels and `answer` has one index.

## Behaviour
- Show one question at a time
- Clearly label the question type at the top of each question
  (id: "Pilihan Ganda", "Benar atau Salah", "Pilih Semua yang Benar";
  en: "Multiple Choice", "True or False", "Multiple Select")
- Radio buttons for multiple choice and true/false; checkboxes for multiple select
- Wait for the user to click Submit before revealing anything
- After Submit: show Correct/Incorrect, highlight the correct option(s), and show the
  explanation; then advance automatically to the next question after about 3 seconds,
  with a visible countdown and a Next button to skip the wait
- Multiple select counts as correct only if the selected set exactly matches the answer set

## Final screen
- Number of correct answers and percentage score
- Breakdown by question type (correct / total for each of the three types)
- A short personalized feedback message based on the overall result
  (e.g. ≥80% praise, 50–79% encouragement with what to review, <50% suggest revisiting the topic)
- A Restart button
