# hexedit / xxd

## Purpose
Hex editors for viewing and modifying binary data at the byte level.
- **hexedit**: Interactive terminal hex editor
- **xxd**: Command-line hex dump utility

## Installation
```bash
sudo apt install hexedit xxd
```

## Quick Start
```bash
# Interactive hex editor
hexedit file.bin

# Hex dump
xxd file.bin | head -20

# Dump specific bytes (offset and length)
xxd -s 0x100 -l 64 file.bin

# Convert hex to binary
echo "48656c6c6f" | xxd -r -p

# Create binary from hex dump
xxd -r hexdump.txt > file.bin

# Plain hex output (no addresses)
xxd -p file.bin
```

## hexedit Controls
| Key | Action |
|-----|--------|
| `Ctrl+S` | Save |
| `Ctrl+X` | Save and exit |
| `Ctrl+C` | Exit without saving |
| `Tab` | Toggle hex/ASCII |
| `Ctrl+G` | Go to offset |
| `/` | Search |

## HTB Usage
- Fix corrupted file headers (magic bytes)
- Inspect binary data for hidden content
- Modify binary flags/values in reversing challenges
- Common magic bytes: PNG (`89 50 4E 47`), JPEG (`FF D8 FF`), ZIP (`50 4B 03 04`), PDF (`25 50 44 46`)
