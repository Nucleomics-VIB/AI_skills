# Application Note Build — Skill Dependency

This application note is built using the **`application_note_template`** skill
from the SP_AI_skills repository.

## Skill location

```
/opt/biotools/SP_AI_skills/application_note_template/
```

The skill provides:
- `convert_to_pdf.sh` — generic pandoc/tectonic PDF builder (takes input filenames as args)
- `header.tex` — LaTeX header (microtype, hbadness suppression)
- `markdown2pdf.yaml` — conda environment definition (pandoc + tectonic)
- `PDF_CONVERSION_GUIDE.md` — full conversion guide with troubleshooting
- `web_promo_instructions.md` — instructions for creating HTML promo pages
- `web_promo.html` — example standalone HTML promo page
- `application_note.md` — structural template / example (not project content)

## One-time setup

```bash
conda env create -f /opt/biotools/SP_AI_skills/application_note_template/markdown2pdf.yaml
```

System font (usually pre-installed):

```bash
sudo apt-get install fonts-dejavu
```

## Building PDFs

The project's `convert_to_pdf.sh` is a project-specific wrapper that calls
the skill's pandoc pipeline with custom output filenames.

```bash
bash application_note/convert_to_pdf.sh
```

To use the generic skill script directly on any file:

```bash
bash /opt/biotools/SP_AI_skills/application_note_template/convert_to_pdf.sh \
  application_note/your_note.md
```

## Web promo page

Refer to the skill's `web_promo_instructions.md` for guidance on adapting
`web_promo.html` for a new project:

```
/opt/biotools/SP_AI_skills/application_note_template/web_promo_instructions.md
```

## Project-specific files

<!-- Update the table below to reflect this project's actual files -->

| File | Purpose |
|------|---------|
| `application_note.md` | Main application note (comprehensive) |
| `application_note_technical.md` | Technical report variant (if applicable) |
| `convert_to_pdf.sh` | Project wrapper with custom output filenames |
| `create_figureN.R` | Figure generation scripts (if applicable) |
| `figures/` | PNG figures referenced by the application note |
| `web_promo.html` | Standalone HTML promotional page |
