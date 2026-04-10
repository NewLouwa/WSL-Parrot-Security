# Photon -- Fast Web Crawler for OSINT

## What It Does
Photon crawls a website and automatically extracts everything useful: URLs, email addresses, social media links, JavaScript files, form parameters, and downloadable files. Think of it as a smart spider that maps out a website and pulls out all the interesting bits for you. Way faster than clicking through a site manually.

## Install
```bash
# Installed via git clone to /opt/htb-toolkit/photon
# If not installed, clone it manually:
git clone https://github.com/s0md3v/Photon.git
cd Photon && pip3 install -r requirements.txt
```

## Basic Usage

### Crawl a website
```bash
photon -u https://target.com             # Crawl and extract everything
```

### Crawl deeper (more levels)
```bash
photon -u https://target.com -l 3        # Follow links 3 levels deep
```

### Speed it up with threads
```bash
photon -u https://target.com -t 10       # Use 10 threads (faster)
```

### Save results to a specific folder
```bash
photon -u https://target.com -o ./target_results
```

## What Photon Extracts
After a crawl, check the output folder -- Photon organizes findings into files:
```
target_results/
  internal.txt    -- All internal URLs found
  external.txt    -- Links pointing to other domains
  scripts.txt     -- JavaScript files (review for secrets/API keys)
  fuzzable.txt    -- URLs with parameters (great for fuzzing later)
  emails.txt      -- Email addresses found on the site
```

## Practical OSINT Workflow
```bash
# Step 1: Crawl the target website
photon -u https://target.com -l 3 -t 10 -o ./recon/target

# Step 2: Check for emails (feed into holehe/GHunt)
cat ./recon/target/emails.txt

# Step 3: Look at JS files for leaked API keys
cat ./recon/target/scripts.txt

# Step 4: Grab fuzzable URLs for web app testing later
cat ./recon/target/fuzzable.txt
```

## Key Flags
```
-u URL           Target URL to crawl
-l LEVEL         Depth of crawling (default: 2)
-t THREADS       Number of threads (default: 2)
-o DIR           Output directory
--keys           Extract API keys from JavaScript files
--dns            Enumerate subdomains via crawled links
```

## HTB / OSINT Tips
- Run Photon early in recon -- it finds emails, subdomains, and attack surface fast
- The `fuzzable.txt` output is gold for web testing -- URLs with parameters to test
- Use `--keys` to automatically search for API keys in JS files
- Combine with theHarvester: Photon finds emails on the site, theHarvester finds them elsewhere
- Keep the thread count reasonable (5-10) to avoid getting blocked
