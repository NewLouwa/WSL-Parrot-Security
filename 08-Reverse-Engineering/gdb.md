# GDB (+ PEDA/GEF)

## Purpose
GNU Debugger — debug Linux binaries, set breakpoints, examine memory, and step through code. PEDA/GEF are extensions that add exploit development features.

## Installation
```bash
sudo apt install gdb gdb-peda
# Or install GEF:
# bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
```

## Quick Start
```bash
# Debug a binary
gdb ./binary

# Run with arguments
gdb --args ./binary arg1 arg2

# Attach to running process
gdb -p PID
```

## Essential Commands
```bash
# Run program
run
run $(python3 -c 'print("A"*100)')

# Breakpoints
break main
break *0x401234
info breakpoints
delete 1

# Stepping
next        # step over
step        # step into
continue    # continue
finish      # run until function returns

# Examine
info registers
x/20x $rsp          # examine 20 hex words at RSP
x/s 0x401234        # examine as string
x/10i $rip          # examine 10 instructions at RIP

# Stack
backtrace
info frame

# Memory
vmmap               # (PEDA/GEF) show memory map
checksec            # (PEDA/GEF) show protections
pattern create 200  # (PEDA/GEF) create cyclic pattern
pattern offset 0x41414141  # find offset
```

## PEDA-Specific
```bash
pdisas main         # pretty disassembly
context             # show registers/stack/code
searchmem "/bin/sh" # search memory for string
ropgadget            # find ROP gadgets
```

## HTB Usage
- Essential for binary exploitation (pwn) challenges
- Find buffer overflow offsets with cyclic patterns
- Inspect memory at runtime for debugging exploits
- Use with pwntools for automated exploit development
