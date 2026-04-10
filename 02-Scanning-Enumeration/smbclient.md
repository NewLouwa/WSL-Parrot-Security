# smbclient

## Purpose
FTP-like client for accessing SMB/CIFS shares on Windows and Samba systems. List shares, download/upload files, browse directories.

## Install
```bash
sudo apt install smbclient
```

## Usage

### List Shares
```bash
smbclient -L //10.10.10.5 -N                     # Null session (no password)
smbclient -L //10.10.10.5 -U username             # With username (prompts for pass)
```

### Connect to a Share
```bash
smbclient //10.10.10.5/sharename -N               # Null session
smbclient //10.10.10.5/sharename -U username       # With credentials
```

### Commands Inside SMB Session
```
ls                    # List files
cd directory          # Change directory
get file.txt          # Download file
put local.txt         # Upload file
mget *.txt            # Download multiple files
recurse ON            # Enable recursive operations
prompt OFF            # Disable prompts for mget
mget *                # Download everything recursively
```

## Tips
- Always try null session first (`-N`)
- Combine with `smbmap` for permission mapping
- Use `recurse ON; prompt OFF; mget *` to grab everything quickly
