# Gobuster

## Purpose
Directory, file, DNS, and vhost brute-forcing tool written in Go. Essential for discovering hidden web content on HTB boxes.

## Install
```bash
sudo apt install gobuster
```

## Usage

### Directory/File Brute-Force
```bash
gobuster dir -u http://10.10.10.5 -w /usr/share/wordlists/dirb/common.txt
gobuster dir -u http://10.10.10.5 -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt
gobuster dir -u http://10.10.10.5 -w wordlist.txt -x php,html,txt   # Search for extensions
gobuster dir -u http://10.10.10.5 -w wordlist.txt -b 404,403        # Exclude status codes
```

### DNS Subdomain Brute-Force
```bash
gobuster dns -d target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

### VHost Enumeration
```bash
gobuster vhost -u http://target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

## Key Flags
```bash
-u          # Target URL
-w          # Wordlist
-x          # File extensions to search
-t          # Threads (default 10)
-b          # Blacklist status codes
-s          # Whitelist status codes
-o          # Output file
-k          # Skip TLS verification
-r          # Follow redirects
-H          # Add custom header (e.g., -H "Host: dev.target.com")
```

## HTB Wordlists
```
/usr/share/wordlists/dirb/common.txt                                    # Quick scan
/usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt   # Thorough
/usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt # Standard
```

## Tips
- Start with `common.txt` for speed, escalate to bigger lists if needed
- Always try common extensions: `-x php,html,txt,bak,old,asp,aspx`
- Use `-t 50` on HTB for faster results
