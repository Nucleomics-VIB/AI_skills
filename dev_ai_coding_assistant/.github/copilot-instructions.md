# Copilot Workspace Instructions

## Session Memory System

**Before EVERY response or action, you MUST read these files:**

1. `.github/AI_files/AI_INSTRUCTIONS.md` - Rules and behavioral guidelines
2. `.github/AI_files/CURRENT_CONTEXT.md` - Project state and environment
3. `.github/AI_files/SESSION_DECISIONS.md` - Decision history and rationale

These files maintain persistent context and decisions across sessions. Failure to read them will result in inconsistent behavior and repeated mistakes.

**Important:** The AI_files folder contains templates. Customize them for your specific project.

---

## Language-Specific Skills

When working with R code, refer to `.github/copilot-skills/rscript-skills.md`
When working with Bash scripts, refer to `.github/copilot-skills/bash-skills.md`
When working with Python code, refer to `.github/copilot-skills/python-skills.md` if exists
When working with JavaScript code, refer to `.github/copilot-skills/javascript-skills.md` if exists

---

## Critical Enforcement Rules

### Terminal Command Execution

**⚠️ IMPORTANT:** VS Code + Copilot terminal integration has known issues.

- NEVER use `run_in_terminal` tool without explicit user request
- Always provide commands as copy-to-terminal code blocks
- User maintains control of all terminal operations

### Code Quality

- Review code carefully before proposing edits
- Verify file paths, syntax, and logic
- Prefer readability over cleverness
- Use simple solutions when possible

### Memory and Consistency

- Read AI_files before every response
- Apply documented decisions consistently
- Update SESSION_DECISIONS.md after significant changes
- Request clarification when uncertain

---

For complete guidelines, see `.github/AI_files/README.md`
