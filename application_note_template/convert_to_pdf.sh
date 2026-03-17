#!/usr/bin/env bash
# convert_to_pdf.sh
# Convert application note markdown files to PDF using the markdown2pdf conda env.
# Run from the project root or the application_note/ directory:
#   bash application_note/convert_to_pdf.sh
#
# Requirements: conda env 'markdown2pdf' (pandoc + tectonic)
#               fonts-dejavu installed system-wide (sudo apt-get install fonts-dejavu)
# See: application_note/PDF_CONVERSION_GUIDE.md for setup instructions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PANDOC_OPTS=(
  --pdf-engine=tectonic
  --variable geometry:a4paper
  --variable geometry:margin=2.5cm
  --variable fontsize=9pt
  --variable "mainfont=DejaVu Serif"
  --variable "monofont=DejaVu Sans Mono"
  --include-in-header=header.tex
  --toc
  --toc-depth=2
  --syntax-highlighting=tango
)

declare -A OUTPUT_NAMES=(
  [application_note.md]="Aviti-WES_application_note.pdf"
  [application_note_technical.md]="Aviti-WES_application_note_technical.pdf"
)

for INPUT in application_note.md application_note_technical.md; do
  OUTPUT="${OUTPUT_NAMES[$INPUT]}"
  echo "Converting ${INPUT} → ${OUTPUT} ..."
  conda run -n markdown2pdf pandoc "${INPUT}" -o "${OUTPUT}" "${PANDOC_OPTS[@]}"
  echo "Done: ${OUTPUT} ($(du -h "${OUTPUT}" | cut -f1))"
done
