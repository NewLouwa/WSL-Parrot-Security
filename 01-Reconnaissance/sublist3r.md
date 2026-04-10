# Sublist3r

## Purpose
Fast subdomain enumeration using search engines (Google, Bing, Yahoo, Baidu, Ask, Netcraft, Virustotal, ThreatCrowd, DNSdumpster, ReverseDNS).

## Install
```bash
sudo apt install sublist3r
```

## Usage
```bash
sublist3r -d target.com                           # Basic enumeration
sublist3r -d target.com -b                        # Include brute-force
sublist3r -d target.com -p 80,443 -t 50           # Check open ports on found subs
sublist3r -d target.com -o subs.txt               # Save results
```

## Key Flags
```bash
-d          # Target domain
-b          # Enable brute-force with subbrute
-p          # Check TCP ports on found subdomains
-t          # Threads (default 30)
-o          # Output file
-e          # Choose engines: google,bing,yahoo
```

## Tips
- Quick alternative to amass for simple subdomain enumeration
- Combine with `amass` for more thorough results
