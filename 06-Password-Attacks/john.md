# John the Ripper

## Purpose
Password cracking tool supporting hundreds of hash types. Includes utilities to extract hashes from files (zip2john, ssh2john, etc.).

## Installation
```bash
sudo apt install john
```

## Quick Start
```bash
# Crack with wordlist
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Identify hash format
john --list=formats | grep -i ntlm

# Specify format
john --format=raw-md5 --wordlist=rockyou.txt hashes.txt

# Show cracked passwords
john --show hashes.txt

# With rules (mutations)
john --wordlist=rockyou.txt --rules=best64 hashes.txt
```

## Hash Extraction Tools
```bash
# SSH private key
ssh2john id_rsa > ssh_hash.txt

# ZIP file
zip2john file.zip > zip_hash.txt

# KeePass database
keepass2john database.kdbx > keepass_hash.txt

# /etc/shadow
unshadow /etc/passwd /etc/shadow > unshadowed.txt

# PFX/PKCS12
pfx2john cert.pfx > pfx_hash.txt

# Office documents
office2john document.docx > office_hash.txt

# 7z archive
7z2john file.7z > 7z_hash.txt
```

## Common Formats
| Format | Hash Type |
|--------|-----------|
| `raw-md5` | Plain MD5 |
| `raw-sha256` | Plain SHA256 |
| `bcrypt` | bcrypt |
| `nt` | Windows NTLM |
| `krb5tgs` | Kerberoast |
| `krb5asrep` | AS-REP roast |
| `ssh` | SSH private key passphrase |

## HTB Usage
- First choice for cracking hashes with wordlists
- `*2john` scripts are essential — convert files to crackable hashes
- Use `--rules` for password mutation when basic wordlist fails
- Check `john --show` to review previously cracked passwords
