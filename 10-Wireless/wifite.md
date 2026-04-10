# Wifite

> An automated WiFi hacking tool -- it handles the entire attack flow so you don't have to run 10 different commands.

## What It Does

Wifite wraps aircrack-ng, reaver, and other wireless tools into a single automated workflow. Instead of manually putting your card in monitor mode, capturing handshakes, and running aircrack-ng separately, wifite does it all. You point it at a network (or let it scan) and it picks the best attack for each target -- WPA handshake capture + dictionary crack, WPS pin brute-force, or Pixie Dust. It's basically "autopilot mode" for WiFi attacks.

## Install

```bash
sudo apt install wifite
```

## Examples

```bash
# Launch and scan for networks (interactive -- pick your target)
sudo wifite

# Target a specific network by BSSID
sudo wifite --bssid AA:BB:CC:DD:EE:FF

# Only attack WPA networks
sudo wifite --wpa

# Only try WPS attacks
sudo wifite --wps

# Use a specific wordlist for WPA cracking
sudo wifite --dict /usr/share/wordlists/rockyou.txt

# Kill processes that interfere with monitor mode (NetworkManager, etc.)
sudo wifite --kill
```

## Let's Be Honest: WSL Limitations

**Same story as every wireless tool -- this doesn't really work in WSL.**

- Needs a WiFi adapter in monitor mode, which WSL doesn't support natively
- USB passthrough to WSL is possible but painful and unreliable
- Best used on a native Linux install or a live USB boot

**What you CAN do without hardware:**
- Study the attack flow to understand what wifite automates behind the scenes
- Use aircrack-ng offline to crack `.cap` files with captured handshakes (no adapter needed)
- Practice with provided capture files from CTF challenges

## What Wifite Automates

Understanding the manual process helps even if you're using the automated version:

1. Puts WiFi adapter into monitor mode
2. Scans for nearby networks
3. For WPA: deauths clients to capture the handshake, then cracks it with a wordlist
4. For WPS: tries Pixie Dust first, falls back to PIN brute-force
5. Reports any recovered passwords

## HTB Tips

- **Wireless challenges on HTB are rare** and usually provide capture files rather than requiring live attacks.
- If you do get a `.cap` file, just use `aircrack-ng` directly -- you don't need wifite for offline cracking.
- The real value of knowing wifite is for real-world pentesting and certs like OSCP/CPTS, not so much for HTB boxes.
- When wifite captures a handshake, it saves it as a `.cap` file. You can then crack it with hashcat on your Windows host for way better performance (GPU cracking).
- Think of wifite as training wheels -- great for learning the flow, but understanding the individual tools underneath gives you more control.
