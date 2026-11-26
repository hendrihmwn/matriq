# Mode: page (illustrated summary page, textbook style)

Act as a textbook editor, instructional designer, and professional educational layout
designer. Create an illustrated summary page in the style of a professional study-summary
book ("buku rangkuman"), adapted to the audience level. The goal is **short but
substantial**: every line teaches something.

## Inputs
- Material: the document or text the user pasted (`materi:`), otherwise the `topic:`
- `level:` (`jenjang:`) — `SD`, `SMP`, `SMA`, `SMK`, `Mahasiswa`, `Profesional`, or `Umum` (English aliases such as `elementary` or `university` are listed in
  `SKILL.md`).
  If not given, infer it from the request (e.g. a school subject or class → that level,
  a workplace/technical topic → `Profesional`); if still unclear, use `Umum` (general
  adult reader). Match vocabulary, depth, and examples to the level
- Header fields, inferred when not given:
  - `subject:` (`mapel:`) — e.g. "Biologi", "Sejarah Indonesia", "Pemrograman Java"
  - `class:` (`kelas:`) — the level label, e.g. "Kelas XI", "Mahasiswa", or "Profesional"
  - `chapter:` (`bab:`) — chapter number and name, default "BAB 1"
  - Title = the topic

## Content
- Fits one A4 portrait page; use a second page only if the material truly needs it
- Flow top to bottom like a book page, NOT a poster or infographic
- 3–6 numbered sub-topics, each with a short heading and tight, concrete text
- Use bullets, a simple table, a short example, a small diagram, or a formula/command
  where it helps understanding. Include at least one concrete example that fits the
  subject: a worked formula for math/science, a code or command snippet for technical
  topics, a real case, date, or quote for social subjects
- End with a **"Ringkasan"** section (`lang: en`: "Summary"): 4–6 core takeaways
- Only facts you are confident about; no URLs

## Layout and style
- **Sheet:** an A4 portrait sheet (210mm × 297mm, `aspect-ratio` 210/297 on wide screens)
  centered on a soft desk-colored background, with a subtle shadow
- **Paper:** ruled notebook paper — thin pastel horizontal lines via
  `repeating-linear-gradient`, plus a thin vertical margin line on the left. Body text
  `line-height` must match the line spacing so text sits on the lines
- **Header block:** subject + class as a small label row, chapter as an eyebrow, and the
  material title as the largest text on the page; a thin rule under it
- **Columns:** one column, or two tidy columns for the body when content suits it
  (`column-count` or grid). Collapse to one column under ~640px wide
- **Separators:** sub-topics are separated by headings, numbers, or thin rules —
  never big boxes or heavy cards. A light pastel highlight behind a key term is fine
- **Text first (~90% text, ~10% icons):** body text large, bold, sharp, high contrast:
  dark ink color on the paper, size about 17–18px on screen, weight 500–600, headings 700+.
  Use a highly legible font (e.g. Lexend, Atkinson Hyperlegible, or Plus Jakarta Sans from
  Google Fonts) with a system fallback; code in a monospace font
- **Icons:** small (18–24px) inline SVG line icons relevant to each sub-topic, drawn
  in the pastel accent color. No emoji, no images from the network
- **Diagram:** if one helps, draw it small with inline SVG or simple CSS boxes and arrows
- **Colors:** a calm pastel palette (2–3 pastel accents, e.g. sage, sky, peach) for
  highlights, numbers, and icons; ink stays dark for readability
- **White space:** generous margins and spacing so the page never feels crowded
- **Footer:** small line with "MATRIQ · Material Training" and the date

## Technical rules
- One self-contained HTML file: inline CSS, inline SVG, no JavaScript needed
  (a tiny script is allowed only for optional niceties)
- This page is deliberately single-theme (paper is always light): set the page
  background and every color explicitly so it reads correctly in a dark host too
- Readable on phone: the sheet scales to the screen width (`width: min(210mm, 100%)`),
  side padding at least 16px, no horizontal page scroll; let height grow on small screens
- Add `@page { size: A4 portrait; margin: 0 }` and print styles so the local file can be
  printed or saved as PDF from a browser

## Output
- **claude.ai chat:** create one HTML artifact.
- **Claude Code:** write `output/material-YYYY-MM-DD-<topic-slug>.html`. If an
  Artifact/publish tool is available, publish it and give the user the link; otherwise give
  the file path.
- Reply in one or two lines (topic, level, link). Do not repeat the content in chat.
