# whois

## Purpose
Queries WHOIS databases for domain registration info, IP ownership, ASN details, and nameserver information. Useful for initial passive recon.

## Installation
```bash
sudo apt install whois
```

## Quick Start
```bash
# Domain lookup
whois target.com

# IP address lookup
whois 10.10.10.1

# Specific WHOIS server
whois -h whois.arin.net 10.10.10.0

# ASN lookup
whois -h whois.radb.net AS12345
```

## Key Options
| Option | Description |
|--------|-------------|
| `-h <server>` | Specify WHOIS server |
| `-p <port>` | Custom port |
| `--verbose` | Verbose output |

## HTB Usage
- Mostly useful for OSINT-style challenges
- Identify IP block ownership
- Check domain registration details in real-world-style boxes
