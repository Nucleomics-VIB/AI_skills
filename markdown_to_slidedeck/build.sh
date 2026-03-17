#!/usr/bin/env bash
# Build a Marp slide deck (PPTX + HTML, optionally PDF)
#
# Usage:
#   bash build.sh <input.md>                       # PPTX + HTML
#   bash build.sh <input.md> --pdf                 # also PDF
#   bash build.sh <input.md> --figures <src_dir>   # convert all PDFs in <src_dir> to PNG, then build
#
# One-time setup on a new host:
#   conda env create -f environment.yml
#   conda run -n marp-slidedeck npm install -g @marp-team/marp-cli
#
# Then build:
#   conda run -n marp-slidedeck bash build.sh marp_template/PRESENTATION.md
#   conda run -n marp-slidedeck bash build.sh my_slides.md --pdf
#   conda run -n marp-slidedeck bash build.sh my_slides.md --figures /path/to/pdf_figures
#
# Tools required (all provided by conda env + npm):
#   - marp       (@marp-team/marp-cli via npm, needs Node.js LTS)
#   - pdftoppm   (poppler, provided by conda) — only needed for --figures

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Parse arguments ────────────────────────────────────────────────────────
if [[ $# -lt 1 || "${1:-}" == --* ]]; then
  echo "Usage: bash build.sh <input.md> [--pdf] [--figures <src_dir>]" >&2
  exit 1
fi

INPUT_ARG="$1"; shift
INPUT="$(cd "$(dirname "${INPUT_ARG}")" && pwd)/$(basename "${INPUT_ARG}")"
STEM="$(basename "${INPUT}" .md)"
OUT_DIR="$(dirname "${INPUT}")"
FIGURES_DST="${OUT_DIR}/pictures"

BUILD_PDF=false
FIGURES_SRC=""

while [[ $# -gt 0 ]]; do
  case "${1}" in
    --pdf)     BUILD_PDF=true; shift ;;
    --figures) FIGURES_SRC="${2}"; shift 2 ;;
    *) echo "[build.sh] Unknown argument: ${1}" >&2; exit 1 ;;
  esac
done

# ── Optional: convert PDF figures to PNG ───────────────────────────────────
if [[ -n "${FIGURES_SRC}" ]]; then
  echo "[build.sh] Converting PDFs in ${FIGURES_SRC} to PNG (150 dpi)..."
  mkdir -p "${FIGURES_DST}"
  for pdf in "${FIGURES_SRC}"/*.pdf; do
    [[ -f "${pdf}" ]] || { echo "[build.sh]   No PDFs found in ${FIGURES_SRC}"; break; }
    fig="$(basename "${pdf}" .pdf)"
    pdftoppm -r 150 -png -singlefile "${pdf}" "${FIGURES_DST}/${fig}"
    echo "[build.sh]   ${fig}.pdf → ${FIGURES_DST}/${fig}.png"
  done
fi

# ── Ensure marp is available ───────────────────────────────────────────────
if ! command -v marp &>/dev/null; then
  if [[ -x "${SCRIPT_DIR}/node_modules/.bin/marp" ]]; then
    MARP="${SCRIPT_DIR}/node_modules/.bin/marp"
  else
    echo "[build.sh] marp not found — installing @marp-team/marp-cli locally..."
    npm install --prefix "${SCRIPT_DIR}" @marp-team/marp-cli
    MARP="${SCRIPT_DIR}/node_modules/.bin/marp"
  fi
else
  MARP="marp"
fi

# ── Resolve a working Chrome for local-file access (Linux NFS workaround) ──
# On Linux the snap Chromium sandbox blocks paths on NFS mounts (e.g. /data/);
# use puppeteer's own downloaded Chrome instead.  On macOS, marp finds the
# system browser fine so no workaround is needed.
BROWSER_ARGS=""
if [[ "$(uname)" == "Linux" ]]; then
  CHROME_PATH="$(find "${HOME}/.cache/puppeteer/chrome" -name "chrome" -type f 2>/dev/null | sort -V | tail -1)"

  if [[ -z "${CHROME_PATH}" ]]; then
    echo "[build.sh] Downloading a compatible Chrome via puppeteer..."
    MARP_MODULES="$(dirname "$(which marp)")/../lib/node_modules/@marp-team/marp-cli/node_modules"
    node -e "
      const { install, resolveBuildId } = require('${MARP_MODULES}/@puppeteer/browsers');
      const cacheDir = process.env.HOME + '/.cache/puppeteer';
      resolveBuildId('chrome', 'linux', 'stable').then(buildId =>
        install({ browser: 'chrome', buildId, cacheDir })
      ).then(r => console.log(r.executablePath)).catch(e => { console.error(e.message); process.exit(1); });
    " 2>&1
    CHROME_PATH="$(find "${HOME}/.cache/puppeteer/chrome" -name "chrome" -type f 2>/dev/null | sort -V | tail -1)"
  fi

  if [[ -n "${CHROME_PATH}" ]]; then
    echo "[build.sh] Using Chrome: ${CHROME_PATH}"
    BROWSER_ARGS="--browser-path ${CHROME_PATH}"
  fi
fi

# ── Build ──────────────────────────────────────────────────────────────────
echo "[build.sh] Building PPTX: ${STEM}.pptx"
# shellcheck disable=SC2086
"${MARP}" "${INPUT}" --pptx --allow-local-files ${BROWSER_ARGS} -o "${OUT_DIR}/${STEM}.pptx"
echo "[build.sh]  → ${OUT_DIR}/${STEM}.pptx"

echo "[build.sh] Building HTML: ${STEM}.html"
# shellcheck disable=SC2086
"${MARP}" "${INPUT}" --html --allow-local-files ${BROWSER_ARGS} -o "${OUT_DIR}/${STEM}.html"
echo "[build.sh]  → ${OUT_DIR}/${STEM}.html"

if [[ "${BUILD_PDF}" == true ]]; then
  echo "[build.sh] Building PDF: ${STEM}.pdf"
  # shellcheck disable=SC2086
  "${MARP}" "${INPUT}" --pdf --allow-local-files ${BROWSER_ARGS} -o "${OUT_DIR}/${STEM}.pdf"
  echo "[build.sh]  → ${OUT_DIR}/${STEM}.pdf"
fi

echo "[build.sh] Done."
