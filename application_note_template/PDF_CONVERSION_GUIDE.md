# PDF Conversion Guide for Application Note

This guide covers converting a Markdown application note to PDF using pandoc and tectonic.

---

## Environment Setup

A dedicated conda environment (`markdown2pdf`) provides all conversion tools.
The environment definition is in `markdown2pdf.yaml` (same folder as this guide).

### Create the environment

```bash
conda env create -f markdown2pdf.yaml
```

### System dependency (if not already installed)

```bash
sudo apt-get install fonts-dejavu
```

> `fonts-dejavu` is pre-installed on most Ubuntu systems. It provides
> **DejaVu Serif**, which is required for correct rendering of Unicode
> characters (≥, ≤, ×, →) in the PDF. No other system LaTeX packages are
> needed — `tectonic` (included in the conda env) is a self-contained
> XeLaTeX engine that manages its own LaTeX packages.

---

## Converting to PDF

All commands use `conda run -n markdown2pdf` — no need to activate the environment manually.

Run from the folder containing your `.md` file.

### Single file

```bash
conda run -n markdown2pdf pandoc your_note.md -o your_note.pdf \
  --pdf-engine=tectonic \
  --variable geometry:a4paper \
  --variable geometry:margin=2.5cm \
  --variable fontsize=10pt \
  --variable mainfont="DejaVu Serif" \
  --variable monofont="DejaVu Sans Mono" \
  --include-in-header=header.tex \
  --toc \
  --toc-depth=2 \
  --syntax-highlighting=tango
```

### Multiple files at once

```bash
for src in note1 note2; do
  conda run -n markdown2pdf pandoc ${src}.md -o ${src}.pdf \
    --pdf-engine=tectonic \
    --variable geometry:a4paper \
    --variable geometry:margin=2.5cm \
    --variable fontsize=10pt \
    --variable mainfont="DejaVu Serif" \
    --variable monofont="DejaVu Sans Mono" \
    --toc \
    --toc-depth=2 \
    --syntax-highlighting=tango
  echo "Done: ${src}.pdf ($(du -h ${src}.pdf | cut -f1))"
done
```

---

## Notes

- `--number-sections` is intentionally **omitted**: the documents already use
  manual section numbers (1., 1.1, etc.) — adding it would produce duplicates.
- Tectonic downloads required LaTeX packages on first run (internet needed);
  subsequent runs are fully offline.
- `header.tex` loads `microtype` (improved justification) and sets `\hbadness=10000`
  to suppress harmless "Underfull \hbox" warnings from short figure caption lines.
- Warnings about missing `✓` (U+2713) in DejaVu Serif are harmless — the
  character is absent from that font but does not cause conversion failure.
- Tectonic "accessing absolute path" warnings for font files are informational —
  the PDF builds correctly; `fonts-dejavu` is a standard Ubuntu system package.

---

## Troubleshooting

### "font not found" errors

```bash
fc-list | grep -i "dejavu"
```

If empty: `sudo apt-get install fonts-dejavu`

### Tectonic package download fails (no internet)

Use the system xelatex as a fallback (requires `texlive-xetex` installed):

```bash
conda run -n markdown2pdf pandoc application_note.md -o application_note.pdf \
  --pdf-engine=xelatex \
  --variable geometry:a4paper \
  --variable geometry:margin=2.5cm \
  --variable fontsize=10pt \
  --variable mainfont="DejaVu Serif" \
  --variable monofont="DejaVu Sans Mono" \
  --include-in-header=header.tex \
  --toc \
  --toc-depth=2 \
  --syntax-highlighting=tango
```

### Pandoc version check

```bash
conda run -n markdown2pdf pandoc --version
conda run -n markdown2pdf tectonic --version
```

---

Last updated: March 2026
