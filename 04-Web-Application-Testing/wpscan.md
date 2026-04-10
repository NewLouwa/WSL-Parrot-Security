# WPScan

## Purpose
WordPress security scanner. Detects vulnerable plugins, themes, users, and misconfigurations in WordPress installations.

## Installation
```bash
sudo apt install wpscan
```

## Quick Start
```bash
# Basic scan
wpscan --url http://target.htb

# Enumerate users
wpscan --url http://target.htb -e u

# Enumerate vulnerable plugins
wpscan --url http://target.htb -e vp

# Enumerate all plugins
wpscan --url http://target.htb -e ap

# Enumerate themes
wpscan --url http://target.htb -e vt

# Full enumeration
wpscan --url http://target.htb -e ap,at,u,dbe

# Password brute-force
wpscan --url http://target.htb -U admin -P /usr/share/wordlists/rockyou.txt

# With API token (for vulnerability data)
wpscan --url http://target.htb --api-token YOUR_TOKEN
```

## Key Options
| Option | Description |
|--------|-------------|
| `--url` | Target WordPress URL |
| `-e` | Enumerate: u(sers), p(lugins), t(hemes), vp, vt, ap, at, dbe |
| `-U` | Username(s) for brute-force |
| `-P` | Password wordlist |
| `--api-token` | WPVulnDB API token |
| `--plugins-detection` | aggressive/passive/mixed |
| `--force` | Don't check if target is WordPress |
| `--stealthy` | Alias for passive detection |

## HTB Usage
- Always run on WordPress sites found during enumeration
- Check for vulnerable plugins - most common WP attack vector
- Enumerate users, then brute-force with rockyou
- Get free API token at wpscan.com for vulnerability database
