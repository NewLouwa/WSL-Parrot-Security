# ltrace / strace

## Purpose
- **ltrace**: Traces library calls made by a program (strcmp, printf, etc.)
- **strace**: Traces system calls made by a program (open, read, write, etc.)

## Installation
```bash
sudo apt install ltrace strace
```

## Quick Start
```bash
# Trace library calls
ltrace ./binary

# Trace system calls
strace ./binary

# Filter specific calls
strace -e open,read,write ./binary
ltrace -e strcmp,strlen ./binary

# Follow child processes
strace -f ./binary

# With output to file
strace -o output.txt ./binary

# Count calls
strace -c ./binary
```

## Key Options
| Option | Description |
|--------|-------------|
| `-e <calls>` | Filter specific calls |
| `-f` | Follow child processes |
| `-p <pid>` | Attach to running process |
| `-o <file>` | Output to file |
| `-c` | Summary of calls |
| `-s <n>` | Max string print length |

## HTB Usage
- **ltrace** reveals hardcoded password comparisons (`strcmp("input", "secret")`)
- Quick way to find what a binary does without full reversing
- See what files a binary opens/reads/writes
- Trace network connections with `strace -e network`
