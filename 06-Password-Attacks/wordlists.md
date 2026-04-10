# Wordlists (SecLists + rockyou)

## Purpose
Pre-built wordlists for brute-forcing passwords, directories, subdomains, parameters, and more. Essential resources for any pentest.

## Installation
```bash
sudo apt install seclists wordlists
# Uncompress rockyou
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
```

## Key Wordlists

### Passwords
| Path | Use |
|------|-----|
| `/usr/share/wordlists/rockyou.txt` | Default password list (~14M) |
| `/usr/share/seclists/Passwords/Common-Credentials/10-million-password-list-top-1000.txt` | Quick spray |
| `/usr/share/seclists/Passwords/Default-Credentials/` | Default login creds |

### Web Discovery
| Path | Use |
|------|-----|
| `/usr/share/seclists/Discovery/Web-Content/common.txt` | Common dirs/files |
| `/usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt` | Medium directory list |
| `/usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt` | Classic dirbuster list |
| `/usr/share/seclists/Discovery/Web-Content/big.txt` | Large directory list |

### DNS/Subdomains
| Path | Use |
|------|-----|
| `/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt` | Quick subdomain check |
| `/usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt` | Thorough subdomain check |
| `/usr/share/seclists/Discovery/DNS/namelist.txt` | DNS names |

### Usernames
| Path | Use |
|------|-----|
| `/usr/share/seclists/Usernames/Names/names.txt` | Common first names |
| `/usr/share/seclists/Usernames/xato-net-10-million-usernames.txt` | Large username list |

### Fuzzing
| Path | Use |
|------|-----|
| `/usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt` | LFI payloads |
| `/usr/share/seclists/Fuzzing/SQLi/` | SQL injection payloads |
| `/usr/share/seclists/Fuzzing/XSS/` | XSS payloads |

## HTB Usage
- `rockyou.txt` is the default for password cracking
- `common.txt` or `directory-list-2.3-medium.txt` for web fuzzing
- `subdomains-top1million-5000.txt` for vhost/subdomain discovery
- Always check SecLists for specialized lists (SNMPm LDAP, etc.)
