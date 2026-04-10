# ldapsearch

> Your way into Active Directory's phonebook -- pull users, groups, computers, and juicy domain info straight from LDAP.

## What It Does

LDAP is basically the database behind Active Directory. Every user, computer, group, and policy is stored there. `ldapsearch` lets you query that database directly. If a box has port 389 open (LDAP) or 636 (LDAPS), this is one of the first tools you reach for. You can often pull a full list of domain users, find who's a Domain Admin, and even discover service accounts ripe for Kerberoasting -- sometimes without any credentials at all.

## Install

```bash
sudo apt install ldap-utils
```

## Examples

```bash
# Step 1: Figure out the domain name (base DN) -- always do this first
# This tells you the "root" of the directory, like DC=megacorp,DC=htb
ldapsearch -x -H ldap://10.10.10.5 -s base namingcontexts

# Step 2: Try an anonymous dump -- no creds needed, sometimes it just works
ldapsearch -x -H ldap://10.10.10.5 -b "DC=megacorp,DC=htb"

# Step 3 (if you have creds): Authenticated search -- way more results
ldapsearch -x -H ldap://10.10.10.5 -D "CN=svc-web,DC=megacorp,DC=htb" -w 'P@ssw0rd' -b "DC=megacorp,DC=htb"

# Pull all usernames -- great for building a user list to spray
ldapsearch -x -H ldap://10.10.10.5 -b "DC=megacorp,DC=htb" "(objectClass=user)" sAMAccountName

# Find Domain Admins -- your high-value targets
ldapsearch -x -H ldap://10.10.10.5 -b "DC=megacorp,DC=htb" \
  "(memberOf=CN=Domain Admins,CN=Users,DC=megacorp,DC=htb)"

# Hunt for service accounts with SPNs -- Kerberoasting candidates
ldapsearch -x -H ldap://10.10.10.5 -b "DC=megacorp,DC=htb" \
  "(servicePrincipalName=*)" sAMAccountName servicePrincipalName

# List all computers in the domain
ldapsearch -x -H ldap://10.10.10.5 -b "DC=megacorp,DC=htb" "(objectClass=computer)" name
```

## Key Flags Cheat Sheet

```
-x          Simple auth (use this almost always)
-H          Server URL, like ldap://10.10.10.5
-b          Search base -- the "DC=...,DC=..." you found in step 1
-D          Your username for authenticated queries (full DN format)
-w          Password (use -W to get prompted instead)
-s          Scope: "base" (just root), "one" (one level), "sub" (everything)
```

## HTB Tips

- **Always try anonymous bind first.** A surprising number of boxes allow it. If you get results with no creds, you just saved yourself a lot of work.
- Run the `namingcontexts` query before anything else -- you need the base DN for every other query.
- If you find users, pipe them into a password spray with `crackmapexec` or `kerbrute`.
- Accounts with `servicePrincipalName` set are Kerberoastable -- that's often the path to Domain Admin.
- On AD boxes, this is as important as nmap. Port 389 open = start here.
