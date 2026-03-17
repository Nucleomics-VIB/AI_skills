# R Markdown Report — Writing Guide

This guide defines content requirements, section rules, code chunk conventions, and
quality standards for R Markdown reports produced with this skill. Read it before writing
or generating any content. The companion `report.Rmd` illustrates the skeleton structure
(setup → analysis → conclusion); this file explains the rules that govern its content.

---

## Audience and tone

**Audience**: the analyst and their PI or collaborators — technically proficient readers
who will verify methods, reproduce results, and act on findings. Not a public-facing
document.

**Tone**: precise, concise, and neutral. Report what the data show; do not editorialize.

**Rules**:
- Avoid hedging: write "the clustering separates the two groups" not "it seems the
  clustering may separate the groups".
- State biological interpretation separately from statistical results — one sentence each.
- Do not write "we" — use passive voice or "the analysis".
- Do not use exclamation marks or marketing language.

---

## Document structure

Mandatory sections, in order:

1. **Aim** — one paragraph, ≤80 words.
2. **Data and Methods** *(optional)* — include if the methods are non-standard or need to
   be recorded for reproducibility. Omit if methods are covered by a companion pipeline
   document.
3. **Results** — one subsection per analysis step.
4. **Conclusion** — one paragraph, ≤150 words.
5. **References** *(optional)* — BibTeX bibliography if tools or methods are cited.

Do not add sections outside this list without an explicit reason documented in the report.

---

## Section requirements

### Aim (≤80 words)

One paragraph. Must state:
- The biological or analytical question being answered.
- The input data: sample names or count, data type (RNA-seq, WES, etc.), reference organism.
- The expected output (a list of DEGs, a variant callset, a clustering, etc.).

Do not describe the methods here. Do not include result numbers.

---

### Data and Methods *(optional)*

Include only for non-standard steps. When present:
- One paragraph or a numbered list per major step.
- State tool name (version), key parameters, and why non-default settings were used.
- Do not describe standard best-practice steps that are self-evident from the code.

---

### Results

**Organisation**: by analysis step, not by tool. A sub-section titled "Differential
expression" is correct; "DESeq2 output" is not.

**Pattern for each sub-section**:
1. **Context sentence** — one sentence explaining what this analysis step does and why.
2. **Key result** — a number, a figure reference, or a table reference. The most important
   finding first.
3. **Interpretation sentence** — what the result means biologically or analytically.

**Never present a figure without interpreting it in the text.** A figure that appears
without a following interpretation sentence is incomplete.

---

### Conclusion (≤150 words)

One paragraph. Must contain, in order:
1. Restatement of the aim (one sentence — do not copy verbatim from the Aim section).
2. Summary of findings (2–3 sentences, with numbers).
3. One limitation or caveat (e.g. sample size, missing controls, technical confound).
4. One sentence on next steps or recommended follow-up.

Do not introduce new results here.

---

## Code chunk conventions

Every code chunk that produces visible output must be **surrounded by narrative text**:

- **Before the chunk**: one sentence explaining what the code does ("The following chunk
  filters low-count genes and runs DESeq2 normalisation.").
- **After the chunk**: one sentence interpreting the output ("The MA plot shows no
  systematic bias across the count range.").

Code chunks must never speak for themselves. A reader who skips all code blocks must still
be able to follow the report narrative from the prose alone.

**Chunk options** (set in the setup chunk or per-chunk):

| Option | Rule |
|--------|------|
| `echo` | `TRUE` for methods-critical code; `FALSE` for boilerplate (library loading, plot theming) |
| `eval` | Never set `eval=FALSE` in a final report — remove the chunk instead |
| `cache` | Use for long-running steps; always invalidate cache when inputs change |
| `message` / `warning` | Set `FALSE` globally; surface warnings explicitly as text if relevant |
| `fig.cap` | Required on every chunk that produces a figure |

---

## Figure conventions

Every figure produced by a code chunk must have a `fig.cap` argument. Caption format:

```
fig.cap = "Declarative statement of what the figure shows. One interpretive sentence."
```

Example:
```
fig.cap = "Volcano plot of differential expression results (treated vs. control, n=6 per group).
           Red points (log2FC > 1, adjusted p < 0.05) are candidate upregulated genes."
```

**Do not** use captions like "Figure 1" or "DESeq2 output" — state the finding.

---

## Table conventions

Use `knitr::kable()` with a caption argument for all tables:

```r
knitr::kable(df, caption = "Summary statistics for filtered gene set (n=312 genes).")
```

Tables that list more than 20 rows should be rendered with `DT::datatable()` for
interactive filtering — note this in a sentence before the chunk.

---

## Statistical reporting

When reporting a statistical test result, always include all of the following:
- Test name
- Test statistic and value
- Degrees of freedom (if applicable)
- p-value (exact, not just "< 0.05"; use "p < 0.001" only when p < 0.001)
- Effect size metric and value

**Example**: "Groups differed significantly in expression level (Wilcoxon rank-sum test:
W = 142, p = 0.012, r = 0.41)."

Never report a p-value alone without an effect size.

---

## What does NOT belong in the report

- Exploratory dead-ends or failed analyses (keep a separate lab notebook for those).
- Commented-out code blocks (`# old approach`).
- Raw tool output pasted as plain text (use structured tables or figures instead).
- Notes-to-self or `TODO` comments (resolve before sharing).
- Duplicate figures showing the same data at different thresholds without justification.

---

## Common mistakes to avoid

- Presenting a figure and then immediately presenting another figure without any
  intervening interpretive sentence.
- Reporting p-values without effect sizes.
- Using `eval=FALSE` in a final report (remove the chunk entirely).
- Writing a Conclusion that introduces numbers not shown in the Results.
- Leaving the Aim section vague ("analysing the data") without specifying the question.
- Omitting `fig.cap` on figures (caption is required, not optional).
