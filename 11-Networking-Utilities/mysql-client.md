# mysql-client

> Connect to MySQL databases from the command line when you find port 3306 open.

## What It Does

MySQL client lets you connect to MySQL/MariaDB databases and run SQL queries directly. On HTB you'll find port 3306 open pretty often, and if you have creds (or the DB allows passwordless login), you can dump usernames, passwords, and sometimes even read files off the server.

## Install

```bash
sudo apt install mysql-client
# or on some systems:
sudo apt install default-mysql-client
```

## Basic Usage

### Connect to a database
```bash
# With credentials
mysql -h 10.10.10.x -u root -p

# If no password is set (yes this happens)
mysql -h 10.10.10.x -u root

# Specify a database
mysql -h 10.10.10.x -u admin -p'password123' -D webapp
```

### Useful commands once connected
```sql
-- List all databases
SHOW DATABASES;

-- Switch to a database
USE webapp;

-- List tables
SHOW TABLES;

-- Dump everything from a table
SELECT * FROM users;

-- Find password columns
SELECT username, password FROM users;
```

### Read files from the server (if you have FILE privilege)
```sql
SELECT LOAD_FILE('/etc/passwd');
SELECT LOAD_FILE('/var/www/html/config.php');
```

### One-liner to dump a table without interactive mode
```bash
mysql -h 10.10.10.x -u root -p'pass' -D webapp -e "SELECT * FROM users;"
```

## HTB Tips

- Always try `root` with no password first, you'd be surprised how often it works
- Check for `FILE` privilege with `SHOW GRANTS;`, if you have it you can read files off the disk
- Look for config files with database creds in `/var/www/html/` or similar web roots
- MySQL hashes look like `*2470C0C06DEE42FD1618BB99005ADCA2EC9D1E19`, crack them with hashcat mode 300
- If you can write files, you might be able to drop a webshell with `SELECT ... INTO OUTFILE`
