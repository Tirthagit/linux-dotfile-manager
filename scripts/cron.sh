#!/bin/bash

# scripts/cron.sh

# Add cron job installer logic
add_cron_job(){

    local schedule="$1"
    local command="$2"

    # Check if the cron job already exists 
    if [[ $? -eq 0 ]]; then
        echo -e "🟡 Cron job already exists: $command" 
        return
    fi

    # Add the new cron job
    (crontab -l 2>/dev/null; echo "$schedule $command") | crontab -
    echo "✅ Cron job added $schedule $command"



}

setup_cron_jobs(){
    echo "📅 Setting up cron jobs..."

    # Sync dotfiles every hour
    add_cron_job "0 * * * *" "$HOME/dotfiles/scripts/sync.sh"

    # Daily backup at 2:00 am 
    add_cron_job "0 2 * * * " "$HOME/dotfiles/scripts/backup.sh"

    # Clear logs every week
    add_cron_job "0 3 * * 0" "rm -f $HOME/dotfiles/log/*.log"

    # Create and store snapshot of the system at 5:20 pm everyday
    add_cron_job "30 17 * * *" "uname -a >> $HOME/dotfiles/log/system.log" 

}
