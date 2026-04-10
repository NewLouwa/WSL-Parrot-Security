# hashcat

## Purpose
World's fastest password cracker. GPU-accelerated, supports 300+ hash types. Preferred over John for large wordlists and complex attacks.

## Installation
```bash
sudo apt install hashcat
```

## Quick Start
```bash
# Basic wordlist attack
hashcat -m 0 hashes.txt /usr/share/wordlists/rockyou.txt

# With rules
hashcat -m 0 hashes.txt rockyou.txt -r /usr/share/hashcat/rules/best64.rule

# Show cracked
hashcat -m 0 hashes.txt --show

# Brute-force (mask attack)
hashcat -m 0 hashes.txt -a 3 ?a?a?a?a?a?a

# Combination attack
hashcat -m 0 hashes.txt -a 1 wordlist1.txt wordlist2.txt
```

## Common Hash Modes (-m)
| Mode | Hash Type |
|------|-----------|
| `0` | MD5 |
| `100` | SHA1 |
| `1400` | SHA256 |
| `1000` | NTLM |
| `3200` | bcrypt |
| `5600` | NTLMv2 (Responder) |
| `13100` | Kerberoast (TGS-REP) |
| `18200` | AS-REP Roast |
| `22000` | WPA-PBKDF2-PMKID+EAPOL |
| `1800` | sha512crypt ($6$) |
| `500` | md5crypt ($1$) |
| `16800` | WPA-PMKID |

## Attack Modes (-a)
| Mode | Type |
|------|------|
| `0` | Dictionary |
| `1` | Combination |
| `3` | Brute-force (mask) |
| `6` | Dictionary + Mask |
| `7` | Mask + Dictionary |

## Mask Charsets
| Char | Set |
|------|-----|
| `?l` | lowercase |
| `?u` | uppercase |
| `?d` | digits |
| `?s` | special chars |
| `?a` | all printable |

## HTB Usage
- Note: GPU acceleration may not work in WSL — use `--force` or crack on Windows host
- `-m 5600` for NTLMv2 hashes from Responder
- `-m 13100` for Kerberoast hashes
- `-m 18200` for AS-REP roast
- Always try `rockyou.txt` first, then add rules
