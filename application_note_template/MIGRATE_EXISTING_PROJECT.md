# Migrating an Existing Project Application Note to the Skill

This guide documents how to clean up a project `application_note/` folder that
was originally built with local copies of the skill files, and migrate it to
delegate entirely to the centralised `application_note_template` skill in
SP_AI_skills.

First applied to `NC_Aviti_Trinity_ExomeSeq` (March 2026).

---

## Background: the "before" state

When the application note was first created, the skill did not yet exist as a
centralised repository. The project therefore contained local copies of:

```
application_note/
├── convert_to_pdf.sh          ← full build logic, hardcoded filenames
├── header.tex                 ← LaTeX snippet
├── markdown2pdf.yaml          ← conda environment definition
├── PDF_CONVERSION_GUIDE.md    ← generic PDF conversion guide
├── web_promo_instructions.md  ← generic web promo guide
├── README.md                  ← verbose with duplicated setup instructions
│
├── application_note.md        ← project content (keep)
├── application_note_technical.md ← project content (keep)
├── create_figure4.R           ← project R script (keep)
├── figures/                   ← project figures (keep)
└── web_promo.html             ← project promo page (keep)
```

---

## What was improved in the skill

The project's `convert_to_pdf.sh` had hardcoded filenames and no argument
handling. The skill's version was updated to be fully generic — it accepts one
or more `<input.md>` filenames as arguments and derives the output name from
the stem:

```bash
bash /opt/biotools/SP_AI_skills/application_note_template/convert_to_pdf.sh \
  application_note/application_note.md \
  application_note/application_note_technical.md
```

The skill's `README.md` already described this interface but the script itself
did not implement it — both were brought into sync.

---

## Migration steps

### 1. Contribute any local improvements back to the skill

Compare the project's `convert_to_pdf.sh` with the skill's. Update the skill
if the project has improvements (e.g. a different fontsize, extra pandoc flags,
or a better argument-handling pattern), then push the skill repo.

### 2. Update the project's convert_to_pdf.sh to reference skill files

The project keeps a `convert_to_pdf.sh` because it has project-specific
output naming logic (e.g. `Aviti-WES_application_note.pdf`). Change its
`--include-in-header` to point to the skill's `header.tex` rather than a
local copy:

```bash
SKILL_DIR="/opt/biotools/SP_AI_skills/application_note_template"

PANDOC_OPTS=(
  ...
  --include-in-header="${SKILL_DIR}/header.tex"
  ...
)
```

Then remove the local `header.tex`.

### 3. Remove generic files from the project

```bash
git rm application_note/PDF_CONVERSION_GUIDE.md
git rm application_note/web_promo_instructions.md
git rm application_note/markdown2pdf.yaml
git rm application_note/header.tex
```

These are all provided by the skill. Direct users to the skill's copies via
`SKILL_DEPENDENCY.md`.

### 4. Rewrite README.md

Replace the verbose README (which duplicated setup instructions and pandoc
commands) with a concise inventory of project-specific files plus a pointer
to `SKILL_DEPENDENCY.md`.

### 5. Add SKILL_DEPENDENCY.md

Create `application_note/SKILL_DEPENDENCY.md` documenting:
- Skill location
- One-time environment setup
- How to build PDFs (both via the project wrapper and the generic skill script)
- Where to find the web promo instructions

Use `SKILL_DEPENDENCY_template.md` from this skill folder as a starting point.

### 6. Commit and push

```bash
# Project repo
git add application_note/convert_to_pdf.sh application_note/README.md \
        application_note/SKILL_DEPENDENCY.md
git commit -m "Harmonize application_note with SP_AI_skills skill repo"
git push
```

---

## After: the "clean" project state

```
application_note/
├── application_note.md            ← project content
├── application_note_technical.md  ← project content (if applicable)
├── convert_to_pdf.sh              ← project wrapper (output naming, calls skill pipeline)
├── create_figure4.R               ← project analysis script (if applicable)
├── figures/                       ← project figures
├── web_promo.html                 ← project promo page
├── SKILL_DEPENDENCY.md            ← setup doc (from template)
├── README.md                      ← concise project inventory
└── (PDF outputs)
    ├── Aviti-WES_application_note.pdf
    └── Aviti-WES_application_note_technical.pdf
```

No generic skill files remain in the project. All build infrastructure
(`header.tex`, `markdown2pdf.yaml`, PDF guide, web promo instructions) lives
exclusively in the skill repo.

---

## Decision guide: what stays in the project vs. the skill

| File | Keep in project? | Reason |
|------|-----------------|--------|
| `application_note.md` | Yes — project content | Specific data and results |
| `application_note_technical.md` | Yes — project content | Specific data and results |
| `convert_to_pdf.sh` | Yes — project-specific wrapper | Custom output filenames |
| `create_figure4.R` | Yes — project analysis code | Data-specific R script |
| `figures/` | Yes — project outputs | Generated from project data |
| `web_promo.html` | Yes — project output | Customised for this note |
| `header.tex` | No → reference from skill | Generic LaTeX snippet |
| `markdown2pdf.yaml` | No → use skill's copy | Generic conda env |
| `PDF_CONVERSION_GUIDE.md` | No → use skill's copy | Generic guide |
| `web_promo_instructions.md` | No → use skill's copy | Generic instructions |
