# FTP Client - Connect to FTP Servers

Basic command-line FTP client for connecting to file transfer services.

## What It Does

The `ftp` command connects you to FTP servers running on port 21. On HTB boxes, FTP is a common finding during enumeration. You use it to check for anonymous login (no password needed), browse shared files, and download anything interesting. It is one of the first things to try when you see port 21 open.

## Install

```bash
sudo apt install ftp
```

## Basic Usage

```bash
# Connect to an FTP server
ftp 10.10.10.20

# Connect with a specific port
ftp 10.10.10.20 2121
```

## Practical Examples

```bash
# Try anonymous login (very common on HTB)
ftp 10.10.10.20
# Username: anonymous
# Password: (just press Enter, or type anything)

# Once connected, common commands:
ls                  # List files
cd dirname          # Change directory
get filename        # Download a file
mget *.txt          # Download multiple files
put localfile       # Upload a file
binary              # Switch to binary mode (for non-text files)
ascii               # Switch to ASCII mode (for text files)
bye                 # Disconnect

# Download everything in one shot
prompt off          # Disable confirmation prompts
mget *              # Grab all files

# If you need to download binary files (images, executables)
binary              # ALWAYS set this before downloading non-text files
get backup.zip
```

## One-Liner Downloads

```bash
# Quick anonymous file grab without interactive mode
wget -r ftp://anonymous:@10.10.10.20/
# Recursively downloads everything via anonymous FTP
```

## HTB Tips

- Always try `anonymous` login when you see port 21 open
- Switch to `binary` mode before downloading non-text files or they will get corrupted
- Check for writable directories. If you can upload files, that might be your way in
- FTP creds are sent in plaintext, so check Wireshark captures for them too
- Look for config files, backup archives, and credential files in FTP shares
- If the FTP server has a known version, run `searchsploit` on it
