# pdf-parser

> Dig into a PDF's guts -- extract JavaScript, embedded files, and hidden content that pdfid flagged as suspicious.

## What It Does

While `pdfid` tells you "this PDF has JavaScript in it," `pdf-parser` lets you actually pull out that JavaScript and read it. PDFs are made up of numbered objects, and pdf-parser lets you list them, search through them, and extract their content. It's your go-to tool for malware analysis on PDFs and for forensics challenges where flags are hidden inside PDF objects, streams, or embedded files.

## Install

```bash
sudo apt install python3-pdfparser
# or
pip install pdf-parser
```

## Examples

```bash
# List all objects in the PDF -- get the lay of the land
pdf-parser suspicious.pdf

# Search for objects containing JavaScript
pdf-parser --search javascript suspicious.pdf

# Search for any keyword (case insensitive)
pdf-parser --search OpenAction suspicious.pdf

# Look at a specific object by its ID number
# (you get the ID from the search results above)
pdf-parser --object 12 suspicious.pdf

# Extract and decompress a stream (this is where the actual content lives)
pdf-parser --object 12 --filter --raw suspicious.pdf

# Dump the raw stream content to a file for further analysis
pdf-parser --object 12 --filter --raw --dump stream_content.bin suspicious.pdf

# Show only objects of a specific type
pdf-parser --type /JS suspicious.pdf
pdf-parser --type /EmbeddedFile suspicious.pdf
```

## Typical Workflow

1. **Start with pdfid** to see what's suspicious
   ```bash
   pdfid suspicious.pdf
   # Output shows: /JS 2, /OpenAction 1
   ```

2. **Search for the suspicious objects**
   ```bash
   pdf-parser --search javascript suspicious.pdf
   # Shows object 12 contains JavaScript
   ```

3. **Extract the content**
   ```bash
   pdf-parser --object 12 --filter --raw suspicious.pdf
   # Now you can read the actual JavaScript code
   ```

4. **Dump embedded files**
   ```bash
   pdf-parser --search EmbeddedFile suspicious.pdf
   # Find the object ID, then extract it
   pdf-parser --object 15 --filter --raw --dump extracted_file.exe suspicious.pdf
   ```

## Key Flags

```
--search <term>     Find objects containing this text
--object <id>       Look at a specific object by number
--filter            Decompress/decode the stream content
--raw               Show raw content (not escaped)
--dump <file>       Save extracted content to a file
--type <type>       Filter by object type (/JS, /EmbeddedFile, etc.)
--stats             Show PDF statistics
```

## HTB Tips

- **Always pair with pdfid.** Use pdfid for the quick overview, then pdf-parser to extract what pdfid found.
- The `--filter --raw` combo is essential. PDF streams are usually compressed -- without these flags you just see garbled bytes.
- In forensics challenges, flags can be hidden in JavaScript objects, embedded files, or even in the metadata of individual PDF objects.
- If you find obfuscated JavaScript, copy it out and deobfuscate it separately (CyberChef is great for this).
- Embedded files extracted with `--dump` might be executables, scripts, or even other documents with more clues inside.
- Some challenges encode data in the raw stream bytes -- if `--filter` gives you garbage, try without it and look for patterns in the raw data.
