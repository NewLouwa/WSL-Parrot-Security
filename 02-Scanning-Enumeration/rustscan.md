# RustScan

## Purpose
Extremely fast port scanner that pipes results into nmap. Scans all 65535 ports in seconds, then hands off to nmap for service detection.

## Install
```bash
sudo apt install rustscan
# or via cargo:
cargo install rustscan
```

## Usage
```bash
rustscan -a 10.10.10.5                            # Scan all ports
rustscan -a 10.10.10.5 -p 80,443                  # Specific ports
rustscan -a 10.10.10.5 -- -sC -sV                 # Pass flags to nmap
rustscan -a 10.10.10.5 -b 1000                    # Batch size 1000
rustscan -a 10.10.10.5 -u 5000                    # Ulimit 5000
```

## Key Flags
```bash
-a          # Target address
-p          # Specific ports
-b          # Batch size (how many ports at once)
-u          # Ulimit (concurrent connections)
-t          # Timeout in ms
--          # Everything after goes to nmap
```

## HTB Workflow
```bash
# Fast full port scan + nmap service detection
rustscan -a 10.10.10.5 -- -sC -sV -oN scan.txt
```

## Tips
- Fastest way to find open ports on HTB
- The `--` separator passes everything after it to nmap
- Adjust `-b` and `-u` if you get connection errors
