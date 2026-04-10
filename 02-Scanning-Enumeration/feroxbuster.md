# Feroxbuster

## Purpose
Fast, recursive content discovery tool written in Rust. Automatically recurses into discovered directories, making it ideal for deep web enumeration.

## Install
```bash
sudo apt install feroxbuster
```

## Usage
```bash
feroxbuster -u http://10.10.10.5                                    # Default scan
feroxbuster -u http://10.10.10.5 -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt
feroxbuster -u http://10.10.10.5 -x php,html,txt                   # With extensions
feroxbuster -u http://10.10.10.5 --no-recursion                    # Disable recursion
feroxbuster -u http://10.10.10.5 -C 404,403                        # Filter status codes
feroxbuster -u http://10.10.10.5 -t 100                             # 100 threads
```

## Key Flags
```bash
-u          # Target URL
-w          # Wordlist
-x          # Extensions
-t          # Threads (default 50)
-d          # Recursion depth (default 4)
-C          # Filter status codes
-S          # Filter by response size
-o          # Output file
-k          # Ignore TLS errors
--no-recursion  # Disable auto-recursion
-H          # Custom header
```

## Tips
- Auto-recursion is the killer feature — it digs deeper automatically
- Set `-d 2` to limit recursion depth if it's too noisy
- Faster than gobuster and dirb in most scenarios
