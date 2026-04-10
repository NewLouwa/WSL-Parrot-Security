# theHarvester

## Purpose
OSINT tool for gathering emails, subdomains, IPs, and URLs from public sources (search engines, PGP servers, Shodan, etc.).

## Install
```bash
sudo apt install theharvester
```

## Usage
```bash
theHarvester -d target.com -b google              # Search Google
theHarvester -d target.com -b all                  # All sources
theHarvester -d target.com -b bing,yahoo -l 200   # Bing + Yahoo, 200 results
theHarvester -d target.com -b linkedin             # LinkedIn usernames
```

## Key Flags
```bash
-d          # Target domain
-b          # Data source (google, bing, linkedin, shodan, crtsh, all)
-l          # Limit number of results
-f file     # Save to HTML/XML
-s          # Use Shodan to query discovered hosts
```

## Sources
`google`, `bing`, `yahoo`, `linkedin`, `crtsh`, `dnsdumpster`, `shodan`, `virustotal`, `threatcrowd`, `hunter`

## Tips
- Configure API keys in `/etc/theHarvester/api-keys.yaml` for premium sources
- Great for initial recon before any active scanning
- Combine emails found here with password spraying tools later
