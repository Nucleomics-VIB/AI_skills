# dev_ai_coding_assistant

A ready-to-deploy `.github/` folder that gives GitHub Copilot (VSCode) persistent memory, language coding standards, and a setup verification script.

## Contents

```text
.github/
    copilot-instructions.md      # main Copilot instruction file
    .gitignore                   # patterns to exclude from commits
    .vscode/
        settings.json            # Markdown file associations + welcome reminder
    AI_files/
        AI_INSTRUCTIONS.md       # rules and standards Copilot must follow
        CURRENT_CONTEXT.md       # current project state
        SESSION_DECISIONS.md     # decision log
        README.md                # guide to the memory system
    copilot-skills/
        bash-skills.md           # Bash coding standards
        rscript-skills.md        # R coding standards
    setup.sh                     # verifies the installation is complete
info/
    dot.AI_ASSISTANT_RULES.md    # standalone rules file (alternative deployment)
SETUP_GUIDE.md                   # step-by-step setup instructions
```

## Setup

```bash
# Copy the .github folder into any project
cp -r /path/to/dev_ai_coding_assistant/.github /path/to/your-project/.github
cd /path/to/your-project

# Optional: verify setup
bash .github/setup.sh
```

Then open the project in VSCode — Copilot reads `.github/copilot-instructions.md` automatically on start.

## How it works

Copilot is instructed to read three memory files before every response:

| File | Purpose |
| ---- | ------- |
| `.github/AI_files/AI_INSTRUCTIONS.md` | Project rules and coding standards |
| `.github/AI_files/CURRENT_CONTEXT.md` | Active state, environment, tech stack |
| `.github/AI_files/SESSION_DECISIONS.md` | Append-only decision log |

Fill these in at the start of a project and update them as decisions are made. Copilot will stay aligned across sessions without repeated corrections.

## Language skills

Pre-written coding standards live in `.github/copilot-skills/`:

- **`bash-skills.md`** — headers, argument parsing, error handling, logging
- **`rscript-skills.md`** — headers, package management, reproducibility, tidyverse style

Add more languages (Python, Nextflow, etc.) by creating additional `*-skills.md` files and referencing them in `copilot-instructions.md`.
