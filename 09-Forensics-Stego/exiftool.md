# ExifTool

## Purpose
Read, write, and edit metadata in files (EXIF, IPTC, XMP, GPS, etc.). Supports virtually every image, audio, video, and document format.

## Installation
```bash
sudo apt install exiftool
```

## Quick Start
```bash
# View all metadata
exiftool image.jpg

# View specific tag
exiftool -GPSPosition image.jpg

# View all files in directory
exiftool *.jpg

# Remove all metadata
exiftool -all= image.jpg

# Extract thumbnail
exiftool -b -ThumbnailImage image.jpg > thumb.jpg
```

## Key Options
| Option | Description |
|--------|-------------|
| `-all=` | Remove all metadata |
| `-b` | Binary output |
| `-r` | Recursive |
| `-json` | JSON output |
| `-csv` | CSV output |
| `-Comment` | View/set comment field |

## HTB Usage
- Check images for hidden data in metadata fields
- Find GPS coordinates, author names, software versions
- Comments field often contains flags or hints
- Check PDF metadata for author/creator info
- Run on every file in forensic/stego challenges
