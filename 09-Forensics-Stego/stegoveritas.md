# stegoveritas

## Purpose
All-in-one steganography analysis tool. Automatically runs multiple stego checks: color planes, LSB extraction, metadata, strings, and more.

## Installation
```bash
pip3 install stegoveritas
stegoveritas_install_deps   # install dependencies
```

## Quick Start
```bash
# Full automatic analysis
stegoveritas image.png

# Extract color planes
stegoveritas -color image.png

# LSB analysis
stegoveritas -extractLSB image.png

# Trailing data
stegoveritas -trailing image.png

# All the things
stegoveritas -meta -color -extractLSB -trailing image.png
```

## Output
Results are saved in `results/` directory in current working dir.

## HTB Usage
- Run on images when basic tools (steghide, exiftool) find nothing
- Analyzes color bit planes which can reveal hidden images
- Extracts LSB (Least Significant Bit) encoded data
- Checks for appended/trailing data after file end marker
