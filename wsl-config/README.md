# WSL Configuration

This folder contains WSL configuration files and a setup script for creating a non-root user with a structured pentesting workspace.

## Files

| File | Purpose |
|------|---------|
| `setup-user.sh` | Automated setup: creates user, configures WSL, builds workspace |
| `htb-connect.sh` | OpenVPN connector with auto-discovery and ping test |
| `motd.sh` | Login banner with quick command reference |
| `bookmarks.html` | 100+ security bookmarks auto-imported into Brave/Firefox |
| `wsl.conf` | Reference WSL config (the setup script generates this for you) |

## Quick Setup

```bash
# Run the setup script with your desired username
sudo bash setup-user.sh parrot
```

This will:
1. Create the user (or skip if it exists) and set a password
2. Add them to `sudo` and `wheel` groups
3. Set them as the default WSL login user
4. Create a structured workspace in their home directory
5. Install helper scripts and shell aliases
6. Configure WSL to open in the home directory

Then restart WSL from PowerShell:
```powershell
wsl --shutdown
```

## Manual Setup

If you prefer to do it yourself:

### 1. Create a user

```bash
# Create user with home directory
sudo useradd -m -s /bin/bash YOUR_USERNAME
sudo passwd YOUR_USERNAME

# Add to sudo and wheel
sudo usermod -aG sudo,wheel YOUR_USERNAME
```

### 2. Configure wsl.conf

Copy `wsl.conf` to `/etc/wsl.conf` and edit the `[user]` section:

```bash
sudo cp wsl.conf /etc/wsl.conf
sudo nano /etc/wsl.conf
```

Change this line:
```ini
[user]
default=YOUR_USERNAME
```

The `[user] default=` setting controls which user WSL logs in as. Without it, WSL defaults to root.

### 3. Restart WSL

From PowerShell:
```powershell
wsl --shutdown
```

Reopen your Parrot WSL terminal — you'll be logged in as your user, in your home directory.

## wsl.conf Reference

| Section | Key | What it does |
|---------|-----|-------------|
| `[boot]` | `systemd=true` | Enables systemd (needed for services like xrdp, neo4j) |
| `[user]` | `default=username` | Sets which user WSL logs in as |
| `[interop]` | `enabled=true` | Allows running Windows programs from Linux |
| `[interop]` | `appendWindowsPath=true` | Adds Windows PATH to Linux PATH |
| `[automount]` | `enabled=true` | Mounts Windows drives at /mnt/c, /mnt/d, etc. |
| `[automount]` | `options="metadata,..."` | Enables Linux file permissions on Windows files |
| `[network]` | `generateResolvConf=true` | Auto-generates DNS config |

## HTB Connect (OpenVPN)

The `htb-connect` script handles VPN connections to HackTheBox. Installed to `/usr/local/bin/htb-connect` by `setup-user.sh`.

### Interactive mode
```bash
htb-connect
# or just:
vpn
```
Searches for `.ovpn` files in your workspace, Windows Downloads/Desktop, and home directory. Lets you pick one, optionally enter a target IP to ping.

### One-liner
```bash
htb-connect ~/workspace/htb/vpn/lab.ovpn 10.10.10.5

# Windows paths work too
htb-connect 'C:\Users\You\Downloads\lab.ovpn' 10.10.10.5
```

### Other commands
```bash
htb-connect --status       # Check if VPN is running + show your IP
htb-connect --disconnect   # Kill VPN

# Or with aliases
vpn-status
vpn-dc
```

## Workspace Structure

After running `setup-user.sh`, your home directory will have:

```
~/workspace/
├── htb/
│   ├── machines/          # new-machine creates folders here
│   ├── challenges/        # new-challenge creates folders here
│   ├── prolabs/
│   ├── endgames/
│   ├── notes/
│   └── vpn/               # store .ovpn files here
├── scripts/
│   ├── new-machine.sh     # usage: new-machine BoxName 10.10.10.x
│   ├── new-challenge.sh   # usage: new-challenge web challenge-name
│   └── serve.sh           # usage: serve 80
├── tools/                 # custom compiled tools
├── wordlists/             # custom wordlists
├── loot/                  # extracted data
└── www/                   # files to serve to targets
```

## Shell Aliases

After setup, these aliases are available:

| Alias | Command |
|-------|---------|
| `ws` | `cd ~/workspace` |
| `htb` | `cd ~/workspace/htb` |
| `machines` | `cd ~/workspace/htb/machines` |
| `new-machine` | Create new machine workspace |
| `new-challenge` | Create new challenge workspace |
| `serve` | Start HTTP server on port 8080 from ~/workspace/www |
| `myip` | Show your HTB VPN IP (tun0) |
| `rsh 4444` | `rlwrap nc -lvnp 4444` |
| `vpn` | `htb-connect` (interactive VPN connect) |
| `vpn-dc` | Disconnect VPN |
| `vpn-status` | Check VPN status |
| `pserv` | `python3 -m http.server` |
| `htb-shell Name` | Enter project shell with per-machine command logging |
| `clip` | Copy to Windows clipboard via `clip.exe` |

## Per-Project Command History

When you start working on a machine, use `htb-shell` to enter a dedicated shell:

```bash
new-machine Lame 10.10.10.3    # create workspace
htb-shell Lame                  # enter project shell
```

Inside the project shell:
- Your prompt shows the machine name: `[Lame] user@host:~/workspace/htb/machines/Lame$`
- All commands are logged to `.cmd_history` in the machine folder
- Type `exit` to leave the project shell
- Review your commands later for writeups: `cat ~/workspace/htb/machines/Lame/.cmd_history`

## Browser Bookmarks

`setup-user.sh` auto-imports 100+ curated security bookmarks into Brave and Firefox, organized by category:

- HackTheBox, HTB Academy, HTB Forum
- Knowledge Bases (HackTricks, The Hacker Recipes, ired.team)
- Cheat Sheets (GTFOBins, LOLBAS, RevShells, CyberChef)
- Vulnerability Databases (Exploit-DB, CVE, NVD, Sploitus)
- Web Testing (PortSwigger Academy, PayloadsAllTheThings, jwt.io)
- Active Directory, OSINT, Reverse Engineering, Forensics
- Writeups & Learning (0xdf, IppSec, TryHackMe, OverTheWire)

Manual import: Bookmarks → Import HTML → `~/workspace/bookmarks.html`
