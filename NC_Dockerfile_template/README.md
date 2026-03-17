# NC_Dockerfile_template

A standardised Dockerfile template for bioinformatics containerisation projects, with a customisation script and detailed usage guide.

## Contents

| File | Description |
| ---- | ----------- |
| `Dockerfile_template` | Master template with placeholder variables and annotated sections |
| `customize_dockerfile_template.sh` | Script that replaces template variables for a new project |
| `README_Dockerfile_template.md` | Full usage guide: variables, customisation examples, best practices |

## Quick start

```bash
# Copy and customise the template
bash customize_dockerfile_template.sh \
    PROJECT_NAME \
    BASE_IMAGE \
    ENV_NAME \
    MAIN_SCRIPT
```

This replaces the four placeholder variables and produces a project-ready `Dockerfile`.

## Template variables

| Variable | Description | Example |
| -------- | ----------- | ------- |
| `{{PROJECT_NAME}}` | Project identifier | `my-analysis` |
| `{{BASE_IMAGE}}` | Docker base image | `mambaorg/micromamba:1.5.8` |
| `{{ENV_NAME}}` | Conda environment name | `myenv` |
| `{{MAIN_SCRIPT}}` | Main executable name | `run_analysis` |

## Template sections

The `Dockerfile_template` is organised into labelled sections:

1. System setup (locale, non-interactive installs, essential packages)
2. Conda/mamba environment creation
3. Environment activation and PATH
4. Project file copying and permissions
5. External tool compilation (optional)
6. System-wide conda activation
7. Runtime setup (entrypoint, temp dirs, verification)
8. Final configuration (user, volumes, default command)

See `README_Dockerfile_template.md` for full customisation examples for bioinformatics, Python data science, and R analysis projects.

## Testing a built image

```bash
docker build -t your-project .
docker run --rm your-project --help
docker run --rm -v $(pwd)/test_data:/data your-project
docker run --rm -it your-project bash   # interactive shell
```
