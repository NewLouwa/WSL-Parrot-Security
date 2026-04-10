# dnsenum

## Purpose
DNS enumeration tool that gathers DNS information about a domain including subdomains, MX records, NS records, and attempts zone transfers.

## Installation
```bash
sudo apt install dnsenum
```

## Quick Start
```bash
# Basic enumeration
dnsenum target.htb

# With subdomain brute-force
dnsenum --enum target.htb

# Use a custom wordlist
dnsenum -f /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt target.htb

# Limit threads
dnsenum --threads 10 target.htb
```

## Key Options
| Option | Description |
|--------|-------------|
| `--enum` | Full enumeration (equiv to --threads 5 -s 15 -w) |
| `-f <file>` | Subdomain brute-force wordlist |
| `--threads <n>` | Number of threads |
| `-r` | Recursion on subdomains |
| `-o <file>` | Output to XML file |
| `--noreverse` | Skip reverse lookups |

## HTB Usage
- Discover subdomains on target domains
- Check for zone transfers (misconfigured DNS)
- Map out DNS infrastructure before deeper enumeration
- Combine with `/etc/hosts` entries for HTB boxes
