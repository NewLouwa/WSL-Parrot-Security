# ffuf — Fuzz Faster U Fool

## Purpose
Fast web fuzzer for directory discovery, parameter fuzzing, vhost enumeration, and more. Extremely flexible with the FUZZ keyword system.

## Install
```bash
sudo apt install ffuf
# or
go install github.com/ffuf/ffuf/v2@latest
```

## Usage

### Directory Fuzzing
```bash
ffuf -u http://10.10.10.5/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

### Extension Fuzzing
```bash
ffuf -u http://10.10.10.5/FUZZ -w wordlist.txt -e .php,.html,.txt
```

### VHost/Subdomain Fuzzing
```bash
ffuf -u http://target.com -H "Host: FUZZ.target.com" -w subdomains.txt -fs 4242
```

### Parameter Fuzzing (GET)
```bash
ffuf -u "http://10.10.10.5/page?FUZZ=test" -w /usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt
```

### Parameter Fuzzing (POST)
```bash
ffuf -u http://10.10.10.5/login -X POST -d "username=admin&password=FUZZ" -w passwords.txt
```

### Multi-Word Fuzzing
```bash
ffuf -u http://10.10.10.5/FUZZ1/FUZZ2 -w users.txt:FUZZ1 -w ids.txt:FUZZ2
```

## Key Flags
```bash
-u          # URL with FUZZ keyword
-w          # Wordlist (wordlist:KEYWORD for named)
-H          # Header
-X          # HTTP method
-d          # POST data
-e          # Extensions
-t          # Threads (default 40)
-mc         # Match status codes (default: 200,204,301,302,307,401,403,405)
-fc         # Filter status codes
-fs         # Filter by response size
-fw         # Filter by word count
-fl         # Filter by line count
-o          # Output file
-of         # Output format (json, csv, html)
-ic         # Ignore comments in wordlist
-recursion  # Enable recursive fuzzing
```

## HTB Quick Start
```bash
# Standard directory brute-force
ffuf -u http://10.10.10.5/FUZZ -w /usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt -ic

# Filter out noise by size
ffuf -u http://10.10.10.5/FUZZ -w wordlist.txt -fs 0

# Subdomain enum
ffuf -u http://10.10.10.5 -H "Host: FUZZ.target.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -fs <default_size>
```

## Tips
- Run once without filters, note the default response size, then re-run with `-fs <size>`
- ffuf is generally faster than gobuster
- Use `-ic` to ignore comment lines in wordlists
- `-mc all -fc 404` is a good catch-all filter approach
