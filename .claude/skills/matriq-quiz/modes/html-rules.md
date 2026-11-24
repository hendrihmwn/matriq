# Rules for the interactive HTML page

Applies to the `quiz` mode.

## Where the output goes
- **claude.ai chat:** create one self-contained HTML artifact.
- **Claude Code:** write the page to `output/<mode>-YYYY-MM-DD-<topic-slug>.html`.
  If an Artifact/publish tool is available, publish that file and give the user the link;
  otherwise tell the user the file path so they can open it in a browser.
- Keep the chat reply short: one line saying what was made (topic, count). Do not
  repeat the questions or answers in the chat — that would spoil the exercise.

## Technical rules
- One file: inline `<style>` and `<script>`, vanilla JavaScript, no external libraries,
  fonts, images, or network requests
- All content lives in one JS data array at the top of the script, so it is easy to review
- Do not rely on `localStorage`/`sessionStorage`; state lives in JS variables
- Never use `alert()`, `confirm()`, or `prompt()`; show all feedback inside the page
- Escape any user-visible text that contains `<`, `>`, or `&`; insert content with
  `textContent` (not `innerHTML`) unless the content is your own fixed markup
- Keyboard friendly: buttons are real `<button>` elements; Enter submits where it makes sense
- Disable Submit until an answer is given, and lock the answer after submitting

## Look and feel
- Clean, centered card layout, max width about 680px, readable on phone width (16px side padding)
- Support light and dark mode with CSS variables and `prefers-color-scheme`
- Correct = green, incorrect = red, with an icon or text too (not color alone)
- Visible progress (e.g. "3 / 10" and/or a progress bar) on every screen
- Short, smooth transitions; respect `prefers-reduced-motion`

## UI labels by language
| Purpose | `lang: id` | `lang: en` |
|---------|------------|------------|
| Submit | Kirim Jawaban | Submit |
| Next | Berikutnya | Next |
| Back / Previous | Kembali / Sebelumnya | Back / Previous |
| Flip | Balik Kartu | Flip |
| Restart | Ulangi | Restart |
| Correct / Incorrect | Benar / Salah | Correct / Incorrect |
| Easy / Medium / Hard | Mudah / Sedang / Sulit | Easy / Medium / Hard |
| True / False | Benar / Salah | True / False |
| Score | Skor | Score |
