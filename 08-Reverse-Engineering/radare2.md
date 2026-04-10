# radare2 (r2)

> A terminal-based reverse engineering tool. Looks scary at first, but once you learn the basics, it's the fastest way to peek inside a binary.

## What It Does

Radare2 lets you disassemble, debug, and analyze compiled programs without having their source code. When you find a mystery binary on an HTB box -- a custom SUID program, a crackme challenge, or a suspicious executable -- r2 helps you figure out what it does. It's entirely command-line based, which makes it great for quick analysis without needing a full GUI like Ghidra. The learning curve is real, but you only need about 10 commands to be productive.

## Install

```bash
sudo apt install radare2
```

## Basic Workflow (Do This Every Time)

```bash
# 1. Open the binary
r2 ./mystery_binary

# 2. FIRST THING: Analyze everything (this is required, r2 is useless without it)
[0x00000000]> aaa

# 3. List all functions -- look for main, interesting names, or custom functions
[0x00000000]> afl

# 4. Jump to main (or whatever function looks interesting)
[0x00000000]> s main

# 5. Disassemble the current function -- read the assembly
[0x00000000]> pdf

# 6. Look for hardcoded strings (passwords, flags, URLs)
[0x00000000]> izz
```

That's it. Those 6 commands cover 80% of what you need on HTB.

## Going Deeper

```bash
# Visual mode -- easier to read than raw commands (press q to quit)
[0x00000000]> V
# Press p to cycle through different views

# Graph mode -- see the control flow as a visual graph
[0x00000000]> VV

# Debug mode -- step through the program as it runs
r2 -d ./mystery_binary
[0x00000000]> aaa
[0x00000000]> db main        # Set a breakpoint at main
[0x00000000]> dc             # Run until breakpoint
[0x00000000]> dr             # Check register values
[0x00000000]> ds             # Step one instruction

# Search for a specific string in the binary
[0x00000000]> / password

# Print hex dump at current position (32 bytes)
[0x00000000]> px 32
```

## The Commands You'll Actually Use

| Command | What it does |
|---|---|
| `aaa` | Analyze the binary (always run first) |
| `afl` | List all functions |
| `s main` | Jump to the main function |
| `pdf` | Show disassembly of current function |
| `izz` | Find all strings in the binary |
| `V` | Visual mode (easier to read) |
| `VV` | Graph view of function flow |
| `px 64` | Hex dump (64 bytes) |
| `q` | Quit (works in any mode) |

## HTB Tips

- **Start with strings.** Run `izz` and grep for anything interesting -- passwords, file paths, URLs, "correct", "flag", "access granted". This alone solves some challenges.
- For quick checks, `strings ./binary | grep -i flag` from bash might be all you need before even opening r2.
- If you're more comfortable with a GUI, use Ghidra for deep analysis. Use r2 for quick command-line checks when you're already in a shell.
- SUID binaries on Linux boxes are prime r2 targets -- understand what they do, find how to abuse them.
- The `pdf` output can look overwhelming. Focus on `cmp` (compare) and `jne`/`je` (conditional jumps) -- those are usually where password checks happen.
