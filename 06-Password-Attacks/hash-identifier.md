# hash-identifier

## Purpose
Identifies the type of a given hash. Helps you determine which hashcat mode or john format to use.

## Installation
```bash
sudo apt install hash-identifier
```

## Quick Start
```bash
# Interactive mode
hash-identifier

# Then paste your hash when prompted
```

## Alternatives
```bash
# hashid (more modern)
pip3 install hashid
hashid 'HASH_HERE'
hashid -m 'HASH_HERE'    # shows hashcat mode

# Online: https://hashes.com/en/tools/hash_identifier
```

## Common Hash Patterns
| Pattern | Likely Type |
|---------|-------------|
| 32 hex chars | MD5 |
| 40 hex chars | SHA1 |
| 64 hex chars | SHA256 |
| 128 hex chars | SHA512 |
| `$1$...` | md5crypt |
| `$5$...` | sha256crypt |
| `$6$...` | sha512crypt |
| `$2a$`/`$2b$` | bcrypt |
| 32 hex (no `$`) | Could be NTLM |

## HTB Usage
- First thing to run when you find an unknown hash
- Use `hashid -m` to get the hashcat mode number directly
- Double-check: multiple hash types can look similar
