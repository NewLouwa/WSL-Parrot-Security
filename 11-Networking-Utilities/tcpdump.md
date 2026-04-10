# tcpdump

## Purpose
CLI packet capture and analysis tool. Captures network traffic and saves to pcap files for later analysis with Wireshark.

## Installation
```bash
sudo apt install tcpdump
```

## Quick Start
```bash
# Capture on interface
sudo tcpdump -i tun0

# Capture with verbose output
sudo tcpdump -i tun0 -v

# Save to pcap file
sudo tcpdump -i tun0 -w capture.pcap

# Read pcap file
tcpdump -r capture.pcap

# Filter by host
sudo tcpdump -i tun0 host 10.10.10.x

# Filter by port
sudo tcpdump -i tun0 port 80

# Show packet content (ASCII)
sudo tcpdump -i tun0 -A

# Show hex + ASCII
sudo tcpdump -i tun0 -XX
```

## Common Filters
```bash
# HTTP traffic
sudo tcpdump -i tun0 port 80 or port 443

# ICMP (ping)
sudo tcpdump -i tun0 icmp

# DNS
sudo tcpdump -i tun0 port 53

# Not SSH (exclude your own session)
sudo tcpdump -i tun0 not port 22

# Combined
sudo tcpdump -i tun0 host 10.10.10.x and port 80
```

## HTB Usage
- Quick packet capture when Wireshark is overkill
- Monitor traffic during exploitation for debugging
- Capture ICMP to verify connectivity
- Save pcaps for later analysis
