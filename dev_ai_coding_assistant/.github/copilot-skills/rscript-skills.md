---
name: rscript-skills
description: Ensures all R scripts follow best practices with proper headers, documentation, error handling, input validation, and tidyverse style conventions. Use this skill whenever writing R analysis scripts.
---

# R Script Coding Standards

This skill ensures all R scripts follow professional standards with complete documentation, proper structure, and reproducibility.

## Core Requirements

Every R script MUST include these elements in order:

### 1. Script Header
Always start R scripts with:

```r
#!/usr/bin/env Rscript
#
# Script Name: analyze_data.R
# Author: Jane Smith <jane@example.com>
# Date: 2025-10-17
# Version: 1.0.0
# Description:
#   Analyzes experimental data and generates visualizations.
#   Performs statistical tests and exports results to CSV.
#
# Usage: Rscript analyze_data.R input.csv output_dir/
#
# Arguments:
#   input.csv    - Path to input CSV file
#   output_dir/  - Directory for output files
#
# Dependencies:
# - R >= 4.0.0
# - tidyverse >= 2.0.0
# - here >= 1.0.0
```

**Required fields:**
- **Script Name**: The actual filename
- **Author**: Your name and email
- **Date**: Creation date in YYYY-MM-DD format
- **Version**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Description**: What the script does
- **Usage**: Command to run the script
- **Arguments**: Description of command-line arguments
- **Dependencies**: R version and required packages

### 2. Load Required Packages
Always check and load packages at the beginning:

```r
# Required packages
required_packages <- c("tidyverse", "here", "glue")

# Check if packages are installed
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  stop(sprintf(
    "Missing required packages: %s\nInstall with: install.packages(c(%s))",
    paste(missing_packages, collapse = ", "),
    paste(sprintf("'%s'", missing_packages), collapse = ", ")
  ))
}

# Load packages (suppress startup messages)
suppressPackageStartupMessages({
  library(tidyverse)
  library(here)
  library(glue)
})
```

### 3. Set Options and Configuration
Configure R session for consistency:

```r
# Set options for reproducibility
options(
  stringsAsFactors = FALSE,  # Never auto-convert strings to factors
  scipen = 999,              # Avoid scientific notation
  digits = 4,                # Default decimal places
  warn = 1                   # Print warnings as they occur
)

# Set random seed for reproducibility
set.seed(42)

# Configure paths
data_dir <- here("data")
output_dir <- here("output")
fig_dir <- here("figures")

# Create output directories if they don't exist
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)
```

### 4. Function Documentation
Document all functions with clear comments:

```r
#' Calculate Summary Statistics
#'
#' Computes mean, median, standard deviation, and 95% confidence intervals
#' for a numeric vector.
#'
#' @param x Numeric vector of values
#' @param conf_level Confidence level for intervals (default: 0.95)
#' @param na.rm Should NA values be removed? (default: TRUE)
#'
#' @return Named list with components:
#'   - mean: Sample mean
#'   - median: Sample median
#'   - sd: Standard deviation
#'   - ci_lower: Lower CI bound
#'   - ci_upper: Upper CI bound
#'   - n: Sample size
#'
#' @examples
#' data <- rnorm(100, mean = 10, sd = 2)
#' stats <- calculate_summary_stats(data)
#' print(stats)
calculate_summary_stats <- function(x, conf_level = 0.95, na.rm = TRUE) {
  # Input validation
  if (!is.numeric(x)) {
    stop("Input must be numeric")
  }
  
  if (conf_level <= 0 || conf_level >= 1) {
    stop("conf_level must be between 0 and 1")
  }
  
  # Remove NAs
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  
  # Check sufficient data
  if (length(x) < 2) {
    stop("Need at least 2 observations")
  }
  
  # Calculate statistics
  n <- length(x)
  mean_x <- mean(x)
  sd_x <- sd(x)
  se_x <- sd_x / sqrt(n)
  
  # Confidence interval
  alpha <- 1 - conf_level
  t_crit <- qt(1 - alpha/2, df = n - 1)
  
  list(
    mean = mean_x,
    median = median(x),
    sd = sd_x,
    ci_lower = mean_x - t_crit * se_x,
    ci_upper = mean_x + t_crit * se_x,
    n = n
  )
}
```

### 5. Input Validation
Always validate inputs:

```r
#' Validate Data Frame Structure
#'
#' @param df Data frame to validate
#' @param required_cols Character vector of required column names
#' @param numeric_cols Character vector of columns that must be numeric
validate_dataframe <- function(df, required_cols = NULL, numeric_cols = NULL) {
  # Check it's a data frame
  if (!is.data.frame(df)) {
    stop("Input must be a data frame")
  }
  
  # Check not empty
  if (nrow(df) == 0) {
    stop("Data frame is empty")
  }
  
  # Check required columns
  if (!is.null(required_cols)) {
    missing <- setdiff(required_cols, names(df))
    if (length(missing) > 0) {
      stop(glue("Missing required columns: {paste(missing, collapse = ', ')}"))
    }
  }
  
  # Check numeric columns
  if (!is.null(numeric_cols)) {
    for (col in numeric_cols) {
      if (!col %in% names(df)) {
        stop(glue("Column '{col}' not found"))
      }
      if (!is.numeric(df[[col]])) {
        stop(glue("Column '{col}' must be numeric, found {class(df[[col]])[1]}"))
      }
    }
  }
  
  invisible(TRUE)
}

#' Validate File Path
#'
#' @param path File path to check
#' @param must_exist Should the file exist? (default: TRUE)
validate_file <- function(path, must_exist = TRUE) {
  if (!is.character(path) || length(path) != 1) {
    stop("Path must be a single character string")
  }
  
  if (must_exist) {
    if (!file.exists(path)) {
      stop(glue("File does not exist: {path}"))
    }
    
    if (file.info(path)$isdir) {
      stop(glue("Path is a directory, not a file: {path}"))
    }
  }
  
  invisible(TRUE)
}
```

### 6. Error Handling
Use tryCatch for robust error handling:

```r
#' Safely Read CSV File
#'
#' @param file Path to CSV file
#' @param ... Additional arguments for read_csv
safe_read_csv <- function(file, ...) {
  validate_file(file, must_exist = TRUE)
  
  tryCatch(
    {
      message(glue("Reading: {file}"))
      df <- read_csv(file, show_col_types = FALSE, ...)
      message(glue("Loaded {nrow(df)} rows, {ncol(df)} columns"))
      return(df)
    },
    error = function(e) {
      stop(glue("Failed to read '{file}': {e$message}"))
    },
    warning = function(w) {
      warning(glue("Warning reading '{file}': {w$message}"))
    }
  )
}

#' Safely Write CSV File
#'
#' @param data Data frame to write
#' @param file Output path
#' @param backup Create backup if file exists?
safe_write_csv <- function(data, file, backup = TRUE) {
  # Create backup if needed
  if (backup && file.exists(file)) {
    backup_file <- glue("{file}.backup.{format(Sys.time(), '%Y%m%d_%H%M%S')}")
    message(glue("Creating backup: {backup_file}"))
    file.copy(file, backup_file)
  }
  
  tryCatch(
    {
      write_csv(data, file)
      message(glue("Wrote {nrow(data)} rows to: {file}"))
    },
    error = function(e) {
      stop(glue("Failed to write '{file}': {e$message}"))
    }
  )
}
```

### 7. Command Line Arguments
Parse arguments for script execution:

```r
#' Parse Command Line Arguments
#'
#' @return List with parsed arguments
parse_args <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  
  # Check number of arguments
  if (length(args) < 2) {
    cat("Usage: Rscript analyze_data.R input.csv output_dir/\n")
    cat("\n")
    cat("Arguments:\n")
    cat("  input.csv   - Path to input CSV file\n")
    cat("  output_dir/ - Directory for output files\n")
    stop("Insufficient arguments", call. = FALSE)
  }
  
  # Parse arguments
  list(
    input_file = args[1],
    output_dir = args[2]
  )
}

# Use in script
args <- parse_args()
validate_file(args$input_file)
```

### 8. Tidyverse Style Guide
Follow tidyverse conventions:

```r
# GOOD: Use <- for assignment
result <- mean(data$value)

# BAD: Don't use =
result = mean(data$value)

# GOOD: Proper spacing
x <- 1 + 2
y <- c(1, 2, 3)

# BAD: No spacing
x<-1+2
y<-c(1,2,3)

# GOOD: Readable pipes
summary_data <- raw_data %>%
  filter(age > 18) %>%
  group_by(category) %>%
  summarize(
    mean_value = mean(value, na.rm = TRUE),
    sd_value = sd(value, na.rm = TRUE),
    n = n()
  ) %>%
  arrange(desc(mean_value))

# GOOD: Function names (snake_case)
calculate_mean <- function(x) { mean(x, na.rm = TRUE) }
clean_data <- function(df) { df %>% filter(!is.na(value)) }

# BAD: Don't use camelCase or dots
calculateMean <- function(x) { }
clean.data <- function(df) { }

# GOOD: Explicit returns and early exits
divide_safe <- function(x, y) {
  if (y == 0) {
    warning("Division by zero, returning NA")
    return(NA)
  }
  return(x / y)
}

# GOOD: Named arguments in function calls
ggplot(data, aes(x = age, y = height)) +
  geom_point(alpha = 0.5, color = "blue", size = 2) +
  theme_minimal()
```

### 9. Logging and Messages
Provide informative output:

```r
#' Log message with timestamp
#'
#' @param msg Message to log
#' @param level Message level (INFO, WARN, ERROR)
log_message <- function(msg, level = "INFO") {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[%s] %s: %s\n", timestamp, level, msg))
}

# Usage
log_message("Starting analysis")
log_message("Missing values detected", level = "WARN")
log_message("Analysis failed", level = "ERROR")

# Progress messages
message("Step 1/3: Reading data...")
message("Step 2/3: Processing...")
message("Step 3/3: Saving results...")
```

### 10. Complete Script Template

```r
#!/usr/bin/env Rscript
#
# Script Name: analyze_data.R
# Author: Your Name <you@example.com>
# Date: 2025-10-17
# Version: 1.0.0
# Description:
#   Analyzes input data and generates summary statistics and plots.
#
# Usage: Rscript analyze_data.R input.csv output/
#
# Arguments:
#   input.csv - Input data file
#   output/   - Output directory
#
# Dependencies:
# - R >= 4.0.0
# - tidyverse >= 2.0.0

# ============================================================================
# Setup
# ============================================================================

# Check and load packages
required_packages <- c("tidyverse", "here", "glue")
missing <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(missing) > 0) {
  stop(sprintf("Missing packages: %s", paste(missing, collapse = ", ")))
}

suppressPackageStartupMessages({
  library(tidyverse)
  library(here)
  library(glue)
})

# Set options
options(stringsAsFactors = FALSE, scipen = 999, digits = 4)
set.seed(42)

# ============================================================================
# Helper Functions
# ============================================================================

validate_file <- function(path) {
  if (!file.exists(path)) stop(glue("File not found: {path}"))
  invisible(TRUE)
}

log_message <- function(msg) {
  cat(sprintf("[%s] %s\n", format(Sys.time(), "%H:%M:%S"), msg))
}

# ============================================================================
# Main Analysis Functions
# ============================================================================

read_and_validate <- function(file) {
  log_message(glue("Reading: {file}"))
  df <- read_csv(file, show_col_types = FALSE)
  
  # Validate structure
  required_cols <- c("id", "group", "value")
  missing_cols <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(glue("Missing columns: {paste(missing_cols, collapse = ', ')}"))
  }
  
  log_message(glue("Loaded {nrow(df)} rows"))
  return(df)
}

analyze_data <- function(df) {
  log_message("Analyzing data...")
  
  summary <- df %>%
    group_by(group) %>%
    summarize(
      n = n(),
      mean = mean(value, na.rm = TRUE),
      sd = sd(value, na.rm = TRUE),
      median = median(value, na.rm = TRUE),
      .groups = "drop"
    )
  
  return(summary)
}

create_plot <- function(df, output_dir) {
  log_message("Creating plot...")
  
  p <- ggplot(df, aes(x = group, y = value, fill = group)) +
    geom_boxplot(alpha = 0.7) +
    theme_minimal() +
    labs(
      title = "Distribution by Group",
      x = "Group",
      y = "Value"
    )
  
  output_file <- file.path(output_dir, "distribution.png")
  ggsave(output_file, p, width = 8, height = 6, dpi = 300)
  log_message(glue("Saved plot: {output_file}"))
}

# ============================================================================
# Main Execution
# ============================================================================

main <- function() {
  # Parse arguments
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 2) {
    cat("Usage: Rscript analyze_data.R input.csv output/\n")
    stop("Insufficient arguments", call. = FALSE)
  }
  
  input_file <- args[1]
  output_dir <- args[2]
  
  # Validate inputs
  validate_file(input_file)
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  
  # Run analysis
  log_message("Analysis started")
  
  data <- read_and_validate(input_file)
  summary <- analyze_data(data)
  create_plot(data, output_dir)
  
  # Save results
  output_file <- file.path(output_dir, "summary.csv")
  write_csv(summary, output_file)
  log_message(glue("Saved results: {output_file}"))
  
  log_message("Analysis completed successfully")
}

# Run with error handling
tryCatch(
  {
    main()
  },
  error = function(e) {
    cat(sprintf("ERROR: %s\n", e$message))
    quit(status = 1)
  }
)
```

## Validation Checklist

Before completing any R script, verify:

- ✅ Header with all required fields (name, author, date, version, usage)
- ✅ Dependencies checked and loaded with error messages
- ✅ Options set (stringsAsFactors, seed, etc.)
- ✅ All functions documented with purpose, parameters, and return values
- ✅ Input validation for files and data frames
- ✅ Error handling with tryCatch
- ✅ Tidyverse style conventions (snake_case, <-, spacing)
- ✅ Informative log messages for users
- ✅ Command-line arguments parsed and validated
- ✅ Output directories created if needed

## When to Use This Skill

Use this skill for:
- Data analysis scripts
- Statistical analysis workflows
- Data cleaning and preprocessing
- Report generation scripts
- Automated data pipelines
- Research analysis code
- Any standalone R script