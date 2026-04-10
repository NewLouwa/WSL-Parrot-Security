# foremost

## Purpose
File carving tool that recovers files based on headers, footers, and data structures. Extracts files from disk images, memory dumps, or any binary data.

## Installation
```bash
sudo apt install foremost
```

## Quick Start
```bash
# Carve all file types
foremost -i image.dd -o output/

# Carve specific types
foremost -t jpg,png,pdf -i image.dd -o output/

# From raw data
foremost -i memdump.raw -o output/

# Verbose
foremost -v -i image.dd -o output/
```

## Key Options
| Option | Description |
|--------|-------------|
| `-i` | Input file |
| `-o` | Output directory |
| `-t` | File types (jpg,png,pdf,doc,exe,zip,all) |
| `-v` | Verbose |
| `-q` | Quick mode (skip header check) |

## HTB Usage
- Recover deleted files from disk images
- Extract files from memory dumps
- Carve images/documents from network captures
- First tool to try on forensic disk images
