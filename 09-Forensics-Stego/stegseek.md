# stegseek

## Purpose
Lightning-fast steghide passphrase cracker. Exploits steghide's metadata structure to crack passphrases at thousands of guesses per second, far faster than brute-forcing with steghide directly.

## Installation
```bash
# Download latest .deb release
wget https://github.com/RickdeJager/stegseek/releases/latest/download/stegseek_0.6-1.deb
sudo dpkg -i stegseek_0.6-1.deb
sudo apt -f install  # fix dependencies if needed

# Or build from source
git clone https://github.com/RickdeJager/stegseek.git
cd stegseek && mkdir build && cd build
cmake .. && make
sudo make install
```

## Quick Start
```bash
# Crack passphrase using rockyou wordlist
stegseek image.jpg /usr/share/wordlists/rockyou.txt

# Specify output file
stegseek image.jpg /usr/share/wordlists/rockyou.txt -xf extracted_data.txt

# Seed-based brute force (no wordlist, tries all short passphrases)
stegseek --seed image.jpg

# Use a custom wordlist
stegseek image.jpg custom_wordlist.txt

# Increase threads
stegseek image.jpg rockyou.txt -t 8
```

## Common Patterns
```bash
# Quick check: try rockyou first (usually finishes in seconds)
stegseek suspicious.jpg /usr/share/wordlists/rockyou.txt

# If wordlist fails, try seed cracking (brute-force short passphrases)
stegseek --seed suspicious.jpg

# Crack then extract in one step
stegseek image.jpg rockyou.txt -xf hidden_flag.txt
cat hidden_flag.txt

# Verify with steghide after finding passphrase
steghide extract -sf image.jpg -p 'found_passphrase'
```

## HTB Usage
- Go-to tool for steganography challenges involving JPEG/BMP images
- Run stegseek before trying manual steghide extraction
- Cracks rockyou-based passphrases in under a minute
- Pair with exiftool and binwalk for a full stego analysis pipeline
- If stegseek finds nothing, the image may use a different stego method (try zsteg, stegoveritas)
