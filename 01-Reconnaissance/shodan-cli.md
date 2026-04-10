# Shodan CLI -- Search Engine for Internet-Connected Devices

## What It Does
Shodan is like Google but for devices connected to the internet -- servers, webcams, routers, IoT devices, industrial systems, you name it. The CLI lets you search Shodan from your terminal. It shows open ports, services, banners, and vulnerabilities without you sending a single packet to the target. Requires a free API key from shodan.io.

## Install
```bash
pip3 install shodan

# Set up your API key (get one free at https://account.shodan.io)
shodan init YOUR_API_KEY_HERE
```

## Basic Usage

### Search for a target IP
```bash
shodan host 10.10.10.5                   # Everything Shodan knows about this IP
```

### Search by keyword
```bash
shodan search apache                     # Find Apache servers
shodan search "default password"         # Find devices with default creds
shodan search "port:3389 country:US"     # RDP servers in the US
```

### Count results for a query
```bash
shodan count apache 2.4.49               # How many servers match?
```

### Get your own public IP info
```bash
shodan myip                              # What does Shodan see about you?
```

## Common Search Filters
```bash
shodan search "hostname:target.com"                  # Specific domain
shodan search "org:Target Corp"                      # By organization name
shodan search "port:22 country:DE"                   # SSH in Germany
shodan search "vuln:CVE-2021-44228"                  # Log4Shell vulnerable
```

## Practical OSINT Workflow
```bash
# Step 1: Check what Shodan already knows (passive -- no packets sent)
shodan host 10.10.10.5

# Step 2: Search for the target's entire infrastructure
shodan search "hostname:target.com" --fields ip_str,port,org

# Step 3: Look for known vulnerabilities
shodan search "hostname:target.com vuln:CVE-2021-44228"
```

## Key Flags
```
init KEY         Set your API key
host IP          Look up a specific IP
search QUERY     Search Shodan
count QUERY      Count matching results
myip             Show your public IP
stats QUERY      Show statistics for a query
```

## HTB / OSINT Tips
- Always check Shodan BEFORE active scanning -- it is passive recon, no packets sent
- Free accounts get limited searches; a membership unlocks way more
- The `host` command is your go-to for a quick target overview
- Combine with nmap: Shodan tells you what is open, nmap confirms and digs deeper
- The `vuln:` filter is incredibly powerful for finding known vulnerabilities
- Remember: Shodan data might be days or weeks old -- verify with active scans
