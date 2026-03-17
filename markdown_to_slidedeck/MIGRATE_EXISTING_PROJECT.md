# Migrating an Existing Project Slide Deck to the Skill

This guide documents how to clean up a project slide deck that was originally
built with local copies of the skill files, and migrate it to delegate entirely
to the centralised `markdown_to_slidedeck` skill in SP_AI_skills.

It was first applied to `NC_Aviti_Trinity_ExomeSeq` (March 2026) and is
intended as a reusable reference for other projects in the same situation.

---

## Background: the "before" state

When the slide deck was first created, the skill did not yet exist as a
centralised repository. The project therefore contained its own copies of:

```
slidedeck/
├── environment.yml          ← conda env definition
├── marp_template/
│   ├── PRESENTATION.md      ← VIB Marp theme template
│   ├── MARP_SLIDE_GUIDE.md  ← authoring guide
│   └── pictures/
│       ├── vib_logo.png
│       └── vib_logo_white.png
└── build.sh                 ← full, self-contained build logic
```

The project-level `build.sh` contained generic logic (marp detection,
figure conversion, Chrome workaround) that is now covered by the skill's
`build.sh`.

---

## What was migrated

### Improvement contributed back to the skill

The local `build.sh` contained a **Linux NFS Chrome workaround** that was
absent from the skill's generic `build.sh`. On Linux, the snap Chromium
sandbox blocks access to NFS-mounted paths (e.g. `/data/`), causing
`ERR_FILE_NOT_FOUND` for all figure files during PPTX rendering.

The fix auto-finds or downloads a puppeteer-managed Chrome binary from
`~/.cache/puppeteer/chrome` and passes `--browser-path` to all marp calls.
This block was added to the skill's `build.sh` (commit `612a000`).

### Local CSS additions (noted but not contributed back)

The project slide deck (`Aviti-WES_application_note.md`) uses table CSS not
present in the skill's `marp_template/PRESENTATION.md`:

```css
table { font-size: 0.82em; border-collapse: collapse; width: 100%; }
th    { background: #1a3a6b; color: white; padding: 4px 8px; }
td    { padding: 3px 8px; border-bottom: 1px solid #dde; }
tr:nth-child(even) td { background: #f0f4fb; }
```

These are project-level overrides in the YAML frontmatter `style:` block and
do not need to be in the template.

---

## Migration steps

### 1. Update the skill's build.sh if there are local improvements

Compare `slidedeck/build.sh` with the skill's `build.sh`. Contribute any
useful additions (e.g. the Chrome workaround) back to the skill repo and push.

### 2. Remove generic files from the project

```bash
git rm slidedeck/environment.yml
git rm -r slidedeck/marp_template/
```

These are now provided by the skill. The project's slide deck `.md` file
still references logos via the path it used at creation time; update that
path to point to the skill's copy:

```
marp_template/pictures/vib_logo_white.png   ← old (worked when local)
/opt/biotools/SP_AI_skills/markdown_to_slidedeck/marp_template/pictures/vib_logo_white.png
```

Or keep a symlink / copy the logo in the project's `figures/` directory if
an absolute path is undesirable.

### 3. Rewrite the project-level build.sh

Replace the full build logic with a thin wrapper that delegates to the skill:

```bash
#!/usr/bin/env bash
# Delegates to the generic markdown_to_slidedeck skill.
# See slidedeck/SKILL_DEPENDENCY.md for setup instructions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_BUILD="/opt/biotools/SP_AI_skills/markdown_to_slidedeck/build.sh"

if [[ ! -f "${SKILL_BUILD}" ]]; then
  echo "[build.sh] ERROR: skill not found at ${SKILL_BUILD}" >&2
  echo "[build.sh]        See slidedeck/SKILL_DEPENDENCY.md for setup." >&2
  exit 1
fi

exec bash "${SKILL_BUILD}" "${SCRIPT_DIR}/YOUR_SLIDE_DECK.md" "$@"
```

Replace `YOUR_SLIDE_DECK.md` with the actual filename. All options (`--pdf`,
`--figures <dir>`) are forwarded to the skill via `"$@"`.

### 4. Add SKILL_DEPENDENCY.md

Copy `SKILL_DEPENDENCY_template.md` from the skill folder to the project's
`slidedeck/` directory, rename it to `SKILL_DEPENDENCY.md`, and fill in the
project-specific section (input filename, output description).

### 5. Commit and push

```bash
# Project repo
git add slidedeck/build.sh slidedeck/SKILL_DEPENDENCY.md
git commit -m "Harmonize slidedeck with SP_AI_skills skill repo"
git push
```

---

## After: the "clean" project state

```
slidedeck/
├── YOUR_SLIDE_DECK.md       ← Marp source (project-specific)
├── figures/                 ← PNG figures (project-specific)
├── build.sh                 ← thin wrapper (7 lines)
├── SKILL_DEPENDENCY.md      ← setup doc (from template)
└── (optional outputs)
    ├── YOUR_SLIDE_DECK.pptx
    └── YOUR_SLIDE_DECK.html
```

No generic skill files remain in the project. All build logic, the conda
environment definition, and the Marp template live exclusively in the skill
repo.
