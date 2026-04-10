# Volatility 3

## Purpose
Memory forensics framework. Analyzes RAM dumps to extract processes, network connections, registry hives, passwords, and more from Windows/Linux memory images.

## Location
```
/opt/htb-toolkit/volatility3/
```

## Quick Start
```bash
cd /opt/htb-toolkit/volatility3

# Identify OS profile
python3 vol.py -f memdump.raw windows.info

# List processes
python3 vol.py -f memdump.raw windows.pslist
python3 vol.py -f memdump.raw windows.pstree

# Hidden processes
python3 vol.py -f memdump.raw windows.psscan

# Network connections
python3 vol.py -f memdump.raw windows.netscan

# Command line history
python3 vol.py -f memdump.raw windows.cmdline

# Dump a process
python3 vol.py -f memdump.raw windows.dumpfiles --pid 1234

# Registry hives
python3 vol.py -f memdump.raw windows.registry.hivelist

# Extract password hashes
python3 vol.py -f memdump.raw windows.hashdump

# File scan
python3 vol.py -f memdump.raw windows.filescan
```

## Common Plugins
| Plugin | Description |
|--------|-------------|
| `windows.info` | OS information |
| `windows.pslist` | Process list |
| `windows.pstree` | Process tree |
| `windows.psscan` | Hidden process scan |
| `windows.netscan` | Network connections |
| `windows.cmdline` | Command line args |
| `windows.hashdump` | SAM password hashes |
| `windows.filescan` | File objects in memory |
| `windows.dumpfiles` | Extract files from memory |
| `windows.registry.hivelist` | Registry hives |

## Linux Plugins
Replace `windows.` with `linux.` (e.g., `linux.pslist`, `linux.bash`)

## HTB Usage
- Essential for forensics challenges involving memory dumps
- Check processes, network connections, and command history
- Extract files and credentials from memory
- Look for suspicious/hidden processes with psscan
