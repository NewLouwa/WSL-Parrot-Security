# Telnet - Raw TCP Connections Made Simple

Basic tool for connecting to any TCP port and talking to services directly.

## What It Does

Telnet opens a raw TCP connection to any host and port. While nobody really uses it as a remote shell anymore, it is incredibly handy for pentesting. You can use it to grab service banners, test if a port is open, manually interact with text-based protocols like HTTP or SMTP, and connect to old services that still use telnet for access.

## Install

```bash
sudo apt install telnet
```

## Basic Usage

```bash
# Connect to a host on a specific port
telnet 10.10.10.20 80

# Connect to the default telnet port (23)
telnet 10.10.10.20
```

## Practical Examples

```bash
# Banner grabbing - see what service is running
telnet 10.10.10.20 22
# Shows SSH banner like "SSH-2.0-OpenSSH_8.2p1"

# Check if a port is open
telnet 10.10.10.20 8080
# "Connected to..." means it's open
# "Connection refused" means it's closed

# Manually send an HTTP request
telnet 10.10.10.20 80
# Then type:
GET / HTTP/1.1
Host: 10.10.10.20
# (press Enter twice)
# You'll see the raw HTTP response

# Talk to an SMTP server
telnet 10.10.10.20 25
# Then interact:
HELO test
VRFY admin
VRFY root
# VRFY can confirm if users exist

# Interact with a POP3 server
telnet 10.10.10.20 110
USER admin
PASS password123
LIST
```

## HTB Tips

- Great for quick banner grabs when nmap feels like overkill
- Use it to manually test SMTP user enumeration (VRFY, EXPN, RCPT TO)
- If you find an actual telnet service (port 23), try common creds right away
- Telnet sends everything in cleartext, so check packet captures for creds
- For anything beyond simple testing, prefer `nc` (netcat) since it is more flexible
- Press `Ctrl+]` then type `quit` to exit if the connection hangs
- Some HTB boxes have custom services on weird ports. Telnet is the fastest way to poke at them
