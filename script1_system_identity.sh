#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Author: [Your Name]
# Description: Displays a welcome screen showing key information about the
#              Linux system, including distro, kernel, user, uptime, and
#              the open-source license that governs the OS.
# =============================================================================

# --- Display a decorative header ---
echo "=============================================="
echo "        LINUX SYSTEM IDENTITY REPORT         "
echo "=============================================="
echo ""

# --- Distribution and Kernel Information ---
# 'uname -r' fetches the running kernel release string
KERNEL_VERSION=$(uname -r)

# Read the distribution name from /etc/os-release (standard on modern distros)
DISTRO_NAME=$(grep ^PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

echo "Operating System : $DISTRO_NAME"
echo "Kernel Version   : $KERNEL_VERSION"
echo ""

# --- Current User Information ---
# $USER is a shell variable that holds the logged-in username
# $HOME holds the path to that user's home directory
echo "Logged-in User   : $USER"
echo "Home Directory   : $HOME"
echo ""

# --- System Uptime and Date/Time ---
# 'uptime -p' gives a human-readable uptime like "up 2 hours, 3 minutes"
UPTIME=$(uptime -p)

# 'date' with a format string produces a nicely formatted timestamp
CURRENT_DATETIME=$(date "+%A, %d %B %Y  |  %H:%M:%S")

echo "System Uptime    : $UPTIME"
echo "Current Date/Time: $CURRENT_DATETIME"
echo ""

# --- Open Source License Notice ---
# The Linux kernel (and most Linux distributions) are distributed under GPL v2
echo "----------------------------------------------"
echo "  License Notice"
echo "----------------------------------------------"
echo "  The Linux kernel running on this system is"
echo "  distributed under the GNU General Public"
echo "  License version 2 (GPL v2)."
echo ""
echo "  This means you are free to use, study,"
echo "  modify, and redistribute this software,"
echo "  provided that any modifications you share"
echo "  are also released under the same license."
echo "----------------------------------------------"
echo ""

# --- Closing message ---
echo "  Welcome to Open Source Linux!"
echo "=============================================="
