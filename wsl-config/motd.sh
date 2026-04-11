#!/bin/bash
# =============================================================================
# Parrot WSL Security Toolkit — Login Banner (MOTD)
#
# To disable: remove or comment the 'source ~/.motd.sh' line in ~/.bashrc
# To edit:    nano ~/.motd.sh
# =============================================================================

GREEN=$'\033[0;32m'
CYAN=$'\033[0;36m'
YELLOW=$'\033[1;33m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
NC=$'\033[0m'

# Get VPN status
VPN_IP=$(ip -4 addr show tun0 2>/dev/null | grep -oP 'inet \K[\d.]+')
if [ -n "$VPN_IP" ]; then
    VPN_STATUS="${GREEN}Connected${NC} ($VPN_IP)"
else
    VPN_STATUS="${YELLOW}Not connected${NC}"
fi

echo ""
echo "${GREEN}${BOLD}  ╔══════════════════════════════════════════════╗${NC}"
echo "${GREEN}${BOLD}  ║   Parrot WSL Security Toolkit               ║${NC}"
echo "${GREEN}${BOLD}  ╚══════════════════════════════════════════════╝${NC}"
echo ""
echo "  ${CYAN}HTB VPN:${NC}  $VPN_STATUS"
echo ""
echo "  ${BOLD}Quick Commands${NC}"
echo "  ${GREEN}vpn${NC}                         Connect to HTB VPN"
echo "  ${GREEN}vpn-status${NC}                  Check VPN connection"
echo "  ${GREEN}new-machine${NC} Name 10.10.10.x Start a new machine"
echo "  ${GREEN}htb-shell${NC} Name              Enter project shell (logs cmds)"
echo "  ${GREEN}new-challenge${NC} web name      Start a new challenge"
echo "  ${GREEN}serve${NC}                       HTTP server for file transfer"
echo "  ${GREEN}rsh${NC} 4444                    Reverse shell listener"
echo "  ${GREEN}myip${NC}                        Show your HTB VPN IP"
echo "  ${GREEN}cheat${NC} toolname              Show tool cheat sheet (cheat nmap)"
if [ -f /etc/.parrot-toolkit-gui-installed ]; then
echo ""
echo "  ${BOLD}GUI${NC}"
echo "  ${GREEN}start-desktop${NC}               Launch XFCE4 desktop (WSLg or XRDP)"
echo "  ${GREEN}start-desktop xrdp${NC}          Force XRDP — then mstsc /v:localhost:3390"
echo "  ${GREEN}fix-wsl-gui${NC}                 Fix display issues"
fi
echo ""
echo "  ${BOLD}Navigation${NC}"
echo "  ${GREEN}ws${NC}  workspace  ${GREEN}htb${NC}  htb folder  ${GREEN}machines${NC}  machines folder"
echo ""
echo "  ${DIM}Docs: ~/WSL-Parrot-Security/ or https://github.com/NewLouwa/WSL-Parrot-Security${NC}"
echo "  ${DIM}Banner: ~/.motd.sh (edit or remove the source line in ~/.bashrc to disable)${NC}"
echo "  ${DIM}If this helped you, leave a star on the repo :)${NC}"
echo ""
