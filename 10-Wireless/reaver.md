# Reaver / Bully

> WPS pin brute-force tools -- crack WiFi passwords by attacking the router's WPS feature.

## What It Does

Most home routers have a feature called WPS (WiFi Protected Setup) -- it's that button on the back of your router that lets you connect without typing a password. The problem is that WPS uses an 8-digit PIN that's surprisingly easy to brute-force. Reaver and Bully attack this PIN to recover the actual WPA/WPA2 password. The "Pixie Dust" attack is even faster -- it exploits weak randomness in the WPS handshake and can crack the PIN in seconds instead of hours.

## Install

```bash
sudo apt install reaver bully pixiewps
```

## Examples

```bash
# Classic Reaver attack -- brute-forces the WPS PIN
# Requires a WiFi adapter in monitor mode (wlan0mon)
sudo reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -vv

# Pixie Dust attack -- the fast path, try this first
sudo reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -K 1 -vv

# Bully -- alternative to Reaver, sometimes works when Reaver doesn't
sudo bully wlan0mon -b AA:BB:CC:DD:EE:FF -v 3

# Bully with Pixie Dust
sudo bully wlan0mon -b AA:BB:CC:DD:EE:FF -d -v 3
```

## Let's Be Honest: WSL Limitations

**This tool basically doesn't work in WSL.** Here's why:

- You need a USB WiFi adapter that supports monitor mode
- That adapter needs to be passed through to your WSL instance via USB/IP
- Even then, driver support is spotty and unreliable
- Most people give up and use a live boot Linux USB instead

**What actually works:**
- Running these tools on a native Linux install or live USB boot
- A dedicated WiFi adapter like the Alfa AWUS036ACH
- VMs with USB passthrough (VirtualBox/VMware) can also work

## HTB Tips

- **HTB rarely has wireless challenges** in the standard machines. When it does, it's usually in a challenge format with provided capture files.
- If you get a `.cap` or `.pcap` file with WPS handshake data, you can analyze it offline without needing a WiFi adapter.
- Pixie Dust (`-K 1` in Reaver) is always the first thing to try -- it's instant when it works.
- Understanding WPS attacks is still valuable knowledge for the CPTS/OSCP even if you don't run it often on HTB.
- For offline WPS cracking practice, look at tools like `pixiewps` that can work with captured handshake data.
