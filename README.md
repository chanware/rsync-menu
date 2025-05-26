# rsync Menu - User-Friendly Sync Utility for macOS

A simple shell script that transforms rsync's overwhelming output into a clean, menu-driven interface for backing up specific folders to external drives.

## Features

- **Clean Progress Display**: No more walls of scrolling filenames - see actual transfer progress
- **Menu-Driven Interface**: Select folders with numbered options instead of typing commands
- **Flexible Sync Options**: Choose between true mirror sync or copy-only mode
- **Safe Interruption**: Press Ctrl+C anytime to safely stop operations without corruption
- **Custom Folder Support**: Add your own directories or sync any folder on-demand
- **Batch Operations**: Sync all configured folders with one command

## Why Use This?

rsync is powerful but intimidating. When syncing large folders, you get flooded with hundreds of filenames, making it hard to track progress or safely interrupt operations. This script provides:

- Visual progress instead of file spam: `1,205,123  45%  123.45kB/s    0:01:23`
- Easy folder selection through numbered menus
- Clear sync vs copy-only options
- Safe interrupt handling with user-friendly messages

## Installation

### Step 1: Download the Script

```bash
# Create scripts directory
mkdir -p ~/Scripts

# Download the script
curl -o ~/Scripts/sync_menu.sh https://raw.githubusercontent.com/yourusername/rsync-menu/main/sync_menu.sh

# Make it executable
chmod +x ~/Scripts/sync_menu.sh
```

### Step 2: Create an Alias

**For zsh (macOS default):**
```bash
echo "alias syncmenu='~/Scripts/sync_menu.sh'" >> ~/.zshrc
source ~/.zshrc
```

**For bash:**
```bash
echo "alias syncmenu='~/Scripts/sync_menu.sh'" >> ~/.bash_profile
source ~/.bash_profile
```

### Step 3: Customize the Script

Edit `~/Scripts/sync_menu.sh` and modify these settings:

1. **Set your external drive name:**
   ```bash
   EXTERNAL_DRIVE_NAME="YOUR_DRIVE_NAME"  # e.g., "backup-ssd" or "My Backup Drive"
   ```

2. **Add your custom folders** (options 5 & 6):
   ```bash
   5) do_sync "$HOME/Projects/" "$DRIVE_PATH/Projects/" "Projects" ;;
   6) do_sync "$HOME/Code/" "$DRIVE_PATH/Code/" "Code" ;;
   ```

3. **Update the "sync all" section** to include your custom folders.

## Usage

### Basic Operation

Run the script:
```bash
syncmenu
```

You'll see a menu like this:
```
=== File Sync Menu ===
(Press Ctrl+C anytime to safely stop sync operations)
1) Desktop
2) Documents
3) Downloads
4) Pictures
5) Custom Folder 1
6) Custom Folder 2
7) Custom folder (enter path)
8) Sync all configured folders
9) Exit
```

### Sync Types

When you select a folder, choose the sync operation:

- **True Sync (Mirror)**: Creates exact copy - adds, updates, AND deletes files not in source
- **Copy/Update Only**: Adds and updates files, but never deletes anything

### Progress Display

Instead of overwhelming file lists, you see clean progress:
```
1,205,123  45%  123.45kB/s    0:01:23
```

### Safe Interruption

Press **Ctrl+C** anytime during sync operations. rsync will:
- Complete writing the current file
- Exit cleanly without corruption
- Display a confirmation message

## Configuration Examples

### For Photography Workflow
```bash
4) do_sync "$HOME/Photos/RAW/" "$DRIVE_PATH/Photos-RAW/" "RAW Photos" ;;
5) do_sync "$HOME/Photos/Processed/" "$DRIVE_PATH/Photos-Processed/" "Processed Photos" ;;
```

### For Development Work
```bash
4) do_sync "$HOME/Development/" "$DRIVE_PATH/Development/" "Development Projects" ;;
5) do_sync "$HOME/.config/" "$DRIVE_PATH/Config-Backup/" "Configuration Files" ;;
```

### For Media Collections
```bash
4) do_sync "$HOME/Movies/" "$DRIVE_PATH/Movies/" "Movie Collection" ;;
5) do_sync "$HOME/Music/" "$DRIVE_PATH/Music/" "Music Library" ;;
```

## Troubleshooting

### Drive Not Found Error
- Ensure external drive is connected and mounted in `/Volumes/`
- Check that `EXTERNAL_DRIVE_NAME` matches exactly (case-sensitive)
- Try: `ls /Volumes/` to see available drives

### Permission Errors
- Ensure script is executable: `chmod +x ~/Scripts/sync_menu.sh`
- Check source folder permissions
- Run with `sudo` if syncing system directories (not recommended for personal files)

### Alias Not Working
- Reload shell configuration: `source ~/.zshrc`
- Restart terminal application
- Verify alias exists: `alias | grep syncmenu`
- Check script path: `ls -la ~/Scripts/sync_menu.sh`

### Sync Operations Fail
- Verify source folders exist
- Ensure external drive has sufficient space
- Check for special characters in folder names

## Requirements

- macOS (rsync comes pre-installed)
- External drive for backups
- Terminal access (Terminal.app or iTerm2)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - feel free to modify and distribute.


Built to solve the common problem of rsync's overwhelming output while maintaining its power and reliability.
