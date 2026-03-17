# Setup Guide

Step-by-step instructions for deploying the AI coding assistant into a new project.

## Installation

Copy the `.github` folder from this skill into your project root:

```bash
cp -r /path/to/dev_ai_coding_assistant/.github /path/to/your-project/.github
cd /path/to/your-project
```

Optionally verify the installation:

```bash
bash .github/setup.sh
```

Then open in VS Code:

```bash
code .
```

Copilot reads `.github/copilot-instructions.md` automatically on start.

---

## Customisation

Edit the three memory files in `.github/AI_files/` for your project:

### AI_INSTRUCTIONS.md — coding rules

```markdown
## Project-Specific Rules
- Never hardcode credentials — use environment variables
- All functions must have a docstring / roxygen block
- Use config files for all paths and settings
```

### CURRENT_CONTEXT.md — project state

```markdown
## Project Overview
**Name:** my-project
**Tech Stack:** Python 3.11, FastAPI, PostgreSQL
**Directory structure:** src/, tests/, docs/
```

### SESSION_DECISIONS.md — decision log

```markdown
## YYYY-MM-DD: Initial setup
- Chose FastAPI over Flask for async support
```

---

## Verification

Ask Copilot: **"What rules and context should you follow for this project?"**

It should summarise the content of your `AI_INSTRUCTIONS.md` and `CURRENT_CONTEXT.md`. If it doesn't, check that the files exist in `.github/AI_files/` and that the workspace is opened (not just individual files).

---

## File reference

| File | Purpose | Edit? |
| ---- | ------- | ----- |
| `.github/copilot-instructions.md` | Main Copilot instruction file | Rarely |
| `.github/AI_files/AI_INSTRUCTIONS.md` | Rules and coding standards | Yes |
| `.github/AI_files/CURRENT_CONTEXT.md` | Project state and tech stack | Yes |
| `.github/AI_files/SESSION_DECISIONS.md` | Decision log | Yes (append) |
| `.github/copilot-skills/bash-skills.md` | Bash standards | Optional |
| `.github/copilot-skills/rscript-skills.md` | R standards | Optional |
| `.github/setup.sh` | Verifies installation | Run once |

---

## Troubleshooting

| Problem | Solution |
| ------- | -------- |
| Copilot not following rules | Add explicit examples to `AI_INSTRUCTIONS.md` |
| Context out of date | Update `CURRENT_CONTEXT.md` |
| Conflicting decisions | Document resolution in `SESSION_DECISIONS.md` |
| Missing files | Run `.github/setup.sh` to check |
