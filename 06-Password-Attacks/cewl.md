# CeWL

## Purpose
Custom Word List generator. Spiders a target website and creates a wordlist from the words found. Great for generating targeted password lists.

## Installation
```bash
sudo apt install cewl
```

## Quick Start
```bash
# Basic wordlist from website
cewl http://target.htb -w wordlist.txt

# With depth and minimum word length
cewl http://target.htb -d 3 -m 5 -w wordlist.txt

# Include emails found
cewl http://target.htb -e -w wordlist.txt

# Include metadata from files
cewl http://target.htb -a -w wordlist.txt

# With authentication
cewl http://target.htb --auth_type basic --auth_user admin --auth_pass password -w wordlist.txt
```

## Key Options
| Option | Description |
|--------|-------------|
| `-w <file>` | Output wordlist file |
| `-d <n>` | Spider depth (default 2) |
| `-m <n>` | Minimum word length |
| `-e` | Include email addresses |
| `-a` | Include metadata |
| `--lowercase` | Lowercase all words |
| `-c` | Show word count |

## HTB Usage
- Generate custom wordlists from the target's own website
- Useful when rockyou.txt doesn't crack the password
- Spider company/organization pages for likely passwords
- Combine with Hydra or Burp Intruder for targeted brute-force
