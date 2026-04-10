# DNSRecon

## Purpose
DNS enumeration tool. Performs zone transfers, brute-force subdomain discovery, reverse lookups, and record enumeration.

## Install
```bash
sudo apt install dnsrecon
```

## Usage
```bash
dnsrecon -d target.com                            # Standard enum
dnsrecon -d target.com -t axfr                    # Attempt zone transfer
dnsrecon -d target.com -t brt -D wordlist.txt     # Brute-force subdomains
dnsrecon -r 10.10.10.0/24                         # Reverse lookup range
dnsrecon -d target.com -t std                     # Standard records (A, AAAA, MX, NS, SOA)
```

## Key Flags
```bash
-d          # Target domain
-t          # Type: std, axfr, brt, rvl, snoop, zonewalk
-D          # Wordlist for brute-force
-r          # IP range for reverse lookup
--xml       # XML output
-j          # JSON output
```

## Tips
- Always try zone transfer (`-t axfr`) first — easy win if misconfigured
- Use with SecLists DNS wordlists for brute-forcing
