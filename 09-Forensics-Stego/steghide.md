# steghide

## Purpose
Steganography tool that hides and extracts data within JPEG, BMP, WAV, and AU files. Most common stego tool in CTF challenges.

## Installation
```bash
sudo apt install steghide
```

## Quick Start
```bash
# Extract hidden data (with password)
steghide extract -sf image.jpg

# Extract (empty password / no password)
steghide extract -sf image.jpg -p ""

# Embed data into image
steghide embed -cf cover.jpg -ef secret.txt

# Get info about embedded data
steghide info image.jpg
```

## Key Options
| Option | Description |
|--------|-------------|
| `-sf` | Stego file (input) |
| `-cf` | Cover file (for embedding) |
| `-ef` | Embed file |
| `-p` | Passphrase |
| `-f` | Force overwrite |

## HTB Usage
- Try on every JPEG/BMP found in challenges
- Try empty password first, then brute-force with `stegseek`
- `steghide info` tells you if data is embedded without extracting
- For brute-force: `stegseek image.jpg rockyou.txt`
