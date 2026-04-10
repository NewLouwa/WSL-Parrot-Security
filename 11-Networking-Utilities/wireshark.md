# Wireshark

## Purpose
GUI network protocol analyzer. Captures and inspects network traffic in real-time or from pcap files. Essential for analyzing network captures in forensics challenges.

## Installation
```bash
sudo apt install wireshark tshark
```

## Quick Start
```bash
# Launch GUI
wireshark

# Open capture file
wireshark capture.pcap

# CLI version
tshark -r capture.pcap
```

## Key Display Filters
| Filter | Description |
|--------|-------------|
| `http` | HTTP traffic only |
| `tcp.port == 80` | Traffic on port 80 |
| `ip.addr == 10.10.10.x` | Traffic to/from IP |
| `dns` | DNS queries/responses |
| `tcp.flags.syn == 1` | SYN packets |
| `http.request.method == "POST"` | HTTP POST requests |
| `ftp-data` | FTP file transfers |
| `smb2` | SMB traffic |
| `tcp contains "password"` | Packets containing string |
| `!(arp or dns)` | Exclude ARP and DNS |

## tshark (CLI) Examples
```bash
# Read pcap with filter
tshark -r capture.pcap -Y "http.request"

# Extract HTTP objects
tshark -r capture.pcap --export-objects http,output_dir/

# Show specific fields
tshark -r capture.pcap -T fields -e ip.src -e http.host -e http.request.uri

# Follow TCP stream
tshark -r capture.pcap -z follow,tcp,ascii,0
```

## Useful Features
- **Follow TCP Stream**: Right-click packet > Follow > TCP Stream
- **Export Objects**: File > Export Objects > HTTP/SMB/etc.
- **Statistics**: Statistics > Protocol Hierarchy / Conversations / Endpoints
- **Coloring Rules**: View > Coloring Rules

## HTB Usage
- Analyze pcap files in forensics challenges
- Extract credentials from unencrypted traffic (HTTP, FTP, Telnet)
- Export transferred files (File > Export Objects)
- Follow TCP streams to reconstruct conversations
- GUI works via WSLg or XRDP
