---
name: bash-skills
description: Ensures all Bash scripts follow best practices with proper shebangs, documentation headers (script name, author, date, version, usage), dependency lists, argument parsing with getopt and validation, and comprehensive input validation. Use this skill whenever writing Bash scripts.
---

# Bash Coding Standards

This skill ensures all Bash scripts follow professional standards with complete documentation, argument parsing, and validation.

## Core Requirements

Every Bash script MUST include these elements in order:

### 1. Shebang
Always start with:
```bash
#!/usr/bin/env bash
```

Never use \`#!/bin/bash\` as it's not portable across systems.

### 2. Header Comment Block
Immediately after the shebang, include:

```bash
#!/usr/bin/env bash
#
# Script Name: process_data.sh
# Author: Jane Smith <jane@example.com>
# Date: 2025-10-17
# Version: 1.0.0
# Usage: ./process_data.sh -i INPUT_FILE -o OUTPUT_FILE [-v]
#
# Description:
#   Processes input data files and generates formatted output.
#   Supports multiple input formats and validation.
#
# Dependencies:
# - bash >= 4.0
# - jq >= 1.6
# - awk
# - sed
```

**Required fields:**
- **Script Name**: The actual filename
- **Author**: Your name and optionally email
- **Date**: Creation date in YYYY-MM-DD format
- **Version**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Usage**: Command syntax showing all options
- **Description**: (Optional but recommended) What the script does
- **Dependencies**: Every external command or tool required

### 3. Set Strict Mode
Immediately after the header, add:

```bash
set -euo pipefail
```

This ensures:
- \`set -e\`: Exit immediately if any command fails
- \`set -u\`: Exit if undefined variables are used
- \`set -o pipefail\`: Catch errors in pipes

### 4. Dependency Validation
Check all dependencies before execution:

```bash
check_dependencies() {
    local deps=("$@")
    local missing=()
    
    for cmd in "\${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ \${#missing[@]} -ne 0 ]; then
        echo "ERROR: Missing required dependencies:" >&2
        printf '  - %s\\n' "\${missing[@]}" >&2
        echo "" >&2
        echo "Please install missing dependencies and try again." >&2
        exit 1
    fi
}

# Call early in script
check_dependencies "jq" "awk" "sed"
```

### 5. Usage Function
Always include a comprehensive help function:

```bash
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Description:
    Brief description of what the script does and its purpose.
    Can span multiple lines for clarity.

Required Options:
    -i, --input FILE        Input file path

Optional Arguments:
    -o, --output FILE       Output file path (default: stdout)
    -v, --verbose           Enable verbose output
    -h, --help              Show this help message and exit

Examples:
    $(basename "$0") -i data.csv -o results.json
    $(basename "$0") --input file.txt --output processed.txt --verbose
    $(basename "$0") -i input.log -v

EOF
}
```

### 6. Argument Parsing with getopt
For scripts that accept user input, use getopt for robust parsing:

```bash
parse_arguments() {
    # Set defaults
    local verbose=false
    local input_file=""
    local output_file=""
    
    # Parse options using getopt
    local TEMP
    TEMP=$(getopt -o 'vhi:o:' \\\\
                   --long 'verbose,help,input:,output:' \\\\
                   -n "$(basename "$0")" -- "$@")
    
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to parse arguments" >&2
        echo "" >&2
        usage
        exit 1
    fi
    
    eval set -- "$TEMP"
    unset TEMP
    
    # Process parsed options
    while true; do
        case "$1" in
            '-v'|'--verbose')
                verbose=true
                shift
                continue
                ;;
            '-h'|'--help')
                usage
                exit 0
                ;;
            '-i'|'--input')
                input_file="$2"
                shift 2
                continue
                ;;
            '-o'|'--output')
                output_file="$2"
                shift 2
                continue
                ;;
            '--')
                shift
                break
                ;;
            *)
                echo "ERROR: Internal error parsing arguments" >&2
                exit 1
                ;;
        esac
    done
    
    # Export variables for use in main script
    export INPUT_FILE="$input_file"
    export OUTPUT_FILE="$output_file"
    export VERBOSE="$verbose"
}
```

**Short options**: Single letter with dash (\`-i\`, \`-v\`)  
**Long options**: Full words with double dash (\`--input\`, \`--verbose\`)  
**Options with arguments**: Followed by colon in getopt string (\`-i:\` or \`--input:\`)

### 7. Input Validation
Always validate all inputs after parsing:

```bash
validate_inputs() {
    local input_file="$1"
    local output_file="$2"
    
    # Check required arguments
    if [ -z "$input_file" ]; then
        echo "ERROR: Input file is required (-i or --input)" >&2
        echo "" >&2
        usage
        exit 1
    fi
    
    # Check file exists
    if [ ! -e "$input_file" ]; then
        echo "ERROR: Input file does not exist: $input_file" >&2
        exit 1
    fi
    
    # Check it's a regular file
    if [ ! -f "$input_file" ]; then
        echo "ERROR: Input path is not a file: $input_file" >&2
        exit 1
    fi
    
    # Check file is readable
    if [ ! -r "$input_file" ]; then
        echo "ERROR: Input file is not readable: $input_file" >&2
        echo "Check file permissions." >&2
        exit 1
    fi
    
    # Check file is not empty
    if [ ! -s "$input_file" ]; then
        echo "ERROR: Input file is empty: $input_file" >&2
        exit 1
    fi
    
    # Validate output path if provided
    if [ -n "$output_file" ]; then
        local output_dir
        output_dir=$(dirname "$output_file")
        
        # Check output directory exists
        if [ ! -d "$output_dir" ]; then
            echo "ERROR: Output directory does not exist: $output_dir" >&2
            exit 1
        fi
        
        # Check output directory is writable
        if [ ! -w "$output_dir" ]; then
            echo "ERROR: Output directory is not writable: $output_dir" >&2
            exit 1
        fi
        
        # Check if output file exists and warn
        if [ -f "$output_file" ]; then
            echo "WARNING: Output file already exists and will be overwritten: $output_file" >&2
        fi
    fi
}
```

**Additional validation helpers:**

```bash
# Validate positive integer
validate_number() {
    local value="$1"
    local name="$2"
    
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "ERROR: $name must be a positive integer: $value" >&2
        exit 1
    fi
}

# Validate email format
validate_email() {
    local email="$1"
    
    if ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\\\.[a-zA-Z]{2,}$ ]]; then
        echo "ERROR: Invalid email address: $email" >&2
        exit 1
    fi
}

# Validate URL format
validate_url() {
    local url="$1"
    
    if ! [[ "$url" =~ ^https?:// ]]; then
        echo "ERROR: Invalid URL (must start with http:// or https://): $url" >&2
        exit 1
    fi
}

# Validate directory exists and is writable
validate_directory() {
    local dir="$1"
    local name="$2"
    
    if [ ! -d "$dir" ]; then
        echo "ERROR: $name directory does not exist: $dir" >&2
        exit 1
    fi
    
    if [ ! -w "$dir" ]; then
        echo "ERROR: $name directory is not writable: $dir" >&2
        exit 1
    fi
}

# Validate choice from list
validate_choice() {
    local value="$1"
    local name="$2"
    shift 2
    local valid_choices=("$@")
    
    for choice in "\${valid_choices[@]}"; do
        if [ "$value" = "$choice" ]; then
            return 0
        fi
    done
    
    echo "ERROR: Invalid $name: $value" >&2
    echo "Valid choices: \${valid_choices[*]}" >&2
    exit 1
}
```

### 8. Error Handling and Cleanup
Always set up proper error handling:

```bash
# Cleanup function that runs on exit
cleanup() {
    local exit_code=$?
    
    # Remove temporary files
    rm -f /tmp/myscript_$$_*
    
    # Close connections, unmount, etc.
    
    # Exit with original code
    exit $exit_code
}

# Register cleanup to run on exit
trap cleanup EXIT

# Optional: Handle specific signals
trap 'echo "Script interrupted" >&2; exit 130' INT
trap 'echo "Script terminated" >&2; exit 143' TERM
```

**Error helper function:**

```bash
error_exit() {
    local message="$1"
    local exit_code="\${2:-1}"
    
    echo "ERROR: $message" >&2
    exit "$exit_code"
}

# Usage: error_exit "Failed to process file" 2
```

### 9. Logging Functions
Include logging for better debugging:

```bash
log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_warning() {
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_debug() {
    if [ "\${DEBUG:-false}" = true ] || [ "\${VERBOSE:-false}" = true ]; then
        echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
    fi
}

# Usage in script:
# log_info "Processing file: $filename"
# log_error "Failed to connect to database"
# log_debug "Variable value: $some_var"
```

## Complete Script Template

Here's a complete template following all standards:

```bash
#!/usr/bin/env bash
#
# Script Name: template.sh
# Author: Your Name <you@example.com>
# Date: 2025-10-17
# Version: 1.0.0
# Usage: ./template.sh -i INPUT_FILE [-o OUTPUT_FILE] [-v]
#
# Description:
#   Template script demonstrating all coding standards.
#   Processes input files with validation and error handling.
#
# Dependencies:
# - bash >= 4.0
# - awk
# - sed

set -euo pipefail

#------------------------------------------------------------------------------
# Cleanup and error handling
#------------------------------------------------------------------------------

cleanup() {
    local exit_code=$?
    rm -f /tmp/template_$$_*
    exit $exit_code
}

trap cleanup EXIT
trap 'echo "Script interrupted" >&2; exit 130' INT TERM

#------------------------------------------------------------------------------
# Logging functions
#------------------------------------------------------------------------------

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
}

log_debug() {
    if [ "\${VERBOSE:-false}" = true ]; then
        echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') - $*" >&2
    fi
}

#------------------------------------------------------------------------------
# Dependency checking
#------------------------------------------------------------------------------

check_dependencies() {
    local deps=("$@")
    local missing=()
    
    for cmd in "\${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ \${#missing[@]} -ne 0 ]; then
        log_error "Missing required dependencies:"
        printf '  - %s\\n' "\${missing[@]}" >&2
        exit 1
    fi
}

#------------------------------------------------------------------------------
# Usage information
#------------------------------------------------------------------------------

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Description:
    Template script demonstrating coding standards.
    Replace this with your script's actual purpose.

Required Options:
    -i, --input FILE        Input file path

Optional Arguments:
    -o, --output FILE       Output file path (default: stdout)
    -v, --verbose           Enable verbose output
    -h, --help              Show this help message

Examples:
    $(basename "$0") -i data.txt -o results.txt
    $(basename "$0") --input file.csv --verbose

EOF
}

#------------------------------------------------------------------------------
# Argument parsing
#------------------------------------------------------------------------------

parse_arguments() {
    local verbose=false
    local input_file=""
    local output_file=""
    
    local TEMP
    TEMP=$(getopt -o 'vhi:o:' \\\\
                   --long 'verbose,help,input:,output:' \\\\
                   -n "$(basename "$0")" -- "$@")
    
    if [ $? -ne 0 ]; then
        log_error "Failed to parse arguments"
        echo "" >&2
        usage
        exit 1
    fi
    
    eval set -- "$TEMP"
    unset TEMP
    
    while true; do
        case "$1" in
            '-v'|'--verbose')
                verbose=true
                shift
                continue
                ;;
            '-h'|'--help')
                usage
                exit 0
                ;;
            '-i'|'--input')
                input_file="$2"
                shift 2
                continue
                ;;
            '-o'|'--output')
                output_file="$2"
                shift 2
                continue
                ;;
            '--')
                shift
                break
                ;;
            *)
                log_error "Internal error parsing arguments"
                exit 1
                ;;
        esac
    done
    
    export INPUT_FILE="$input_file"
    export OUTPUT_FILE="$output_file"
    export VERBOSE="$verbose"
}

#------------------------------------------------------------------------------
# Input validation
#------------------------------------------------------------------------------

validate_inputs() {
    local input_file="$1"
    local output_file="$2"
    
    if [ -z "$input_file" ]; then
        log_error "Input file is required (-i or --input)"
        echo "" >&2
        usage
        exit 1
    fi
    
    if [ ! -f "$input_file" ]; then
        log_error "Input file does not exist: $input_file"
        exit 1
    fi
    
    if [ ! -r "$input_file" ]; then
        log_error "Input file is not readable: $input_file"
        exit 1
    fi
    
    if [ ! -s "$input_file" ]; then
        log_error "Input file is empty: $input_file"
        exit 1
    fi
    
    if [ -n "$output_file" ]; then
        local output_dir
        output_dir=$(dirname "$output_file")
        
        if [ ! -d "$output_dir" ]; then
            log_error "Output directory does not exist: $output_dir"
            exit 1
        fi
        
        if [ ! -w "$output_dir" ]; then
            log_error "Output directory is not writable: $output_dir"
            exit 1
        fi
    fi
}

#------------------------------------------------------------------------------
# Main script logic
#------------------------------------------------------------------------------

main() {
    log_info "Starting script execution"
    log_debug "Input file: $INPUT_FILE"
    log_debug "Output file: \${OUTPUT_FILE:-stdout}"
    
    # Check dependencies
    check_dependencies "awk" "sed"
    
    # Your script logic here
    # Example:
    # process_file "$INPUT_FILE" "$OUTPUT_FILE"
    
    log_info "Script completed successfully"
}

#------------------------------------------------------------------------------
# Script entry point
#------------------------------------------------------------------------------

parse_arguments "$@"
validate_inputs "$INPUT_FILE" "$OUTPUT_FILE"
main

exit 0
```

## Validation Checklist

Before completing any Bash script, verify:

- ✅ Shebang: \`#!/usr/bin/env bash\`
- ✅ Header with all fields: name, author, date, version, usage
- ✅ Dependencies listed in header
- ✅ Strict mode: \`set -euo pipefail\`
- ✅ Dependencies checked with \`check_dependencies()\`
- ✅ Usage function exists and is complete
- ✅ Arguments parsed with \`getopt\` (if applicable)
- ✅ All inputs validated
- ✅ Cleanup trap registered
- ✅ Error handling implemented
- ✅ Logging functions used

## When to Use This Skill

Use this skill for:
- Every Bash script, regardless of size
- Command-line tools
- Automation scripts
- System administration scripts
- CI/CD scripts
- Any script that accepts user input
- Scripts that will be maintained or shared`;

        // Create a data URL with the content
        const blob = new Blob([content], { type: 'text/markdown;charset=utf-8' });
        const url = URL.createObjectURL(blob);
        
        // Set the download link href
        document.getElementById('downloadLink').href = url;
