# How to Build a Marp Slide Deck — Replication Guide

This document explains every design decision in `marp_template/PRESENTATION.md` so you can
reproduce the same layout, colour scheme, and components in a different project.

---

## 1. Tool: Marp

[Marp](https://marp.app/) converts a single Markdown file into a slide deck (HTML,
PDF, or PPTX). It requires no PowerPoint.

### Install Marp CLI

```bash
# via npm (recommended)
npm install -g @marp-team/marp-cli

# or via homebrew
brew install marp-cli
```

### Export commands

Use `build.sh` (from the `markdown_to_slidedeck` skill) to build outputs named after your input file:

```bash
# PPTX + HTML (outputs: myslides.pptx, myslides.html)
bash build.sh myslides.md

# Also build PDF
bash build.sh myslides.md --pdf

# Convert all PDFs in a figures directory to PNG first, then build
bash build.sh myslides.md --figures /path/to/pdf_figures

# Live preview in browser (auto-reloads on save)
marp --preview myslides.md
```

Or call Marp directly:

```bash
marp myslides.md --html -o myslides.html
marp myslides.md --pdf  -o myslides.pdf
marp myslides.md --pptx -o myslides.pptx
```

---

## 2. YAML Frontmatter (global settings)

Every Marp file starts with a YAML block between `---` markers:

```yaml
---
marp: true
theme: default
paginate: true
backgroundColor: #f7f8fc
style: |
  /* all your CSS goes here */
---
```

| Key | Purpose |
|-----|---------|
| `marp: true` | Activates Marp processing |
| `theme: default` | Base theme (also: gaia, uncover) |
| `paginate: true` | Adds slide numbers bottom-right |
| `backgroundColor` | Default background for all slides |
| `style` | Inline CSS that overrides the theme globally |

---

## 3. Slide Separator

Each slide is separated by a `---` on its own line:

```markdown
## Slide One

Content here.

---

## Slide Two

Content here.
```

---

## 4. Colour Scheme

The deck uses two accent colours consistently:

| Name | Hex | Used for |
|------|-----|---------|
| Deep navy | `#1a3a6b` | Headings, `.box` borders, `.app` panels |
| VIB orange | `#e85d26` | H3, `.box-o` borders, `h2` underline |
| Title background | `#0b2f6b` | Dark title slides |
| Slide background | `#f7f8fc` | All regular slides |

To adapt for a different project, do a global find-and-replace on these two hex
values.

---

## 5. Typography

```css
section {
  font-family: 'Helvetica Neue', Arial, sans-serif;
  font-size: 17px;
  padding: 22px 46px;
  color: #1e1e2e;
}
h1 { color: #1a3a6b; font-size: 1.85em; }
h2 { color: #1a3a6b; font-size: 1.35em;
     border-bottom: 3px solid #e85d26; padding-bottom: 4px; }
h3 { color: #e85d26; font-size: 1.0em; }
```

- `h2` gets an orange underline bar — gives every slide a visual anchor.
- `h3` is orange — used as sub-section labels inside boxes.
- Base font size 17px keeps content readable at 1280×960.

---

## 6. Box Classes

Four coloured callout boxes, used inside `<div>` tags:

| Class | Background | Left border | Use for |
|-------|-----------|-------------|---------|
| `.box` | `#eef4fb` (light blue) | `#1a3a6b` (navy) | App/tech context |
| `.box-o` | `#fff3ec` (light orange) | `#e85d26` (orange) | Pain points, contrasts |
| `.box-g` | `#edfaed` (light green) | `#2a8a2a` (green) | Positive outcomes |
| `.box-y` | `#fffbe6` (light yellow) | `#c8960c` (gold) | Cautions, notes |

Two additional context-specific variants:

| Class | Use for |
|-------|---------|
| `.lab` | "Lab step" panels (orange border, warm background) |
| `.app` | "App page" panels (navy border, cool background) |

Usage:

```html
<div class="box">

### Title inside box
Content here — supports full Markdown including bullet lists.

</div>
```

**Important:** always leave a blank line after the opening `<div>` and before the
closing `</div>` — Marp needs this to parse Markdown inside HTML blocks.

---

## 7. Layout Classes

### Two-column layout: `.cols`

```html
<div class="cols">
<div class="box">

Left column content.

</div>
<div class="box-o">

Right column content.

</div>
</div>
```

CSS: `display: grid; grid-template-columns: 1fr 1fr; gap: 2rem`

### Three-column layout: `.cols3`

```html
<div class="cols3">
<div class="box">Column 1</div>
<div class="box-o">Column 2</div>
<div class="box-g">Column 3</div>
</div>
```

CSS: `display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1.2rem`

### Mixing columns with raw divs (no box)

```html
<div class="cols">
<div>

Left — plain text or image, no box styling.

</div>
<div class="box">

Right — inside a box.

</div>
</div>
```

---

## 8. Monospace Chain / Diagram Class

For ASCII-art entity diagrams or code-like sequences:

```html
<div class="chain">

PROJECT  ──► SAMPLESHEET  ──► SAMPLE
                │
                └── QC_EVENTS  ──► QC_DOCUMENTS

</div>
```

CSS: monospace font, light grey background, 1.7 line-height. Use `──`, `►`, `│`,
`├──`, `└──` characters for structure — these render correctly in all browsers.

---

## 9. Utility Classes

| Class | Effect |
|-------|--------|
| `.center` | `text-align: center` |
| `.small` | `font-size: 0.82em` |
| `.tag` | Navy pill badge (inline) — e.g. `<span class="tag">v1.0</span>` |

---

## 10. Images

```markdown
![Alt text](pictures/screenshot.png)
```

Global image CSS:

```css
img {
  max-width: 100%;
  max-height: 430px;
  object-fit: contain;
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.12);
}
```

- Keep screenshots in a `pictures/` subfolder next to the `.md` file.
- `max-height: 430px` prevents images from overwhelming the slide.
- Images inside `.cols` naturally fill half the slide width.

---

## 11. Title Slides (dark background)

Title slides use a special CSS class applied per-slide with a Marp directive:

```markdown
<!-- _class: title -->
<!-- _backgroundColor: #0b2f6b -->
<!-- _color: #ffffff -->

<img class="title-logo" src="pictures/your_logo_white.png" alt="Logo">

# Your Title
## Subtitle in gold

<br>

**Tagline or description**

Author · Organisation · Year
```

The `section.title` CSS block in the frontmatter overrides all colours for slides
with this class — headings turn white, h2 turns gold (`#ffd28a`), boxes get a
translucent white background with dark text.

The `.title-logo` class positions the logo absolutely at top-left:

```css
section.title .title-logo {
  position: absolute;
  top: 26px;
  left: 34px;
  width: 155px;
}
```

Replace `vib_logo_white.png` with a white/transparent version of your institution's
logo. Use a closing title slide with the same class for consistency.

---

## 12. Per-Slide Directives

Marp HTML comments apply settings to a single slide only (prefix with `_`):

```markdown
<!-- _class: title -->          ← apply CSS class to this slide only
<!-- _backgroundColor: #fff -->  ← override background for this slide
<!-- _color: #000 -->            ← override text colour for this slide
<!-- _paginate: false -->         ← hide page number on this slide
```

Without the `_` prefix, the directive applies to all following slides.

---

## 13. Slide Structure Pattern Used in This Deck

Every content slide follows the same pattern:

```markdown
## Slide Title

<div class="cols">
<div class="lab">           ← or .box / .app / plain <div>

### Lab Step / Context
Narrative text explaining what happens in the lab or why.

- Bullet point
- Bullet point

</div>
<div>

![Screenshot](pictures/screenshot.png)

</div>
</div>
```

- Left column: context, steps, field names — what the user needs to understand
- Right column: screenshot or diagram — what it looks like

For conceptual slides with no screenshot, use `.cols3` with three `.box` variants
to present three parallel ideas side by side.

---

## 14. Tables

Standard Markdown tables render cleanly inside slides and inside `.box` divs:

```markdown
| Column A | Column B | Column C |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
```

---

## 15. Replication Checklist for a New Project

- [ ] Copy `PRESENTATION.md` to the new project's `docs/` folder
- [ ] Create a `docs/pictures/` subfolder for screenshots
- [ ] Replace the logo image reference (`vib_logo_white.png`) with your logo
- [ ] Update author, organisation, and year on title/closing slides
- [ ] Replace the two accent hex values if a different colour scheme is needed:
  - Navy `#1a3a6b` → your primary colour
  - Orange `#e85d26` → your accent colour
  - Title background `#0b2f6b` → your dark primary
- [ ] Replace slide content — keep the structure (`.cols`, `.box`, headings) intact
- [ ] Run `marp --preview docs/PRESENTATION.md` while editing for live feedback
- [ ] Export: `marp docs/PRESENTATION.md --pptx -o docs/PRESENTATION.pptx`
