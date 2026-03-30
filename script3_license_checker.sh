#!/bin/bash
# =============================================================================
# Script 3: License Compliance Checker
# Author: [Your Name]
# Description: Reads a directory of text files and searches each one for
#              known open-source license identifiers. This simulates a basic
#              compliance audit — checking which license a project uses.
#              Concepts: loops, grep, if-else, functions, arrays.
# =============================================================================

echo "=============================================="
echo "      OSS LICENSE COMPLIANCE CHECKER         "
echo "=============================================="
echo ""

# --- Define a directory to scan ---
# Default: scan the current directory. User can pass a path as argument $1.
SCAN_DIR="${1:-.}"

# Validate that the directory actually exists
if [ ! -d "$SCAN_DIR" ]; then
    echo "Error: Directory '$SCAN_DIR' not found."
    echo "Usage: $0 [directory_path]"
    exit 1
fi

echo "Scanning directory: $SCAN_DIR"
echo ""

# --- Define known license patterns as arrays ---
# Each element is a keyword that appears in the license header text.
declare -a LICENSE_NAMES=("MIT License" "GNU General Public License" "Apache License" "BSD License" "Mozilla Public License" "ISC License" "PSF License")
declare -a LICENSE_KEYS=("MIT" "GPL" "Apache" "BSD" "MPL" "ISC" "PSF")

# --- Counter for statistics ---
TOTAL_FILES=0
LICENSED_FILES=0
UNLICENSED_FILES=0

# --- Function: detect_license ---
# Arguments: $1 = file path
# Returns: prints the detected license name or "Unknown"
detect_license() {
    local FILE="$1"
    local DETECTED="Unknown"

    # Loop through each license keyword and search the file
    for i in "${!LICENSE_KEYS[@]}"; do
        # grep -q = quiet mode (no output), just returns true/false
        # -i = case-insensitive, -l = only show filename
        if grep -qi "${LICENSE_KEYS[$i]}" "$FILE" 2>/dev/null; then
            DETECTED="${LICENSE_NAMES[$i]}"
            break  # Stop at first match; a file usually has one license
        fi
    done

    echo "$DETECTED"
}

# --- Main loop: scan all .txt, .md, .py, .sh files in the directory ---
echo "----------------------------------------------"
echo "  File-by-file Scan Results:"
echo "----------------------------------------------"

# 'find' locates files recursively; '-maxdepth 2' prevents going too deep
while IFS= read -r -d '' FILE; do
    TOTAL_FILES=$((TOTAL_FILES + 1))

    # Call our function to detect the license
    LICENSE=$(detect_license "$FILE")

    # Get just the filename (not the full path) for cleaner output
    FILENAME=$(basename "$FILE")

    if [ "$LICENSE" != "Unknown" ]; then
        LICENSED_FILES=$((LICENSED_FILES + 1))
        echo "  [FOUND]   $FILENAME"
        echo "             -> License: $LICENSE"
    else
        UNLICENSED_FILES=$((UNLICENSED_FILES + 1))
        echo "  [NO LIC]  $FILENAME  -> No recognized license header"
    fi

done < <(find "$SCAN_DIR" -maxdepth 2 -type f \( -name "*.txt" -o -name "*.md" -o -name "*.py" -o -name "*.sh" \) -print0)

# --- Summary report ---
echo ""
echo "----------------------------------------------"
echo "  SCAN SUMMARY"
echo "----------------------------------------------"
echo "  Total files scanned : $TOTAL_FILES"
echo "  Files with licenses : $LICENSED_FILES"
echo "  Files without       : $UNLICENSED_FILES"
echo ""

# Warn if more than half the files have no license info
if [ "$TOTAL_FILES" -gt 0 ] && [ "$UNLICENSED_FILES" -gt "$LICENSED_FILES" ]; then
    echo "  [WARNING] Most files lack a license header."
    echo "  Consider adding an OSS license to your project."
fi

echo "=============================================="
echo "  Compliance check complete."
echo "=============================================="
