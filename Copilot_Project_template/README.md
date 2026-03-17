# Copilot_Project_template

A structured file-based memory system for GitHub Copilot inside VSCode. Gives Copilot persistent context, coding rules, and a decision log that survive across sessions.

## Problem it solves

AI assistants reset between sessions and repeat the same mistakes. This template provides four memory files that Copilot reads before every response, keeping it aligned with your project rules and decisions.

## Contents

```text
_.github/                        # rename to .github/ in your project
    copilot-instructions.md      # instructs Copilot to read the memory files
_.vscode/
    settings.json                # associates memory files with Markdown, shows reminder
AI_INSTRUCTIONS.md               # rules and coding standards Copilot must follow
CURRENT_CONTEXT.md               # current project state and tech stack
SESSION_DECISIONS.md             # log of decisions made during sessions
COPILOT_REQUEST_TEMPLATE.md      # template for submitting requests to Copilot
.gitignore                       # standard ignore patterns
```

> **Note:** Folders are prefixed with `_` here so they are visible in the file browser. Rename `_.github` → `.github` and `_.vscode` → `.vscode` in your actual project.

## Setup

1. Copy `_.github/` to `.github/` in your project root.
2. Copy `_.vscode/` to `.vscode/` in your project root.
3. Copy the four memory files (`AI_INSTRUCTIONS.md`, `CURRENT_CONTEXT.md`, `SESSION_DECISIONS.md`, `COPILOT_REQUEST_TEMPLATE.md`) to your project root.
4. Add the `.gitignore` entries to your project's `.gitignore` if needed.
5. Open the project in VSCode — Copilot will read `.github/copilot-instructions.md` automatically.

## Workflow

- **Start of session:** Copilot reads all four memory files to rebuild context.
- **During session:** Submit requests using the `COPILOT_REQUEST_TEMPLATE.md` format.
- **After decisions:** Update `SESSION_DECISIONS.md` with what was chosen and why.
- **When context changes:** Update `CURRENT_CONTEXT.md` to reflect the new state.

## Memory files

| File | Purpose |
| ---- | ------- |
| `AI_INSTRUCTIONS.md` | Coding rules, standards, and constraints Copilot must respect |
| `CURRENT_CONTEXT.md` | Active files, environment, tech stack, current focus |
| `SESSION_DECISIONS.md` | Append-only log of decisions with rationale |
| `COPILOT_REQUEST_TEMPLATE.md` | Prompt format ensuring context is checked before acting |

## Extending

Add language-specific standards by creating files under `.github/copilot-skills/` (see `dev_ai_coding_assistant` skill for Bash and R examples) and referencing them in `copilot-instructions.md`.
