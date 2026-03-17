#!/bin/bash

# customize_dockerfile_template.sh
# Helper script to customize the Dockerfile template for new projects
#
# Usage: ./customize_dockerfile_template.sh PROJECT_NAME BASE_IMAGE ENV_NAME MAIN_SCRIPT
#
# Example: ./customize_dockerfile_template.sh barcode-qc mambaorg/micromamba:1.5.8 pbbioconda barcode_QC_gDNA

set -euo pipefail

# Function to display usage
usage() {
    echo "Usage: $0 PROJECT_NAME BASE_IMAGE ENV_NAME MAIN_SCRIPT"
    echo ""
    echo "Arguments:"
    echo "  PROJECT_NAME  Name of your project (e.g., barcode-qc-gdna)"
    echo "  BASE_IMAGE    Docker base image (e.g., mambaorg/micromamba:1.5.8)"
    echo "  ENV_NAME      Conda environment name (e.g., pbbioconda)"
    echo "  MAIN_SCRIPT   Main script name without .sh (e.g., barcode_QC_gDNA)"
    echo ""
    echo "Examples:"
    echo "  $0 barcode-qc-gdna mambaorg/micromamba:1.5.8 pbbioconda barcode_QC_gDNA"
    echo "  $0 hifi-16s ubuntu:22.04 qiime2-env hifi_16s_workflow"
    echo ""
    echo "This script will:"
    echo "  1. Copy backup/Dockerfile_template to ./Dockerfile"
    echo "  2. Replace all template variables with your values"
    echo "  3. Create a backup of the original template"
    echo ""
    exit 1
}

# Check if correct number of arguments provided
if [ $# -ne 4 ]; then
    echo "Error: Incorrect number of arguments"
    echo ""
    usage
fi

# Assign arguments to variables
PROJECT_NAME="$1"
BASE_IMAGE="$2"
ENV_NAME="$3"
MAIN_SCRIPT="$4"

# Validate inputs
if [[ -z "$PROJECT_NAME" || -z "$BASE_IMAGE" || -z "$ENV_NAME" || -z "$MAIN_SCRIPT" ]]; then
    echo "Error: All arguments must be non-empty"
    usage
fi

# Check if template exists
TEMPLATE_FILE="backup/Dockerfile_template"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file '$TEMPLATE_FILE' not found"
    echo "Make sure you're running this script from the project root directory"
    exit 1
fi

# Check if Dockerfile already exists
if [ -f "Dockerfile" ]; then
    echo "Warning: Dockerfile already exists"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted"
        exit 1
    fi
    # Create backup
    cp Dockerfile "Dockerfile.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Created backup of existing Dockerfile"
fi

# Copy template and perform replacements
echo "Customizing Dockerfile template..."
echo "  Project Name: $PROJECT_NAME"
echo "  Base Image: $BASE_IMAGE"
echo "  Environment Name: $ENV_NAME"
echo "  Main Script: $MAIN_SCRIPT"

# Copy template
cp "$TEMPLATE_FILE" Dockerfile

# Escape special characters for sed
BASE_IMAGE_ESCAPED=$(echo "$BASE_IMAGE" | sed 's/[\/&]/\\&/g')

# Perform replacements
sed -i.tmp "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" Dockerfile
sed -i.tmp "s/{{BASE_IMAGE}}/$BASE_IMAGE_ESCAPED/g" Dockerfile
sed -i.tmp "s/{{ENV_NAME}}/$ENV_NAME/g" Dockerfile
sed -i.tmp "s/{{MAIN_SCRIPT}}/$MAIN_SCRIPT/g" Dockerfile

# Remove temporary file
rm -f Dockerfile.tmp

echo ""
echo "✅ Dockerfile customized successfully!"
echo ""
echo "Next steps:"
echo "1. Review and customize the Dockerfile further if needed"
echo "2. Create or update your environment.yml file"
echo "3. Ensure your scripts/ directory contains the required files"
echo "4. Test the build: docker build -t $PROJECT_NAME ."
echo ""
echo "Template sections you may want to customize:"
echo "- System dependencies (lines ~30-65)"
echo "- Build steps for external tools (lines ~130-150)"
echo "- Database downloads (lines ~195-200)"
echo ""
echo "See backup/README_Dockerfile_template.md for detailed customization guide."