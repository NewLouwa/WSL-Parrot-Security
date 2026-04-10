# WhatWeb

## Purpose
Web technology fingerprinting. Identifies CMS platforms, web frameworks, server software, JavaScript libraries, and more.

## Install
```bash
sudo apt install whatweb
```

## Usage
```bash
whatweb http://10.10.10.5                         # Basic scan
whatweb -v http://10.10.10.5                      # Verbose
whatweb -a 3 http://10.10.10.5                    # Aggressive mode
whatweb http://10.10.10.5 --log-json=out.json     # JSON output
```

## Key Flags
```bash
-v          # Verbose output
-a          # Aggression level (1=stealthy, 3=aggressive)
--log-json  # JSON output
--log-xml   # XML output
-U          # Custom User-Agent
-c          # Cookie
```

## Tips
- Quick way to identify the tech stack before deeper testing
- Helps decide which specific tools to use next (e.g., wpscan for WordPress)
