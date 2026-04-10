# Nikto

## Purpose
Web server vulnerability scanner. Checks for dangerous files, outdated software, server misconfigurations, and known vulnerabilities.

## Install
```bash
sudo apt install nikto
```

## Usage
```bash
nikto -h http://10.10.10.5                        # Basic scan
nikto -h http://10.10.10.5 -p 8080                # Custom port
nikto -h http://10.10.10.5 -ssl                   # Force SSL
nikto -h http://10.10.10.5 -o report.html -Format htm  # HTML report
nikto -h http://10.10.10.5 -Tuning 9              # SQL injection tests only
```

## Key Flags
```bash
-h          # Target host
-p          # Port
-ssl        # Force SSL
-o          # Output file
-Format     # Output format (htm, csv, txt, xml)
-Tuning     # Test type (1=files, 2=misconfig, 3=info, 9=sqli, etc.)
-id         # HTTP auth (user:pass)
-useproxy   # Use proxy (e.g., Burp)
```

## Tips
- Noisy scanner — not for stealth, but great for thorough checks
- Run early in enumeration to catch low-hanging fruit
- Proxy through Burp (`-useproxy http://127.0.0.1:8080`) to review findings
