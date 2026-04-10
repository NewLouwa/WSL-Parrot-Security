# tmux

## Purpose
Terminal multiplexer. Run multiple terminal sessions in one window, split panes, detach/reattach sessions. Essential for managing multiple tools during pentesting.

## Installation
```bash
sudo apt install tmux
```

## Quick Start
```bash
# Start new session
tmux

# Named session
tmux new -s htb

# Detach: Ctrl+B, then D
# Reattach
tmux attach -t htb

# List sessions
tmux ls
```

## Key Bindings (prefix = Ctrl+B)
| Key | Action |
|-----|--------|
| `Ctrl+B, %` | Split vertically |
| `Ctrl+B, "` | Split horizontally |
| `Ctrl+B, arrow` | Switch pane |
| `Ctrl+B, c` | New window |
| `Ctrl+B, n` | Next window |
| `Ctrl+B, p` | Previous window |
| `Ctrl+B, d` | Detach session |
| `Ctrl+B, z` | Zoom pane (toggle fullscreen) |
| `Ctrl+B, [` | Scroll mode (q to exit) |
| `Ctrl+B, x` | Kill pane |

## HTB Usage
- Keep multiple tools running simultaneously (nmap, shell, notes)
- Split screen: shell on one side, enumeration on the other
- Sessions survive terminal disconnects
- Organize by: one window for recon, one for exploit, one for shells
