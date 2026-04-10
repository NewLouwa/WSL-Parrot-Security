# GDB + PEDA - Debugging Without the Pain

GDB with the PEDA plugin that adds colors, context, and exploit development helpers.

## What It Does

GDB is the standard Linux debugger, but its default interface is pretty bare. PEDA (Python Exploit Development Assistance) is a plugin that makes GDB actually usable. It adds colored output, automatically shows registers/stack/code after every step, and includes tools for pattern generation and ROP gadget finding. If you are doing buffer overflow challenges on HTB, this is what you want.

## Install

```bash
# Install GDB
sudo apt install gdb

# Install PEDA
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit

# Verify it works
gdb -q
# You should see "gdb-peda$" as your prompt
```

## Basic Usage

```bash
# Load a binary
gdb ./vulnerable_app

# Load a binary quietly (skip banner)
gdb -q ./vulnerable_app

# Attach to a running process
gdb -q -p <PID>
```

## Practical Examples

```bash
# Inside gdb-peda:

# Run the program
run
run < input.txt                # Run with input from file
run $(python3 -c 'print("A"*100)')  # Run with crafted input

# Set breakpoints
break main                     # Break at main function
break *0x08048456              # Break at specific address
info breakpoints               # List breakpoints
delete 1                       # Delete breakpoint #1

# Step through code
ni                             # Next instruction (step over)
si                             # Step instruction (step into)
continue                       # Continue execution

# Examine memory
x/20x $esp                     # Show 20 hex words at ESP
x/s 0x08048500                 # Show string at address
x/10i $eip                     # Show 10 instructions at EIP
```

## PEDA-Specific Commands

```bash
# Buffer overflow pattern generation
pattern_create 200             # Generate a 200-byte cyclic pattern
pattern_offset 0x41416141      # Find offset from pattern value

# Find useful addresses
jmpcall esp                    # Find JMP ESP gadgets
ropgadget                      # Search for ROP gadgets

# Search memory
searchmem "/bin/sh"            # Find string in memory
find "/bin/sh"                 # Same thing

# Security checks
checksec                       # Show binary protections (NX, ASLR, canary, PIE)

# Show current context (registers, code, stack)
context                        # Refreshes the display manually
```

## HTB Tips

- Always run `checksec` first to know what protections you are dealing with
- For buffer overflows: `pattern_create` then `pattern_offset` gives you the exact offset fast
- PEDA shows registers, stack, and code after every step, so you always know where you are
- If you prefer a different flavor, check out GEF or pwndbg as alternatives to PEDA
- Combine with `pwntools` in Python for scripting your exploits
- Use `vmmap` to see memory mappings and find writable/executable regions
- For 64-bit binaries, remember arguments go in registers (RDI, RSI, RDX) not on the stack
