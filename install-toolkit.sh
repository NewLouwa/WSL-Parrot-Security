#!/bin/bash
# =============================================================================
# Parrot WSL Security Toolkit Installer
# Installs tools commonly found in Kali but missing from base Parrot WSL
# Includes FULL GUI/Desktop Environment support (WSLg + XRDP fallback)
# Organized by pentest phase for HTB training
# =============================================================================

# NOT using set -e — we want to keep going if individual installs fail,
# and report what broke at the end rather than dying silently mid-install.

LOG_FILE="/var/log/parrot-toolkit-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "=== Install started: $(date) ===" >> "$LOG_FILE"

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
NC=$'\033[0m'

log()     { printf '%s[+]%s %s\n' "$GREEN" "$NC" "$1"; }
warn()    { printf '%s[!]%s %s\n' "$YELLOW" "$NC" "$1"; }
err()     { printf '%s[-]%s %s\n' "$RED" "$NC" "$1"; }
section() { printf '\n%s%s========== %s ==========%s\n\n' "$CYAN" "$BOLD" "$1" "$NC"; }

if [ "$EUID" -ne 0 ]; then
    err "Run as root: sudo bash install-toolkit.sh"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="/opt/htb-toolkit"
mkdir -p "$TOOLS_DIR"

# Fix "sudo: unable to resolve host" warning — happens when /etc/hosts
# doesn't have an entry for the current hostname. Silent, runs once.
HOSTNAME_CURRENT=$(hostname 2>/dev/null)
if [ -n "$HOSTNAME_CURRENT" ] && ! grep -q "$HOSTNAME_CURRENT" /etc/hosts 2>/dev/null; then
    echo "127.0.0.1 $HOSTNAME_CURRENT" >> /etc/hosts
    log "Fixed: added $HOSTNAME_CURRENT to /etc/hosts (no more sudo hostname warnings)"
fi

# =============================================================================
# FIRST THINGS FIRST: Desktop shortcut + start directory fix
# =============================================================================

# Fix WSL start directory for root — without this WSL lands in /mnt/c/Users/...
# (your Windows profile) instead of /root. This makes it sane immediately.
if ! grep -q "mnt.*cd ~" /root/.bashrc 2>/dev/null; then
    cat >> /root/.bashrc << 'RCEOF'

# Start in home directory instead of Windows mount path
[[ "$PWD" == /mnt/* ]] && cd ~
RCEOF
    log "Fixed: WSL will now start in home directory instead of Windows path"
fi

# Create a Windows Desktop shortcut right now, before anything else.
# So even if the install fails halfway, you still have a way back in.
WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')
WIN_DESKTOP="/mnt/c/Users/$WIN_USER/Desktop"
if [ -n "$WIN_USER" ] && [ -d "$WIN_DESKTOP" ]; then
    cat > "$WIN_DESKTOP/Parrot HTB Toolkit.bat" << 'BATEOF'
@echo off
title Parrot HTB Toolkit
where wt >nul 2>&1 && (wt wsl) || wsl
BATEOF
    log "Desktop shortcut created on your Windows Desktop: 'Parrot HTB Toolkit.bat'"
    log "  Double-click it from Windows to launch straight into your toolkit"
else
    warn "Could not detect Windows Desktop — shortcut not created"
    warn "  To launch WSL from Windows, just run: wsl"
fi

INSTALLED=()
FAILED=()
SKIPPED=()

safe_install() {
    local pkg="$1"
    if dpkg -l "$pkg" 2>/dev/null | grep -q "^ii"; then
        SKIPPED+=("$pkg")
        return
    fi
    log "Installing $pkg..."
    if apt-get install -y "$pkg" > /dev/null 2>&1; then
        INSTALLED+=("$pkg")
    else
        warn "Failed to install $pkg via apt"
        FAILED+=("$pkg")
    fi
}

pip_install() {
    local pkg="$1"
    log "Installing $pkg (pip)..."
    if pip3 install "$pkg" --break-system-packages > /dev/null 2>&1; then
        INSTALLED+=("$pkg")
    elif pip3 install "$pkg" --break-system-packages --ignore-installed > /dev/null 2>&1; then
        INSTALLED+=("$pkg")
    else
        warn "Failed to install $pkg via pip"
        FAILED+=("$pkg")
    fi
}

go_install() {
    local name="$1"
    local url="$2"
    log "Installing $name (go)..."
    if command -v go &> /dev/null; then
        if go install "$url" > /dev/null 2>&1; then
            INSTALLED+=("$name")
        else
            warn "Failed to install $name via go"
            FAILED+=("$name")
        fi
    else
        warn "Go not installed, skipping $name"
        FAILED+=("$name")
    fi
}

# =============================================================================
section "UPDATING SYSTEM"
# =============================================================================
apt-get update -y
apt-get upgrade -y

log "Installing base dependencies..."
# Install packages individually so one missing package doesn't nuke the whole setup.
# software-properties-common is Ubuntu-only and doesn't exist in Parrot/Debian — don't add it.
BASE_DEPS=(
    git curl wget
    python3 python3-pip python3-dev
    golang-go
    build-essential libssl-dev libffi-dev
    unzip jq net-tools
    ca-certificates gnupg
    lsb-release apt-transport-https
)
BASE_FAILED=()
for dep in "${BASE_DEPS[@]}"; do
    if dpkg -l "$dep" 2>/dev/null | grep -q "^ii"; then
        continue  # already installed
    fi
    if ! apt-get install -y "$dep" > /dev/null 2>&1; then
        warn "Base dep not available: $dep (skipping)"
        BASE_FAILED+=("$dep")
    fi
done

if [ ${#BASE_FAILED[@]} -gt 0 ]; then
    warn "Some base deps couldn't be installed: ${BASE_FAILED[*]}"
    warn "The toolkit will still install everything it can — unlike a vibecoder, it doesn't give up after one error."
else
    log "All base dependencies installed."
fi

# Ensure Go tools are in PATH
export PATH="$PATH:/root/go/bin:/usr/local/go/bin"
if [ -n "$SUDO_USER" ]; then
    export PATH="$PATH:/home/$SUDO_USER/go/bin"
fi


# =============================================================================
section "GUI / DESKTOP ENVIRONMENT SETUP"
# =============================================================================
# This enables graphical apps in WSL via WSLg and provides a full desktop
# via XRDP as fallback for a complete GUI experience.

log "Setting up GUI — this part takes a while, go make a coffee."

# Core X11 + WSLg support
log "Installing X11 display server..."
apt-get install -y \
    xorg \
    xserver-xorg \
    x11-apps \
    x11-utils \
    x11-xserver-utils \
    dbus-x11 \
    xdg-utils \
    mesa-utils \
    > /dev/null 2>&1 || warn "Some X11 packages failed"
log "X11 done."

# XFCE4 desktop (lightweight, works great in WSL)
log "Installing XFCE4 desktop... (yes, a full desktop in WSL, yes it works)"
apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    xfce4-whiskermenu-plugin \
    thunar \
    mousepad \
    ristretto \
    > /dev/null 2>&1 || warn "Some XFCE packages failed"
log "XFCE4 done."

# XRDP for full remote desktop (connect from Windows via mstsc)
log "Installing XRDP — because mstsc /v:localhost:3390 is a banger command..."
apt-get install -y xrdp > /dev/null 2>&1 || warn "XRDP install failed"

if command -v xrdp &> /dev/null; then
    # Configure XRDP to use XFCE4
    cat > /etc/xrdp/startwm.sh << 'XRDPEOF'
#!/bin/sh
if [ -r /etc/default/locale ]; then
    . /etc/default/locale
    export LANG LANGUAGE
fi
export DESKTOP_SESSION=xfce
export XDG_SESSION_DESKTOP=xfce
export XDG_CURRENT_DESKTOP=XFCE
exec startxfce4
XRDPEOF
    chmod +x /etc/xrdp/startwm.sh

    # Fix XRDP port to 3390 to avoid conflicts with Windows RDP on 3389
    sed -i 's/^port=3389/port=3390/' /etc/xrdp/xrdp.ini 2>/dev/null || true

    log "XRDP configured on port 3390"
    log "  -> Connect from Windows: mstsc /v:localhost:3390"
fi

# Audio support
log "Installing PulseAudio..."
apt-get install -y pulseaudio > /dev/null 2>&1 || true

# GTK/QT themes for nice-looking GUI apps
log "Installing themes and fonts — making it look less like a 2004 Linux distro..."
apt-get install -y \
    arc-theme \
    papirus-icon-theme \
    fonts-noto \
    fonts-hack \
    fonts-liberation \
    adwaita-icon-theme \
    gtk2-engines-murrine \
    qt5ct \
    > /dev/null 2>&1 || true
log "Themes done."

# File manager and essential desktop apps
log "Installing desktop apps (KeePassXC, VLC, Flameshot, Filezilla...)..."
apt-get install -y \
    filezilla \
    keepassxc \
    flameshot \
    vlc \
    evince \
    libreoffice-calc \
    gedit \
    > /dev/null 2>&1 || warn "Some desktop apps failed"
log "Desktop apps done."

# Brave Browser
log "Installing Brave browser..."
if ! command -v brave-browser &> /dev/null; then
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg 2>/dev/null
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        > /etc/apt/sources.list.d/brave-browser-release.list
    apt-get update -y > /dev/null 2>&1
    if apt-get install -y brave-browser > /dev/null 2>&1; then
        INSTALLED+=("brave-browser")
    else
        warn "Failed to install Brave browser"
        FAILED+=("brave-browser")
    fi
else
    SKIPPED+=("brave-browser")
fi

# Terminal emulators (extra options)
apt-get install -y terminator > /dev/null 2>&1 || true

# Create a helper script to start the desktop
cat > /usr/local/bin/start-desktop << 'DESKEOF'
#!/bin/bash
# Start Parrot WSL Desktop Environment
# Usage: start-desktop [xrdp|wslg]

MODE="${1:-auto}"

start_xrdp() {
    echo "[+] Starting XRDP on port 3390..."
    sudo service xrdp start
    echo "[+] Connect from Windows with:"
    echo "    mstsc /v:localhost:3390"
    echo "[+] Username: your WSL username"
    echo "[+] Password: your WSL password"
}

start_wslg() {
    echo "[+] Launching XFCE4 via WSLg..."
    export DISPLAY=:0
    export DESKTOP_SESSION=xfce
    export XDG_SESSION_DESKTOP=xfce
    export XDG_CURRENT_DESKTOP=XFCE
    startxfce4 &
    echo "[+] Desktop launched. GUI windows should appear on your Windows desktop."
}

case "$MODE" in
    xrdp)
        start_xrdp
        ;;
    wslg)
        start_wslg
        ;;
    auto)
        if [ -n "$WAYLAND_DISPLAY" ] || [ -n "$DISPLAY" ]; then
            echo "[+] WSLg detected, launching directly..."
            start_wslg
        else
            echo "[+] No WSLg detected, falling back to XRDP..."
            start_xrdp
        fi
        ;;
    *)
        echo "Usage: start-desktop [xrdp|wslg|auto]"
        ;;
esac
DESKEOF
chmod +x /usr/local/bin/start-desktop

# Create .desktop launchers for custom tools
DESKTOP_DIR="/usr/share/applications"
mkdir -p "$DESKTOP_DIR"

# Configure WSLg environment variables
cat >> /etc/environment << 'ENVEOF'
# WSLg / GUI support
XDG_RUNTIME_DIR=/run/user/1000
WAYLAND_DISPLAY=wayland-0
PULSE_SERVER=unix:/mnt/wslg/PulseServer
ENVEOF

log "GUI setup complete!"
log "  -> Individual GUI apps work via WSLg automatically"
log "  -> Full desktop: run 'start-desktop' (auto-detects best method)"
log "  -> XRDP manual: run 'start-desktop xrdp' then mstsc /v:localhost:3390"

# =============================================================================
section "PHASE 1: RECONNAISSANCE"
# =============================================================================
log "Recon — figure out who you're dealing with before you knock."
safe_install nmap
safe_install masscan
safe_install recon-ng
pip_install theHarvester
safe_install amass
safe_install dnsrecon
safe_install dnsenum
safe_install whois
safe_install fierce
safe_install sublist3r
# maltego requires manual install: https://www.maltego.com/downloads/

# OSINT tools
pip_install sherlock-project
pip_install holehe
pip_install shodan
pip_install spiderfoot

# GHunt
log "Installing GHunt..."
if ! pip3 show ghunt > /dev/null 2>&1; then
    pip_install ghunt
fi

# Photon web crawler
log "Installing Photon..."
if [ ! -d "$TOOLS_DIR/photon" ]; then
    git clone --depth 1 https://github.com/s0md3v/Photon.git "$TOOLS_DIR/photon" 2>/dev/null
    if [ -d "$TOOLS_DIR/photon" ]; then
        pip3 install -r "$TOOLS_DIR/photon/requirements.txt" --break-system-packages > /dev/null 2>&1 || true
        ln -sf "$TOOLS_DIR/photon/photon.py" /usr/local/bin/photon
        chmod +x "$TOOLS_DIR/photon/photon.py"
        INSTALLED+=("photon")
    else
        FAILED+=("photon")
    fi
fi

# =============================================================================
section "PHASE 2: SCANNING & ENUMERATION"
# =============================================================================
log "Knock on every port, rattle every service, read every banner."
safe_install enum4linux
safe_install smbclient
safe_install smbmap
safe_install snmp
safe_install onesixtyone
safe_install nbtscan
safe_install ldap-utils
safe_install samba-common-bin    # provides rpcclient
safe_install gobuster
safe_install feroxbuster
safe_install dirb
safe_install nikto
safe_install whatweb
# rustscan — not in Parrot repos, grab .deb from GitHub
if ! command -v rustscan &> /dev/null; then
    log "Downloading rustscan..."
    RUSTSCAN_URL=$(curl -s https://api.github.com/repos/RustScan/RustScan/releases/latest \
        | jq -r '.assets[].browser_download_url' 2>/dev/null | grep "amd64.deb" | head -1)
    if [ -n "$RUSTSCAN_URL" ] && [ "$RUSTSCAN_URL" != "null" ]; then
        wget -q -O /tmp/rustscan.deb "$RUSTSCAN_URL" 2>/dev/null
        dpkg -i /tmp/rustscan.deb > /dev/null 2>&1 || apt-get install -f -y > /dev/null 2>&1
        rm -f /tmp/rustscan.deb
        command -v rustscan &>/dev/null && INSTALLED+=("rustscan") || FAILED+=("rustscan")
    else
        warn "Could not fetch rustscan release URL"
        FAILED+=("rustscan")
    fi
else
    SKIPPED+=("rustscan")
fi

if ! command -v ffuf &> /dev/null; then
    go_install ffuf "github.com/ffuf/ffuf/v2@latest"
fi

# =============================================================================
section "PHASE 3: VULNERABILITY ANALYSIS"
# =============================================================================
log "Finding the weak spots. CVEs are just features with documentation."
safe_install exploitdb
# legion — not in Parrot repos, manual install: https://github.com/GoVanguard/legion
warn "legion not available in Parrot repos — install manually from https://github.com/GoVanguard/legion"
safe_install lynis

# =============================================================================
section "PHASE 4: WEB APPLICATION TESTING"
# =============================================================================
log "Breaking web apps — legally, on purpose, for fun and for flags."
safe_install sqlmap
safe_install wfuzz
safe_install wpscan
safe_install commix
safe_install zaproxy     # OWASP ZAP (GUI app)
safe_install wafw00f
safe_install burpsuite   # May not be in repos, manual install below

pip_install xsstrike

# jwt_tool
log "Installing jwt_tool..."
if [ ! -d "$TOOLS_DIR/jwt_tool" ]; then
    git clone --depth 1 https://github.com/ticarpi/jwt_tool.git "$TOOLS_DIR/jwt_tool" 2>/dev/null
    if [ -d "$TOOLS_DIR/jwt_tool" ]; then
        pip3 install -r "$TOOLS_DIR/jwt_tool/requirements.txt" --break-system-packages > /dev/null 2>&1 || true
        ln -sf "$TOOLS_DIR/jwt_tool/jwt_tool.py" /usr/local/bin/jwt_tool
        chmod +x "$TOOLS_DIR/jwt_tool/jwt_tool.py"
        INSTALLED+=("jwt_tool")
    else
        FAILED+=("jwt_tool")
    fi
fi

# tplmap (SSTI exploitation)
log "Installing tplmap..."
if [ ! -d "$TOOLS_DIR/tplmap" ]; then
    git clone --depth 1 https://github.com/epinna/tplmap.git "$TOOLS_DIR/tplmap" 2>/dev/null
    if [ -d "$TOOLS_DIR/tplmap" ]; then
        pip3 install -r "$TOOLS_DIR/tplmap/requirements.txt" --break-system-packages > /dev/null 2>&1 || true
        ln -sf "$TOOLS_DIR/tplmap/tplmap.py" /usr/local/bin/tplmap
        chmod +x "$TOOLS_DIR/tplmap/tplmap.py"
        INSTALLED+=("tplmap")
    else
        FAILED+=("tplmap")
    fi
fi

# Burp Suite Community (if not available via apt)
if ! command -v burpsuite &> /dev/null; then
    log "Downloading Burp Suite Community..."
    BURP_DIR="$TOOLS_DIR/burpsuite"
    mkdir -p "$BURP_DIR"
    # Burp requires manual download from PortSwigger - create a placeholder script
    cat > "$BURP_DIR/README.txt" << 'BURPEOF'
Burp Suite Community Edition
Download from: https://portswigger.net/burp/communitydownload
Install: java -jar burpsuite_community.jar
Or install via: sudo apt install burpsuite (if available in Parrot repos)
BURPEOF
fi

# =============================================================================
section "PHASE 5: EXPLOITATION"
# =============================================================================
log "The part people write scary articles about. Authorized targets only."
safe_install metasploit-framework
# crackmapexec is deprecated — netexec is the successor (installed via pip below)
safe_install evil-winrm
safe_install responder
safe_install swaks

# impacket — try apt package first (more stable on Parrot 13), pip as fallback
if apt-get install -y python3-impacket > /dev/null 2>&1; then
    INSTALLED+=("impacket")
else
    pip_install impacket
fi
pip_install netexec
pip_install pwncat-cs
pip_install certipy-ad

# Kerbrute
if ! command -v kerbrute &> /dev/null; then
    log "Downloading kerbrute..."
    KERBRUTE_URL="https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64"
    if wget -q -O /usr/local/bin/kerbrute "$KERBRUTE_URL" 2>/dev/null; then
        chmod +x /usr/local/bin/kerbrute
        INSTALLED+=("kerbrute")
    else
        FAILED+=("kerbrute")
    fi
fi

# Nishang PowerShell scripts
log "Downloading Nishang..."
if [ ! -d "$TOOLS_DIR/nishang" ]; then
    git clone --depth 1 https://github.com/samratashok/nishang.git "$TOOLS_DIR/nishang" 2>/dev/null && \
        INSTALLED+=("nishang") || FAILED+=("nishang")
fi

# =============================================================================
section "PHASE 6: PASSWORD ATTACKS"
# =============================================================================
log "rockyou.txt: 14 million reasons why 'password123' was a terrible idea."
safe_install john
safe_install hashcat
safe_install hydra
safe_install cewl
safe_install crunch
safe_install hash-identifier

pip_install hashid

# Wordlists
log "Installing SecLists..."
if [ ! -d "/usr/share/seclists" ]; then
    apt-get install -y seclists > /dev/null 2>&1 || {
        git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists 2>/dev/null
    }
    if [ -d "/usr/share/seclists" ]; then
        INSTALLED+=("seclists")
    else
        FAILED+=("seclists")
    fi
else
    SKIPPED+=("seclists")
fi

log "Ensuring rockyou.txt is available..."
if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then
    gunzip -k /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true
fi
safe_install wordlists

# =============================================================================
section "PHASE 7: POST-EXPLOITATION"
# =============================================================================
log "You're in. Now figure out where you are, what you can reach, and how deep it goes."
safe_install bloodhound     # GUI graph tool (needs neo4j)
safe_install neo4j
safe_install socat
safe_install proxychains4
safe_install sshuttle
# mimikatz/powercat: Windows-only binaries — download from GitHub when needed

pip_install pypykatz

# Chisel
if ! command -v chisel &> /dev/null; then
    go_install chisel "github.com/jpillora/chisel@latest"
fi

# dnscat2
log "Downloading dnscat2..."
if [ ! -d "$TOOLS_DIR/dnscat2" ]; then
    git clone --depth 1 https://github.com/iagox86/dnscat2.git "$TOOLS_DIR/dnscat2" 2>/dev/null
    if [ -d "$TOOLS_DIR/dnscat2" ]; then
        cd "$TOOLS_DIR/dnscat2/server" && gem install bundler 2>/dev/null && bundle install 2>/dev/null || true
        cd /
        INSTALLED+=("dnscat2")
    else
        FAILED+=("dnscat2")
    fi
fi

# LinPEAS / WinPEAS
log "Downloading PEAS suite..."
PEAS_DIR="$TOOLS_DIR/peas"
mkdir -p "$PEAS_DIR"
wget -q -O "$PEAS_DIR/linpeas.sh" "https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh" 2>/dev/null && chmod +x "$PEAS_DIR/linpeas.sh" || warn "Failed to download linpeas"
wget -q -O "$PEAS_DIR/winPEASx64.exe" "https://github.com/peass-ng/PEASS-ng/releases/latest/download/winPEASx64.exe" 2>/dev/null || warn "Failed to download winpeas"

# pspy
log "Downloading pspy..."
mkdir -p "$TOOLS_DIR/pspy"
wget -q -O "$TOOLS_DIR/pspy/pspy64" "https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64" 2>/dev/null && chmod +x "$TOOLS_DIR/pspy/pspy64" || warn "Failed to download pspy"

# Ligolo-ng
log "Downloading ligolo-ng..."
LIGOLO_DIR="$TOOLS_DIR/ligolo-ng"
mkdir -p "$LIGOLO_DIR"
LIGOLO_VER=$(curl -s https://api.github.com/repos/nicocha30/ligolo-ng/releases/latest | jq -r '.tag_name' 2>/dev/null)
if [ -n "$LIGOLO_VER" ] && [ "$LIGOLO_VER" != "null" ]; then
    wget -q -O "$LIGOLO_DIR/ligolo-proxy.tar.gz" "https://github.com/nicocha30/ligolo-ng/releases/download/${LIGOLO_VER}/ligolo-ng_proxy_${LIGOLO_VER#v}_linux_amd64.tar.gz" 2>/dev/null
    tar -xzf "$LIGOLO_DIR/ligolo-proxy.tar.gz" -C "$LIGOLO_DIR" 2>/dev/null || true
    rm -f "$LIGOLO_DIR/ligolo-proxy.tar.gz"
    wget -q -O "$LIGOLO_DIR/ligolo-agent.tar.gz" "https://github.com/nicocha30/ligolo-ng/releases/download/${LIGOLO_VER}/ligolo-ng_agent_${LIGOLO_VER#v}_linux_amd64.tar.gz" 2>/dev/null
    tar -xzf "$LIGOLO_DIR/ligolo-agent.tar.gz" -C "$LIGOLO_DIR" 2>/dev/null || true
    rm -f "$LIGOLO_DIR/ligolo-agent.tar.gz"
fi

# =============================================================================
section "PHASE 8: REVERSE ENGINEERING"
# =============================================================================
log "Reading other people's compiled code. Ghidra makes it slightly less painful."
safe_install ghidra          # GUI reverse engineering suite
safe_install radare2
safe_install gdb
safe_install gdb-peda
safe_install ltrace
safe_install strace
safe_install binwalk

pip_install pwntools

# =============================================================================
section "PHASE 9: FORENSICS & STEGO"
# =============================================================================
log "Finding things people tried to hide. Spoiler: steghide with rockyou is cheating and it works."
safe_install foremost
safe_install steghide
safe_install exiftool
safe_install testdisk
safe_install pdfid
safe_install pdf-parser
safe_install hexedit
safe_install xxd
safe_install autopsy         # GUI forensics platform

pip_install stegoveritas

# Stegseek — fast steghide cracker
log "Installing stegseek..."
if ! command -v stegseek &> /dev/null; then
    STEGSEEK_DEB=$(curl -s https://api.github.com/repos/RickdeJager/stegseek/releases/latest | jq -r '.assets[].browser_download_url' 2>/dev/null | grep "\.deb$" | head -1)
    if [ -n "$STEGSEEK_DEB" ] && [ "$STEGSEEK_DEB" != "null" ]; then
        wget -q -O /tmp/stegseek.deb "$STEGSEEK_DEB" 2>/dev/null
        dpkg -i /tmp/stegseek.deb > /dev/null 2>&1 || apt-get install -f -y > /dev/null 2>&1
        rm -f /tmp/stegseek.deb
        if command -v stegseek &> /dev/null; then
            INSTALLED+=("stegseek")
        else
            FAILED+=("stegseek")
        fi
    else
        FAILED+=("stegseek")
    fi
fi

# Volatility 3
log "Installing Volatility 3..."
if [ ! -d "$TOOLS_DIR/volatility3" ]; then
    git clone https://github.com/volatilityfoundation/volatility3.git "$TOOLS_DIR/volatility3" 2>/dev/null
    pip3 install -r "$TOOLS_DIR/volatility3/requirements.txt" --break-system-packages > /dev/null 2>&1 || true
fi

# =============================================================================
section "PHASE 10: WIRELESS (limited in WSL)"
# =============================================================================
log "WSL doesn't have raw WiFi access — installing anyway for when you boot into real hardware."
safe_install aircrack-ng
safe_install reaver
safe_install wifite

# =============================================================================
section "NETWORKING & MISC UTILITIES"
# =============================================================================
log "The stuff you'll use every single session without thinking about it."
safe_install tcpdump
safe_install wireshark       # GUI packet analyzer
safe_install tshark
safe_install netcat-openbsd
safe_install rlwrap
safe_install tmux
safe_install vim
safe_install tree
safe_install ftp
safe_install telnet
safe_install redis-tools
safe_install default-mysql-client   # renamed in Debian 13
safe_install postgresql-client
safe_install openvpn         # For HTB VPN
safe_install remmina          # GUI RDP/VNC client
safe_install remmina-plugin-rdp
safe_install remmina-plugin-vnc

# =============================================================================
section "CREATING DESKTOP SHORTCUTS FOR PENTEST TOOLS"
# =============================================================================

# Burp Suite launcher
cat > /usr/share/applications/burpsuite.desktop << 'EOF'
[Desktop Entry]
Name=Burp Suite
Comment=Web Application Security Testing
Exec=burpsuite
Icon=burpsuite
Terminal=false
Type=Application
Categories=Security;Network;
EOF

# Wireshark
cat > /usr/share/applications/wireshark-htb.desktop << 'EOF'
[Desktop Entry]
Name=Wireshark
Comment=Network Protocol Analyzer
Exec=wireshark
Icon=wireshark
Terminal=false
Type=Application
Categories=Security;Network;
EOF

# BloodHound
cat > /usr/share/applications/bloodhound.desktop << 'EOF'
[Desktop Entry]
Name=BloodHound
Comment=Active Directory Attack Path Analysis
Exec=bloodhound
Icon=bloodhound
Terminal=false
Type=Application
Categories=Security;
EOF

# Terminal shortcut with HTB theming
cat > /usr/share/applications/htb-terminal.desktop << 'EOF'
[Desktop Entry]
Name=HTB Terminal
Comment=Terminal for HackTheBox
Exec=xfce4-terminal --title="HTB Terminal" --color-bg="#1a2332" --color-fg="#a4b1cd"
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=System;TerminalEmulator;
EOF

# Brave Browser
if command -v brave-browser &> /dev/null; then
    cat > /usr/share/applications/brave-htb.desktop << 'EOF'
[Desktop Entry]
Name=Brave Browser
Comment=Privacy-focused web browser
Exec=brave-browser
Icon=brave-browser
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
fi

log "Desktop shortcuts created"

# =============================================================================
section "WSL CONFIGURATION HELPERS"
# =============================================================================

# NOTE: User creation, wsl.conf, and workspace setup are handled by
# wsl-config/setup-user.sh — run it separately after this script:
#   sudo bash wsl-config/setup-user.sh <your-username>

# Create a helper to fix common WSL GUI issues
cat > /usr/local/bin/fix-wsl-gui << 'FIXEOF'
#!/bin/bash
# Fix common WSL GUI issues
echo "[+] Fixing WSL GUI issues..."

# Fix D-Bus
if [ ! -d /run/user/$(id -u) ]; then
    sudo mkdir -p /run/user/$(id -u)
    sudo chown $(id -u):$(id -g) /run/user/$(id -u)
fi
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Restart D-Bus
sudo service dbus restart 2>/dev/null

# Fix display
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

# Test
if command -v xeyes &>/dev/null; then
    echo "[+] Testing GUI with xeyes..."
    xeyes &
    sleep 2
    killall xeyes 2>/dev/null
    echo "[+] If you saw the xeyes window, GUI is working!"
else
    echo "[!] Install x11-apps for GUI testing: sudo apt install x11-apps"
fi

echo "[+] Done. If GUI still doesn't work:"
echo "    1. Make sure WSLg is enabled (Windows 11 + WSL2)"
echo "    2. Run: wsl --shutdown (in PowerShell) then restart"
echo "    3. Or use XRDP: start-desktop xrdp"
FIXEOF
chmod +x /usr/local/bin/fix-wsl-gui

# =============================================================================
section "WSL FIXES"
# =============================================================================

# Fix nmap requiring root for SYN scans in WSL
log "Setting nmap capabilities for non-root scanning..."
NMAP_BIN=$(which nmap 2>/dev/null)
if [ -n "$NMAP_BIN" ]; then
    setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip "$NMAP_BIN" 2>/dev/null && \
        log "  nmap can now run SYN scans without sudo" || \
        warn "  Failed to set nmap capabilities (may need kernel support)"
fi

# Ensure DNS works after VPN connects (common WSL issue)
log "Setting up DNS fallback..."
if [ ! -f /etc/resolv.conf.backup ]; then
    cp /etc/resolv.conf /etc/resolv.conf.backup 2>/dev/null || true
fi

# =============================================================================
section "CLEANUP"
# =============================================================================
apt-get autoremove -y > /dev/null 2>&1
apt-get clean > /dev/null 2>&1

# Mark tools as installed
touch /etc/.parrot-toolkit-installed

# =============================================================================
section "INSTALLATION SUMMARY"
# =============================================================================
printf '%s%sSuccessfully installed (%s):%s\n' "$GREEN" "$BOLD" "${#INSTALLED[@]}" "$NC"
printf '  %s\n' "${INSTALLED[@]}"

if [ ${#SKIPPED[@]} -gt 0 ]; then
    printf '\n%sAlready installed / skipped (%s):%s\n' "$CYAN" "${#SKIPPED[@]}" "$NC"
    printf '  %s\n' "${SKIPPED[@]}"
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    printf '\n%sFailed to install (%s):%s\n' "$YELLOW" "${#FAILED[@]}" "$NC"
    printf '  %s\n' "${FAILED[@]}"
    printf '\n%s[!] These tools did not install. Not crashing out like a vibecoder\n' "$YELLOW"
    printf '    whose app breaks when the API is down. Install them manually when you get a chance:%s\n' "$NC"
    for f in "${FAILED[@]}"; do
        printf '    %s  apt install %s%s\n' "$CYAN" "$f" "$NC"
    done
    printf '\n%s    Or check the docs in the repo for alternative install methods.%s\n' "$YELLOW" "$NC"
fi

printf '\n%sExtra tools downloaded to: %s%s\n' "$GREEN" "$TOOLS_DIR" "$NC"
printf '%sFull install log: %s%s\n' "$GREEN" "$LOG_FILE" "$NC"
printf '%sWordlists at: /usr/share/seclists and /usr/share/wordlists%s\n' "$GREEN" "$NC"

printf '\n%s%s=== GUI QUICK START ===%s\n' "$CYAN" "$BOLD" "$NC"
printf '%s  Individual GUI apps (Wireshark, Ghidra, etc):%s just run them — WSLg handles display\n' "$GREEN" "$NC"
printf '%s  Full desktop environment:%s run '\''start-desktop'\''\n' "$GREEN" "$NC"
printf '%s  XRDP remote desktop:%s run '\''start-desktop xrdp'\'' then connect via mstsc /v:localhost:3390\n' "$GREEN" "$NC"
printf '%s  Fix GUI issues:%s run '\''fix-wsl-gui'\''\n' "$GREEN" "$NC"

# Check if user setup has been done
if [ ! -f /etc/.parrot-toolkit-user-setup ]; then
    echo ""
    printf '%s%s=== NEXT STEP ===%s\n' "$CYAN" "$BOLD" "$NC"
    printf '%s  User & workspace setup has not been run yet.%s\n' "$YELLOW" "$NC"
    printf '%s  This sets up a non-root user, workspace folders, shell aliases, VPN helper, and login banner.%s\n' "$GREEN" "$NC"
    echo ""
    read -rp "  Would you like to run user setup now? [Y/n] " RUN_SETUP
    RUN_SETUP="${RUN_SETUP:-y}"
    if [[ "$RUN_SETUP" =~ ^[Yy] ]]; then
        read -rp "  Enter your desired username: " SETUP_USERNAME
        if [ -n "$SETUP_USERNAME" ]; then
            if [ -f "$SCRIPT_DIR/wsl-config/setup-user.sh" ]; then
                bash "$SCRIPT_DIR/wsl-config/setup-user.sh" "$SETUP_USERNAME"
            else
                warn "setup-user.sh not found. Run it manually:"
                echo "    sudo bash wsl-config/setup-user.sh $SETUP_USERNAME"
            fi
        fi
    else
        echo ""
        printf '  %sRun it later with:%s\n' "$GREEN" "$NC"
        printf '    %ssudo bash wsl-config/setup-user.sh <your-username>%s\n' "$CYAN" "$NC"
    fi
else
    echo ""
    printf '%s  User setup already done. All good!%s\n' "$GREEN" "$NC"
fi

echo ""
printf '%s%s=== ONE MORE THING ===%s\n' "$CYAN" "$BOLD" "$NC"
echo ""
printf '  %s%sPlease, PLEASE use KeePassXC.%s It'\''s installed. It'\''s free. It'\''s right there.\n' "$GREEN" "$BOLD" "$NC"
echo ""
printf '  I know you have a passwords.txt somewhere on your Desktop.\n'
printf '  I know because %sI'\''m going to steal it%s. I'\''m a pentesting toolkit.\n' "$YELLOW" "$NC"
printf '  That'\''s literally what I was built to do.\n'
echo ""
printf '  Seriously though — you'\''re learning to hack into systems with weak passwords.\n'
printf '  Don'\''t be the guy whose own passwords are in a .txt file or saved in Chrome.\n'
printf '  That'\''s like a locksmith leaving his front door wide open.\n'
echo ""
printf '  %sKeePassXC%s — free, offline, open-source password manager\n' "$GREEN" "$NC"
printf '    %shttps://keepassxc.org%s\n' "$CYAN" "$NC"
printf '    %shttps://keepassxc.org/docs/KeePassXC_GettingStarted%s\n' "$CYAN" "$NC"
echo ""
printf '  Why not NordPass / 1Password / your browser?\n'
printf '  Because paying $5/month to store your passwords on %ssomeone else'\''s server%s\n' "$YELLOW" "$NC"
printf '  is just outsourcing your passwords.txt to a company that pinky-promises\n'
printf '  they won'\''t get breached. (Spoiler: LastPass said that too.)\n'
printf '  And giving them to Google? That'\''s not a password manager, that'\''s a confession.\n'
echo ""
printf '  %sWhile you'\''re at it:%s\n' "$BOLD" "$NC"
printf '  %s•%s Use a %sunique password%s for every single account. Yes, every one.\n' "$GREEN" "$NC" "$BOLD" "$NC"
printf '  %s•%s Make them %slong%s (20+ chars). KeePassXC generates them for you.\n' "$GREEN" "$NC" "$BOLD" "$NC"
printf '  %s•%s Enable %s2FA everywhere%s. TOTP app (not SMS). KeePassXC does TOTP too.\n' "$GREEN" "$NC" "$BOLD" "$NC"
printf '  %s•%s Your master password should be a %spassphrase%s — 4+ random words.\n' "$GREEN" "$NC" "$BOLD" "$NC"
echo ""
printf '  %sLearn more:%s\n' "$CYAN" "$NC"
printf '    %shttps://www.ncsc.gov.uk/collection/top-tips-for-staying-secure-online%s\n' "$CYAN" "$NC"
printf '    (NCSC UK — the Brits know a thing or two about keeping secrets.)\n'
echo ""
printf '    %shttps://www.cisa.gov/secure-our-world/use-strong-passwords%s\n' "$CYAN" "$NC"
printf '    (CISA — US Cybersecurity Agency. Short, sweet, to the point.)\n'
echo ""
printf '    %shttps://cyber-gouv-fr.translate.goog/bonnes-pratiques-protegez-vous?_x_tr_sl=fr&_x_tr_tl=en%s\n' "$CYAN" "$NC"
printf '    (ANSSI — France'\''s cyber agency. They protect nuclear secrets AND croissant recipes. Auto-translated for you.)\n'
echo ""
printf '    %shttps://www.troyhunt.com/passwords-evolved-authentication-guidance-for-the-modern-era/%s\n' "$CYAN" "$NC"
printf '    (Troy Hunt — the guy who made haveibeenpwned. He definitely knows your 2008 MSN password. At least he'\''s got mine.)\n'
echo ""
printf '    %shttps://ssd.eff.org/module/creating-strong-passwords%s\n' "$CYAN" "$NC"
printf '    (EFF — they'\''ve been fighting for your digital rights since before you were born.)\n'
echo ""
printf '    %sAnd this one'\''s for your grandpa and your little sister:%s\n' "$YELLOW" "$NC"
printf '    %shttps://staysafeonline.org/online-safety-privacy-basics/passwords-securing-accounts/%s\n' "$CYAN" "$NC"
printf '    (National Cybersecurity Alliance — explains it so well even your cat could set up 2FA.)\n'
echo ""
printf '  %sOne last thing — go check if you'\''ve already been pwned:%s\n' "$BOLD" "$NC"
printf '    %shttps://haveibeenpwned.com%s\n' "$CYAN" "$NC"
printf '    Go ahead, type your email. I'\''ll wait.\n'
printf '    ...yeah. That'\''s how many companies had your password and %slost it%s.\n' "$RED" "$NC"
printf '    If that list isn'\''t empty, you need KeePassXC %stoday%s, not tomorrow.\n' "$YELLOW" "$NC"
echo ""

printf '\n%s%sHappy hacking!%s\n\n' "$CYAN" "$BOLD" "$NC"
