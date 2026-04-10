# OpenVPN

## Purpose
VPN client for connecting to HackTheBox and other VPN-based lab environments. Required to access HTB machines.

## Installation
```bash
sudo apt install openvpn
```

## Quick Start
```bash
# Connect to HTB VPN
sudo openvpn your-htb-lab.ovpn

# Connect in background
sudo openvpn --config your-htb-lab.ovpn --daemon

# Check connection
ip addr show tun0
# Should show 10.10.x.x address
```

## HTB Setup
1. Log into hackthebox.com
2. Go to Access > Connection Pack
3. Download .ovpn file for your lab (Starting Point, Machines, etc.)
4. Connect: `sudo openvpn lab_username.ovpn`
5. Verify: `ping 10.10.10.x` (target machine)

## Tips
```bash
# Use with tmux (keep VPN running in background)
tmux new -s vpn
sudo openvpn lab.ovpn
# Ctrl+B, D to detach

# Check your HTB IP
ip addr show tun0 | grep inet

# If connection drops, reconnect
sudo killall openvpn
sudo openvpn lab.ovpn
```

## HTB Usage
- Required for every HTB machine and challenge
- Keep .ovpn files organized per lab type
- Always verify tun0 interface is up before starting a box
- Use `tun0` as your LHOST for reverse shells
