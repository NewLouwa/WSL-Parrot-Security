# GHunt -- Google Account OSINT

## What It Does
GHunt takes a Google email address and pulls out as much public information as possible from the linked Google account. This includes profile photos, Google Maps reviews, YouTube channels, calendar events, and more. If your target uses Gmail, GHunt can reveal a surprising amount about them.

## Install
```bash
pip3 install ghunt

# First-time setup: authenticate with a Google cookie
ghunt login
```
The login step walks you through grabbing a browser cookie. You only need to do this once.

## Basic Usage

### Investigate a Gmail address
```bash
ghunt email target@gmail.com             # Pull all public info for this account
```

### Investigate a Google Doc or Drive link
```bash
ghunt doc "https://docs.google.com/document/d/1a2b3c..."   # Find the doc owner
```

### Investigate a YouTube channel
```bash
ghunt youtube "https://youtube.com/channel/UC..."           # OSINT on channel owner
```

### Investigate a Google Maps contributor
```bash
ghunt gaia 12345678901234567890          # Look up a Gaia ID (Google internal ID)
```

## What GHunt Can Find
- Profile name and photo
- Google Maps reviews and photos (reveals places they visit)
- YouTube channels and activity
- Google Calendar events (if public)
- Connected services and linked accounts
- Account creation approximate date
- Gaia ID (unique Google identifier)

## Practical OSINT Workflow
```bash
# Step 1: You found target's Gmail from theHarvester or holehe
ghunt email suspect@gmail.com

# Step 2: If they have Google Maps reviews, you might find:
#   - Their neighborhood (frequent restaurant reviews)
#   - Workplace (office reviews)
#   - Travel history

# Step 3: Check any Google Docs they shared publicly
ghunt doc "https://docs.google.com/spreadsheets/d/..."
```

## HTB / OSINT Tips
- Gmail addresses are goldmines -- always run GHunt when you find one
- Google Maps reviews often leak real-world locations (home area, workplace)
- Public Google Calendar events can reveal meetings, schedules, contacts
- Combine with holehe to confirm the email is Gmail, then deep-dive with GHunt
- The Gaia ID is persistent -- even if they change their display name you can track them
- Works best against targets who actively use Google services (reviews, photos, YouTube)
