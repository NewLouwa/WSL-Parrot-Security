# enum4linux

## Purpose
Windows/Samba enumeration tool. Extracts user lists, shares, group memberships, password policies, and OS info from SMB/NetBIOS services.

## Install
```bash
sudo apt install enum4linux
```

## Usage

### Full Enumeration
```bash
enum4linux -a 10.10.10.5              # Run all checks
```

### Specific Enumerations
```bash
enum4linux -U 10.10.10.5              # User listing
enum4linux -S 10.10.10.5              # Share listing
enum4linux -G 10.10.10.5              # Group listing
enum4linux -P 10.10.10.5              # Password policy
enum4linux -o 10.10.10.5              # OS information
enum4linux -n 10.10.10.5              # Nbtstat info
```

### With Credentials
```bash
enum4linux -u "user" -p "pass" -a 10.10.10.5
```

## Key Flags
```bash
-a          # All enumeration
-U          # User list
-S          # Share list
-G          # Group list
-P          # Password policy
-o          # OS info
-u / -p     # Username / password
-r          # RID cycling (user enumeration via RID)
```

## Tips
- Always start with `-a` for full enumeration
- Null sessions (no creds) often work on misconfigured boxes
- Combine with `smbclient` and `smbmap` for deeper SMB exploration
- Consider `enum4linux-ng` (Python rewrite) for better output
