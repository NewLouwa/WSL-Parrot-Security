# Recon-ng

## Purpose
Full-featured OSINT framework with modules for reconnaissance. Works like Metasploit but for information gathering.

## Install
```bash
sudo apt install recon-ng
```

## Usage
```bash
recon-ng                                          # Launch framework
```

### Inside the Framework
```
marketplace search                                # List all modules
marketplace install recon/domains-hosts/hackertarget  # Install module
modules load recon/domains-hosts/hackertarget     # Load module
options set SOURCE target.com                     # Set target
run                                               # Execute

# Manage results
show hosts                                        # View discovered hosts
show contacts                                     # View discovered contacts
```

### Common Modules
```
recon/domains-hosts/hackertarget        # Subdomain enum via HackerTarget
recon/domains-hosts/google_site_web     # Google dorking
recon/domains-contacts/whois_pocs       # WHOIS contacts
recon/hosts-ports/shodan_ip             # Shodan port lookup
```

## Tips
- Add API keys with `keys add <keyname> <value>`
- Results persist in a workspace database
- Create workspaces per target: `workspaces create htb-box`
