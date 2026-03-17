# Slide Deck — Writing Guide

This guide covers the **prose and narrative layer** of a Marp slide deck: how to write
slide text, structure the narrative arc, and decide what belongs on a slide vs. in a
companion document. For CSS, layout classes, typography, and Marp syntax, see
`marp_template/MARP_SLIDE_GUIDE.md`.

The example file `marp_template/PRESENTATION.md` shows a LIMS-related deck. Its
**structure** (section flow, slide types, headline style) is the model to follow. Its
**content** (LIMS-specific text and data) is not reusable.

---

## Audience and tone

**Default audience**: external — clients, conference attendees, or management. Assume
semi-technical familiarity (knows what sequencing is; does not know pipeline internals).

**Tone**: confident, concrete, and visual. A slide deck is a complement to a spoken
presentation — it should reinforce what the speaker says, not replace it.

**Rules**:
- No unexplained jargon. If a tool name (e.g. "DeepVariant") appears on a slide, it must
  be followed by a one-line description on the same slide.
- Avoid passive voice in headlines. "98.77% of genes fully covered" not "Gene coverage was
  achieved at 98.77%".
- Never use abbreviations on a slide that have not been introduced earlier in the deck.

---

## Narrative arc

Every deck must follow this five-part structure. Each part maps to one or more slides:

| Part | Content |
|------|---------|
| **Problem** | What challenge does this technology or service address? |
| **Approach** | What is the solution (platform, pipeline, service)? |
| **Evidence** | Data: coverage, efficiency, variant counts, figures. |
| **Outcome** | What can the client/researcher do with these results? |
| **Call to action** | Contact, next steps, service offering. |

Each major part should begin with a **section-divider slide**: dark background, title only,
no bullets. Use the `<!-- _class: lead -->` directive.

---

## Headline style

Use **declarative statements** as slide headlines, not topic labels.

| Wrong (topic label) | Correct (declarative) |
|---------------------|-----------------------|
| Coverage | Mean coverage: 50.5× across all samples |
| Capture efficiency | 98.77% of genes fully captured |
| Pipeline | Five-step pipeline from FASTQ to annotated variants |

**Exception**: title slide and section-divider slides may use a topic label or question.

---

## Slide content density

- **Maximum 5–6 bullet points per slide**. If you have more, split into two slides.
- **One idea per slide**. Do not combine a coverage discussion with a variant discussion
  on the same slide.
- **Never put dense bullets AND a large figure on the same slide**. Choose one:
  - A figure with 1–3 short annotation bullets, or
  - A bullet list with no figure.
- **Bullet length**: max one line at the presentation font size. If it wraps, shorten it.

---

## Slide types and their rules

### Title slide
Must include: technology/service name, VIB Nucleomics Core logo, presenter name (optional),
and date. No bullet points.

### Section-divider slide
Dark background. Title only (one line). Optional subtitle (one line). No bullets, no figures.

### Data slide
- Headline states the takeaway from the data.
- Figure or table occupies 50–70% of the slide area.
- Label all axes and units in figures.
- Caption below figure: one declarative sentence (matches headline or adds one detail).
- Max 3 annotation bullets beside or below the figure.

### Summary / Key Metrics slide
- One `<div>` box or structured bullet list.
- Three groups: Platform & Capture, Coverage, Variant Discovery.
- All numbers must match the companion application note exactly.

### Contact / Call to Action slide (final slide)
- Must always end the deck.
- Include: email address, website URL, offer of consultation.
- Never end on a "Thank you" or "Questions?" slide alone — merge those with the contact
  information.

---

## What belongs on a slide vs. in the companion document

| Belongs on the slide | Belongs in the application note |
|---------------------|---------------------------------|
| Key metric numbers | Full tables with all samples |
| Declarative takeaway | Detailed statistical analysis |
| Tool names (bolded) | Tool version numbers and parameters |
| High-level pipeline diagram | Step-by-step Methods section |
| Figure with brief caption | Full figure legend |
| One-line service description | Detailed service catalogue |

Raw shell commands, VCF file formats, and extended prose paragraphs always belong in the
application note, not on a slide.

---

## Figure and visual guidelines

- Use PNG figures at ≥150 dpi. Avoid JPEG for charts (compression artefacts).
- Figures must be sized so they are legible at the back of a meeting room: font size in
  figures ≥18pt equivalent.
- Prefer horizontal layouts over vertical for bar charts (more readable at presentation
  distances).
- Colour: use the VIB palette defined in MARP_SLIDE_GUIDE.md. Do not introduce arbitrary
  colours.
- Every figure must have a short caption on the slide (1 sentence). If the figure was
  generated by a script, the caption should state the key finding, not "Figure generated
  by create_figure.R".

---

## Common mistakes to avoid

- Putting full sentences in bullets (should be fragments or short declarative phrases).
- Using the same slide as both a data slide and a section divider.
- Defining a term mid-deck that was used (unexplained) on an earlier slide.
- Including more than 6 slides of pure text with no visuals.
- Ending the deck without contact information.
- Mixing font sizes within a single slide (other than headline vs. body — already set by CSS).
- Leaving placeholder text from the template (e.g. `[YOUR DATA HERE]`).
