# pdfid

> Quickly scan a PDF to see if it's hiding something nasty -- JavaScript, embedded files, auto-open actions, and more.

## What It Does

PDFs aren't just static documents -- they can contain JavaScript, embedded executables, auto-run actions, and other sketchy stuff. `pdfid` scans a PDF and counts how many of these potentially dangerous elements it contains. It doesn't analyze them deeply (that's what `pdf-parser` is for), but it gives you a fast "is this PDF suspicious?" answer. Think of it as triage: pdfid tells you IF something is there, then you use pdf-parser to dig into WHAT it is.

## Install

```bash
sudo apt install python3-pdfid
# or
pip install pdfid
```

## Examples

```bash
# Scan a single PDF -- see what's inside
pdfid suspicious.pdf

# Scan all PDFs in a directory
pdfid *.pdf

# Extra analysis (tries to decode some obfuscation)
pdfid -e suspicious.pdf

# Output in JSON format for scripting
pdfid -j suspicious.pdf
```

## Reading the Output

pdfid outputs a list of keywords and how many times each appears. Here's what to watch for:

| Keyword | What it means | Suspicious? |
|---|---|---|
| `/JS` or `/JavaScript` | Contains JavaScript code | Yes -- PDF malware often uses JS |
| `/OpenAction` or `/AA` | Does something when opened | Yes -- auto-run is a red flag |
| `/EmbeddedFile` | Has files embedded inside it | Maybe -- could hide executables |
| `/Launch` | Can launch external programs | Yes -- big red flag |
| `/URI` | Contains URLs | Depends -- could be phishing links |
| `/AcroForm` | Has a form | Low risk, but can be used for phishing |
| `/ObjStm` | Object streams (can hide content) | Worth investigating |
| `/Encrypt` | PDF is encrypted | Makes analysis harder |

**Rule of thumb:** If you see `/JS`, `/JavaScript`, `/OpenAction`, or `/Launch` with a count > 0, that PDF deserves a closer look with `pdf-parser`.

## HTB Tips

- **Forensics challenges love malicious PDFs.** If you get a suspicious PDF file, pdfid is your first stop before opening it.
- Never open a suspicious PDF in a normal reader -- use pdfid and pdf-parser to analyze it safely from the command line.
- A count of 0 for all suspicious keywords doesn't mean it's safe, but a count > 0 for `/JS` + `/OpenAction` is almost always malicious.
- After pdfid flags something, use `pdf-parser` to extract and read the actual JavaScript or embedded content.
- In CTF challenges, the flag is sometimes hidden in embedded JavaScript, encoded in object streams, or tucked inside embedded files.
