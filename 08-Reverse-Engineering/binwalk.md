# binwalk

## Purpose
Firmware analysis tool. Searches binary images for embedded files, compressed archives, and file system images. Extracts hidden content from binaries.

## Installation
```bash
sudo apt install binwalk
```

## Quick Start
```bash
# Scan for embedded files
binwalk firmware.bin

# Extract embedded files
binwalk -e firmware.bin

# Recursive extract
binwalk -eM firmware.bin

# Entropy analysis (detect encryption/compression)
binwalk -E firmware.bin

# Scan for specific signatures
binwalk -R '\x89PNG' firmware.bin
```

## Key Options
| Option | Description |
|--------|-------------|
| `-e` | Extract files |
| `-M` | Recursive extraction |
| `-E` | Entropy analysis |
| `-R` | Search for raw bytes |
| `-A` | Search for opcodes |
| `-D <type>` | Extract specific file type |
| `--dd='.*'` | Extract everything |

## HTB Usage
- Extract files hidden inside images or binaries
- Analyze firmware for IoT/hardware challenges
- Entropy analysis reveals encrypted/compressed sections
- Often first tool to run on mystery binary files
