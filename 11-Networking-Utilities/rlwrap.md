# rlwrap

## Purpose
Readline wrapper — adds command history and arrow key support to any CLI program. Essential for making reverse shells usable.

## Installation
```bash
sudo apt install rlwrap
```

## Quick Start
```bash
# Wrap netcat listener (arrow keys + history!)
rlwrap nc -lvnp 4444

# Wrap any interactive program
rlwrap ./program
```

## HTB Usage
- Always use `rlwrap nc -lvnp 4444` instead of plain `nc`
- Gives you arrow keys, command history, and line editing in reverse shells
- Simple but dramatically improves shell usability
