#!/bin/bash 

set -e

LOG_DIR="$HOME/dotfiles/logs"
LOG_FILE="$LOG_DIR/install.log"

if [ - $LOG_DIR/$LOG_FILE ]; then


#!/bin/bash
logDir=...
logFile=...
DBG=false    # or "true"

# Check to see if a LOG file exists
if [ -f "$logDir/$logFile" ]
then
    $DBG && echo "Log file exists: $logDir/$logFile" >&2
    > "$logDir/$logFile"
else
    echo "Log file does not exist. Creating: $logDir/$logFile" >&2
    if touch "$logDir/$logFile"
    then
        echo "Log file created successfully" >&2
    else
        echo "Unable to create file. Logging disabled" >&2
    fi
fi
# Although personally I'd wrap that up in a logging function something like this untested version:

#!/bin/bash

log() {
    local dt=$(date +'%Y%m%d_%H%M%S') toTerm=false msg=

    # "+" prefix mandates writing to stderr
    [ "$1" = + ] && toTerm=true && shift

    msg=$(
        if [ $# -gt 0 ] then
            printf '%s: %s\n' "$dt" "$*"
        else
            sed "s/^/$dt: /"
        fi
    )

    # write to stderr if mandated or enabled
    if ${logTerm:-false} || $toTerm; then printf '%s' "$msg" >&2; fi

    # write to logfile if enabled and it exists
    [ -n "$logPath" ] && [ -f "$logPath" ] && { printf '%s' "$msg" >>"$logPath"; } 2>/dev/null
}

logPath=/path/to/logfile        # Enable all logging to file
logTerm=false                   # Do not copy logging to terminal (stderr)

log + 'Logging is enabled'      # Write a message to logfile and terminal
log 'Written to the logfile'    # Write a message just to the logfile
who | log                       # Write a block of text to the terminal

logPath=/path/to/logfile        # Enable all logging to file
logTerm=true                    # Copy all logging to terminal (stderr)

log + 'Logging is enabled'      # Write a message to logfile and terminal
log 'Written to the logfile'    # Write a message to both the logfile and terminal
who | log                       # Write a block of text to both the logfile and terminal