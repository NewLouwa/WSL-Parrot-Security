# onesixtyone - Fast SNMP Community String Scanner

Blasts through a list of SNMP community strings to find ones that respond.

## What It Does

SNMP (Simple Network Management Protocol) uses "community strings" as passwords. Many devices ship with default ones like `public` or `private`. onesixtyone takes a list of community strings and a list of target IPs, then quickly tests every combination. If a device responds, you know the community string and can pull tons of info from it (hostnames, network interfaces, running processes, even credentials sometimes).

## Install

```bash
sudo apt install onesixtyone
```

## Basic Usage

```bash
# Test a single target with a single community string
onesixtyone 10.10.10.20 public

# Test with a wordlist of community strings
onesixtyone 10.10.10.20 -c /usr/share/seclists/Discovery/SNMP/common-snmp-community-strings.txt

# Test multiple targets from a file
onesixtyone -i targets.txt -c community_strings.txt
```

## Practical Examples

```bash
# Quick check with default strings
echo "public" > communities.txt
echo "private" >> communities.txt
echo "manager" >> communities.txt
onesixtyone 10.10.10.20 -c communities.txt
# If you get a response, that community string works

# Scan a whole subnet for SNMP
# First create a target list
for i in $(seq 1 254); do echo "10.10.10.$i"; done > targets.txt
onesixtyone -i targets.txt -c communities.txt

# Found a valid community string? Now enumerate with snmpwalk
snmpwalk -v 2c -c public 10.10.10.20
```

## Key Flags

```bash
-c <file>     # File with community strings (one per line)
-i <file>     # File with target IPs (one per line)
-o <file>     # Output file
-d            # Debug mode (verbose)
```

## Wordlists

```
/usr/share/seclists/Discovery/SNMP/common-snmp-community-strings.txt
/usr/share/seclists/Discovery/SNMP/snmp-onesixtyone.txt
/usr/share/metasploit-framework/data/wordlists/snmp_default_pass.txt
```

## HTB Tips

- If nmap shows port 161/udp open, run onesixtyone right away
- After finding a valid community string, use `snmpwalk` to dump everything
- SNMP can leak usernames, running services, network configs, and more
- Try both SNMP v1 (`-v 1`) and v2c (`-v 2c`) with snmpwalk after discovery
- The name "onesixtyone" comes from port 161, the default SNMP port
