# SpiderFoot -- Automated OSINT Scanner with Web UI

## What It Does
SpiderFoot is an all-in-one OSINT automation platform. Give it a target (domain, IP, email, username, phone number) and it runs hundreds of modules to gather intelligence from public sources. The best part: it has a built-in web interface so you can explore results visually, making it great for people who prefer clicking over typing commands.

## Install
```bash
pip3 install spiderfoot
```

## Basic Usage

### Launch the web UI (recommended for beginners)
```bash
spiderfoot -l 127.0.0.1:5001            # Start web UI on port 5001
# Then open http://127.0.0.1:5001 in your browser
```

### Run a scan from the command line
```bash
spiderfoot -s target.com -q              # Quick scan on a domain
spiderfoot -s 10.10.10.5 -q             # Scan an IP address
spiderfoot -s user@target.com -q         # Scan an email address
```

### Run specific modules only
```bash
spiderfoot -s target.com -m sfp_dnsresolve,sfp_whois -q
```

## Using the Web Interface
1. Start SpiderFoot: `spiderfoot -l 127.0.0.1:5001`
2. Open your browser to `http://127.0.0.1:5001`
3. Click "New Scan" and enter your target
4. Pick a scan type:
   - **All** -- runs everything (slow but thorough)
   - **Footprint** -- maps the target's internet presence
   - **Investigate** -- focuses on a person or entity
   - **Passive** -- no direct contact with target
5. Watch results come in live and explore the graph view

## Practical OSINT Workflow
```bash
# Step 1: Start the web UI
spiderfoot -l 127.0.0.1:5001

# Step 2: Create a "Passive" scan for target.com (no direct contact)
# Step 3: Review findings in the graph view
# Step 4: Feed specific findings into other tools:
#   - Emails -> holehe, GHunt
#   - Usernames -> Sherlock
#   - Subdomains -> nmap, gobuster
```

## Key Flags
```
-l HOST:PORT     Start web UI on this address
-s TARGET        Scan target (domain, IP, email, username)
-m MODULES       Comma-separated list of modules to run
-q               Quiet mode (less output)
-o FORMAT        Output format (csv, json, xml)
```

## HTB / OSINT Tips
- The web UI is your friend -- the graph view shows relationships between findings
- Use "Passive" scan type first to stay under the radar
- Add API keys in Settings for better results (Shodan, VirusTotal, etc.)
- For HTB boxes, a quick domain scan often reveals subdomains you missed
- It is resource-heavy -- give it time and do not run on a weak machine
