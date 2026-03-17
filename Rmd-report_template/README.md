# Rmd-report_template

An R Markdown template for producing PDF reports with a custom logo, LaTeX preamble, bibliography support, and knitr code chunk examples.

## Contents

| File / Folder | Description |
| ------------- | ----------- |
| `report.Rmd` | Main template — YAML header, knitr setup, example sections |
| `NC_logo.png` | Logo image for use in the report header |
| `pictures/` | Folder for figures included in the report body |
| `tex_data/preamble.tex` | LaTeX preamble (header logo placement, extra packages) |
| `tex_data/bibliography.bib` | BibTeX reference file |
| `tex_data/pictures/cover.png` | Cover image used by the preamble |

## Usage

1. Copy the entire folder to your project.
2. Edit the YAML header in `report.Rmd`:
   - Update `title`, `author`, and `date`
   - Adjust `geometry` margins as needed
3. Set `workdir` in the setup chunk to your project path.
4. Replace `NC_logo.png` and `tex_data/pictures/cover.png` with your own branding.
5. Add references to `tex_data/bibliography.bib` and cite them with `[@key]`.
6. Knit to PDF from RStudio or from the command line:

```bash
Rscript -e "rmarkdown::render('report.Rmd')"
```

## Key knitr options (set in setup chunk)

| Option | Default | Effect |
| ------ | ------- | ------ |
| `eval` | `FALSE` | Chunks are shown but not run unless overridden per chunk |
| `echo` | `FALSE` | Code is hidden in output unless overridden |
| `include` | `TRUE` | Output is included |
| `cache` | `TRUE` | Results cached to speed up re-knitting |

Override any option at the individual chunk level as needed.

## Dependencies

Install required R packages before knitting:

```r
install.packages(c("knitr", "ggplot2", "RColorBrewer", "rmarkdown"))
```

A working LaTeX installation is also required (TinyTeX recommended):

```r
install.packages("tinytex")
tinytex::install_tinytex()
```
