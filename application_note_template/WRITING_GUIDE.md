# Application Note — Writing Guide

This guide defines the content requirements, section rules, formatting conventions, and
quality standards for application notes produced with this skill. Read it before writing
or generating any content. The companion `application_note.md` illustrates the structure
visually; this file explains the rules behind it.

---

## Audience and tone

**Primary audience**: researchers and clients who are not bioinformaticians — wet-lab
scientists, PIs, facility managers, and procurement decision-makers.

**Secondary audience**: bioinformaticians reviewing the technical appendix or methods.

**Tone**: professional, evidence-based, and accessible. Write in the third person or
passive voice for methods; use first-person plural ("we") only in the Discussion and
service-offering sections.

**Rules**:
- Every acronym must be expanded on first use. Example: "whole exome sequencing (WES)".
- Define technical terms on first use or defer to the Glossary. Do not assume domain
  knowledge.
- Avoid hedging language: write "coverage is 50×" not "coverage appears to be around 50×".
- Use SI units consistently. Write "37 Mb", "50.5×", "28,856 variants" — not "37 megabases"
  or "50.5-fold" or "28856 variants".

---

## Section requirements

### Abstract (≤200 words)

Must contain, in order:
1. One sentence of field context (why this technology matters).
2. One sentence describing the dataset or experiment (platform, capture panel, sample count).
3. Three key numbers: mean coverage, capture efficiency (% genes covered), variant count.
4. One sentence on advanced capabilities ("Beyond standard variant calling, WES data enables…").
5. One sentence offering the Core's service.

**Do not**:
- Use citations.
- Repeat section headers or pipeline tool names.
- Open with "In this study we show…" or "Here we present…".

---

### Introduction (~300 words, three subsections)

**§1.1 — Field context**: Explain what the technology does and why it matters. Include a
bullet list of 4–5 application areas (rare disease, cancer, population genetics, etc.).
Close with one sentence about quality requirements. Do **not** quote the abstract numbers.

**§1.2 — Technical challenges**: A focused paragraph listing 3–4 specific challenges
(coverage uniformity, capture efficiency, base quality, pipeline robustness). Each
challenge should be self-contained in 1–2 sentences.

**§1.3 — Core service offering**: A bullet list of 4–5 service components (sequencing
platform, capture panel, bioinformatics tools, QC reporting, consultation). Close with one
sentence naming the public dataset used in this note.

---

### Materials and Methods

**§2.1 — Sample preparation and sequencing**: Describe the capture panel and sequencing
platform. Include a sub-section for the public dataset (DOI/URL, sample count, data
access). Include a run-level QC table (Table 1) and a per-sample depth table (Table 3).

**§2.2 — Bioinformatics pipeline**: A numbered list of pipeline steps. Each step must:
- Bold the tool name on first mention.
- State the input, transformation, and output in ≤2 sentences.
- Preserve the order in which steps actually run.

**§2.3 — Quality control metrics**: A bulleted list of QC thresholds for read quality,
alignment, coverage, variant quality, and capture efficiency. One threshold per bullet.
Close with a sentence on what happens to samples that fail.

---

### Results

Each Results sub-section must follow this pattern:
1. **Opening sentence** — state the key finding as a number or comparison.
2. **Supporting data** — a bullet list or table of metrics; at least one figure reference.
3. **Biological Interpretation paragraph** — explain what the numbers mean for real-world
   use. This paragraph must not introduce new data.

**Figure placement**: figures go immediately after the paragraph that first references them.

**Figure caption format**:
```
![](figures/filename.png){width=60%}

**Figure N: Declarative title** — One sentence explaining what the reader should notice.
```

**Table format**: table number and italic caption appear *above* the table.
```
*Table N: Caption describing the table contents.*

| Col1 | Col2 |
```

---

### Advanced Applications (§4)

This section describes downstream analyses the pipeline *can* support, not analyses
demonstrated with the current dataset.

- 2–4 sentences per subsection.
- List tools without explaining each in depth.
- Do **not** create Glossary entries for terms that appear only here.
- Use "can be detected", "is detectable", "supports" — not "we detected".

---

### Discussion and Summary (~400 words, five subsections)

Subsection headings must mirror the Results section headings. No new data or figures.
The five subsections are: Data Quality, Bioinformatics Pipeline, Flexible Experimental
Designs, Biological Insights, Service Offering.

Close §5.5 with contact details (email and URL).

---

### Key Metrics Summary (§6)

A `<div>` box with blue border (colour: `#4472C4`). Three groups of bullets:
1. **Platform & Capture** — platform name, sample count, capture panel and target size.
2. **Coverage Excellence** — mean coverage, % below 20×, gene capture %, target dropout %.
3. **Variant Discovery** — on-target variant count, HIGH-impact variant count, quality
   pass rate.

All numbers must match the Results section exactly. End with a bullet list of advanced
analyses available (drawn from §4).

---

### Appendix — Glossary of Technical Terms

**Placement**: immediately before Acknowledgements.

**Order**: alphabetical by term.

**Format**:
```
**Term**
Definition in 1–3 sentences. Self-contained — do not cross-reference other entries.
```

**Inclusion rule**: define a term only if it is used in §1 Introduction, §2 Methods,
§3 Results, or §5 Discussion. Terms appearing exclusively in:
- §4 Advanced Applications and Future Directions
- Parenthetical side remarks not central to the analysis
- Service-offering bullet lists (§5.5)

must **not** be included in the Glossary.

---

### Acknowledgements

One short paragraph. Standard VIB Nucleomics Core boilerplate: acknowledge the funding
context, the public dataset provider, and any computational infrastructure used.

---

## Formatting conventions

| Element | Rule |
|---------|------|
| Tables | Number as Table N; italic caption *above* the table |
| Figures | Number as Figure N; bold+dash caption *below* the figure |
| Tool names | Bold on first mention; plain text thereafter |
| Acronyms | Expand on first use; use acronym only thereafter |
| Numbers | Use digit form (28,856 not "twenty-eight thousand…") |
| Percentages | One decimal place (98.77%, not 98.8% or 98.77234%) |
| Coverage depth | Use × symbol (50.5×, not "50.5-fold" or "50.5x") |
| File sizes | SI prefix (37 Mb, not 37MB or 37 megabases) |

---

## Common mistakes to avoid

- Defining glossary terms for future-directions content.
- Repeating abstract numbers in the Introduction.
- Presenting a figure without referencing it in the text first.
- Introducing new results in the Discussion.
- Leaving "Advanced Applications" tools undefined if they are also used in the Methods.
- Using a "Thank you" or "Questions?" slide at the end (applies to slidedeck, not here).
- Writing "0%" as a result without noting it is a good outcome (state "no X detected").
