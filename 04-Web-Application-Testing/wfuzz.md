# wfuzz

## Purpose
Web application fuzzer for brute-forcing directories, parameters, headers, POST data, and more. Very flexible with the FUZZ keyword placeholder.

## Installation
```bash
sudo apt install wfuzz
```

## Quick Start
```bash
# Directory brute-force
wfuzz -w /usr/share/seclists/Discovery/Web-Content/common.txt --hc 404 http://target.htb/FUZZ

# Subdomain enumeration
wfuzz -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -H "Host: FUZZ.target.htb" --hc 302 http://target.htb

# POST parameter fuzzing
wfuzz -w wordlist.txt -d "user=admin&pass=FUZZ" --hc 403 http://target.htb/login

# Multiple fuzz points
wfuzz -w users.txt -w passwords.txt -d "user=FUZ2Z&pass=FUZZ" http://target.htb/login

# Filter by response size
wfuzz -w wordlist.txt --hl 0 http://target.htb/FUZZ

# With cookie
wfuzz -w wordlist.txt -b "session=abc123" http://target.htb/FUZZ
```

## Key Options
| Option | Description |
|--------|-------------|
| `-w <wordlist>` | Wordlist file |
| `--hc <code>` | Hide responses with status code |
| `--hl <lines>` | Hide responses with line count |
| `--hw <words>` | Hide responses with word count |
| `--hh <chars>` | Hide responses with char count |
| `-H <header>` | Add header |
| `-b <cookie>` | Add cookie |
| `-d <data>` | POST data |
| `-t <n>` | Concurrent threads |
| `-p <proxy>` | Use proxy |

## HTB Usage
- Virtual host discovery with Host header fuzzing
- Parameter discovery on web apps
- Brute-force login forms
- FUZZ keyword goes wherever you want to inject payloads
