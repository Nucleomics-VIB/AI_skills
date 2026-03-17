#!/usr/bin/env bash
###############################################################################
# AI Workspace Setup Script
#
# Description:  Create a AI-enhanced workspace memory system for GitHub Copilot
#               Run after copying the .github/ folder to your project.  
#
# Author:       SP@NC + AI
# Date:         2025-11-07
# Version:      1.0
#
# Usage:        chmod +x .github/setup.sh && .github/setup.sh
#
###############################################################################

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Version
readonly VERSION="1.0"

#######################################
# Print colored message
# Arguments:
#   $1: color code
#   $2: message
#######################################
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

#######################################
# Print section header
#######################################
print_header() {
    echo ""
    print_color "$BLUE" "================================"
    print_color "$BLUE" "$1"
    print_color "$BLUE" "================================"
    echo ""
}

#######################################
# Verify file structure
#######################################
verify_structure() {
    print_header "Verifying .github Structure"
    
    local all_ok=true
    
    # Check required directories
    local required_dirs=(
        "AI_files"
        "copilot-skills"
        ".vscode"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "${SCRIPT_DIR}/${dir}" ]]; then
            print_color "$GREEN" "✓ ${dir}/ found"
        else
            print_color "$RED" "✗ ${dir}/ missing"
            all_ok=false
        fi
    done
    
    # Check required files
    local required_files=(
        "AI_files/AI_INSTRUCTIONS.md"
        "AI_files/CURRENT_CONTEXT.md"
        "AI_files/SESSION_DECISIONS.md"
        "AI_files/README.md"
        "copilot-instructions.md"
        ".vscode/settings.json"
        ".gitignore"
    )
    
    for file in "${required_files[@]}"; do
        if [[ -f "${SCRIPT_DIR}/${file}" ]]; then
            print_color "$GREEN" "✓ ${file} found"
        else
            print_color "$RED" "✗ ${file} missing"
            all_ok=false
        fi
    done
    
    if [[ "$all_ok" == "true" ]]; then
        print_color "$GREEN" "✓ All required files and folders present"
        return 0
    else
        print_color "$RED" "✗ Some files or folders are missing"
        return 1
    fi
}

#######################################
# Show customization checklist
#######################################
show_checklist() {
    print_header "Customization Checklist"
    
    print_color "$YELLOW" "Edit these files for your project:"
    echo ""
    echo "  1. AI_files/AI_INSTRUCTIONS.md"
    echo "     → Add your coding standards and rules"
    echo ""
    echo "  2. AI_files/CURRENT_CONTEXT.md"
    echo "     → Describe your technology stack"
    echo "     → Document your directory structure"
    echo "     → List environment details"
    echo ""
    echo "  3. AI_files/SESSION_DECISIONS.md"
    echo "     → Document your initial setup decision"
    echo "     → Add any architectural choices made"
    echo ""
    
    print_color "$BLUE" "Optional customizations:"
    echo ""
    echo "  • Add language-specific skills in copilot-skills/"
    echo "  • Customize .vscode/settings.json"
    echo "  • Update .gitignore for your project"
    echo ""
}

#######################################
# Check for VS Code
#######################################
check_vscode() {
    print_header "Checking for VS Code"
    
    if command -v code &> /dev/null; then
        print_color "$GREEN" "✓ VS Code CLI found"
        print_color "$BLUE" "  Run: code . (to open workspace)"
        return 0
    else
        print_color "$YELLOW" "⚠ VS Code CLI not found in PATH"
        print_color "$YELLOW" "  Install VS Code or add 'code' to your PATH"
        return 1
    fi
}

#######################################
# Show next steps
#######################################
show_next_steps() {
    print_header "Next Steps"
    
    echo "1. Customize AI files (5 minutes):"
    print_color "$BLUE" "   cd ${SCRIPT_DIR}/AI_files"
    echo "   Edit AI_INSTRUCTIONS.md, CURRENT_CONTEXT.md, SESSION_DECISIONS.md"
    echo ""
    
    echo "2. Open workspace in VS Code:"
    print_color "$BLUE" "   code ."
    echo ""
    
    echo "3. Test Copilot integration:"
    echo "   Ask: 'What rules should you follow for this project?'"
    echo ""
    
    echo "4. Start coding with persistent AI memory! 🚀"
    echo ""
    
    print_color "$GREEN" "For detailed documentation, see:"
    echo "  • ${SCRIPT_DIR}/AI_files/README.md"
    echo "  • SETUP_GUIDE.md (in template repository)"
    echo ""
}

#######################################
# Main execution
#######################################
main() {
    print_color "$GREEN" "╔════════════════════════════════════════╗"
    print_color "$GREEN" "║  AI Workspace Setup v${VERSION}              ║"
    print_color "$GREEN" "╚════════════════════════════════════════╝"
    
    # Verify structure
    if ! verify_structure; then
        print_color "$RED" "Setup cannot continue with missing files."
        exit 1
    fi
    
    # Show customization steps
    show_checklist
    
    # Check for VS Code
    check_vscode
    
    # Show next steps
    show_next_steps
    
    print_color "$GREEN" "✓ Setup verification complete!"
}

# Run main function
main "$@"
