# dirb

## Purpose
Web content scanner that brute-forces directories and files on web servers using wordlists. Simple and reliable alternative to gobuster/ffuf.

## Installation
```bash
sudo apt install dirb
```

## Quick Start
```bash
# Basic scan with default wordlist
dirb http://target.htb

# Custom wordlist
dirb http://target.htb /usr/share/seclists/Discovery/Web-Content/common.txt

# With authentication
dirb http://target.htb -u admin:password

# Custom extensions
dirb http://target.htb -X .php,.html,.txt

# Save output
dirb http://target.htb -o results.txt
```

## Key Options
| Option | Description |
|--------|-------------|
| `-o <file>` | Save output |
| `-X <exts>` | Append extensions (.php,.txt) |
| `-u <user:pass>` | HTTP Basic auth |
| `-H <header>` | Custom header |
| `-a <agent>` | Custom User-Agent |
| `-c <cookie>` | Set cookie |
| `-z <ms>` | Delay between requests |
| `-r` | Don't recurse |
| `-S` | Silent mode (no test output) |

## HTB Usage
- Discover hidden directories and files on web servers
- Find admin panels, backup files, config files
- Slower but more thorough than gobuster for basic enumeration
