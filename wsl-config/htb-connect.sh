#!/bin/bash
# =============================================================================
# HTB Connect — OpenVPN connector with connectivity check
#
# Interactive:  htb-connect
# One-liner:    htb-connect /path/to/lab.ovpn 10.10.10.x
# =============================================================================

GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
YELLOW=$'\033[1;33m'
CYAN=$'\033[0;36m'
NC=$'\033[0m'

log()  { echo "${GREEN}[+]${NC} $1"; }
warn() { echo "${YELLOW}[!]${NC} $1"; }
err()  { echo "${RED}[-]${NC} $1"; }
info() { echo "${CYAN}[*]${NC} $1"; }

# Default VPN dir
VPN_DIR="$HOME/workspace/htb/vpn"

# ---- Resolve .ovpn path ----
resolve_ovpn() {
    local path="$1"

    # Convert Windows paths to WSL paths
    if [[ "$path" =~ ^[A-Za-z]:\\ ]] || [[ "$path" =~ ^[A-Za-z]:/ ]]; then
        # Windows path like C:\Users\... or C:/Users/...
        drive=$(echo "${path:0:1}" | tr '[:upper:]' '[:lower:]')
        rest="${path:2}"
        rest="${rest//\\//}"
        path="/mnt/$drive$rest"
    fi

    echo "$path"
}

# ---- Kill existing VPN ----
kill_vpn() {
    if pgrep -x openvpn > /dev/null; then
        warn "Existing OpenVPN connection found. Killing it..."
        sudo killall openvpn 2>/dev/null
        sleep 2
    fi
}

# ---- Wait for tun0 ----
wait_for_tun0() {
    info "Waiting for VPN interface..."
    for i in $(seq 1 15); do
        if ip link show tun0 &>/dev/null; then
            return 0
        fi
        sleep 1
    done
    return 1
}

# ---- Ping test ----
ping_target() {
    local ip="$1"
    info "Pinging $ip..."
    if ping -c 3 -W 2 "$ip" > /dev/null 2>&1; then
        log "Target $ip is reachable!"
        return 0
    else
        err "Target $ip is not reachable."
        warn "The machine might be stopped. Start it on HTB and try again."
        return 1
    fi
}

# ---- Show VPN info ----
show_info() {
    local vpn_ip
    vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP 'inet \K[\d.]+')
    echo ""
    log "VPN connected!"
    info "Your HTB IP: ${GREEN}$vpn_ip${NC}"
    info "Interface:   tun0"
    info "Use this as LHOST in exploits and reverse shells"
    echo ""
}

# ---- List .ovpn files ----
list_ovpn_files() {
    local files=()

    # Check workspace vpn dir
    if [ -d "$VPN_DIR" ]; then
        while IFS= read -r f; do
            files+=("$f")
        done < <(find "$VPN_DIR" -name "*.ovpn" 2>/dev/null)
    fi

    # Check home dir
    while IFS= read -r f; do
        files+=("$f")
    done < <(find "$HOME" -maxdepth 2 -name "*.ovpn" 2>/dev/null)

    # Check /mnt/c common locations
    for windir in "/mnt/c/Users/*/Downloads" "/mnt/c/Users/*/Desktop"; do
        while IFS= read -r f; do
            files+=("$f")
        done < <(find $windir -name "*.ovpn" 2>/dev/null)
    done

    # Deduplicate
    printf '%s\n' "${files[@]}" | sort -u
}

# ---- Interactive mode ----
interactive() {
    echo "${CYAN}╔════════════════════════════════╗${NC}"
    echo "${CYAN}║      HTB Connect — OpenVPN     ║${NC}"
    echo "${CYAN}╚════════════════════════════════╝${NC}"
    echo ""

    # Find .ovpn files
    info "Searching for .ovpn files..."
    mapfile -t found_files < <(list_ovpn_files)

    OVPN_PATH=""

    if [ ${#found_files[@]} -gt 0 ]; then
        log "Found .ovpn files:"
        echo ""
        for i in "${!found_files[@]}"; do
            local display_path="${found_files[$i]}"
            local path_note=""
            if [[ "$display_path" == /mnt/c/* ]]; then
                path_note=" ${YELLOW}(Windows)${NC}"
            fi
            echo "  ${GREEN}[$((i+1))]${NC} ${display_path}${path_note}"
        done
        echo "  ${GREEN}[0]${NC} Enter a custom path"
        echo ""
        # Tip if any file is on Windows filesystem
        local has_mnt=false
        for f in "${found_files[@]}"; do [[ "$f" == /mnt/c/* ]] && has_mnt=true; done
        if [ "$has_mnt" = true ]; then
            echo "  ${YELLOW}Tip:${NC} /mnt/c/ is your Windows C: drive mounted inside WSL."
            echo "       For faster access, copy your .ovpn to: ${CYAN}~/workspace/htb/vpn/${NC}"
            echo ""
        fi

        read -rp "Select a file [1]: " choice
        choice="${choice:-1}"

        if [ "$choice" = "0" ]; then
            read -rp "Enter .ovpn file path (Windows or Linux): " OVPN_PATH
        elif [ "$choice" -ge 1 ] && [ "$choice" -le ${#found_files[@]} ] 2>/dev/null; then
            OVPN_PATH="${found_files[$((choice-1))]}"
        else
            err "Invalid selection"
            exit 1
        fi
    else
        warn "No .ovpn files found automatically."
        echo ""
        info "Tip: Save your HTB .ovpn files to: $VPN_DIR"
        info "Accepts Windows paths too (e.g., C:\\Users\\You\\Downloads\\lab.ovpn)"
        echo ""
        read -rp "Enter .ovpn file path: " OVPN_PATH
    fi

    OVPN_PATH=$(resolve_ovpn "$OVPN_PATH")

    if [ ! -f "$OVPN_PATH" ]; then
        err "File not found: $OVPN_PATH"
        exit 1
    fi

    log "Using: $OVPN_PATH"
    echo ""

    # Ask for target IP
    read -rp "Target machine IP (leave empty to skip ping test): " TARGET_IP
    echo ""

    # Connect
    connect "$OVPN_PATH" "$TARGET_IP"
}

# ---- Connect ----
connect() {
    local ovpn="$1"
    local target="$2"

    kill_vpn

    # Backup DNS before VPN overwrites resolv.conf
    if [ -f /etc/resolv.conf ] && [ ! -f /tmp/resolv.conf.pre-vpn ]; then
        cp /etc/resolv.conf /tmp/resolv.conf.pre-vpn
    fi

    log "Connecting to HTB VPN..."
    sudo openvpn --config "$ovpn" --daemon --log /tmp/htb-vpn.log

    if wait_for_tun0; then
        show_info

        if [ -n "$target" ]; then
            ping_target "$target"
        fi

        info "VPN running in background. Log: /tmp/htb-vpn.log"
        info "To disconnect: ${CYAN}sudo killall openvpn${NC}"
    else
        err "VPN failed to connect. Check the log:"
        echo "  cat /tmp/htb-vpn.log"
        exit 1
    fi
}

# ---- Disconnect ----
disconnect() {
    if pgrep -x openvpn > /dev/null; then
        sudo killall openvpn 2>/dev/null
        # Restore DNS if it was backed up
        if [ -f /tmp/resolv.conf.pre-vpn ]; then
            sudo cp /tmp/resolv.conf.pre-vpn /etc/resolv.conf 2>/dev/null
            rm -f /tmp/resolv.conf.pre-vpn
            log "DNS restored."
        fi
        log "VPN disconnected."
    else
        warn "No VPN connection found."
    fi
}

# ---- Status ----
status() {
    if ip link show tun0 &>/dev/null; then
        local vpn_ip
        vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP 'inet \K[\d.]+')
        log "VPN is connected. Your IP: $vpn_ip"
    else
        warn "VPN is not connected."
    fi
}

# ---- Main ----
case "${1:-}" in
    --help|-h)
        echo "Usage:"
        echo "  htb-connect                              Interactive mode"
        echo "  htb-connect <ovpn-file> [target-ip]      One-liner connect"
        echo "  htb-connect --disconnect                 Kill VPN"
        echo "  htb-connect --status                     Check VPN status"
        echo ""
        echo "Accepts both Linux and Windows paths:"
        echo "  htb-connect ~/workspace/htb/vpn/lab.ovpn 10.10.10.5"
        echo "  htb-connect 'C:\\Users\\You\\Downloads\\lab.ovpn' 10.10.10.5"
        ;;
    --disconnect|--dc|-d)
        disconnect
        ;;
    --status|-s)
        status
        ;;
    "")
        interactive
        ;;
    *)
        # One-liner mode
        OVPN_PATH=$(resolve_ovpn "$1")
        TARGET_IP="${2:-}"

        if [ ! -f "$OVPN_PATH" ]; then
            err "File not found: $OVPN_PATH"
            exit 1
        fi

        connect "$OVPN_PATH" "$TARGET_IP"
        ;;
esac
