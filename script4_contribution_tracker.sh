#!/bin/bash
# =============================================================================
# Script 4: FOSS Contribution Tracker
# Author: [Ayush Makhija]
# Reg No.: [24BAI10283]
# Description: Simulates a contribution logger for an open-source project.
#              Allows a user to log contributions (bug fixes, features,
#              documentation), view logs, and generate a simple report.
#              Concepts: while loop, case/esac, file I/O, input reading,
#              date formatting, arithmetic, persistent log file.
# =============================================================================

# --- Configuration ---
# The log file where contributions are saved (in the script's directory)
LOG_FILE="$(dirname "$0")/oss_contributions.log"
PROJECT_NAME="Python (CPython)"

echo "=============================================="
echo "      FOSS CONTRIBUTION TRACKER              "
echo "  Project: $PROJECT_NAME"
echo "=============================================="
echo ""

# --- Ensure the log file exists ---
# If the file does not exist, 'touch' creates it (empty)
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
    echo "Created new contribution log: $LOG_FILE"
fi

# --- Function: log_contribution ---
# Writes a new entry to the log file with timestamp and type
log_contribution() {
    local TYPE="$1"
    local DESCRIPTION="$2"
    local TIMESTAMP
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # Append a pipe-delimited record to the log file
    echo "$TIMESTAMP | $TYPE | $USER | $DESCRIPTION" >> "$LOG_FILE"
    echo ""
    echo "  [LOGGED] Contribution recorded at $TIMESTAMP"
}

# --- Function: view_log ---
# Reads and displays all entries from the log file
view_log() {
    echo ""
    echo "----------------------------------------------"
    echo "  Contribution History:"
    echo "----------------------------------------------"

    # Check if log is empty before trying to display it
    if [ ! -s "$LOG_FILE" ]; then
        echo "  No contributions logged yet."
    else
        # 'cat -n' displays lines with line numbers
        echo "  #  | Timestamp           | Type          | User       | Description"
        echo "  ---|---------------------|---------------|------------|------------------"

        # 'nl' adds line numbers; awk formats the pipe-delimited log neatly
        nl -w3 "$LOG_FILE" | while IFS= read -r LINE; do
            echo "  $LINE"
        done
    fi
    echo "----------------------------------------------"
}

# --- Function: generate_report ---
# Counts contributions by type using grep
generate_report() {
    echo ""
    echo "----------------------------------------------"
    echo "  Contribution Summary Report"
    echo "----------------------------------------------"

    # Count how many times each contribution type appears in the log
    BUGS=$(grep -c "Bug Fix" "$LOG_FILE" 2>/dev/null || echo 0)
    FEATURES=$(grep -c "Feature" "$LOG_FILE" 2>/dev/null || echo 0)
    DOCS=$(grep -c "Documentation" "$LOG_FILE" 2>/dev/null || echo 0)
    TESTS=$(grep -c "Testing" "$LOG_FILE" 2>/dev/null || echo 0)

    # Calculate total using arithmetic expansion $(( ))
    TOTAL=$((BUGS + FEATURES + DOCS + TESTS))

    echo "  Bug Fixes      : $BUGS"
    echo "  New Features   : $FEATURES"
    echo "  Documentation  : $DOCS"
    echo "  Testing        : $TESTS"
    echo "  -------------------------"
    echo "  Total logged   : $TOTAL contribution(s)"
    echo "----------------------------------------------"
}

# --- Main Menu Loop ---
# The 'while true' loop keeps running until the user chooses to exit
while true; do
    echo ""
    echo "  What would you like to do?"
    echo "  [1] Log a new contribution"
    echo "  [2] View all contributions"
    echo "  [3] Generate summary report"
    echo "  [4] Exit"
    echo ""
    read -rp "  Your choice: " CHOICE

    # 'case' evaluates CHOICE against multiple patterns
    case $CHOICE in
        1)
            echo ""
            echo "  Select contribution type:"
            echo "  [a] Bug Fix"
            echo "  [b] Feature"
            echo "  [c] Documentation"
            echo "  [d] Testing"
            read -rp "  Type: " TYPE_CHOICE

            # Map the letter choice to a readable label
            case $TYPE_CHOICE in
                a) CONT_TYPE="Bug Fix" ;;
                b) CONT_TYPE="Feature" ;;
                c) CONT_TYPE="Documentation" ;;
                d) CONT_TYPE="Testing" ;;
                *) echo "  Invalid type. Defaulting to Bug Fix."; CONT_TYPE="Bug Fix" ;;
            esac

            # Prompt for the description of what was done
            read -rp "  Brief description: " CONT_DESC

            # Call the logging function with the collected data
            log_contribution "$CONT_TYPE" "$CONT_DESC"
            ;;
        2)
            view_log
            ;;
        3)
            generate_report
            ;;
        4)
            echo ""
            echo "  Thank you for contributing to open source!"
            echo "=============================================="
            exit 0
            ;;
        *)
            echo "  Invalid option. Please choose 1, 2, 3, or 4."
            ;;
    esac
done
