#!/usr/bin/env bash
# convert_to_pdf.sh
# Convert one or more application note Markdown files to PDF.
#
# Usage:
#   bash convert_to_pdf.sh <input.md> [input2.md ...]
#
# Run from the directory containing the .md file(s), or provide paths.
#
# Requirements: conda env 'markdown2pdf' (pandoc + tectonic)
#               fonts-dejavu installed system-wide (sudo apt-get install fonts-dejavu)
# See: PDF_CONVERSION_GUIDE.md for setup instructions.

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -lt 1 ]]; then
  echo "Usage: bash convert_to_pdf.sh <input.md> [input2.md ...]" >&2
  exit 1
fi

PANDOC_OPTS=(
  --pdf-engine=tectonic
  --variable geometry:a4paper
  --variable geometry:margin=2.5cm
  --variable fontsize=9pt
  --variable "mainfont=DejaVu Serif"
  --variable "monofont=DejaVu Sans Mono"
  --include-in-header="${SKILL_DIR}/header.tex"
  --toc
  --toc-depth=2
  --syntax-highlighting=tango
)

for INPUT in "$@"; do
  INPUT="$(cd "$(dirname "${INPUT}")" && pwd)/$(basename "${INPUT}")"
  STEM="$(basename "${INPUT}" .md)"
  OUT_DIR="$(dirname "${INPUT}")"
  OUTPUT="${OUT_DIR}/${STEM}.pdf"
  echo "Converting $(basename "${INPUT}") → $(basename "${OUTPUT}") ..."
  conda run -n markdown2pdf pandoc "${INPUT}" -o "${OUTPUT}" "${PANDOC_OPTS[@]}"
  echo "Done: ${OUTPUT} ($(du -h "${OUTPUT}" | cut -f1))"
done
