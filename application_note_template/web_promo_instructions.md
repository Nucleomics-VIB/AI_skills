# How to Create a Project Promotional Web Page (web_promo.html)

This document explains how to produce a `web_promo.html` one-page promotional page for a new VIB Nucleomics Core application note. The page is designed to be copy-pasted into the VIB website and requires no external CSS framework.

---

## Purpose

The page advertises a new application note to a broad audience. It should be **attractive but not detailed** — enough to create incentive to read the full document. It ends with a clear invitation to contact the team for further discussion.

---

## File location

Place `web_promo.html` inside the project's `application_note/` folder, alongside the figures and the markdown/PDF of the note:

```
application_note/
├── your_note.md
├── your_note.pdf
├── web_promo.html          ← this file
├── web_promo_instructions.md
├── figures/
│   ├── figure1.png
│   └── figure2.png
└── ...
```

---

## Layout overview

The page uses simple, single-column HTML with no external dependencies and no JavaScript. The structure from top to bottom is:

1. **Header** — dark coloured banner with project title and subtitle
2. **Figure pair** — two figures displayed side by side
3. **Three content sections** (fixed titles, see below)
4. **Contact block** — dark footer banner
5. **Footer** — copyright line

---

## Fixed section titles

All promotional pages must use these three section headings verbatim (only the hook phrase before the dash in the first title should be adapted to the project):

| Section | Title pattern |
|---------|---------------|
| 1 | `Beyond [X] — [Project-specific claim]` |
| 2 | `How It Works` |
| 3 | `What This Means for Your Research` |

**Examples from existing pages:**

- Kinnex 16S: *Beyond Genus — Species-Level Microbiome Profiling*
- Aviti WES: *Beyond Gene Lists — Clinical-Grade Variant Discovery*

The contact block always reads: **Interested? Let's Talk**

---

## Figure pair

Choose **two figures** from the `figures/` folder that best represent the project visually. Favour colourful, self-explanatory plots over technical diagrams. Both images are displayed side by side at 27% page width each.

Reference them in the HTML as relative paths:

```html
<div class="figure-pair">
  <figure>
    <img src="figures/your_first_figure.png" alt="Short description" />
    <figcaption>One-sentence plain-language caption.</figcaption>
  </figure>
  <figure>
    <img src="figures/your_second_figure.png" alt="Short description" />
    <figcaption>One-sentence plain-language caption.</figcaption>
  </figure>
</div>
```

> The figures will only render when the HTML is opened in a real browser or served from a web server. VSCode's built-in HTML preview blocks local image loading.

---

## Colour scheme

Each project should use a distinct header/accent colour to visually differentiate the pages. Define it as a single CSS variable at the top of the `<style>` block and apply it to `header`, `h2 borders`, `highlight-box border`, and the `contact` block.

| Project | Header colour |
|---------|--------------|
| Kinnex 16S | `#1a3a5c` (dark blue) |
| Aviti WES | `#1e3a1e` (dark green) |
| Next project | choose a new distinct dark colour |

---

## Content guidelines per section

### Section 1 — Beyond [X] — [Claim]

- State the core limitation of existing approaches in one sentence.
- Explain how the new method overcomes it.
- Keep it to 2–3 short paragraphs maximum.
- No data tables, no methods detail.

### Key results box

Include a `highlight-box` `<div>` with 4–6 bullet points of key quantitative results. These are the most eye-catching elements and should use `<strong>` for the numbers.

```html
<div class="highlight-box">
  <strong>Key results at a glance:</strong>
  <ul>
    <li>Metric 1: <strong>value</strong></li>
    <li>Metric 2: <strong>value</strong></li>
    ...
  </ul>
</div>
```

### Section 2 — How It Works

- Describe the wet-lab workflow in 1–2 short paragraphs (no protocol-level detail).
- Mention the key instruments, kits, and bioinformatics tools by name.
- If the method scales to many samples or supports multiplexing, state that here.

### Section 3 — What This Means for Your Research

- Translate the technical results into research benefits.
- List advanced downstream analyses if available (bullet list is fine).
- Mention supported species, study designs, or cohort sizes if relevant.
- End with a pointer to the full application note or consultation offer.

---

## Contact block

Always use the standard VIB Nucleomics Core contact information:

```html
<div class="contact">
  <h2>Interested? Let&rsquo;s Talk</h2>
  <p>
    We welcome enquiries about project design, pricing, turnaround times,<br>
    or custom analysis requirements for your specific research questions.
  </p>
  <p>
    Contact the <strong>VIB Nucleomics Core</strong> team:<br>
    <a href="mailto:nucleomics@vib.be">nucleomics@vib.be</a>
    &nbsp;&bull;&nbsp;
    <a href="https://www.nucleomics.be" target="_blank">www.nucleomics.be</a>
  </p>
</div>
```

---

## Full HTML template

Copy the block below and fill in the placeholders marked with `[...]`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>[Project title] — VIB Nucleomics Core</title>
  <style>
    body { margin:0; font-family:Georgia,"Times New Roman",serif; background:#f9f9f7; color:#222; }
    header { background:[COLOUR]; color:#fff; padding:48px 40px 36px; text-align:center; }
    header p.eyebrow { font-family:Arial,Helvetica,sans-serif; font-size:0.85em;
      letter-spacing:0.12em; text-transform:uppercase; color:#ccc; margin:0 0 10px; }
    header h1 { font-size:2.2em; margin:0 0 12px; line-height:1.25; }
    header p.subtitle { font-size:1.1em; color:#ddd; margin:0; }
    .figure-pair { display:flex; justify-content:center; gap:24px; padding:24px 40px; background:#eee; }
    .figure-pair figure { margin:0; flex:0 1 27%; text-align:center; }
    .figure-pair img { width:100%; height:auto; }
    .figure-pair figcaption { font-family:Arial,Helvetica,sans-serif; font-size:0.78em; color:#555; margin-top:6px; }
    main { max-width:820px; margin:40px auto; padding:0 30px; }
    h2 { font-size:1.4em; color:[COLOUR]; border-bottom:2px solid [COLOUR]; padding-bottom:6px; margin-top:40px; }
    p { line-height:1.75; margin:0.8em 0; }
    ul { line-height:1.75; padding-left:1.5em; }
    ul li { margin-bottom:0.4em; }
    .highlight-box { background:[COLOUR-LIGHT]; border-left:5px solid [COLOUR];
      padding:18px 24px; margin:30px 0; font-size:1.05em; }
    .highlight-box strong { color:[COLOUR]; }
    .contact { background:[COLOUR]; color:#fff; padding:36px 40px; margin-top:50px; text-align:center; }
    .contact h2 { color:#ccc; border-bottom:1px solid #ccc; display:inline-block; padding-bottom:4px; margin-top:0; }
    .contact p { color:#ddd; margin:10px 0 4px; }
    .contact a { color:#7ec8a0; text-decoration:none; }
    .contact a:hover { text-decoration:underline; }
    footer { font-family:Arial,Helvetica,sans-serif; font-size:0.78em; color:#999; text-align:center; padding:20px; }
  </style>
</head>
<body>

<header>
  <p class="eyebrow">VIB Nucleomics Core &mdash; Application Note &mdash; [Month Year]</p>
  <h1>[Full project title]</h1>
  <p class="subtitle">[Keyword 1] &middot; [Keyword 2] &middot; [Keyword 3]</p>
</header>

<div class="figure-pair">
  <figure>
    <img src="figures/[figure1].png" alt="[Alt text]" />
    <figcaption>[Caption 1]</figcaption>
  </figure>
  <figure>
    <img src="figures/[figure2].png" alt="[Alt text]" />
    <figcaption>[Caption 2]</figcaption>
  </figure>
</div>

<main>

  <h2>Beyond [X] — [Project-specific claim]</h2>
  <p>[2–3 paragraphs: limitation of existing approaches, how this method overcomes it.]</p>

  <div class="highlight-box">
    <strong>Key results at a glance:</strong>
    <ul>
      <li>[Metric]: <strong>[value]</strong></li>
      <li>[Metric]: <strong>[value]</strong></li>
      <li>[Metric]: <strong>[value]</strong></li>
      <li>[Metric]: <strong>[value]</strong></li>
    </ul>
  </div>

  <h2>How It Works</h2>
  <p>[1–2 paragraphs: instruments, kits, pipeline, scalability.]</p>

  <h2>What This Means for Your Research</h2>
  <p>[1–2 paragraphs: research benefits, supported designs, pointer to full note.]</p>

</main>

<div class="contact">
  <h2>Interested? Let&rsquo;s Talk</h2>
  <p>
    We welcome enquiries about project design, pricing, turnaround times,<br>
    or custom analysis requirements for your specific research questions.
  </p>
  <p>
    Contact the <strong>VIB Nucleomics Core</strong> team:<br>
    <a href="mailto:nucleomics@vib.be">nucleomics@vib.be</a>
    &nbsp;&bull;&nbsp;
    <a href="https://www.nucleomics.be" target="_blank">www.nucleomics.be</a>
  </p>
</div>

<footer>
  &copy; [Year] VIB Nucleomics Core &mdash; Application Note: [Project title]
</footer>

</body>
</html>
```

---

*Template version: 1.0 — March 2026*
