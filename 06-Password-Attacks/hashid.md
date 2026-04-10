# hashID

## Purpose
Hash type identification tool. Analyzes hash strings and identifies possible hashing algorithms. More accurate and maintained than the older `hash-identifier`. Supports 220+ hash types and outputs corresponding hashcat/john format codes.

## Installation
```bash
pip install hashid

# Or from source
git clone https://github.com/psypanda/hashID.git
cd hashID && python3 setup.py install
```

## Quick Start
```bash
# Identify a single hash
hashid 'e99a18c428cb38d5f260853678922e03'

# Show hashcat mode numbers
hashid -m 'e99a18c428cb38d5f260853678922e03'

# Show john format names
hashid -j 'e99a18c428cb38d5f260853678922e03'

# Show both hashcat and john formats
hashid -mj '$2y$10$abc123...'

# Identify hashes from a file
hashid -m -f hashes.txt
```

## Common Patterns
```bash
# Identify and get hashcat mode in one shot
hashid -m '5f4dcc3b5aa765d61d8327deb882cf99'
# Output: [+] MD5 [Hashcat Mode: 0]

# Identify bcrypt hash
hashid -mj '$2a$12$LJ3m4ysNhDE/...'
# Output: [+] bcrypt [Hashcat Mode: 3200] [JtR Format: bcrypt]

# Pipe hash directly
echo '$6$rounds=5000$salt$hash...' | hashid -m

# Identify multiple hashes from a dump
hashid -m -f extracted_hashes.txt > identified_hashes.txt
```

## HTB Usage
- First step when you find unknown hashes in databases, config files, or dumps
- Use `-m` flag to get the exact hashcat mode for cracking
- Faster workflow than looking up hash formats manually
- Handles edge cases like salted hashes, bcrypt, and Kerberos tickets better than hash-identifier
- Pipe output into your cracking workflow: identify hash type then crack with hashcat/john
- When multiple types match, try the most common one first (MD5, SHA-256, bcrypt)
