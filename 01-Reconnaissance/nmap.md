# Nmap — Network Mapper

## Purpose
The most essential network scanning tool. Discovers hosts, open ports, running services, OS versions, and vulnerabilities on target networks.

## Install
```bash
sudo apt install nmap
```

## Core Usage

### Host Discovery
```bash
nmap -sn 10.10.10.0/24              # Ping sweep — find live hosts
nmap -Pn 10.10.10.5                  # Skip ping, scan directly (useful when ICMP blocked)
```

### Port Scanning
```bash
nmap 10.10.10.5                      # Top 1000 ports (TCP SYN)
nmap -p- 10.10.10.5                  # All 65535 ports
nmap -p 80,443,8080 10.10.10.5      # Specific ports
nmap -sU 10.10.10.5                  # UDP scan
nmap --top-ports 100 10.10.10.5     # Top 100 most common ports
```

### Service & Version Detection
```bash
nmap -sV 10.10.10.5                  # Detect service versions
nmap -sC 10.10.10.5                  # Run default NSE scripts
nmap -A 10.10.10.5                   # Aggressive: OS, versions, scripts, traceroute
```

### NSE Scripts
```bash
nmap --script vuln 10.10.10.5                    # Run all vuln scripts
nmap --script smb-enum-shares 10.10.10.5         # Enumerate SMB shares
nmap --script http-enum 10.10.10.5               # Enumerate web paths
ls /usr/share/nmap/scripts/ | grep <keyword>     # Find scripts
```

## HTB Quick Start
```bash
# Standard initial scan
nmap -sC -sV -oN initial.txt 10.10.10.5

# Full port scan
nmap -p- --min-rate 5000 -oN allports.txt 10.10.10.5

# Targeted scan on discovered ports
nmap -sC -sV -p 22,80,445 -oN targeted.txt 10.10.10.5
```

## Output Formats
```bash
-oN file.txt    # Normal output
-oG file.txt    # Grepable output
-oX file.xml    # XML output
-oA basename    # All formats at once
```

## Tips
- Use `--min-rate 5000` on HTB to speed things up (controlled environment)
- Always save output (`-oN`) so you don't have to rescan
- Combine `-sC -sV` as your default for service enumeration
