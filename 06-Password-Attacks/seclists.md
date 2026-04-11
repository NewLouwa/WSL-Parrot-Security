# SecLists

## What it does
The largest collection of wordlists for security testing. Covers usernames, passwords, URLs, fuzzing payloads, sensitive data patterns, web shells — everything you need for brute-forcing and fuzzing in one place.

## Location after install

```bash
/usr/share/seclists/
# or
ls /opt/htb-toolkit/SecLists/
```

## Directory Structure

```
SecLists/
├── Discovery/
│   ├── Web-Content/        # directory brute-force wordlists
│   │   ├── common.txt
│   │   ├── big.txt
│   │   └── directory-list-2.3-medium.txt
│   └── DNS/                # subdomain brute-force
│       ├── subdomains-top1million-5000.txt
│       └── bitquark-subdomains-top100000.txt
├── Passwords/
│   ├── Leaked-Databases/   # rockyou and friends
│   ├── Common-Credentials/ # top-N password lists
│   └── Default-Credentials/ # vendor defaults
├── Usernames/
│   └── Names/              # name-based username lists
├── Fuzzing/                # payload fuzzing (SQLi, XSS, LFI, etc.)
├── Web-Shells/             # common web shells
└── Miscellaneous/
```

## Most Used Wordlists (HTB)

```bash
# Web directory brute-force
/usr/share/seclists/Discovery/Web-Content/common.txt
/usr/share/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt
/usr/share/seclists/Discovery/Web-Content/big.txt
/usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt

# Subdomain enumeration
/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
/usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt

# Password cracking / brute-force
/usr/share/seclists/Passwords/Leaked-Databases/rockyou.txt
/usr/share/seclists/Passwords/Common-Credentials/10k-most-common.txt
/usr/share/seclists/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt

# Username enumeration
/usr/share/seclists/Usernames/Names/names.txt
/usr/share/seclists/Usernames/top-usernames-shortlist.txt

# Fuzzing payloads
/usr/share/seclists/Fuzzing/SQLi/Generic-SQLi.txt
/usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt
/usr/share/seclists/Fuzzing/XSS/XSS-Jhaddix.txt
```

## With Common Tools

```bash
# gobuster directory brute-force
gobuster dir -u http://10.10.10.5 -w /usr/share/seclists/Discovery/Web-Content/common.txt

# ffuf vhost fuzzing
ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -u http://10.10.10.5 -H "Host: FUZZ.target.htb"

# hydra SSH brute-force
hydra -L /usr/share/seclists/Usernames/Names/names.txt -P /usr/share/seclists/Passwords/Common-Credentials/10k-most-common.txt ssh://10.10.10.5

# wfuzz LFI fuzzing
wfuzz -c -w /usr/share/seclists/Fuzzing/LFI/LFI-Jhaddix.txt --hc 404 http://10.10.10.5/page?file=FUZZ
```

## HTB Tips

- Start with `common.txt` for web content — it's fast and hits ~95% of HTB boxes
- Use `directory-list-2.3-medium.txt` if `common.txt` misses something
- `raft-medium-*` lists are better organized (no dupes, better coverage)
- For API endpoints try `Discovery/Web-Content/api/objects.txt`
- Check `Default-Credentials/` when you find a login page with an obvious vendor
