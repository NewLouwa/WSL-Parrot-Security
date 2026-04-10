# TestDisk / PhotoRec

> Recover deleted files and lost partitions from disk images -- essential for forensics challenges.

## What It Does

TestDisk and PhotoRec are two tools that come in the same package. **TestDisk** fixes broken partition tables and recovers lost partitions -- if someone deleted a partition to hide data, this brings it back. **PhotoRec** digs through raw disk data and recovers individual files, even from damaged or formatted drives. It doesn't care about the filesystem -- it looks for file signatures (headers) directly in the raw bytes. In CTF/HTB forensics challenges, you'll usually get a disk image (.dd, .img, .raw) and need to pull deleted files out of it.

## Install

```bash
sudo apt install testdisk
```

## TestDisk Step-by-Step

```bash
# Open a disk image for analysis
testdisk disk_image.dd
```

Then follow the interactive menu:

1. **Create** a new log file (or append to existing)
2. **Select the disk image** from the list
3. **Choose partition type** -- usually "Intel" for MBR or "EFI GPT" for newer disks
4. **Analyse** -- let it scan for partitions
5. **Quick Search** -- finds recently deleted partitions fast
6. If Quick Search misses something, try **Deeper Search**
7. Once you see partitions, press **P** to list files inside them
8. **Copy files** you want to recover (press C to copy)

## PhotoRec Step-by-Step

```bash
# Recover files from a disk image
photorec disk_image.dd
```

1. Select the disk image
2. Choose the partition (or "Whole disk" to scan everything)
3. Pick filesystem type -- "ext2/ext3/ext4" for Linux, "Other" for FAT/NTFS
4. Choose where to save recovered files (pick an empty directory)
5. Wait -- it will dump recovered files into `recup_dir.1/`, `recup_dir.2/`, etc.

```bash
# Tip: create an output directory first so recovered files don't clutter your workspace
mkdir recovered
cd recovered
photorec /path/to/disk_image.dd
```

## HTB Tips

- **Forensics challenges love deleted files.** If you get a disk image and can't find the flag with normal mounting, run PhotoRec on it.
- Try mounting the image first (`mount -o loop,ro image.dd /mnt/evidence`) to look around, then use TestDisk/PhotoRec for anything that's been deleted.
- PhotoRec recovers files with generic names (f000001.txt, f000002.jpg). You'll need to sift through them -- `grep -r "HTB{" recovered/` is your friend.
- If `foremost` isn't finding what you need, PhotoRec often catches more file types.
- Works on `.dd`, `.img`, `.raw`, `.E01` (EnCase) images, and even directly on USB drives.
- For CTF challenges where you get a corrupted disk image, TestDisk's partition recovery is usually the intended path.
