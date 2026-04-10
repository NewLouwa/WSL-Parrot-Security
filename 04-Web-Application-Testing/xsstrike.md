# XSStrike

## Purpose
Advanced XSS detection and exploitation tool. Uses fuzzy matching, context analysis, and payload generation to find cross-site scripting vulnerabilities.

## Installation
```bash
pip3 install xsstrike
# or
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike && pip3 install -r requirements.txt
```

## Quick Start
```bash
# Test a URL parameter
xsstrike -u "http://target.htb/search?q=test"

# Test POST data
xsstrike -u "http://target.htb/search" --data "q=test"

# Crawl and test
xsstrike -u "http://target.htb" --crawl

# With headers
xsstrike -u "http://target.htb/search?q=test" --headers "Cookie: session=abc"

# Fuzzing mode
xsstrike -u "http://target.htb/search?q=test" --fuzzer

# Blind XSS
xsstrike -u "http://target.htb/search?q=test" --blind
```

## Key Options
| Option | Description |
|--------|-------------|
| `-u` | Target URL |
| `--data` | POST data |
| `--crawl` | Crawl and test all found URLs |
| `--fuzzer` | Fuzz for filter detection |
| `--blind` | Blind XSS testing |
| `--headers` | Custom headers |
| `--skip` | Skip confirmation prompts |
| `-t <n>` | Threads |
| `-d <n>` | Delay between requests |

## HTB Usage
- Test any user input reflected in web pages
- Use `--fuzzer` to understand what characters/tags are filtered
- Combine with Burp for complex XSS in authenticated contexts
