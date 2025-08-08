#!/bin/bash
set -euo pipefail

# Colors for pretty output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT_DIR/test-logs"
mkdir -p "$LOG_DIR"

summary_file="$LOG_DIR/summary.log"
: > "$summary_file"  # clear summary file

# Function to run a command, log, and print result
run_test() {
    local name="$1"
    local cmd="$2"
    local logfile="$LOG_DIR/$3"

    echo -e "${CYAN}[TEST]${NC} $name..."
    if eval "$cmd" > "$logfile" 2>&1; then
        echo -e "${GREEN}[PASS]${NC} $name" | tee -a "$summary_file"
    else
        echo -e "${RED}[FAIL]${NC} $name — see $logfile" | tee -a "$summary_file"
    fi
}

echo "=== Running Dotfiles Utility Tests ==="
echo "Logs: $LOG_DIR"
echo "Started at: $(date)" > "$summary_file"
echo "-----------------------------------" >> "$summary_file"

# Run in parallel for speed
run_test "ShellCheck" \
    "shellcheck \"$ROOT_DIR\"/scripts/*.sh" \
    "shellcheck.log" &

run_test "shfmt" \
    "shfmt -d \"$ROOT_DIR\"/scripts" \
    "shfmt.log" &

wait # wait for parallel jobs to finish

echo "-----------------------------------" >> "$summary_file"
echo "Finished at: $(date)" >> "$summary_file"

echo -e "\n${CYAN}=== Test Summary ===${NC}"
cat "$summary_file"
