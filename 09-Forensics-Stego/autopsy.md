# Autopsy - Digital Forensics Made Visual

GUI-based forensics platform that lets you explore disk images and memory dumps like a file explorer.

## What It Does

Autopsy is a graphical front-end for The Sleuth Kit and other forensics tools. Instead of running a dozen command-line tools to analyze a disk image, you load it into Autopsy and get a nice GUI to browse files, recover deleted data, search keywords, and view timelines. It is the go-to tool for CTF forensics challenges where you get a `.dd`, `.E01`, or `.raw` image file.

## Install

```bash
# Autopsy is usually pre-installed on Parrot/Kali
sudo apt install autopsy

# Launch it (opens a web-based GUI)
autopsy
```

Then open your browser to `http://localhost:9999/autopsy`.

> On Windows, you can grab the standalone installer from https://www.autopsy.com/download/

## Basic Workflow

```bash
# 1. Start autopsy
autopsy

# 2. Open browser to http://localhost:9999/autopsy
# 3. Create a new case (give it a name, fill investigator info)
# 4. Add a "host" (the machine the image came from)
# 5. Add your image file (.dd, .E01, .raw, etc.)
# 6. Browse away - files, deleted files, metadata, timelines
```

## Practical Examples

```bash
# Analyze a CTF disk image
# 1. Start autopsy, create case "CTF-Forensics"
# 2. Add the image file challenge.dd
# 3. Check "Deleted Files" section for hidden flags
# 4. Use keyword search to look for "flag{" or "HTB{"

# Recover deleted files from an image
# Browse to the directory, deleted files show up with a red X
# Right-click > Export to save them to your machine

# Check file metadata and timestamps
# Click any file to see MAC times (Modified, Accessed, Created)
# Useful for building a timeline of what happened
```

## HTB Tips

- When you get a forensics challenge with a disk image, Autopsy is your first stop
- Always check the "Deleted Files" view, flags are often hidden there
- Use the keyword search for strings like `flag`, `password`, `secret`, `HTB`
- Look at browser history and recent documents for clues
- The timeline feature helps you figure out what happened and when
- For memory dumps (.raw), consider using Volatility instead, Autopsy is better for disk images
- If the GUI feels heavy, you can use `fls` and `icat` from The Sleuth Kit directly
