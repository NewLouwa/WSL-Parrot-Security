# Burp Suite

## Purpose
The industry-standard GUI web application security testing platform. Intercepts, modifies, and replays HTTP/HTTPS requests. Includes scanner, repeater, intruder, and more.

## Installation
```bash
# Via Parrot repos (if available)
sudo apt install burpsuite

# Or download Community Edition from:
# https://portswigger.net/burp/communitydownload
# java -jar burpsuite_community.jar
```

## Quick Start
```bash
# Launch
burpsuite
```

### Browser Proxy Setup
1. Set browser proxy to `127.0.0.1:8080`
2. Visit `http://burp` to download CA certificate
3. Import CA cert into browser trust store
4. FoxyProxy extension recommended for easy toggling

## Key Modules
| Module | Purpose |
|--------|---------|
| **Proxy** | Intercept and modify requests in real-time |
| **Repeater** | Manually modify and resend requests |
| **Intruder** | Automated payload fuzzing (rate-limited in Community) |
| **Decoder** | Encode/decode data (Base64, URL, hex, etc.) |
| **Comparer** | Diff two responses |
| **Sequencer** | Analyze token randomness |

## Common Workflow
1. Configure proxy, browse target normally
2. Review HTTP history in Proxy tab
3. Send interesting requests to Repeater for manual testing
4. Use Intruder for brute-force / fuzzing
5. Check Decoder for encoded parameters

## HTB Usage
- Essential for every web challenge
- Intercept login forms, API calls, file uploads
- Use Repeater to test SQLi, XSS, SSRF payloads manually
- Intruder for brute-forcing with custom wordlists
- Works via WSLg or by running in Windows and proxying WSL traffic
