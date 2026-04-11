# tshark

## What it does
CLI version of Wireshark. Captures and analyzes packets without a GUI — perfect for WSL or remote sessions. Reads `.pcap` files, filters live traffic, and exports in multiple formats.

## Basic Usage

```bash
# List available interfaces
tshark -D

# Capture on interface (Ctrl+C to stop)
tshark -i eth0

# Capture and save to file
tshark -i eth0 -w capture.pcap

# Read a pcap file
tshark -r capture.pcap

# Limit packet count
tshark -i eth0 -c 100
```

## Filtering

```bash
# Display filter (same syntax as Wireshark)
tshark -r capture.pcap -Y "http"
tshark -r capture.pcap -Y "tcp.port == 80"
tshark -r capture.pcap -Y "ip.addr == 10.10.10.5"
tshark -r capture.pcap -Y "http.request.method == POST"

# Capture filter (BPF syntax -- applied before capture)
tshark -i eth0 -f "port 80"
tshark -i eth0 -f "host 10.10.10.5"
```

## Extract Specific Fields

```bash
# Show only src/dst IP and protocol
tshark -r capture.pcap -T fields -e ip.src -e ip.dst -e _ws.col.Protocol

# Extract HTTP requests
tshark -r capture.pcap -Y "http.request" -T fields -e http.host -e http.request.uri

# Extract credentials from HTTP POST
tshark -r capture.pcap -Y "http.request.method == POST" -T fields -e http.file_data

# Follow TCP stream (export as text)
tshark -r capture.pcap -z follow,tcp,ascii,0
```

## HTB Tips

```bash
# Find credentials in cleartext protocols
tshark -r capture.pcap -Y "ftp || telnet || http" -T fields -e frame.time -e ip.src -e ip.dst

# Extract all files from HTTP traffic
tshark -r capture.pcap --export-objects http,./extracted/

# Analyze DNS queries (find exfil or C2)
tshark -r capture.pcap -Y "dns" -T fields -e dns.qry.name

# Find NTLM hashes (SMB captures)
tshark -r capture.pcap -Y "ntlmssp" -T fields -e ntlmssp.auth.username -e ntlmssp.auth.domain

# Statistics -- what protocols are in this pcap?
tshark -r capture.pcap -q -z io,phs
```

## Key Options

| Option | Description |
|--------|-------------|
| `-i <iface>` | Interface to capture on |
| `-r <file>` | Read from pcap file |
| `-w <file>` | Write capture to file |
| `-Y <filter>` | Display filter |
| `-f <filter>` | Capture filter (BPF) |
| `-T fields` | Output specific fields |
| `-e <field>` | Field to extract (use with `-T fields`) |
| `-c <n>` | Stop after n packets |
| `-q` | Quiet mode (suppress packet output) |
| `-z <stat>` | Statistics module |
