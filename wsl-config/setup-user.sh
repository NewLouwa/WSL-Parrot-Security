#!/bin/bash
# =============================================================================
# WSL User & Workspace Setup
# Creates a non-root user in the wheel/sudo group, sets up home directory
# with a structured HTB workspace, and configures wsl.conf
#
# Run as root: sudo bash setup-user.sh <username>
# =============================================================================

set -e

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
NC=$'\033[0m'

log()  { echo "${GREEN}[+]${NC} $1"; }
warn() { echo "${YELLOW}[!]${NC} $1"; }
err()  { echo "${RED}[-]${NC} $1"; }

if [ "$EUID" -ne 0 ]; then
    err "Run as root: sudo bash setup-user.sh"
    exit 1
fi

# Auto-detect the real user -- WSL already created them on first boot
# $SUDO_USER is set when running via sudo, fall back to the arg if provided
USERNAME="${1:-$SUDO_USER}"

if [ -z "$USERNAME" ] || [ "$USERNAME" = "root" ]; then
    err "Could not detect your username automatically."
    err "Pass it manually: sudo bash setup-user.sh <your-username>"
    exit 1
fi

if ! id "$USERNAME" &>/dev/null; then
    err "User '$USERNAME' not found. WSL should have created it on first boot."
    err "Pass it manually: sudo bash setup-user.sh <your-username>"
    exit 1
fi

# Add to sudo/wheel groups
log "Adding '$USERNAME' to sudo and wheel groups..."
usermod -aG sudo "$USERNAME" 2>/dev/null || true

# Create wheel group if it doesn't exist and add user
if ! getent group wheel &>/dev/null; then
    groupadd wheel
fi
usermod -aG wheel "$USERNAME"

# Ensure wheel group has sudo access
if ! grep -q "^%wheel" /etc/sudoers 2>/dev/null; then
    echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
fi

log "User '$USERNAME' is in groups: $(groups $USERNAME)"

# =============================================================================
# CONFIGURE WSL TO LOGIN AS THIS USER
# =============================================================================

log "Configuring WSL to login as '$USERNAME'..."

cat > /etc/wsl.conf << WSLEOF
[boot]
systemd=true

[user]
default=$USERNAME

[interop]
enabled=true
appendWindowsPath=true

[automount]
enabled=true
options="metadata,uid=$(id -u $USERNAME),gid=$(id -g $USERNAME),umask=22,fmask=11"
mountFsTab=true

[network]
generateResolvConf=true
WSLEOF

log "WSL will now login as '$USERNAME' after restart"

# =============================================================================
# CREATE WORKSPACE STRUCTURE
# =============================================================================

HOME_DIR="/home/$USERNAME"
WORKSPACE="$HOME_DIR/workspace"

log "Creating workspace at $WORKSPACE..."

# Main workspace
mkdir -p "$WORKSPACE"

# HTB workspace
mkdir -p "$WORKSPACE/htb/machines"
mkdir -p "$WORKSPACE/htb/challenges"
mkdir -p "$WORKSPACE/htb/prolabs"
mkdir -p "$WORKSPACE/htb/endgames"
mkdir -p "$WORKSPACE/htb/notes"
mkdir -p "$WORKSPACE/htb/vpn"

# Shared resources
mkdir -p "$WORKSPACE/scripts"
mkdir -p "$WORKSPACE/tools"
mkdir -p "$WORKSPACE/wordlists"
mkdir -p "$WORKSPACE/loot"
mkdir -p "$WORKSPACE/www"

# =============================================================================
# MACHINE TEMPLATE SCRIPT
# =============================================================================

cat > "$WORKSPACE/scripts/new-machine.sh" << 'MACHEOF'
#!/bin/bash
# Creates a structured folder for a new HTB machine
# Usage: new-machine.sh <machine-name> [ip]

NAME="${1}"
IP="${2:-10.10.10.x}"

if [ -z "$NAME" ]; then
    echo "Usage: new-machine.sh <machine-name> [ip]"
    echo "Example: new-machine.sh Lame 10.10.10.3"
    exit 1
fi

BASE="$HOME/workspace/htb/machines/$NAME"

if [ -d "$BASE" ]; then
    echo "[!] Machine folder already exists: $BASE"
    exit 1
fi

mkdir -p "$BASE"/{recon,exploit,loot,privesc,screenshots}

cat > "$BASE/notes.md" << EOF
# $NAME

## Info
- **IP:** $IP
- **OS:**
- **Difficulty:**
- **Date started:** $(date +%Y-%m-%d)

## Recon

### Nmap
\`\`\`bash
nmap -sC -sV -p- $IP -oN recon/nmap_full.txt
\`\`\`

### Web


### SMB / Other Services


## Foothold


## Privilege Escalation


## Flags
- **user.txt:**
- **root.txt:**

## Lessons Learned

EOF

# Add to /etc/hosts if IP provided
if [ "$IP" != "10.10.10.x" ]; then
    HOSTNAME=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
    if ! grep -q "$HOSTNAME.htb" /etc/hosts 2>/dev/null; then
        echo "[+] Adding $IP $HOSTNAME.htb to /etc/hosts (needs sudo)"
        echo "$IP $HOSTNAME.htb" | sudo tee -a /etc/hosts > /dev/null
    fi
fi

echo "[+] Machine workspace created: $BASE"
echo "[+] Notes template: $BASE/notes.md"
echo "[+] Start project shell: htb-shell $NAME"
ls -la "$BASE"
MACHEOF
chmod +x "$WORKSPACE/scripts/new-machine.sh"

# =============================================================================
# CHALLENGE TEMPLATE SCRIPT
# =============================================================================

cat > "$WORKSPACE/scripts/new-challenge.sh" << 'CHALEOF'
#!/bin/bash
# Creates a folder for an HTB challenge
# Usage: new-challenge.sh <category> <name>
# Example: new-challenge.sh crypto easy-rsa

CATEGORY="${1}"
NAME="${2}"

if [ -z "$CATEGORY" ] || [ -z "$NAME" ]; then
    echo "Usage: new-challenge.sh <category> <name>"
    echo "Categories: crypto, forensics, misc, osint, pwn, reversing, web, hardware, mobile"
    exit 1
fi

BASE="$HOME/workspace/htb/challenges/$CATEGORY/$NAME"
mkdir -p "$BASE"/{files,solution}

cat > "$BASE/notes.md" << EOF
# $NAME ($CATEGORY)

## Description


## Files


## Solution


## Flag

EOF

echo "[+] Challenge workspace created: $BASE"
CHALEOF
chmod +x "$WORKSPACE/scripts/new-challenge.sh"

# =============================================================================
# HTTP SERVER SHORTCUT
# =============================================================================

cat > "$WORKSPACE/scripts/serve.sh" << 'SERVEEOF'
#!/bin/bash
# Quick HTTP server for file transfer to targets
# Usage: serve.sh [port] [directory]
# Default: port 8080, serves from ~/workspace/www
# Use port 80 with sudo: sudo serve 80

PORT="${1:-8080}"
DIR="${2:-$HOME/workspace/www}"

echo "[+] Serving $DIR on port $PORT"
echo "[+] Download from target: wget http://$(ip -4 addr show tun0 2>/dev/null | grep -oP 'inet \K[\d.]+' || echo 'YOUR_IP'):$PORT/filename"
echo "[+] Ctrl+C to stop"

if [ "$PORT" -lt 1024 ] && [ "$EUID" -ne 0 ]; then
    echo "[!] Port $PORT requires sudo"
    cd "$DIR" && sudo python3 -m http.server "$PORT"
else
    cd "$DIR" && python3 -m http.server "$PORT"
fi
SERVEEOF
chmod +x "$WORKSPACE/scripts/serve.sh"

# =============================================================================
# WORKSPACE README
# =============================================================================

cat > "$WORKSPACE/README.md" << 'READMEEOF'
# Workspace

Organized workspace for pentesting and HTB.

## Structure

```
workspace/
├── htb/
│   ├── machines/          # One folder per HTB machine
│   │   └── MachineName/
│   │       ├── recon/         # Nmap, gobuster, enum output
│   │       ├── exploit/       # Exploit scripts, payloads
│   │       ├── loot/          # Extracted creds, hashes, flags
│   │       ├── privesc/       # Privesc scripts, findings
│   │       ├── screenshots/   # Evidence
│   │       └── notes.md       # Writeup and notes
│   ├── challenges/        # CTF challenges by category
│   ├── prolabs/           # Pro Lab notes and progress
│   ├── endgames/          # Endgame notes
│   ├── notes/             # General study notes
│   └── vpn/               # .ovpn files (gitignored)
├── scripts/               # Helper scripts
│   ├── new-machine.sh     # Create machine workspace
│   ├── new-challenge.sh   # Create challenge workspace
│   └── serve.sh           # Quick HTTP server
├── tools/                 # Custom/compiled tools
├── wordlists/             # Custom wordlists
├── loot/                  # Global loot storage
└── www/                   # Files to serve to targets
```

## Quick Start

```bash
# Start a new machine
new-machine Lame 10.10.10.3

# Start a challenge
new-challenge web easy-login

# Serve files to a target
serve 80
```
READMEEOF

# =============================================================================
# LOGIN BANNER (MOTD) & HTB CONNECT
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/motd.sh" ]; then
    log "Installing login banner..."
    cp "$SCRIPT_DIR/motd.sh" "$HOME_DIR/.motd.sh"
    chmod +x "$HOME_DIR/.motd.sh"
fi
if [ -f "$SCRIPT_DIR/htb-connect.sh" ]; then
    log "Installing htb-connect..."
    cp "$SCRIPT_DIR/htb-connect.sh" /usr/local/bin/htb-connect
    chmod +x /usr/local/bin/htb-connect
fi

# =============================================================================
# BROWSER BOOKMARKS IMPORT
# =============================================================================

BOOKMARKS_SRC="$SCRIPT_DIR/bookmarks.html"

if [ -f "$BOOKMARKS_SRC" ]; then
    log "Importing security bookmarks into browsers..."

    # ---- Firefox ----
    # Copy bookmarks.html to a location Firefox can auto-import on first run
    FIREFOX_DIR="$HOME_DIR/.mozilla"
    mkdir -p "$FIREFOX_DIR"
    cp "$BOOKMARKS_SRC" "$FIREFOX_DIR/bookmarks.html"

    # If a Firefox profile already exists, place it there too
    if [ -d "$FIREFOX_DIR/firefox" ]; then
        for profile_dir in "$FIREFOX_DIR/firefox/"*.default*; do
            if [ -d "$profile_dir" ]; then
                cp "$BOOKMARKS_SRC" "$profile_dir/bookmarks.html"
                log "  Firefox profile: $(basename "$profile_dir")"
            fi
        done
    fi

    # Create an autoconfig to import bookmarks on first launch
    mkdir -p "$HOME_DIR/.config/autostart"
    cat > "$HOME_DIR/.config/autostart/import-bookmarks.desktop" << BMEOF
[Desktop Entry]
Type=Application
Name=Import HTB Bookmarks
Exec=bash -c 'if [ -f ~/.mozilla/bookmarks.html ] && ! [ -f ~/.mozilla/.bookmarks-imported ]; then sleep 3; firefox -headless "file://\$HOME/.mozilla/bookmarks.html" & sleep 5; kill %1 2>/dev/null; touch ~/.mozilla/.bookmarks-imported; fi'
Hidden=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
BMEOF

    # ---- Brave ----
    BRAVE_DIR="$HOME_DIR/.config/BraveSoftware/Brave-Browser"
    mkdir -p "$BRAVE_DIR/Default"
    cp "$BOOKMARKS_SRC" "$BRAVE_DIR/Default/bookmarks.html"

    # Create Brave first-run bookmark import preference
    if [ ! -f "$BRAVE_DIR/First Run" ]; then
        touch "$BRAVE_DIR/First Run"
    fi

    # Also store in a well-known location for manual import
    cp "$BOOKMARKS_SRC" "$HOME_DIR/workspace/bookmarks.html"

    log "Bookmarks installed for Firefox and Brave"
    log "  Manual import: open browser → Bookmarks → Import → from HTML file"
    log "  File: ~/workspace/bookmarks.html"
else
    warn "bookmarks.html not found in $SCRIPT_DIR"
fi

# =============================================================================
# BASH PROFILE SETUP
# =============================================================================

log "Configuring shell for '$USERNAME'..."

cat > "$HOME_DIR/.bash_aliases" << 'ALIASEOF'
# HTB Aliases
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CF'

# Quick navigation
alias ws='cd ~/workspace'
alias htb='cd ~/workspace/htb'
alias machines='cd ~/workspace/htb/machines'
alias challenges='cd ~/workspace/htb/challenges'

# cheat <toolname>  → show tool cheat sheet from toolkit docs
cheat() {
    if [ -z "$1" ]; then
        echo "Usage: cheat <toolname>"
        echo "Example: cheat nmap"
        echo ""
        echo "Available tools:"
        find "$HOME/WSL-Parrot-Security" -name "*.md" \
            | grep -Ev "README|DOCUMENTATION|TROUBLESHOOTING|AI-DISCLAIMER" \
            | xargs -I{} basename {} .md | sort | column
        return
    fi
    local DOCS_DIR="$HOME/WSL-Parrot-Security"
    local TOOL="$1"
    local MD

    _cheat_find() {
        find "$DOCS_DIR" -iname "${1}.md" 2>/dev/null \
            | grep -Ev "README|DOCUMENTATION|TROUBLESHOOTING|AI-DISCLAIMER" \
            | head -1
    }

    MD=$(_cheat_find "$TOOL")

    # Strip common package suffixes and try again
    if [ -z "$MD" ]; then
        local STRIPPED
        # proxychains4→proxychains, netcat-openbsd→netcat, ligolo-ng→ligolo, etc.
        STRIPPED=$(echo "$TOOL" | sed 's/[0-9]*$//' | sed 's/-openbsd$//' | sed 's/-tools$//' | sed 's/-ng$//' | sed 's/-framework$//' | sed 's/^python3-//')
        [ "$STRIPPED" != "$TOOL" ] && MD=$(_cheat_find "$STRIPPED")
    fi

    # Known aliases that don't follow a pattern
    if [ -z "$MD" ]; then
        case "${TOOL,,}" in
            theharvester|harvester)    MD=$(_cheat_find "theharvester") ;;
            sherlock*)                 MD=$(_cheat_find "sherlock") ;;
            shodan*)                   MD=$(_cheat_find "shodan-cli") ;;
            crackmapexec|cme)          MD=$(_cheat_find "crackmapexec") ;;
            bloodhound*|sharphound*)   MD=$(_cheat_find "bloodhound") ;;
            zaproxy|owasp-zap|zap)    MD=$(_cheat_find "zaproxy") ;;
            burp*)                     MD=$(_cheat_find "burpsuite") ;;
            ncat|nc)                   MD=$(_cheat_find "netcat") ;;
            john*|jtr)                 MD=$(_cheat_find "john") ;;
            msf|msfconsole)            MD=$(_cheat_find "metasploit") ;;
            proxychains*)              MD=$(_cheat_find "proxychains") ;;
            pwncat*)                   MD=$(_cheat_find "pwncat") ;;
            certipy*)                  MD=$(_cheat_find "certipy") ;;
            ligolo*)                   MD=$(_cheat_find "ligolo-ng") ;;
            linpeas|winpeas|peas)      MD=$(_cheat_find "linpeas-winpeas") ;;
            ltrace|strace)             MD=$(_cheat_find "ltrace-strace") ;;
            hexedit|xxd|hexdump)       MD=$(_cheat_find "hexedit") ;;
        esac
    fi

    if [ -n "$MD" ]; then
        if command -v bat &>/dev/null; then
            bat --style=plain --language=markdown "$MD"
        else
            cat "$MD"
        fi
    else
        echo "[-] No cheat sheet found for '$1'"
        echo ""
        echo "[*] Available tools:"
        find "$DOCS_DIR" -name "*.md" \
            | grep -Ev "README|DOCUMENTATION|TROUBLESHOOTING|AI-DISCLAIMER" \
            | xargs -I{} basename {} .md | sort | column
    fi
}

# Tools
alias serve='bash ~/workspace/scripts/serve.sh'
alias new-machine='bash ~/workspace/scripts/new-machine.sh'
alias new-challenge='bash ~/workspace/scripts/new-challenge.sh'

# Networking
alias myip='ip -4 addr show tun0 2>/dev/null | grep -oP "inet \K[\d.]+" || echo "VPN not connected"'
alias ports='ss -tlnp'

# Common pentest shortcuts
alias rsh='rlwrap nc -lvnp'
alias pserv='python3 -m http.server'
alias clip='clip.exe'  # pipe to Windows clipboard via WSL interop

# HTB VPN
alias vpn='htb-connect'
alias vpn-dc='htb-connect --disconnect'
alias vpn-status='htb-connect --status'

# Safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# ---- Per-project shell with command logging ----
htb-shell() {
    local NAME="$1"
    if [ -z "$NAME" ]; then
        echo "Usage: htb-shell <machine-name>"
        echo "Starts a shell that logs all commands to the machine folder."
        echo ""
        echo "Available machines:"
        ls ~/workspace/htb/machines/ 2>/dev/null || echo "  (none yet — use new-machine first)"
        return 1
    fi

    local BASE="$HOME/workspace/htb/machines/$NAME"
    if [ ! -d "$BASE" ]; then
        echo "[!] Machine folder not found: $BASE"
        echo "[*] Create it first: new-machine $NAME <ip>"
        return 1
    fi

    echo "[+] Entering HTB shell for: $NAME"
    echo "[+] Commands will be logged to: $BASE/.cmd_history"
    echo "[+] Type 'exit' to leave the project shell"
    echo ""

    HISTFILE="$BASE/.cmd_history" \
    HTB_PROJECT="$NAME" \
    bash --rcfile <(cat ~/.bashrc; echo "cd '$BASE'; export HISTFILE='$BASE/.cmd_history'; export HTB_PROJECT='$NAME'; export PS1=\"\[\033[0;32m\][$NAME]\[\033[0m\] \u@\h:\w\$ \"")
}
ALIASEOF

# Make sure .bashrc sources aliases and starts in home dir
if ! grep -q "bash_aliases" "$HOME_DIR/.bashrc" 2>/dev/null; then
    cat >> "$HOME_DIR/.bashrc" << 'RCEOF'

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Login banner — remove this line to disable
if [ -f ~/.motd.sh ]; then
    source ~/.motd.sh
fi

# Start in home directory
cd ~
RCEOF
fi

# =============================================================================
# FIX OWNERSHIP
# =============================================================================

log "Fixing ownership on $HOME_DIR..."
chown -R "$USERNAME:$USERNAME" "$HOME_DIR"

# Mark user setup as done
touch /etc/.parrot-toolkit-user-setup

# =============================================================================
# DONE
# =============================================================================

echo ""
echo "${CYAN}============================================${NC}"
echo "${GREEN} User setup complete!${NC}"
echo "${CYAN}============================================${NC}"
echo ""
echo "  User:       ${GREEN}$USERNAME${NC} (in sudo + wheel)"
echo "  Home:       ${GREEN}$HOME_DIR${NC}"
echo "  Workspace:  ${GREEN}$WORKSPACE${NC}"
echo "  WSL login:  ${GREEN}$USERNAME${NC} (after restart)"
echo ""
echo "  ${YELLOW}Quick commands after restart:${NC}"
echo "    ${CYAN}vpn${NC}                          — connect to HTB VPN"
echo "    ${CYAN}new-machine Lame 10.10.10.3${NC}  — start a machine"
echo "    ${CYAN}htb-shell Lame${NC}               — enter project shell (logs commands)"
echo "    ${CYAN}new-challenge web easy-rsa${NC}   — start a challenge"
echo "    ${CYAN}serve${NC}                        — HTTP server for file transfer"
echo "    ${CYAN}myip${NC}                         — show HTB VPN IP"
echo "    ${CYAN}cheat nmap${NC}                   — show any tool's cheat sheet"

# Check if tools have been installed
if [ ! -f /etc/.parrot-toolkit-installed ]; then
    echo ""
    echo "  ${YELLOW}${BOLD}Security tools have not been installed yet.${NC}"
    echo ""
    read -rp "  Would you like to install all security tools now? [Y/n] " RUN_TOOLS
    RUN_TOOLS="${RUN_TOOLS:-y}"
    if [[ "$RUN_TOOLS" =~ ^[Yy] ]]; then
        if [ -f "$SCRIPT_DIR/../install-toolkit.sh" ]; then
            echo ""
            bash "$SCRIPT_DIR/../install-toolkit.sh"
        else
            warn "install-toolkit.sh not found. Run it manually:"
            echo "    sudo bash install-toolkit.sh"
        fi
    else
        echo ""
        echo "  ${GREEN}Install tools later with:${NC}"
        echo "    ${CYAN}sudo bash install-toolkit.sh${NC}"
    fi
else
    echo ""
    echo "  ${GREEN}Security tools already installed. All good!${NC}"
fi

echo ""
echo "  ${YELLOW}⚠  WSL restart required — aliases won't work until you do this:${NC}"
echo ""
echo "    1. Open PowerShell and run:  ${CYAN}wsl --shutdown${NC}"
echo "    2. Reopen your Parrot WSL terminal"
echo ""
echo "  ${RED}source ~/.bashrc is NOT enough.${NC} WSL needs a full restart"
echo "  because wsl.conf (auto-login as $USERNAME) only applies on fresh boot."
echo ""
