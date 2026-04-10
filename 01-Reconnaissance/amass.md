# Amass

## Purpose
Advanced subdomain enumeration and network mapping. Uses OSINT, DNS brute-forcing, and API integrations to discover subdomains and map attack surfaces.

## Install
```bash
sudo apt install amass
```

## Usage

### Passive Enumeration (no direct contact with target)
```bash
amass enum -passive -d target.com
```

### Active Enumeration
```bash
amass enum -d target.com                          # Standard enum
amass enum -brute -d target.com                   # Include brute-force
amass enum -d target.com -o subdomains.txt        # Save output
```

### Intel Gathering
```bash
amass intel -d target.com                         # Discover related domains
amass intel -whois -d target.com                  # Reverse whois
```

## Key Flags
```bash
-passive       # OSINT only, no DNS queries to target
-brute         # Include brute-force subdomain guessing
-min-for-recursive 2   # Require 2 subs before recursive brute
-o file.txt    # Output file
-json file.json # JSON output
```

## Tips
- Configure API keys in `~/.config/amass/config.ini` for better results
- Start with `-passive` to avoid detection
- Combine with other tools like `subfinder` or `dnsrecon`
