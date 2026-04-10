# Holehe -- Check if an Email is Registered on 100+ Sites

## What It Does
Holehe takes an email address and checks if it is used to register accounts on over 100 popular websites (Twitter, Instagram, Spotify, Adobe, etc.). It does this by abusing password reset and login forms -- no passwords needed, just the email. Great for mapping out what services a target uses.

## Install
```bash
pip3 install holehe
```

## Basic Usage

### Check a single email
```bash
holehe target@example.com                # Check all 100+ sites
```

### Only show sites where the email IS registered
```bash
holehe target@example.com --only-used    # Skip "not found" results
```

### Save output to a file
```bash
holehe target@example.com -o results.csv # Export as CSV
```

## Reading the Output
Holehe uses simple indicators:
```
[+]  Email is registered on this site
[-]  Email is NOT registered
[x]  Check failed (site might be blocking or down)
```

## Practical OSINT Workflow
```bash
# Step 1: You found an email from theHarvester or a data breach
holehe john.smith@company.com --only-used

# Step 2: The output might show:
#   [+] twitter.com
#   [+] instagram.com
#   [+] spotify.com
#   [+] adobe.com

# Step 3: Now you know which platforms to investigate further
#   - Check their Twitter/Instagram for public posts
#   - Spotify might reveal real name or playlists
#   - Adobe account confirms they use creative tools

# Step 4: Feed the username you find into Sherlock
sherlock john_smith --print-found
```

## Key Flags
```
--only-used      Only show sites where the email is registered
-o FILE          Save results to CSV file
--no-color       Plain text output (useful for piping)
```

## HTB / OSINT Tips
- This is usually one of the first tools to run after finding an email address
- The password reset trick means you are NOT logging in -- just checking registration
- Cross-reference results: if they have Twitter, go find their username for Sherlock
- Works with any email provider, not just Gmail
- Some sites rate-limit, so a few checks might fail -- just re-run if needed
- Pair with GHunt if the email is a Gmail address for even deeper Google OSINT
- On HTB challenges, emails from theHarvester go straight into holehe
