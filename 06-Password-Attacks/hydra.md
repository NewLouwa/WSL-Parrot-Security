# Hydra

## Purpose
Fast online password brute-forcer. Attacks login services over the network: SSH, FTP, HTTP, SMB, RDP, MySQL, and 50+ other protocols.

## Installation
```bash
sudo apt install hydra
```

## Quick Start
```bash
# SSH brute-force
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.10.10.x

# FTP brute-force
hydra -L users.txt -P passwords.txt ftp://10.10.10.x

# HTTP POST login form
hydra -l admin -P rockyou.txt 10.10.10.x http-post-form "/login:user=^USER^&pass=^PASS^:Invalid credentials"

# HTTP Basic Auth
hydra -l admin -P rockyou.txt 10.10.10.x http-get /admin

# SMB
hydra -l admin -P rockyou.txt smb://10.10.10.x

# RDP
hydra -l admin -P rockyou.txt rdp://10.10.10.x

# MySQL
hydra -l root -P rockyou.txt mysql://10.10.10.x

# With threads and wait
hydra -l admin -P rockyou.txt -t 4 -W 1 ssh://10.10.10.x
```

## Key Options
| Option | Description |
|--------|-------------|
| `-l` | Single username |
| `-L` | Username wordlist |
| `-p` | Single password |
| `-P` | Password wordlist |
| `-t` | Threads (default 16) |
| `-W` | Wait time between requests |
| `-f` | Stop on first valid cred |
| `-V` | Verbose (show each attempt) |
| `-s` | Custom port |
| `-o` | Output file |

## HTTP Form Syntax
```
http-post-form "/path:BODY:FAIL_STRING"
```
- `^USER^` = username placeholder
- `^PASS^` = password placeholder
- `FAIL_STRING` = text present on failed login

## HTB Usage
- Always reduce threads (`-t 4`) to avoid lockouts and crashes
- HTTP forms: inspect login request in Burp to get exact POST body
- Use `-f` to stop as soon as valid creds found
- Combine with CeWL-generated wordlists for targeted attacks
