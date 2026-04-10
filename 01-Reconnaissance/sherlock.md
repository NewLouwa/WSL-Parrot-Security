# Sherlock -- Find Usernames Across 400+ Social Networks

## What It Does
Give Sherlock a username and it checks over 400 websites to see if that username exists. Perfect for OSINT -- if you find a target's username on one platform, Sherlock quickly maps out where else they have accounts. Think of it as a "username search engine" across the entire internet.

## Install
```bash
pip3 install sherlock-project
```

## Basic Usage

### Search for a single username
```bash
sherlock john_doe_1337                   # Check "john_doe_1337" on all 400+ sites
```

### Search for multiple usernames at once
```bash
sherlock john_doe alex.smith h4cker99    # Check three users in one shot
```

### Save results to a file
```bash
sherlock john_doe -o john_results.txt    # Save found accounts to a file
```

### Only show accounts that exist (cleaner output)
```bash
sherlock john_doe --print-found          # Skip the "Not Found" noise
```

### Use Tor for anonymity
```bash
sherlock john_doe --tor                  # Route through Tor (slower but anonymous)
```

## Practical OSINT Workflow
```bash
# Step 1: You found username "c0ldfire" on a forum
sherlock c0ldfire --print-found -o c0ldfire_accounts.txt

# Step 2: Check variations people commonly use
sherlock c0ldfire coldfire c0ld_fire cold-fire --print-found

# Step 3: Browse the results -- look for bios, photos, linked accounts
cat c0ldfire_accounts.txt
```

## Key Flags
```
-o FILE          Save results to a file
--print-found    Only display found accounts (less noise)
--tor            Route traffic through Tor
--timeout SEC    Set timeout per request (default: 60)
--csv            Output as CSV for spreadsheets
--site SITE      Only check a specific site (e.g. --site github)
```

## HTB / OSINT Tips
- Start with usernames from email addresses (the part before @)
- People reuse usernames everywhere -- one hit can snowball into a full profile
- Cross-reference found accounts with other tools like holehe and GHunt
- On HTB OSINT challenges, check if the target reuses their handle across platforms
- Combine with theHarvester: find emails first, extract usernames, then run Sherlock
- Be patient -- scanning 400+ sites takes a few minutes
