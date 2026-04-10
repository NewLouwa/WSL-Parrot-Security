# Masscan

## Purpose
Extremely fast port scanner. Scans the entire internet in under 6 minutes. Use it for rapid port discovery, then follow up with nmap for detailed enumeration.

## Install
```bash
sudo apt install masscan
```

## Usage

### Basic Scan
```bash
sudo masscan -p 1-65535 10.10.10.5 --rate=1000    # All ports, 1000 pps
sudo masscan -p 80,443 10.10.10.0/24 --rate=500   # Specific ports on subnet
```

### Common Options
```bash
--rate=10000       # Packets per second (be careful with high values)
-p 0-65535         # Port range
--banners          # Grab service banners
-oL output.txt     # List output
-oJ output.json    # JSON output
-oG output.gnmap   # Grepable output
```

## HTB Workflow
```bash
# Fast discovery of all open ports
sudo masscan -p 1-65535 10.10.10.5 --rate=1000 -oL ports.txt

# Then use nmap on discovered ports
nmap -sC -sV -p <ports_from_masscan> 10.10.10.5
```

## Tips
- Always run as root (needs raw sockets)
- Don't crank the rate too high on HTB — `1000` is fine
- Use masscan for discovery, nmap for enumeration
