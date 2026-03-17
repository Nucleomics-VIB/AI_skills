# Slide Deck Build — Skill Dependency

This slide deck is built using the **`markdown_to_slidedeck`** skill from the
SP_AI_skills repository.

## Skill location

```
/opt/biotools/SP_AI_skills/markdown_to_slidedeck/
```

The skill provides:
- `build.sh` — generic Marp build script (PPTX / HTML / PDF) with Linux NFS
  Chrome workaround for `/data/` paths
- `marp_template/PRESENTATION.md` — VIB-themed Marp template
- `marp_template/MARP_SLIDE_GUIDE.md` — full authoring guide
- `environment.yml` — conda environment with Node.js + Marp CLI

## One-time setup

```bash
conda env create -f /opt/biotools/SP_AI_skills/markdown_to_slidedeck/environment.yml
conda run -n marp-slidedeck npm install -g @marp-team/marp-cli
```

## Building this deck

```bash
# PPTX + HTML
conda run -n marp-slidedeck bash slidedeck/build.sh

# Also build PDF
conda run -n marp-slidedeck bash slidedeck/build.sh --pdf

# Convert PDF figures to PNG, then build
conda run -n marp-slidedeck bash slidedeck/build.sh --figures /path/to/pdf_figures
```

Outputs are written next to the source `.md` file in `slidedeck/`.

## Project-specific files

<!-- Update the table below to reflect this project's actual files -->

| File | Purpose |
|------|---------|
| `YOUR_SLIDE_DECK.md` | Marp source for the slide deck |
| `figures/` | PNG figures referenced by the slide deck |
| `build.sh` | Thin wrapper that calls the skill's `build.sh` |
