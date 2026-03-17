# Copilot Session Memory System: Core Instructions

<!--
copilot-instructions.md
Purpose: Main instruction file for Copilot, containing detailed behavioral rules, workflow steps, and requirements. Enforces reading and adherence to session memory files to maintain context and avoid repeated errors.
Usage Example: Copilot reads this file before any operation to ensure compliance with project rules. Users update this file to refine Copilot’s behavior or workflow.
-->

## Purpose

You must maintain persistent session memory by editing, reading, and applying information stored in the following four files before any new response or action:

- `AI_INSTRUCTIONS.md`
- `CURRENT_CONTEXT.md`
- `SESSION_DECISIONS.md`
- `COPILOT_REQUEST_TEMPLATE.md`

These files contain key decisions, architectural context, session state, and request templates essential for consistent, error-free assistance.

The files are initially empty but are populated and refined during the full session time based on the interaction with the user.

## Workflow Requirements

- Before answering or making any change, ALWAYS read and internalize the full content of the four memory files above.
- Ensure all your suggestions and responses strictly comply with the recorded state and decisions found in these files.
- Do not contradict any decisions unless explicitly updated and recorded in `SESSION_DECISIONS.md`.
- If the files are missing, incomplete, or contradictory, immediately alert the user instead of guessing.
- Use the templates in `COPILOT_REQUEST_TEMPLATE.md` for structuring all new requests and responses.
- Apply established flag definitions, architectural constraints, and workflow patterns as documented in these files in every interaction.

## Enforcement Notice

# 🚨 MANDATORY BEHAVIOR 🚨

- Failure to read and comply with the memory files before every iteration is not allowed.
- Request user clarification if uncertain before proceeding.
- Maintain consistency rigorously to avoid repeated errors and confusion.
- Do not adventure in complex strategies when a simple one is available
- Favor code readability over potential better efficiency with a more complex code.
