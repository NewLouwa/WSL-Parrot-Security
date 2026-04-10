# OWASP ZAP (zaproxy)

## Purpose
Open-source GUI web application security scanner. Free alternative to Burp Suite Pro with automated scanning, spidering, and fuzzing capabilities.

## Installation
```bash
sudo apt install zaproxy
```

## Quick Start
```bash
# Launch GUI
zaproxy
# or
owasp-zap
```

## Key Features
| Feature | Description |
|---------|-------------|
| **Automated Scan** | Point-and-shoot vulnerability scanning |
| **Spider** | Crawl web applications to discover content |
| **Active Scan** | Test for vulnerabilities (SQLi, XSS, etc.) |
| **Fuzzer** | Fuzz parameters with custom payloads |
| **HUD** | Heads-Up Display overlay in browser |
| **Proxy** | Intercept/modify requests (like Burp) |
| **Scripts** | Extensible with scripts (Python, JS) |

## Workflow
1. Launch ZAP, configure browser proxy to `127.0.0.1:8080`
2. Browse the target site (ZAP records everything)
3. Run Spider to discover more pages
4. Run Active Scan on interesting targets
5. Review alerts in the Alerts tab

## CLI Mode
```bash
# Quick scan
zap-cli quick-scan http://target.htb

# Full scan
zap-cli active-scan http://target.htb
```

## HTB Usage
- Good free alternative to Burp Pro for automated scanning
- Use the spider to discover hidden pages
- Active scan for quick vulnerability overview
- GUI works via WSLg or XRDP
