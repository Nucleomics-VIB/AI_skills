# application_note_template

A template for writing, converting, and promoting a scientific application note. Produces a polished PDF from Markdown and a ready-to-use HTML web promo page.

## Contents

| File | Description |
| ---- | ----------- |
| `application_note.md` | Example application note in Markdown (comprehensive version) |
| `convert_to_pdf.sh` | Shell script wrapping the pandoc conversion command |
| `markdown2pdf.yaml` | Conda environment definition (pandoc + tectonic PDF engine) |
| `header.tex` | LaTeX header snippet (microtype, hbadness suppression) |
| `PDF_CONVERSION_GUIDE.md` | Full conversion guide with troubleshooting |
| `web_promo_instructions.md` | Instructions for generating the HTML promo page |
| `web_promo.html` | Example HTML promo page (standalone, no external dependencies) |

## Workflow

### 1. Write your note

Edit or replace `application_note.md` with your own content. The example file demonstrates:

- Standard scientific structure (Abstract, Methods, Results, Discussion)
- Figure references and captions
- Tables
- A key metrics summary box

See **`WRITING_GUIDE.md`** for content requirements, section rules, formatting conventions, and glossary curation.

### 2. Set up the conversion environment (once)

```bash
conda env create -f markdown2pdf.yaml
```

### 3. Convert to PDF

```bash
bash convert_to_pdf.sh your_note.md
```

Or manually with pandoc:

```bash
conda run -n markdown2pdf pandoc your_note.md -o your_note.pdf \
  --pdf-engine=tectonic \
  --variable geometry:a4paper \
  --variable geometry:margin=2.5cm \
  --variable fontsize=10pt \
  --variable mainfont="DejaVu Serif" \
  --variable monofont="DejaVu Sans Mono" \
  --include-in-header=header.tex \
  --toc --toc-depth=2 \
  --syntax-highlighting=tango
```

> `--number-sections` is intentionally omitted when the document already uses manual section numbers.

See `PDF_CONVERSION_GUIDE.md` for full options and troubleshooting.

### 4. Generate the web promo page

Follow `web_promo_instructions.md` to adapt `web_promo.html` for your note. The HTML file is self-contained and can be hosted on any static site.

## Notes

- Tectonic downloads required LaTeX packages on first run (internet needed); subsequent runs are offline.
- System font `DejaVu Serif` must be available: `sudo apt-get install fonts-dejavu`
- `application_note.md` is an **example file** — use it as a structural reference, not as content to reuse verbatim.
