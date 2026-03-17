# Dockerfile Template Usage Guide

This `Dockerfile_template` provides a standardized structure for Nucleomics-VIB Docker projects, incorporating best practices learned from multiple bioinformatics containerization projects.

## Quick Start

1. **Copy the template**:
   ```bash
   cp backup/Dockerfile_template Dockerfile
   ```

2. **Replace template variables**:
   ```bash
   # Required replacements
   sed -i 's/{{PROJECT_NAME}}/your-project-name/g' Dockerfile
   sed -i 's/{{BASE_IMAGE}}/mambaorg\/micromamba:1.5.8/g' Dockerfile
   sed -i 's/{{ENV_NAME}}/your-env-name/g' Dockerfile
   sed -i 's/{{MAIN_SCRIPT}}/your-main-script/g' Dockerfile
   ```

3. **Customize for your project** (see sections below)

## Template Variables

### Required Replacements

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_NAME}}` | Name of your project | `barcode-qc-gdna` |
| `{{BASE_IMAGE}}` | Docker base image | `mambaorg/micromamba:1.5.8` |
| `{{ENV_NAME}}` | Conda environment name | `pbbioconda` |
| `{{MAIN_SCRIPT}}` | Main executable script name | `barcode_QC_gDNA` |

### Optional Customizations

| Section | Customize When |
|---------|----------------|
| System Dependencies | Need additional packages |
| Environment Setup | Multiple conda environments |
| Build Steps | Compiling external tools |
| Database Downloads | Project needs databases |

## Common Base Images

### For Bioinformatics Projects
```dockerfile
FROM mambaorg/micromamba:1.5.8
# Pre-configured micromamba, smaller image
```

### For Complex Multi-Environment Projects
```dockerfile
FROM ubuntu:22.04
# Full control over environment setup
```

## Example Customizations

### 1. Bioinformatics Project (Current Template)
```dockerfile
FROM mambaorg/micromamba:1.5.8
# Add bioconda packages, samtools, R packages
# Include build tools for compiling C/C++ tools
```

### 2. Python Data Science Project
```dockerfile
FROM mambaorg/micromamba:1.5.8
# Focus on python packages: pandas, numpy, scipy, matplotlib
# Skip build tools unless needed
```

### 3. R Analysis Project
```dockerfile
FROM ubuntu:22.04
# Manual micromamba installation
# Heavy focus on R packages and LaTeX for reports
```

## Template Structure

### 1. System Setup (Lines 13-30)
- UTF-8 locale configuration
- Non-interactive package installation
- Essential system dependencies

### 2. Conda/Mamba Environment (Lines 66-95)
- Environment variable setup
- Conda environment creation
- Multi-environment support (commented)

### 3. Environment Activation (Lines 101-109)
- PATH configuration
- Environment verification

### 4. Project Files (Lines 115-125)
- File copying and permissions
- Directory structure setup

### 5. Build Steps (Lines 131-150)
- External tool compilation
- Build artifact cleanup
- Project-specific builds

### 6. System Configuration (Lines 156-188)
- System-wide environment activation
- Conda/mamba aliases
- Shell configuration

### 7. Runtime Setup (Lines 218-252)
- Temporary directory handling
- Entrypoint script creation
- Environment verification

### 8. Final Configuration (Lines 265-285)
- Runtime user setup
- Volume declarations
- Default commands

## Customization Examples

### Adding System Packages

Replace the system dependencies section:
```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Your specific packages
    python3-dev \
    libhdf5-dev \
    libnetcdf-dev \
    && rm -rf /var/lib/apt/lists/*
```

### Multiple Conda Environments

Replace the single environment creation:
```dockerfile
RUN micromamba create -y -n analysis -f /tmp/env/analysis.yml \
    && micromamba create -y -n visualization -f /tmp/env/viz.yml \
    && micromamba clean -a -y

ENV PATH="/opt/conda/envs/analysis/bin:/opt/conda/envs/visualization/bin:$PATH"
```

### Adding Database Downloads

Add to the external tools section:
```dockerfile
# Download databases
RUN bash /app/scripts/download_databases.sh
ENV DATABASE_PATH=/app/databases
```

### Custom Build Steps

Replace the build section:
```dockerfile
WORKDIR /tmp/build
RUN wget https://example.com/tool.tar.gz && \
    tar -xzf tool.tar.gz && \
    cd tool && \
    ./configure --prefix=/usr/local && \
    make && make install
```

## Best Practices Included

1. **Reproducible Builds**:
   - UTF-8 locale configuration
   - Pinned package versions in environment.yml
   - Non-interactive package installation

2. **Efficient Layering**:
   - System packages in single RUN command
   - Build artifact cleanup
   - Smart caching with COPY order

3. **Runtime Flexibility**:
   - Volume declarations for data
   - Configurable temporary directories
   - Environment variable overrides

4. **Robust Environment Activation**:
   - System-wide conda activation
   - Fallback activation scripts
   - Conda/mamba command aliases

5. **Comprehensive Verification**:
   - Build-time tool verification
   - Runtime environment checks
   - Clear error messages

## Testing Your Dockerfile

```bash
# Build the image
docker build -t your-project .

# Test basic functionality
docker run --rm your-project --help

# Test with data mounting
docker run --rm -v $(pwd)/test_data:/data your-project

# Interactive testing
docker run --rm -it your-project bash
```

## Template Maintenance

This template should be updated when:
- New best practices are discovered
- Base images are updated
- Common patterns emerge across projects
- Security improvements are identified

## Example Projects Using This Template

- **NC_Barcode_QC_gDNA_docker**: PacBio barcode QC analysis
- **HiFi-16S-workflow**: 16S rRNA analysis pipeline
- Future Nucleomics-VIB projects

## Support

For questions or improvements to this template, please:
1. Check existing project Dockerfiles for examples
2. Review Docker best practices documentation
3. Contact the Nucleomics-VIB team