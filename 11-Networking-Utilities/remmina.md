# Remmina

> A GUI remote desktop client -- connect to Windows boxes via RDP or VNC once you've got credentials.

## What It Does

Remmina is a graphical remote desktop app that supports RDP (for Windows), VNC (cross-platform), and SSH. When you pop credentials on an HTB Windows box and want a full desktop instead of just a command line, Remmina gives you that GUI connection. It's the "point and click" alternative to command-line tools like `xfreerdp`. You can save connections for different boxes, which is nice when you're juggling multiple machines.

## Install

```bash
sudo apt install remmina remmina-plugin-rdp remmina-plugin-vnc
```

## Quick Start

```bash
# Launch the GUI
remmina
```

Then in the GUI:
1. Click the **+** button to create a new connection
2. Set **Protocol** to RDP (or VNC)
3. Enter the **Server** IP (e.g., 10.10.10.5)
4. Enter **Username** and **Password**
5. Click **Save and Connect**

## Or Use the Command Line

```bash
# Quick RDP connection without opening the GUI first
remmina -c rdp://administrator@10.10.10.5

# Connect to VNC
remmina -c vnc://10.10.10.5:5900
```

## Supported Protocols

| Protocol | Default Port | When to use it |
|---|---|---|
| RDP | 3389 | Windows Remote Desktop -- most common on HTB |
| VNC | 5900 | When you find a VNC service running |
| SSH | 22 | If you want a GUI terminal manager (overkill, just use ssh) |
| SFTP | 22 | File transfer through a GUI |

## WSL Note

Remmina is a GUI app, so you need one of these to run it:
- **WSLg** (Windows 11) -- should just work, GUI apps launch automatically
- **XRDP** or an X server on Windows -- if WSLg isn't available
- Or just use **xfreerdp** from the command line if the GUI is giving you trouble

## HTB Tips

- **Got creds? RDP in.** If port 3389 is open and you have valid credentials (especially admin), connecting via RDP gives you a full Windows desktop. Sometimes you need the GUI to find files, run programs, or check things that are hard to do from a shell.
- For quick one-off connections, `xfreerdp` from the command line is honestly faster. Use Remmina when you want to save connections and switch between them.
- VNC (port 5900-5910) shows up occasionally on HTB. Some boxes run VNC with weak or no passwords -- always try connecting.
- If RDP is open but you can't get in, you might need to add your user to the "Remote Desktop Users" group first (post-exploitation).
- Save your HTB connections in Remmina so you don't have to retype credentials every time you reconnect after a VPN drop.
