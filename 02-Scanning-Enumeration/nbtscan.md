# nbtscan

> Quick and dirty way to find Windows machines on a network and grab their hostnames.

## What It Does

NetBIOS is an old Windows protocol that lets machines announce themselves on a network. Think of it like a name tag -- each Windows box broadcasts its hostname, what domain or workgroup it belongs to, and sometimes who's logged in. `nbtscan` sweeps a network range and collects all those name tags. It's fast, noisy, and gives you a quick picture of what Windows machines are out there.

## Install

```bash
sudo apt install nbtscan
```

## Examples

```bash
# Scan a single host -- see its hostname and domain
nbtscan 10.10.10.5

# Sweep an entire subnet -- find all Windows boxes at once
nbtscan 10.10.10.0/24

# Human-readable output -- easier to read than the default format
nbtscan -h 10.10.10.0/24

# Verbose mode -- shows NetBIOS service types (useful for identifying DCs)
nbtscan -v 10.10.10.5

# Use local port 137 -- sometimes needed to get responses
nbtscan -r 10.10.10.0/24

# Faster scan with shorter timeout (default is 1000ms)
nbtscan -t 500 10.10.10.0/24
```

## What the Output Means

When you scan a host, you'll see something like:

```
10.10.10.5  MEGACORP\DC01        SHARING  DC
```

- **IP address** -- the machine
- **MEGACORP** -- the domain or workgroup name
- **DC01** -- the hostname
- **SHARING** -- file sharing is enabled
- **DC** -- this machine is a Domain Controller

## HTB Tips

- Use this early in enumeration when you hit a Windows network. It's faster than a full nmap scan for just finding hostnames.
- The domain/workgroup name it returns is useful for building your attack -- you'll need it for tools like `crackmapexec`, `smbclient`, and `ldapsearch`.
- If you see a machine flagged as a DC (Domain Controller), that's your primary target for AD attacks.
- Pairs well with `enum4linux` -- nbtscan finds the machines, enum4linux digs deeper into each one.
- Not every box responds to NetBIOS queries (it can be disabled), so don't rely on it alone.
