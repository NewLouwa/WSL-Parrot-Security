# rpcclient

## Purpose
Tool for executing MS-RPC functions against Windows systems. Enumerates users, groups, shares, and domain info via SMB/RPC.

## Installation
```bash
sudo apt install samba-common-bin
# rpcclient comes with samba
```

## Quick Start
```bash
# Null session (anonymous)
rpcclient -U "" -N 10.10.10.x

# Authenticated
rpcclient -U "user%password" 10.10.10.x

# One-shot command
rpcclient -U "" -N 10.10.10.x -c "enumdomusers"
```

## Useful Commands (inside rpcclient)
```
# Enumerate users
enumdomusers

# Enumerate groups
enumdomgroups

# Get user info by RID
queryuser 0x1f4

# Lookup user by name
lookupnames administrator

# Enumerate shares
netshareenumall

# Get domain info
querydominfo

# Enumerate printers
enumprinters

# Get password policy
getdompwinfo

# SID lookup
lsaenumsid
lookupsids S-1-5-21-...
```

## HTB Usage
- Null session enumeration on Windows/AD boxes
- Extract usernames for password spraying
- Get password policies before brute-forcing
- Map out domain structure in AD challenges
