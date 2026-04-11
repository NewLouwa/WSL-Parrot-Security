# Parrot WSL Security Toolkit

I use WSL across multiple computers and I got tired of reinstalling every single tool from scratch each time. Parrot WSL ships barebones compared to a full Kali install, and I always end up forgetting which tools I need, what commands do what, or how to use something I haven't touched in a while.

So I built this: **one script** that installs everything, and **a doc for every tool** so I stop googling the same flags over and over.

- One `sudo bash install-toolkit.sh` and you're done — 100+ security tools installed
- Full GUI desktop included (XFCE4 + XRDP + Brave) so you're not stuck in CLI-only WSL
- Every tool has a `.md` cheat sheet with purpose, usage examples, and HTB-specific tips
- Organized by pentest phase so you can find what you need when you need it

> If this project helped you, consider leaving a star on the repo :)

---

## TL;DR — Quick Install

**On Windows (PowerShell):**
```powershell
Set-ExecutionPolicy Bypass -Scope Process; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/NewLouwa/WSL-Parrot-Security/main/Setup-ParrotWSL.ps1" -OutFile "$env:TEMP\Setup-ParrotWSL.ps1"; & "$env:TEMP\Setup-ParrotWSL.ps1"
```

That's the only command you need to run on the Windows side. It detects whether Parrot is installed and tells you exactly what to do next — no guessing.

---

## Full Setup Guide

There are two entry points depending on where you are:

| Situation | What to run |
|-----------|-------------|
| Fresh Windows machine, Parrot not installed | `Setup-ParrotWSL.ps1` (PowerShell) |
| Parrot already installed, just need the tools | `sudo bash install-toolkit.sh` (inside WSL) |

Both paths end up in the same place.

---

### Path A — Starting from scratch (PowerShell first)

```powershell
# Run this from PowerShell — no admin needed
Set-ExecutionPolicy Bypass -Scope Process
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/NewLouwa/WSL-Parrot-Security/main/Setup-ParrotWSL.ps1" -OutFile "$env:TEMP\Setup-ParrotWSL.ps1"
& "$env:TEMP\Setup-ParrotWSL.ps1"
```

The script will:
- **Detect** whether Parrot WSL is already installed
- **If not** → open the Parrot download page and walk you through installing it step by step
- **If yes** → give you the exact commands to clone and run the installer inside WSL

Once Parrot is up, jump to Path B.

---

### Path B — Parrot is installed, run the toolkit

> **Important:** Clone inside your Linux home directory, not on the Windows filesystem.
> Running from `/mnt/c/...` causes permission issues and slows everything down.
> Your Linux home is `~` — that's `/root` or `/home/youruser` inside WSL.

If you ran `Setup-ParrotWSL.ps1`, it already cloned the repo into your Linux home and dropped you there. Just run:

```bash
sudo bash WSL-Parrot-Security/install-toolkit.sh
```

If you're doing it manually:

```bash
# Make sure you're in your Linux home, not on /mnt/c/
cd ~
git clone --depth 1 https://github.com/NewLouwa/WSL-Parrot-Security.git
cd WSL-Parrot-Security
sudo bash install-toolkit.sh
```

Once the install finishes it'll ask if you want to run the user setup next — say yes.

### Set Up Your User & Workspace

> **Note:** The tools installer already prompts you to run this at the end. If you skipped it or want to run it separately:

```bash
sudo bash wsl-config/setup-user.sh <your-username>
```

Then restart WSL from PowerShell:
```powershell
wsl --shutdown
```

This gives you:
- Non-root login with sudo access
- WSL opens in your home directory
- `~/workspace/` with organized folders for machines, challenges, loot, scripts
- Helper commands: `new-machine`, `new-challenge`, `htb-shell`, `serve`, `myip`, `vpn`
- Per-project command history logging with `htb-shell` (great for writeups)
- 100+ security bookmarks auto-imported into Brave and Firefox
- Login banner with quick reference and VPN status

Full list of aliases and shell commands: [`wsl-config/README.md`](wsl-config/README.md)

### 3. Start the GUI

```bash
# Auto-detect best method (WSLg or XRDP)
start-desktop

# Or force XRDP and connect from Windows
start-desktop xrdp
# Then open Remote Desktop Connection: mstsc /v:localhost:3390

# Or force WSLg
start-desktop wslg
```

### 4. Connect to HTB

```bash
# Interactive — finds your .ovpn files and lets you pick
vpn

# One-liner — accepts Linux or Windows paths
htb-connect ~/workspace/htb/vpn/lab.ovpn 10.10.10.5
htb-connect 'C:\Users\You\Downloads\lab.ovpn' 10.10.10.5

# Check status / disconnect
vpn-status
vpn-dc
```

## Tool Categories

The toolkit is organized into 11 phases following the standard penetration testing methodology:

| Phase | Folder | Tools | Description |
|-------|--------|-------|-------------|
| 1 | `01-Reconnaissance` | 16 | Passive & active recon, OSINT |
| 2 | `02-Scanning-Enumeration` | 14 | Service discovery & deep enumeration |
| 3 | `03-Vulnerability-Analysis` | 4 | Vulnerability identification & assessment |
| 4 | `04-Web-Application-Testing` | 10 | Web app attacks (SQLi, XSS, SSTI, JWT) |
| 5 | `05-Exploitation` | 11 | Gaining initial access, AD attacks |
| 6 | `06-Password-Attacks` | 8 | Cracking, brute-forcing & wordlists |
| 7 | `07-Post-Exploitation` | 10 | Privilege escalation, pivoting, C2 |
| 8 | `08-Reverse-Engineering` | 6 | Binary analysis & exploit development |
| 9 | `09-Forensics-Stego` | 10 | Digital forensics & steganography |
| 10 | `10-Wireless` | 3 | WiFi security (limited in WSL) |
| 11 | `11-Networking-Utilities` | 7 | Network tools, VPN, packet analysis |

## Full Tool List

<details>
<summary><strong>01 - Reconnaissance</strong> (click to expand)</summary>

| Tool | Description |
|------|-------------|
| [nmap](01-Reconnaissance/nmap.md) | Network scanner & port discovery |
| [masscan](01-Reconnaissance/masscan.md) | High-speed port scanner |
| [amass](01-Reconnaissance/amass.md) | Subdomain enumeration & OSINT |
| [dnsrecon](01-Reconnaissance/dnsrecon.md) | DNS enumeration & zone transfers |
| [dnsenum](01-Reconnaissance/dnsenum.md) | DNS information gathering |
| [fierce](01-Reconnaissance/fierce.md) | DNS recon & subdomain brute-force |
| [whois](01-Reconnaissance/whois.md) | Domain & IP registration lookup |
| [recon-ng](01-Reconnaissance/recon-ng.md) | OSINT framework |
| [sublist3r](01-Reconnaissance/sublist3r.md) | Fast subdomain enumeration |
| [theHarvester](01-Reconnaissance/theharvester.md) | Email, subdomain & IP harvesting |
| [sherlock](01-Reconnaissance/sherlock.md) | Find usernames across 400+ social networks |
| [holehe](01-Reconnaissance/holehe.md) | Check if email is registered on 100+ sites |
| [GHunt](01-Reconnaissance/ghunt.md) | Google account OSINT from email |
| [Photon](01-Reconnaissance/photon.md) | Web crawler for URLs, emails, files |
| [SpiderFoot](01-Reconnaissance/spiderfoot.md) | Automated OSINT scanner with web UI |
| [shodan](01-Reconnaissance/shodan-cli.md) | Search internet-connected devices |

</details>

<details>
<summary><strong>02 - Scanning & Enumeration</strong></summary>

| Tool | Description |
|------|-------------|
| [gobuster](02-Scanning-Enumeration/gobuster.md) | Directory & DNS brute-forcer |
| [ffuf](02-Scanning-Enumeration/ffuf.md) | Fast web fuzzer |
| [feroxbuster](02-Scanning-Enumeration/feroxbuster.md) | Recursive content discovery |
| [dirb](02-Scanning-Enumeration/dirb.md) | Web content scanner |
| [nikto](02-Scanning-Enumeration/nikto.md) | Web server vulnerability scanner |
| [whatweb](02-Scanning-Enumeration/whatweb.md) | Web technology identifier |
| [rustscan](02-Scanning-Enumeration/rustscan.md) | Ultra-fast port scanner |
| [enum4linux](02-Scanning-Enumeration/enum4linux.md) | Windows/SMB enumeration |
| [smbclient](02-Scanning-Enumeration/smbclient.md) | SMB share access |
| [smbmap](02-Scanning-Enumeration/smbmap.md) | SMB share permissions mapper |
| [rpcclient](02-Scanning-Enumeration/rpcclient.md) | MS-RPC enumeration |
| [SNMP tools](02-Scanning-Enumeration/snmp-tools.md) | SNMP enumeration suite |
| [nbtscan](02-Scanning-Enumeration/nbtscan.md) | NetBIOS scanner |
| [ldapsearch](02-Scanning-Enumeration/ldapsearch.md) | LDAP directory queries |

</details>

<details>
<summary><strong>03 - Vulnerability Analysis</strong></summary>

| Tool | Description |
|------|-------------|
| [searchsploit](03-Vulnerability-Analysis/searchsploit.md) | Exploit-DB CLI search |
| [nmap scripts](03-Vulnerability-Analysis/nmap-scripts.md) | NSE vulnerability scripts |
| [lynis](03-Vulnerability-Analysis/lynis.md) | System security auditing |
| [legion](03-Vulnerability-Analysis/legion.md) | GUI network pentest framework |

</details>

<details>
<summary><strong>04 - Web Application Testing</strong></summary>

| Tool | Description |
|------|-------------|
| [sqlmap](04-Web-Application-Testing/sqlmap.md) | Automatic SQL injection |
| [Burp Suite](04-Web-Application-Testing/burpsuite.md) | Web proxy & testing platform (GUI) |
| [OWASP ZAP](04-Web-Application-Testing/zaproxy.md) | Web app scanner (GUI) |
| [wfuzz](04-Web-Application-Testing/wfuzz.md) | Web fuzzer |
| [WPScan](04-Web-Application-Testing/wpscan.md) | WordPress scanner |
| [commix](04-Web-Application-Testing/commix.md) | Command injection exploitation |
| [wafw00f](04-Web-Application-Testing/wafw00f.md) | WAF detection |
| [XSStrike](04-Web-Application-Testing/xsstrike.md) | XSS detection & exploitation |
| [jwt_tool](04-Web-Application-Testing/jwt_tool.md) | JWT token attacks |
| [tplmap](04-Web-Application-Testing/tplmap.md) | SSTI detection & exploitation |

</details>

<details>
<summary><strong>05 - Exploitation</strong></summary>

| Tool | Description |
|------|-------------|
| [Metasploit](05-Exploitation/metasploit.md) | Exploitation framework |
| [Impacket](05-Exploitation/impacket.md) | Windows/AD protocol attacks |
| [Evil-WinRM](05-Exploitation/evil-winrm.md) | WinRM shell |
| [CrackMapExec](05-Exploitation/crackmapexec.md) | Network pentest swiss knife |
| [NetExec](05-Exploitation/netexec.md) | CrackMapExec successor |
| [Responder](05-Exploitation/responder.md) | LLMNR/NBT-NS poisoner |
| [pwncat](05-Exploitation/pwncat.md) | Post-exploitation shell handler |
| [kerbrute](05-Exploitation/kerbrute.md) | Kerberos brute-force & user enum |
| [certipy](05-Exploitation/certipy.md) | AD Certificate Services attacks |
| [nishang](05-Exploitation/nishang.md) | PowerShell offensive scripts |
| [swaks](05-Exploitation/swaks.md) | SMTP testing swiss army knife |

</details>

<details>
<summary><strong>06 - Password Attacks</strong></summary>

| Tool | Description |
|------|-------------|
| [John the Ripper](06-Password-Attacks/john.md) | Password cracker + hash extractors |
| [hashcat](06-Password-Attacks/hashcat.md) | GPU-accelerated password cracker |
| [Hydra](06-Password-Attacks/hydra.md) | Online brute-forcer (SSH, HTTP, etc.) |
| [CeWL](06-Password-Attacks/cewl.md) | Custom wordlist from website |
| [crunch](06-Password-Attacks/crunch.md) | Pattern-based wordlist generator |
| [hash-identifier](06-Password-Attacks/hash-identifier.md) | Hash type identification |
| [hashid](06-Password-Attacks/hashid.md) | Better hash identifier with mode output |
| [Wordlists](06-Password-Attacks/wordlists.md) | SecLists & rockyou reference |

</details>

<details>
<summary><strong>07 - Post-Exploitation</strong></summary>

| Tool | Description |
|------|-------------|
| [BloodHound](07-Post-Exploitation/bloodhound.md) | AD attack path visualization (GUI) |
| [Chisel](07-Post-Exploitation/chisel.md) | HTTP tunneling for pivoting |
| [Ligolo-ng](07-Post-Exploitation/ligolo-ng.md) | Advanced pivoting via TUN interface |
| [LinPEAS/WinPEAS](07-Post-Exploitation/linpeas-winpeas.md) | Privilege escalation enumeration |
| [pspy](07-Post-Exploitation/pspy.md) | Process monitoring (find cron jobs) |
| [Proxychains](07-Post-Exploitation/proxychains.md) | Route tools through SOCKS proxy |
| [socat](07-Post-Exploitation/socat.md) | Advanced networking relay |
| [sshuttle](07-Post-Exploitation/sshuttle.md) | VPN over SSH |
| [pypykatz](07-Post-Exploitation/pypykatz.md) | Python mimikatz for LSASS dumps |
| [dnscat2](07-Post-Exploitation/dnscat2.md) | DNS tunneling C2 |

</details>

<details>
<summary><strong>08 - Reverse Engineering</strong></summary>

| Tool | Description |
|------|-------------|
| [Ghidra](08-Reverse-Engineering/ghidra.md) | NSA reverse engineering suite (GUI) |
| [radare2](08-Reverse-Engineering/radare2.md) | CLI reverse engineering framework |
| [GDB + PEDA](08-Reverse-Engineering/gdb.md) | Debugger for exploit dev |
| [pwntools](08-Reverse-Engineering/pwntools.md) | Python exploit development library |
| [binwalk](08-Reverse-Engineering/binwalk.md) | Firmware/binary analysis |
| [ltrace/strace](08-Reverse-Engineering/ltrace-strace.md) | Library & system call tracing |

</details>

<details>
<summary><strong>09 - Forensics & Steganography</strong></summary>

| Tool | Description |
|------|-------------|
| [foremost](09-Forensics-Stego/foremost.md) | File carving from disk images |
| [steghide](09-Forensics-Stego/steghide.md) | Steganography extraction |
| [exiftool](09-Forensics-Stego/exiftool.md) | Metadata reader/editor |
| [Volatility 3](09-Forensics-Stego/volatility3.md) | Memory forensics framework |
| [stegoveritas](09-Forensics-Stego/stegoveritas.md) | Multi-method stego analysis |
| [TestDisk](09-Forensics-Stego/testdisk.md) | Partition & file recovery |
| [hexedit/xxd](09-Forensics-Stego/hexedit.md) | Hex editors |
| [stegseek](09-Forensics-Stego/stegseek.md) | Fast steghide passphrase cracker |

</details>

<details>
<summary><strong>10 - Wireless</strong></summary>

| Tool | Description |
|------|-------------|
| [aircrack-ng](10-Wireless/aircrack-ng.md) | WiFi security auditing suite |
| [reaver](10-Wireless/reaver.md) | WPS brute-force |
| [wifite](10-Wireless/wifite.md) | Automated WiFi auditing |

> **Note:** Wireless tools have limited functionality in WSL due to hardware access restrictions. Use for offline cracking or run on bare metal.

</details>

<details>
<summary><strong>11 - Networking Utilities</strong></summary>

| Tool | Description |
|------|-------------|
| [Wireshark](11-Networking-Utilities/wireshark.md) | Packet analyzer (GUI) |
| [netcat](11-Networking-Utilities/netcat.md) | TCP/UDP network tool |
| [tcpdump](11-Networking-Utilities/tcpdump.md) | CLI packet capture |
| [tmux](11-Networking-Utilities/tmux.md) | Terminal multiplexer |
| [OpenVPN](11-Networking-Utilities/openvpn.md) | VPN client (for HTB) |
| [rlwrap](11-Networking-Utilities/rlwrap.md) | Readline wrapper for shells |
| [Remmina](11-Networking-Utilities/remmina.md) | Remote desktop client (GUI) |

</details>

## GUI Support

This toolkit provides full graphical desktop support for Parrot WSL:

### WSLg (Recommended - Windows 11)
Individual GUI apps (Wireshark, Ghidra, Burp Suite, BloodHound, etc.) launch directly on your Windows desktop via WSLg. No configuration needed — just run the tool.

### XRDP (Full Desktop)
For a complete Linux desktop experience:
```bash
start-desktop xrdp
```
Then connect from Windows using **Remote Desktop Connection** (`mstsc`) to `localhost:3390`.

### Included Desktop Apps
- **Brave** — Privacy-focused web browser
- **Wireshark** — Network analysis
- **Ghidra** — Reverse engineering
- **Burp Suite** — Web testing
- **OWASP ZAP** — Web scanning
- **BloodHound** — AD visualization
- **Remmina** — RDP/VNC client
- **XFCE4 Terminal / Terminator** — Terminal emulators
- **Thunar** — File manager
- **Mousepad** — Text editor

## Directory Structure

```
WSL-Parrot-Security/
├── Setup-ParrotWSL.ps1         # Run this first on Windows — detects/installs Parrot WSL
├── install-toolkit.sh          # Main installer script (tools + GUI)
├── wsl-config/                 # WSL user & workspace setup
│   ├── setup-user.sh           # Creates user, workspace, aliases
│   ├── wsl.conf                # Reference WSL config
│   └── README.md               # How to customize for your machine
├── README.md                   # This file
├── DOCUMENTATION.md            # Full reference documentation
├── 01-Reconnaissance/          # Phase 1: Recon tools & docs
│   ├── nmap.md
│   ├── masscan.md
│   └── ...
├── 02-Scanning-Enumeration/    # Phase 2: Enumeration tools & docs
├── 03-Vulnerability-Analysis/  # Phase 3: Vuln scanning
├── 04-Web-Application-Testing/ # Phase 4: Web attacks
├── 05-Exploitation/            # Phase 5: Initial access
├── 06-Password-Attacks/        # Phase 6: Cracking & brute-force
├── 07-Post-Exploitation/       # Phase 7: Privesc & pivoting
├── 08-Reverse-Engineering/     # Phase 8: Binary analysis
├── 09-Forensics-Stego/         # Phase 9: Forensics & stego
├── 10-Wireless/                # Phase 10: WiFi (limited in WSL)
└── 11-Networking-Utilities/    # Networking tools & VPN
```

## Requirements

- **Windows 10** (Build 19041+) or **Windows 11**
- **WSL2** enabled
- **Parrot OS** WSL distribution (or Debian-based distro upgraded to Parrot)
- ~15-20 GB free disk space
- Internet connection for package downloads

## WSL Setup From Scratch

If you're starting from zero, here's the full path:

```powershell
# 1. Enable WSL (PowerShell Admin)
wsl --install

# 2. Install Parrot (or start from Debian and upgrade)
wsl --install -d Debian

# 3. Inside Debian, upgrade to Parrot (optional, if Parrot WSL isn't available)
curl https://raw.githubusercontent.com/ParrotSec/alternate-install/master/parrot-install.sh -o parrot-install.sh
chmod a+x parrot-install.sh
sudo ./parrot-install.sh
# Select: 1. Install Core Only

# 4. Update
sudo parrot-upgrade

# 5. Run this toolkit installer
sudo bash install-toolkit.sh
```

## Troubleshooting

### GUI apps don't display
```bash
# Run the built-in fixer
fix-wsl-gui

# Or manually check
echo $DISPLAY
echo $WAYLAND_DISPLAY
# If empty, restart WSL: wsl --shutdown (from PowerShell)
```

### XRDP won't connect
```bash
# Check XRDP status
sudo service xrdp status

# Restart XRDP
sudo service xrdp restart

# Verify port
ss -tlnp | grep 3390
```

### Tool installation failed
```bash
# Re-run just the failed section
sudo apt update
sudo apt install <package-name>

# For pip packages
pip3 install <package> --break-system-packages
```

### Hashcat GPU not working
GPU acceleration doesn't work natively in WSL. Options:
- Install hashcat on Windows and run from there
- Use `--force` flag (CPU-only, slower)
- Use a cloud GPU instance

## Contributing

PRs welcome. To add a new tool:

1. Add the `apt install` / `pip install` command to the appropriate phase in `install-toolkit.sh`
2. Create a `.md` file in the matching phase folder with:
   - Purpose
   - Installation
   - Quick Start examples
   - Key options table
   - HTB-specific usage tips
3. Update this README's tool list

## Disclaimer

This toolkit is intended for **authorized security testing, CTF competitions, and educational purposes only**. All tools should be used in controlled environments such as HackTheBox, TryHackMe, or authorized penetration testing engagements.

**Do not use these tools against systems you do not have explicit permission to test.**

## License

MIT License — see [LICENSE](LICENSE) for details.
