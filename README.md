# AI_skills

A personal library of prompt templates, formatting standards, and worked examples for repetitive tasks — designed to be pasted into Claude (or other AI) sessions for consistent, reproducible outputs.

## Structure

Each subfolder is a **skill** — a self-contained unit containing:

- A guide or template the agent reads to learn the skill
- Example outputs or worked samples
- Any supporting assets (images, config files, etc.)

When starting a session, point the agent to the relevant skill folder so it can apply the defined formats and templates.

## Skills

| Folder | Description |
| ------ | ----------- |
| [GPT_templates/](GPT_templates/) | Prompt templates for common code request workflows |
| [dev_ai_coding_assistant/](dev_ai_coding_assistant/) | Setup guide, instructions, and copilot skills for an AI coding assistant environment |
| [Copilot_Project_template/](Copilot_Project_template/) | Template project structure with Copilot instructions, request template, and VSCode settings |
| [NC_Dockerfile_template/](NC_Dockerfile_template/) | Dockerfile template with customisation script and package summary for containerised workflows |
| [Rmd-report_template/](Rmd-report_template/) | R Markdown report template with logos, bibliography, LaTeX preamble, and tex layout data |
| [application_note_template/](application_note_template/) | Application note template with PDF conversion guide and web promo scaffold |
| [markdown_to_slidedeck/](markdown_to_slidedeck/) | Build scripts, conda environment, and Marp template to convert Markdown into a slide deck (PPTX/HTML/PDF) |

## Usage

1. Open a Claude (or other AI) session.
2. Reference the skill folder relevant to your task (e.g., "Read `marp_template/MARP_SLIDE_GUIDE.md` and apply the conventions to create a new presentation").
3. The agent will learn from the guide and produce outputs matching the defined style.

## Contributing

Add a new subfolder for each new skill. Include a clear `README.md` or guide file at the root of the skill folder explaining its purpose and usage.

---

Maintained by Stéphane Plaisance with help from Claude AI
[Nucleomics-VIB](https://github.com/Nucleomics-VIB)
version 1.0; 2026-03-17
