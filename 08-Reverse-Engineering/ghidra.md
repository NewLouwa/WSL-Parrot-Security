# Ghidra

## Purpose
NSA's open-source GUI reverse engineering suite. Disassembler and decompiler supporting x86, x64, ARM, MIPS, and more. Free alternative to IDA Pro.

## Installation
```bash
sudo apt install ghidra
```

## Quick Start
```bash
# Launch GUI
ghidra
```

## Workflow
1. Create a new project (File > New Project)
2. Import binary (File > Import File)
3. Double-click the file to open CodeBrowser
4. Let auto-analysis complete
5. Navigate functions in the Symbol Tree (left panel)
6. View decompiled C code in the Decompile window (right panel)

## Key Features
| Feature | Description |
|---------|-------------|
| **Decompiler** | Converts assembly to readable C-like code |
| **Cross-references** | Find where functions/strings are used |
| **String search** | Window > Defined Strings |
| **Function graph** | Window > Function Graph |
| **Patch binary** | Modify and export binaries |
| **Scripting** | Python/Java scripts for automation |

## Useful Shortcuts
| Shortcut | Action |
|----------|--------|
| `G` | Go to address |
| `L` | Rename label/function |
| `T` | Set data type |
| `;` | Add comment |
| `Ctrl+Shift+E` | Search strings |

## HTB Usage
- Analyze challenge binaries and crackmes
- Find hardcoded passwords, keys, and flags
- Understand custom encryption algorithms
- Patch binary checks to bypass protections
- GUI works via WSLg or XRDP
