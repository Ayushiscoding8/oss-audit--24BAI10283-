#!/bin/bash
# =============================================================================
# Script 2: FOSS Package Inspector
# Author: [Ayush Makhija]
# Reg No.: [24BAI10283]
# Description: Checks whether Python (our chosen OSS project) is installed,
#              reports its version, displays where it is located, lists
#              installed pip packages, and checks for available updates.
# =============================================================================

# --- The software we are auditing ---
SOFTWARE="python3"
PACKAGE_MANAGER=""  # Will be detected automatically

echo "=============================================="
echo "        FOSS PACKAGE INSPECTOR               "
echo "  Auditing: Python (python3)                 "
echo "=============================================="
echo ""

# --- Step 1: Detect which package manager is available ---
# Different Linux distributions use different package managers.
# We use 'command -v' to check if a command exists (returns true/false).
if command -v apt &> /dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v dnf &> /dev/null; then
    PACKAGE_MANAGER="dnf"
elif command -v yum &> /dev/null; then
    PACKAGE_MANAGER="yum"
else
    PACKAGE_MANAGER="unknown"
fi

echo "Detected Package Manager: $PACKAGE_MANAGER"
echo ""

# --- Step 2: Check if Python3 is installed ---
# 'command -v' locates the binary; if it fails the software is not installed
if command -v $SOFTWARE &> /dev/null; then
    echo "[INSTALLED] Python3 is installed on this system."
    echo ""

    # --- Step 3: Display version information ---
    # '--version' flag prints the Python version string
    PYTHON_VERSION=$($SOFTWARE --version 2>&1)
    echo "Version      : $PYTHON_VERSION"

    # --- Step 4: Show the installation path ---
    # 'which' returns the full path to the executable
    INSTALL_PATH=$(which $SOFTWARE)
    echo "Location     : $INSTALL_PATH"
    echo ""

    # --- Step 5: List installed pip packages (top 10) ---
    echo "----------------------------------------------"
    echo "  Installed pip Packages (top 10):"
    echo "----------------------------------------------"

    # 'pip3 list' shows all installed packages; head -n 12 limits output
    # (first 2 lines are the header, so we show 10 actual packages)
    if command -v pip3 &> /dev/null; then
        pip3 list 2>/dev/null | head -n 12
    else
        echo "  pip3 not found. Cannot list packages."
    fi
    echo ""

    # --- Step 6: Check if an update is available ---
    echo "----------------------------------------------"
    echo "  Update Check:"
    echo "----------------------------------------------"

    # This checks the package manager's cache for available upgrades
    if [ "$PACKAGE_MANAGER" = "apt" ]; then
        # 'apt list --upgradable' shows packages that can be updated
        UPDATE_INFO=$(apt list --upgradable 2>/dev/null | grep "^python3/")
        if [ -n "$UPDATE_INFO" ]; then
            echo "  [UPDATE AVAILABLE] $UPDATE_INFO"
        else
            echo "  [UP TO DATE] Python3 is at the latest version in your repos."
        fi
    else
        echo "  Update check supported for apt-based systems only."
        echo "  Run: sudo $PACKAGE_MANAGER update python3   (to update manually)"
    fi

else
    # --- Software not found: provide installation guidance ---
    echo "[NOT INSTALLED] Python3 was not found on this system."
    echo ""
    echo "  To install Python3, run one of the following:"
    echo ""

    # Use a case statement to show the right install command per distro
    case $PACKAGE_MANAGER in
        apt)
            echo "    sudo apt update && sudo apt install python3"
            ;;
        dnf)
            echo "    sudo dnf install python3"
            ;;
        yum)
            echo "    sudo yum install python3"
            ;;
        *)
            echo "    Please visit: https://www.python.org/downloads/"
            ;;
    esac
fi

echo ""
echo "=============================================="
echo "  Inspection complete."
echo "=============================================="
