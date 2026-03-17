# AI Instructions

<!--
AI_INSTRUCTIONS.md
Purpose: Defines the rules, behavioral guidelines, and architectural standards for Copilot in this workspace.
Usage: Copilot reads this file before responding to ensure all instructions are followed. Update this file to modify rules.
-->

## 🚨 CRITICAL RULE: Read Memory Files First - MANDATORY

**Before EVERY response or action, you MUST:**

1. Read all 3 memory files from `AI_files/`:
   - `AI_INSTRUCTIONS.md` (THIS FILE)
   - `CURRENT_CONTEXT.md`
   - `SESSION_DECISIONS.md`

2. Verify all rules are understood and will be followed
3. Check CURRENT_CONTEXT.md for any flags or state changes
4. Confirm no conflicting decisions in SESSION_DECISIONS.md

**Failure to read memory files = MEMORY LOSS = UNACCEPTABLE**

If you skip this step, you will violate rules, repeat errors, and frustrate the user.

---

## 🚨 CRITICAL RULE: Terminal Command Execution

**IMPORTANT:** VS Code's integration with Copilot has known issues with terminal sessions.

### The Problem

- Copilot-created terminal sessions WILL not function correctly in VS Code
- User's personal terminal works fine, but Copilot cannot reliably use it
- Commands run in a new terminal session WILL fail due to bad ENV support (known unfixed bug)

### The Rule

**NEVER execute terminal commands using the `run_in_terminal` tool unless explicitly requested.**

### What to Do Instead

**Provide commands as copy-to-terminal code blocks:**

```bash
# Example: Commands formatted for user to copy-paste
command1 arg1 arg2
command2 arg1 arg2
```

The code block will display copy icons automatically—user clicks and pastes into their terminal.

### Enforcement

**Before executing ANY action with `run_in_terminal`:**

1. Stop. Do not proceed.
2. Ask yourself: "Did the user explicitly request command execution?"
3. If NO: Provide copy-to-terminal code block instead
4. If YES: Proceed with caution and inform user

### Exceptions

The user may request command execution for:

- Running tests or builds
- Starting development servers
- Installing dependencies
- Git operations

**In these cases:** Acknowledge the request and execute, but inform user about potential issues.

---

## 🔐 CRITICAL RULE: Never Hardcode Credentials or Secrets

**IMPORTANT:** Never hardcode credentials, API keys, passwords, tokens, or any sensitive data directly in code files.

### The Rule

**ALWAYS externalize sensitive data to environment files or secure configuration:**

1. **Use `.env` files** for credentials and secrets
2. **Provide `.env.template`** as a documented example
3. **Add `.env` to `.gitignore`** to prevent accidental commits
4. **Load environment variables** at runtime using appropriate libraries

### Environment File Template

**Create `.env.template` (committed to Git):**

```bash
# .env.template - Template for environment variables
# Copy this file to .env and fill in your actual values
# NEVER commit .env to version control!

# ============================================================================
# Application Configuration
# ============================================================================
APP_NAME=my_application
APP_ENV=development
DEBUG=true

# ============================================================================
# Security & Authentication
# ============================================================================
# Secret key for session encryption (generate with: openssl rand -hex 32)
SECRET_KEY=your_secret_key_here

# JWT authentication (generate with: openssl rand -base64 32)
JWT_SECRET=your_jwt_secret_here
JWT_EXPIRATION=3600

# ============================================================================
# Database Credentials
# ============================================================================
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp_db
DB_USER=myapp_user
DB_PASSWORD=your_database_password_here

# Database connection string (alternative to individual values)
# DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# ============================================================================
# External APIs & Services
# ============================================================================
# API Keys (never share these!)
OPENAI_API_KEY=sk-your-openai-api-key
STRIPE_API_KEY=sk_test_your_stripe_key
SENDGRID_API_KEY=SG.your-sendgrid-api-key

# Service URLs
API_BASE_URL=https://api.example.com
WEBHOOK_URL=https://yourapp.com/webhook

# ============================================================================
# Cloud Storage
# ============================================================================
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-bucket-name

# ============================================================================
# Email Configuration
# ============================================================================
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@example.com
SMTP_PASSWORD=your_email_password
EMAIL_FROM=noreply@example.com

# ============================================================================
# Logging & Monitoring
# ============================================================================
LOG_LEVEL=INFO
SENTRY_DSN=https://your-sentry-dsn@sentry.io/project

# ============================================================================
# Feature Flags
# ============================================================================
ENABLE_ANALYTICS=true
ENABLE_CACHING=true
MAINTENANCE_MODE=false
```

**Create `.env` (user fills this out, never committed):**

User copies `.env.template` to `.env` and fills in real values.

**Update `.gitignore`:**

```gitignore
# Environment variables
.env
.env.local
.env.*.local

# Keep template
!.env.template
!.env.example
```

### Loading Environment Variables

**Python:**
```python
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Access variables
api_key = os.getenv('OPENAI_API_KEY')
db_password = os.getenv('DB_PASSWORD')

# With default values
debug = os.getenv('DEBUG', 'false').lower() == 'true'
```

**Node.js/JavaScript:**
```javascript
require('dotenv').config();

// Access variables
const apiKey = process.env.OPENAI_API_KEY;
const dbPassword = process.env.DB_PASSWORD;

// With defaults
const debug = process.env.DEBUG === 'true';
```

**R:**
```r
library(dotenv)

# Load .env file
load_dot_env()

# Access variables
api_key <- Sys.getenv("OPENAI_API_KEY")
db_password <- Sys.getenv("DB_PASSWORD")
```

**Bash:**
```bash
# Source .env file
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Access variables
echo $OPENAI_API_KEY
```

---

## 📋 CRITICAL RULE: Externalize Configuration to YAML Files

**IMPORTANT:** When scripts require multiple configuration variables (paths, settings, options), externalize them to a `config.yaml` file instead of hardcoding.

### The Rule

**ALWAYS use configuration files for:**

1. **File paths** - Input/output directories, data locations
2. **Application settings** - Thresholds, parameters, options
3. **Environment-specific configs** - Development vs production
4. **User-customizable values** - Any value users might need to change

### Configuration YAML Template

**Create `config.yaml.template` (committed to Git):**

```yaml
# config.yaml.template - Configuration template
# Copy this file to config.yaml and customize for your environment
# This file can be committed if it doesn't contain secrets

# ============================================================================
# Application Metadata
# ============================================================================
application:
  name: "My Application"
  version: "1.0.0"
  environment: "development"  # development, staging, production
  debug: true

# ============================================================================
# File Paths & Directories
# ============================================================================
paths:
  # Input directories
  data_dir: "./data"
  input_dir: "./data/input"
  raw_data: "./data/raw"
  
  # Output directories
  output_dir: "./output"
  results_dir: "./output/results"
  reports_dir: "./output/reports"
  figures_dir: "./output/figures"
  logs_dir: "./logs"
  
  # Cache and temporary
  cache_dir: "./cache"
  temp_dir: "./tmp"
  
  # Specific files
  database_file: "./data/database.db"
  config_file: "./config/settings.json"

# ============================================================================
# Processing Parameters
# ============================================================================
processing:
  # General settings
  batch_size: 100
  max_workers: 4
  timeout_seconds: 300
  
  # Data processing
  chunk_size: 1000
  max_memory_mb: 2048
  enable_parallel: true
  
  # Quality control
  min_quality_score: 0.8
  remove_duplicates: true
  validate_inputs: true

# ============================================================================
# Analysis Settings
# ============================================================================
analysis:
  # Statistical parameters
  confidence_level: 0.95
  significance_threshold: 0.05
  min_sample_size: 30
  
  # Algorithm settings
  random_seed: 42
  max_iterations: 1000
  convergence_threshold: 0.0001
  
  # Feature selection
  feature_selection_method: "auto"  # auto, manual, all
  max_features: 50
  
# ============================================================================
# Database Configuration
# ============================================================================
database:
  # Connection settings (use .env for credentials!)
  host: "localhost"
  port: 5432
  name: "myapp_db"
  pool_size: 10
  
  # Query settings
  timeout_seconds: 30
  enable_query_cache: true
  batch_insert_size: 500

# ============================================================================
# API Configuration
# ============================================================================
api:
  # Server settings
  host: "0.0.0.0"
  port: 8000
  base_url: "/api/v1"
  
  # Request settings
  max_requests_per_minute: 60
  request_timeout_seconds: 30
  enable_cors: true
  
  # Response settings
  enable_compression: true
  max_response_size_mb: 10

# ============================================================================
# Logging Configuration
# ============================================================================
logging:
  # Log levels: DEBUG, INFO, WARNING, ERROR, CRITICAL
  level: "INFO"
  
  # Output destinations
  console_output: true
  file_output: true
  log_file: "./logs/app.log"
  
  # Formatting
  include_timestamp: true
  include_function_name: true
  date_format: "%Y-%m-%d %H:%M:%S"
  
  # Rotation
  max_file_size_mb: 10
  backup_count: 5

# ============================================================================
# Visualization Settings
# ============================================================================
visualization:
  # Figure settings
  figure_width: 10
  figure_height: 6
  dpi: 300
  
  # Style
  theme: "default"  # default, dark, minimal
  color_palette: "viridis"
  font_size: 12
  
  # Output
  save_format: "png"  # png, pdf, svg
  save_figures: true

# ============================================================================
# Email/Notification Settings
# ============================================================================
notifications:
  # Email settings (use .env for SMTP credentials!)
  enabled: true
  smtp_host: "smtp.gmail.com"
  smtp_port: 587
  
  # Recipients
  admin_email: "admin@example.com"
  error_recipients:
    - "dev-team@example.com"
    - "alerts@example.com"
  
  # Conditions
  notify_on_error: true
  notify_on_completion: false
  notify_on_warning: true

# ============================================================================
# Feature Flags
# ============================================================================
features:
  enable_caching: true
  enable_analytics: true
  enable_experimental_features: false
  enable_profiling: false
  enable_auto_backup: true

# ============================================================================
# Resource Limits
# ============================================================================
limits:
  max_file_size_mb: 100
  max_concurrent_jobs: 5
  max_execution_time_minutes: 60
  max_retry_attempts: 3
  
# ============================================================================
# Data Validation Rules
# ============================================================================
validation:
  # Required columns for input data
  required_columns:
    - "id"
    - "timestamp"
    - "value"
  
  # Data types
  column_types:
    id: "string"
    timestamp: "datetime"
    value: "numeric"
  
  # Value ranges
  value_ranges:
    value:
      min: 0
      max: 100

# ============================================================================
# Custom User Settings
# ============================================================================
user_settings:
  # Add your custom settings here
  custom_parameter_1: "value1"
  custom_parameter_2: 42
  custom_list:
    - "item1"
    - "item2"
    - "item3"
```

### Loading Configuration in Code

**Python:**
```python
import yaml
from pathlib import Path

def load_config(config_file='config.yaml'):
    """Load configuration from YAML file."""
    config_path = Path(config_file)
    
    if not config_path.exists():
        raise FileNotFoundError(
            f"Configuration file not found: {config_file}\n"
            f"Copy config.yaml.template to config.yaml and customize it."
        )
    
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
    
    return config

# Usage
config = load_config()
data_dir = config['paths']['data_dir']
batch_size = config['processing']['batch_size']
log_level = config['logging']['level']
```

**R:**
```r
library(yaml)

#' Load Configuration from YAML
#'
#' @param config_file Path to config.yaml file
#' @return List containing configuration
load_config <- function(config_file = "config.yaml") {
  if (!file.exists(config_file)) {
    stop(sprintf(
      "Configuration file not found: %s\nCopy config.yaml.template to config.yaml",
      config_file
    ))
  }
  
  config <- yaml::read_yaml(config_file)
  return(config)
}

# Usage
config <- load_config()
data_dir <- config$paths$data_dir
batch_size <- config$processing$batch_size
log_level <- config$logging$level
```

**Node.js/JavaScript:**
```javascript
const fs = require('fs');
const yaml = require('js-yaml');

function loadConfig(configFile = 'config.yaml') {
  if (!fs.existsSync(configFile)) {
    throw new Error(
      `Configuration file not found: ${configFile}\n` +
      'Copy config.yaml.template to config.yaml and customize it.'
    );
  }
  
  const fileContents = fs.readFileSync(configFile, 'utf8');
  const config = yaml.load(fileContents);
  
  return config;
}

// Usage
const config = loadConfig();
const dataDir = config.paths.data_dir;
const batchSize = config.processing.batch_size;
const logLevel = config.logging.level;
```

**Bash:**
```bash
#!/usr/bin/env bash

# Simple YAML parser for bash (requires yq or python)

load_config() {
    local config_file="${1:-config.yaml}"
    
    if [ ! -f "$config_file" ]; then
        echo "ERROR: Configuration file not found: $config_file" >&2
        echo "Copy config.yaml.template to config.yaml" >&2
        exit 1
    fi
    
    # Option 1: Using yq (if installed)
    if command -v yq &> /dev/null; then
        # Example: get value
        DATA_DIR=$(yq eval '.paths.data_dir' "$config_file")
        BATCH_SIZE=$(yq eval '.processing.batch_size' "$config_file")
    else
        # Option 2: Using python (more portable)
        DATA_DIR=$(python3 -c "import yaml; print(yaml.safe_load(open('$config_file'))['paths']['data_dir'])")
        BATCH_SIZE=$(python3 -c "import yaml; print(yaml.safe_load(open('$config_file'))['processing']['batch_size'])")
    fi
}
```

### Setup Instructions Template

**Create `SETUP.md` or include in `README.md`:**

```markdown
## Configuration Setup

### 1. Environment Variables (Secrets)

Copy the environment template and add your credentials:

\`\`\`bash
cp .env.template .env
\`\`\`

Edit `.env` and fill in your actual credentials:
- Database passwords
- API keys
- Secret keys
- Service credentials

**IMPORTANT:** Never commit `.env` to Git!

### 2. Application Configuration

Copy the configuration template:

\`\`\`bash
cp config.yaml.template config.yaml
\`\`\`

Edit `config.yaml` to customize:
- File paths for your environment
- Processing parameters
- Feature flags
- Resource limits

This file can be committed if it doesn't contain secrets.

### 3. Verify Setup

\`\`\`bash
# Check environment variables are loaded
python -c "from dotenv import load_dotenv; load_dotenv(); import os; print('✓ Loaded' if os.getenv('SECRET_KEY') else '✗ Missing')"

# Check config file exists
test -f config.yaml && echo "✓ Config found" || echo "✗ Config missing"
\`\`\`
```

---

## General Behavioral Rules

### Code Quality

- **Review before editing** - Verify file paths, syntax, and logic before any `replace_string_in_file` calls
- **Be methodical** - Don't rush edits; slow down and verify
- **Test mentally** - Think through the logic before proposing code changes
- **Prefer readability** - Simple, clear code over clever optimizations
- **Use appropriate tools** - `read_file` for viewing, edit tools for modifications
- **Externalize configuration** - Use `.env` for secrets, `config.yaml` for settings
- **Never hardcode credentials** - Always use environment variables or secure vaults

### Communication

- **Be concise** - Keep responses short and actionable
- **Explain decisions** - Brief rationale for non-obvious choices
- **Ask for clarification** - Don't assume when uncertain
- **Acknowledge errors** - Admit mistakes immediately and correct them

### File Organization

- **Respect structure** - Follow existing project organization
- **Use relative paths** - Paths should work from any workspace location
- **Document significant changes** - Update SESSION_DECISIONS.md after major edits

### Safety

- **Never delete without confirmation** - Ask before removing files or large code blocks
- **Backup important data** - Suggest backups before risky operations
- **Validate inputs** - Check file existence, paths, and permissions

---

## Coding Standards (Language-Specific)

### Bash Scripts

Follow standards in `.github/copilot-skills/bash-skills.md`:

- Use `#!/usr/bin/env bash` shebang
- Include complete header with script name, author, date, version, usage, dependencies
- Set strict mode: `set -euo pipefail`
- Validate all dependencies before execution
- Parse arguments with `getopt`
- Validate all inputs comprehensively
- Implement cleanup traps
- Include logging functions

### R Scripts

Follow standards in `.github/copilot-skills/rscript-skills.md`:

- Use `#!/usr/bin/env Rscript` shebang
- Include complete header with metadata
- Check and load required packages with error messages
- Set reproducibility options (stringsAsFactors, seed, etc.)
- Document all functions with roxygen-style comments
- Validate inputs (data frames, files, parameters)
- Use tryCatch for error handling
- Follow tidyverse style conventions

### Other Languages

Apply consistent standards:

- Clear naming conventions
- Comprehensive error handling
- Input validation
- Inline documentation
- Unit test coverage where appropriate

---

## Project-Specific Rules

*Add your project-specific rules here. Examples:*

### Example: API Development

- All endpoints must include OpenAPI documentation
- Use async/await for all asynchronous operations
- Implement rate limiting on public endpoints
- Log all errors with structured logging

### Example: Docker Projects

- Always use multi-stage builds for smaller images
- Pin specific versions for base images (no :latest)
- Run containers as non-root users
- Include health checks in docker-compose.yml

### Example: Data Science

- Set random seed for reproducibility
- Document data sources and transformations
- Include data validation before analysis
- Export results with metadata (timestamp, version, parameters)

---

## Tool Usage Guidelines

### File Operations

- ✅ **Use `read_file`** to view file contents
- ✅ **Use `file_search`** to find files by pattern
- ✅ **Use `grep_search`** for text search in files
- ✅ **Use `semantic_search`** for conceptual searches
- ✅ **Use edit tools** (`replace_string_in_file`, `create_file`) for modifications
- ❌ **Don't use terminal commands** for file operations unless necessary

### Code Navigation

- ✅ **Use `list_code_usages`** to find references and implementations
- ✅ **Use `grep_search`** for code patterns
- ✅ **Use `semantic_search`** for architectural understanding
- ✅ **Read large context** - prefer single large reads over many small reads

### Version Control

- ✅ **Use Git tools** when available
- ✅ **Check `get_changed_files`** before major edits
- ✅ **Review diffs** before suggesting commits
- ❌ **Don't assume clean working directory** - always check first

---

## Error Handling and Recovery

### When Things Go Wrong

1. **Acknowledge the error** immediately
2. **Explain what happened** and why
3. **Provide solution** or correction
4. **Document in SESSION_DECISIONS.md** if pattern should be avoided
5. **Update AI_INSTRUCTIONS.md** if new rule needed

### Common Mistakes to Avoid

- ❌ Using wrong file paths (verify before editing)
- ❌ Assuming file structure (read and confirm)
- ❌ Ignoring error messages (read and address)
- ❌ Skipping validation (always validate inputs)
- ❌ Over-complicated solutions (prefer simple approaches)

---

## Decision Documentation

### When to Update SESSION_DECISIONS.md

Update after:

- ✅ Architectural decisions
- ✅ Technology choices
- ✅ Design pattern selections
- ✅ Significant refactoring
- ✅ New features or modules
- ✅ Bug fixes with lessons learned

### Decision Format

```markdown
## YYYY-MM-DD: Decision Title

### What Was Decided
Brief description of the decision

### Rationale
Why this choice was made

### Alternatives Considered
Other options and why they weren't chosen

### Implementation
How this will be/was implemented

### Status
✅ Completed / ⏳ In Progress / 🚫 Blocked
```

---

## Enforcement and Accountability

### Rule Violations

If a rule is violated:

1. **User catches it** - User will point out the violation
2. **Agent acknowledges** - Immediately admit the mistake
3. **Agent explains** - Describe what went wrong
4. **Agent corrects** - Provide correct approach
5. **Document** - Add to SESSION_DECISIONS.md with prevention strategy

### Continuous Improvement

- Review rules regularly
- Update based on patterns and needs
- Simplify overly complex rules
- Remove obsolete rules
- Add new rules as needed

---

## Template Sections (Customize for Your Project)

### Project-Specific Constraints

*Example: "All database migrations must be reversible"*

### Architectural Patterns

*Example: "Use repository pattern for data access"*

### Security Requirements

*Example: "Never log sensitive data (passwords, tokens, PII)"*

### Performance Guidelines

*Example: "Cache API responses for at least 5 minutes"*

### Testing Requirements

*Example: "Unit tests required for all business logic"*

### Documentation Standards

*Example: "README must include setup, usage, and deployment sections"*

---

## Quick Reference Card

**Before Responding:**
☐ Read AI_INSTRUCTIONS.md
☐ Read CURRENT_CONTEXT.md
☐ Read SESSION_DECISIONS.md
☐ Understand the request
☐ Apply rules and context

**After Completing:**
☐ Verify output matches requirements
☐ Update SESSION_DECISIONS.md if needed
☐ Confirm no rules violated

**When Uncertain:**
☐ Ask for clarification
☐ Don't guess or assume
☐ Reference previous decisions
☐ Propose options for user to choose

---

*Last Updated: 2025-11-07*
*This file should be reviewed and updated regularly to reflect current project needs.*
