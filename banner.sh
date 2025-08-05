
---

### 🖥 Bonus: Colorful Bash Welcome Banner (Optional)

You can save this as `banner.sh` and call it from `install.sh` to show a welcome screen:

```bash
#!/bin/bash

cyan="\e[36m"
green="\e[32m"
yellow="\e[33m"
bold="\e[1m"
reset="\e[0m"

echo -e "${cyan}${bold}
  ____        _    __ _ _           
  |  _ \  ___ | |_ / _(_) | ___  ___ 
  | | | |/ _ \| __| |_| | |/ _ \/ __|
  | |_| | (_) | |_|  _| | |  __/\__ \
  |____/ \___/ \__|_| |_|_|\___||___/
                                    
                                    
${reset}${yellow}DotWizard – Distro-Aware Dotfiles Manager${reset}
${green}Your Linux. Your Configs. Synchronized.${reset}"
