# SMBMap

## Purpose
Enumerate SMB shares and their permissions across a network. Shows read/write access per share without connecting individually.

## Install
```bash
sudo apt install smbmap
```

## Usage
```bash
smbmap -H 10.10.10.5                             # Null session
smbmap -H 10.10.10.5 -u user -p pass             # With creds
smbmap -H 10.10.10.5 -u user -p pass -r share    # List share contents
smbmap -H 10.10.10.5 -u user -p pass -R share    # Recursive listing
smbmap -H 10.10.10.5 --download 'share\file.txt' # Download file
smbmap -H 10.10.10.5 --upload local.txt 'share\remote.txt' # Upload file
```

## Key Flags
```bash
-H          # Target host
-u / -p     # Credentials
-d          # Domain
-r          # List share contents
-R          # Recursive listing
-x          # Execute command (if admin)
--download  # Download file
--upload    # Upload file
```

## Tips
- Best tool for quickly checking share permissions (READ, WRITE)
- Use before `smbclient` to know what you can access
- `-x` can execute commands if you have admin access
