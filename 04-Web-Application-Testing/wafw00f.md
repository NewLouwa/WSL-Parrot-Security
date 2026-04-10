# wafw00f

> Quickly figure out if a website has a firewall blocking your attacks -- and which one it is.

## What It Does

A WAF (Web Application Firewall) sits between you and the web app, filtering out anything that looks like an attack. If your SQL injection or XSS payloads keep getting blocked and you can't figure out why, there might be a WAF in the way. `wafw00f` sends some test requests and analyzes the responses to detect whether a WAF is present and which product it is. Once you know what you're dealing with, you can look up specific bypass techniques for that WAF.

## Install

```bash
sudo apt install wafw00f
```

## Examples

```bash
# Basic WAF detection -- is there a firewall?
wafw00f http://target.htb

# Verbose mode -- shows what tests it's running
wafw00f -v http://target.htb

# Test ALL WAF signatures, not just stop at first match
# Useful when multiple WAFs are stacked
wafw00f -a http://target.htb

# See every WAF it can detect (just for reference)
wafw00f -l

# Route through Burp to see the requests it makes
wafw00f -p http://127.0.0.1:8080 http://target.htb

# Save results to a file
wafw00f -o results.json -f json http://target.htb
```

## Reading the Output

wafw00f will tell you one of three things:

1. **WAF detected: [Product Name]** -- Now you know what you're bypassing. Google "[WAF name] bypass" for techniques.
2. **Generic WAF detected** -- Something is filtering requests, but wafw00f can't tell exactly what.
3. **No WAF detected** -- You're clear to send payloads directly.

## HTB Tips

- **Run this early in web enumeration.** Before you spend an hour wondering why your SQLi payloads aren't working, check if there's a WAF eating them.
- On HTB, WAFs are less common than in real life, but some boxes do use them as part of the challenge.
- If a WAF is detected, look into SQLMap tamper scripts (`--tamper`) designed for that specific WAF.
- A WAF doesn't mean the app isn't vulnerable -- it just means you need to be smarter with your payloads. Try encoding, case changes, or alternative syntax.
- No WAF detected? Great, go wild with your payloads. One less thing to worry about.
