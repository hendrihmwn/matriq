# Mode: telegram (summary as a Telegram message)

Write a concise summary that the target reader can read in about 3 minutes and send
it to the group as a Telegram message.

## Content rules
- Total length max 3500 characters (fits in one Telegram message)
- Do NOT include URLs or links
- Prefer practical content: concrete examples, real cases, common mistakes

## Structure
Use Telegram HTML formatting. Allowed tags only: `<b>`, `<i>`, `<code>`, `<pre>`.
Escape `<`, `>`, `&` in normal text as `&lt;`, `&gt;`, `&amp;`. No Markdown syntax.

For `lang: id`:

```
📚 <b>Ringkasan Materi: {topic}</b>

<b>Apa itu?</b>
2–3 sentences.

<b>Poin penting</b>
• ...
• ...
• ... (3–6 bullets)

<b>Contoh</b>
example (use <pre> only for code, commands, or formulas)

<b>Kesalahan umum</b>
• ... (2–3 bullets)

💡 <b>Tips:</b> one sentence.
```

For `lang: en`, use English headings: `Material Summary`, `What is it?`,
`Key points`, `Example`, `Common mistakes`, `Tip`.

## Sending
1. Write the message to `output/summary-YYYY-MM-DD.html` (today's date).
2. If `send: yes` (default), run:
   `bash .claude/skills/matriq-material/send_telegram.sh output/summary-YYYY-MM-DD.html`
   - The script reads `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` from the environment
     (or from `.env` in the current directory).
   - If the script fails, report the error output; do not retry more than once.
3. If `send: no`, only write the file and show the message in your reply.
4. If there is no file system or shell (e.g. claude.ai chat), show the message in a code
   block instead and say it was not sent.
