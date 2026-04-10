# crunch

## Purpose
Wordlist generator that creates custom wordlists based on criteria you specify: character sets, patterns, min/max length.

## Installation
```bash
sudo apt install crunch
```

## Quick Start
```bash
# Generate 4-6 char words with lowercase
crunch 4 6 -o wordlist.txt

# Custom character set
crunch 4 4 0123456789 -o pins.txt

# Pattern-based (@ = lowercase, , = uppercase, % = number, ^ = special)
crunch 8 8 -t pass%%@@ -o wordlist.txt

# Using predefined charset
crunch 4 4 -f /usr/share/crunch/charset.lst mixalpha-numeric -o wordlist.txt

# Pipe to hydra directly
crunch 4 4 0123456789 | hydra -l admin -P - ssh://10.10.10.x
```

## Pattern Characters
| Char | Replaces With |
|------|---------------|
| `@` | Lowercase letters |
| `,` | Uppercase letters |
| `%` | Numbers |
| `^` | Special characters |

## HTB Usage
- Generate PIN codes or short passwords
- Create targeted wordlists when you know the password pattern
- Pipe directly to tools (hydra, john) to avoid writing huge files
- Warning: large wordlists can be massive — use patterns to limit scope
