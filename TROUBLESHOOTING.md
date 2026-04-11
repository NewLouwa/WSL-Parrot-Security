# Troubleshooting — Tools That Don't Auto-Install

Some tools can't be installed with a single `apt install` or `pip install`.
Either the packaging is weird, the GitHub API gets rate-limited during a long install session,
or the tool just has too many moving parts to automate cleanly.

Install them when you actually need them. They're not going anywhere.

---

## spiderfoot

**What it does:** OSINT framework. Aggregates data from 200+ sources — emails, IPs, domains, usernames. Good for passive recon.

**Why it fails:** No PyPI package. `pip install spiderfoot` doesn't exist.

**Fix:**
```bash
git clone https://github.com/smicallef/spiderfoot.git /opt/htb-toolkit/spiderfoot
pip3 install -r /opt/htb-toolkit/spiderfoot/requirements.txt --break-system-packages
ln -sf /opt/htb-toolkit/spiderfoot/sf.py /usr/local/bin/spiderfoot
```

Then run: `spiderfoot -l 127.0.0.1:5001` and open your browser.

---

## rustscan

**What it does:** Fast port scanner. Finds open ports in seconds, then hands them to nmap for service detection.

**Why it fails:** GitHub API rate-limiting during a long install session. With 10+ curl/wget calls to GitHub, the 60 req/hour unauthenticated limit kicks in.

**Fix (easiest):**
```bash
cargo install rustscan
```
If cargo isn't installed: `apt install cargo` first (takes a few minutes to compile).

**Or grab the .deb manually:**
Go to https://github.com/RustScan/RustScan/releases/latest, download the `amd64.deb`, then:
```bash
dpkg -i rustscan*.deb
```

**Usage:** `rustscan -a 10.10.10.x -- -sV`

---

## netexec

**What it does:** CrackMapExec successor. Swiss army knife for Active Directory — SMB, WinRM, LDAP, MSSQL, RDP enumeration and exploitation.

**Why it fails:** pip package has dependency conflicts. Needs isolation.

**Fix:**
```bash
apt install netexec
```
It's in Debian repos. If that doesn't work:
```bash
apt install pipx
pipx install git+https://github.com/Pennyw0rth/NetExec
```

**Usage:** `netexec smb 10.10.10.x -u user -p pass`

---

## pwncat-cs

**What it does:** Reverse shell handler on steroids. Auto-upgrades shells, handles file transfers, has a built-in exploit suggester.

**Why it fails:** C extensions need build tools. Sometimes conflicts with system Python packages.

**Fix:**
```bash
pip3 install pwncat-cs --break-system-packages --no-build-isolation
```
If that still fails, use a venv:
```bash
python3 -m venv /opt/pwncat-env
/opt/pwncat-env/bin/pip install pwncat-cs
ln -sf /opt/pwncat-env/bin/pwncat-cs /usr/local/bin/pwncat-cs
```

**Usage:** `pwncat-cs -l -p 4444`

---

## certipy-ad

**What it does:** Active Directory Certificate Services exploitation. Finds and abuses misconfigured certificate templates (ESC1-ESC13).

**Why it fails:** Build deps. Usually fixes itself with `--no-build-isolation`.

**Fix:**
```bash
pip3 install certipy-ad --break-system-packages --no-build-isolation
```
Or from source:
```bash
pip3 install "git+https://github.com/ly4k/Certipy" --break-system-packages
```

**Usage:** `certipy find -u user@domain -p pass -dc-ip 10.10.10.x`

---

## stegoveritas

**What it does:** Steganography analysis tool. Runs a bunch of checks on images automatically — LSB, metadata, color planes, etc.

**Why it fails:** Needs `libmagic1` installed first. The installer now does this but older runs didn't.

**Fix:**
```bash
apt install libmagic1 python3-magic
pip3 install stegoveritas --break-system-packages
stegoveritas_install_deps
```

The last command downloads extra tools (zsteg, outguess, etc.) — don't skip it.

**Usage:** `stegoveritas image.png`

---

## General tips when pip fails

```bash
# Try with no build isolation (fixes most C extension issues)
pip3 install <package> --break-system-packages --no-build-isolation

# Try ignoring conflicting versions
pip3 install <package> --break-system-packages --ignore-installed

# Isolate in a venv (always works, slightly more annoying)
python3 -m venv /opt/<tool>-env
/opt/<tool>-env/bin/pip install <package>
ln -sf /opt/<tool>-env/bin/<tool> /usr/local/bin/<tool>
```

If GitHub API calls fail during install (rustscan, stegseek, ligolo), wait an hour and re-run just that tool manually. Unauthenticated GitHub API = 60 requests/hour, and a full install session burns through them fast.
