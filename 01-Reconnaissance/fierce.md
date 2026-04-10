# fierce

## Purpose
DNS reconnaissance tool that locates non-contiguous IP space and hostnames against domains. Tries zone transfers, then brute-forces subdomains.

## Installation
```bash
sudo apt install fierce
```

## Quick Start
```bash
# Basic scan
fierce --domain target.htb

# With custom wordlist
fierce --domain target.htb --subdomain-file /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

# Specify DNS server
fierce --domain target.htb --dns-servers 10.10.10.2

# Wide scan (expand search to nearby IPs)
fierce --domain target.htb --wide
```

## Key Options
| Option | Description |
|--------|-------------|
| `--domain` | Target domain |
| `--subdomain-file` | Wordlist for brute-force |
| `--dns-servers` | Custom DNS server |
| `--wide` | Scan entire class C of found IPs |
| `--traverse <n>` | Scan IPs near discovered hosts |

## HTB Usage
- Quick subdomain discovery
- Find hidden virtual hosts on HTB machines
- Identify DNS misconfigurations (zone transfers)
