# markdown_to_slidedeck

Build a Marp slide deck (PPTX + HTML, optionally PDF) from a single Markdown file. Includes a conda environment, a build script, and a worked example template.

## Contents

```text
build.sh              # build script — accepts any .md file as input
environment.yml       # conda environment (Node.js + Marp CLI + poppler)
marp_template/
    PRESENTATION.md       # example Marp slide deck (worked template)
    MARP_SLIDE_GUIDE.md   # guide to Marp syntax, layout, and design conventions
    pictures/
        vib_logo.png
        vib_logo_white.png
```

## One-time setup

```bash
conda env create -f environment.yml
conda run -n marp-slidedeck npm install -g @marp-team/marp-cli
```

## Usage

```bash
# PPTX + HTML (outputs named after the input file)
bash build.sh marp_template/PRESENTATION.md

# Also build PDF
bash build.sh my_slides.md --pdf

# Convert all PDFs in a figures directory to PNG, then build
bash build.sh my_slides.md --figures /path/to/pdf_figures

# Live preview in browser (auto-reloads on save)
marp --preview my_slides.md
```

Output files are written alongside the input `.md` file, named from its stem:
`my_slides.md` → `my_slides.pptx`, `my_slides.html`, `my_slides.pdf`

## Marp template

`marp_template/PRESENTATION.md` is a fully worked example demonstrating:

- YAML frontmatter (theme, pagination, background colour)
- Title slide and section dividers
- Two-column layouts
- Image placement and sizing
- Code blocks with syntax highlighting
- Logo overlay on every slide

Read `marp_template/MARP_SLIDE_GUIDE.md` before creating a new deck — it explains every design decision in the example so you can reproduce the same layout in a new project.

## Using with conda run (no environment activation needed)

```bash
conda run -n marp-slidedeck bash build.sh my_slides.md
conda run -n marp-slidedeck bash build.sh my_slides.md --pdf
```
