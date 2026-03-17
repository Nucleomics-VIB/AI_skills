# GPT_templates

Prompt templates for submitting structured code requests to an AI assistant (ChatGPT, Claude, Copilot, etc.).

## Contents

| File | Description |
| ---- | ----------- |
| `code_request_template.txt` | Structured template for a code generation request |

## Usage

Copy `code_request_template.txt` into your AI session and fill in the placeholders before submitting. The template ensures the assistant receives all the context it needs to produce well-formed, correctly styled code on the first attempt.

### Template fields

| Field | What to fill in |
| ----- | --------------- |
| `Title` | Short name for the request |
| `Description` | What the code should do and why |
| `Expected Outputs` | File types, formats, or printed results expected |
| `Desired Language` | Python, R, Bash, etc. |
| `Code formatting request` | Formatter to apply (e.g. `black` for Python, `styler` for R) |

The `--BEGIN TEMPLATE--` block is what the AI fills out: shebang, description, usage line, credit header, and the actual code.

## Example

```text
Title: [Code Request] Normalize RNA-seq counts
Description: Read a tab-delimited file with gene names in column 1 and
             raw counts in remaining columns. Normalize each column to
             counts-per-million (CPM). Write the result to a new TSV file.
Expected Outputs: normalized_counts.tsv
Desired Language: Python
Code formatting request: black
```

Paste this into the template and submit — the assistant returns a complete, formatted script.
