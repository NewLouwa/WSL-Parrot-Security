# SNMP Tools (snmpwalk / onesixtyone)

> SNMP is like a chatty status page for network devices -- and it often spills way more than it should.

## What It Does

SNMP (Simple Network Management Protocol) is meant for monitoring network devices -- routers, switches, printers, and servers all use it. The problem is that it's often misconfigured with default "community strings" (basically passwords) like `public`. When that happens, you can pull usernames, running processes, installed software, network configs, and sometimes even passwords. It runs on UDP port 161, so make sure your nmap scans include `-sU`.

**OIDs explained:** SNMP organizes everything in a tree structure. Each piece of info has an address called an OID (Object Identifier) -- just a bunch of numbers separated by dots. You don't need to memorize them, just know which ones to ask for.

## Install

```bash
sudo apt install snmp onesixtyone snmp-mibs-downloader
```

## Examples

```bash
# Step 1: Find the community string (the "password" for SNMP)
# This brute-forces common community strings against the target
onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp-onesixtyone.txt 10.10.10.5

# Step 2: Once you have a community string, dump everything
snmpwalk -v2c -c public 10.10.10.5

# Pull just usernames -- great for building a user list
snmpwalk -v2c -c public 10.10.10.5 1.3.6.1.4.1.77.1.2.25

# See what processes are running -- might reveal interesting services
snmpwalk -v2c -c public 10.10.10.5 1.3.6.1.2.1.25.4.2.1.2

# Check installed software -- find outdated/vulnerable versions
snmpwalk -v2c -c public 10.10.10.5 1.3.6.1.2.1.25.6.3.1.2

# Get basic system info (hostname, OS, uptime)
snmpwalk -v2c -c public 10.10.10.5 system

# See what ports are listening -- find services nmap might have missed
snmpwalk -v2c -c public 10.10.10.5 1.3.6.1.2.1.6.13.1.3
```

## OID Cheat Sheet (the useful ones)

| What you get | OID |
|---|---|
| User accounts | `1.3.6.1.4.1.77.1.2.25` |
| Running processes | `1.3.6.1.2.1.25.4.2.1.2` |
| Process paths | `1.3.6.1.2.1.25.4.2.1.4` |
| Installed software | `1.3.6.1.2.1.25.6.3.1.2` |
| TCP listening ports | `1.3.6.1.2.1.6.13.1.3` |
| Storage/disks | `1.3.6.1.2.1.25.2.3.1.4` |
| System info | `system` |

## HTB Tips

- **SNMP is a goldmine that people overlook.** If you see UDP 161 open, stop and enumerate it thoroughly before moving on.
- The default community string `public` works more often than you'd expect. But always brute-force with `onesixtyone` too -- custom strings like `internal` or the company name show up.
- The user list from SNMP + a password spray = easy wins on many boxes.
- Process lists can reveal scripts with hardcoded passwords in the command line arguments.
- Use `-v2c` (SNMP version 2c) by default. If it doesn't work, try `-v1`.
- Don't forget: SNMP is UDP. You need `nmap -sU` to find it -- a regular TCP scan won't show it.
