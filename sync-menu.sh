#!/bin/bash

# rsync Menu - User-friendly sync utility for macOS
# Customize the variables below for your setup

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# CONFIGURATION - Edit these variables for your setup
EXTERNAL_DRIVE_NAME="YOUR_DRIVE_NAME"  # e.g., "My Backup Drive" or "backup-ssd"
DRIVE_PATH="/Volumes/$EXTERNAL_DRIVE_NAME"

# Trap function for safe interruption
cleanup() {
    echo
    echo -e "${YELLOW}Sync operation interrupted by user.${NC}"
    echo -e "${BLUE}Current file transfer completed safely - no corruption.${NC}"
    echo -e "${GREEN}You can resume syncing later.${NC}"
    exit 0
}

# Set up trap to catch Ctrl+C
trap cleanup SIGINT

# Check if drive is mounted
if [ ! -d "$DRIVE_PATH" ]; then
    echo -e "${RED}Error: $EXTERNAL_DRIVE_NAME is not mounted!${NC}"
    echo "Please connect your external drive and try again."
    exit 1
fi

# Function to choose sync type
choose_sync_type() {
    echo
    echo -e "${YELLOW}Choose sync operation:${NC}"
    echo "1) True Sync (mirror - adds, updates, AND deletes extra files)"
    echo "2) Copy/Update Only (adds and updates, but never deletes)"
    echo
    read -p "Choose sync type (1-2): " sync_choice
    
    case $sync_choice in
        1) SYNC_FLAGS="-av --delete --info=progress2" ;;
        2) SYNC_FLAGS="-av --info=progress2" ;;
        *) echo "Invalid choice, defaulting to Copy/Update Only"; SYNC_FLAGS="-av --info=progress2" ;;
    esac
}

# Function to execute sync
do_sync() {
    local source="$1"
    local dest="$2"
    local name="$3"
    
    choose_sync_type
    echo -e "${GREEN}Syncing $name...${NC}"
    rsync $SYNC_FLAGS "$source" "$dest"
    echo -e "${GREEN}$name sync complete!${NC}"
}

echo -e "${BLUE}=== File Sync Menu ===${NC}"
echo -e "${YELLOW}(Press Ctrl+C anytime to safely stop sync operations)${NC}"
echo "1) Desktop"
echo "2) Documents"
echo "3) Downloads"
echo "4) Pictures"
echo "5) Custom Folder 1"
echo "6) Custom Folder 2"
echo "7) Custom folder (enter path)"
echo "8) Sync all configured folders"
echo "9) Exit"
echo
read -p "Choose an option (1-9): " choice

case $choice in
    1) do_sync "$HOME/Desktop/" "$DRIVE_PATH/Desktop/" "Desktop" ;;
    2) do_sync "$HOME/Documents/" "$DRIVE_PATH/Documents/" "Documents" ;;
    3) do_sync "$HOME/Downloads/" "$DRIVE_PATH/Downloads/" "Downloads" ;;
    4) do_sync "$HOME/Pictures/" "$DRIVE_PATH/Pictures/" "Pictures" ;;
    5) 
        # CUSTOMIZE: Replace with your actual folder path
        # Example: do_sync "$HOME/Projects/" "$DRIVE_PATH/Projects/" "Projects"
        echo -e "${RED}Please customize this option with your folder path${NC}"
        ;;
    6) 
        # CUSTOMIZE: Replace with your actual folder path  
        # Example: do_sync "$HOME/Code/" "$DRIVE_PATH/Code/" "Code"
        echo -e "${RED}Please customize this option with your folder path${NC}"
        ;;
    7) 
        echo
        read -p "Enter full path to source folder: " custom_path
        
        # Expand tilde if present
        custom_path="${custom_path/#\~/$HOME}"
        
        if [ ! -d "$custom_path" ]; then
            echo -e "${RED}Error: Folder does not exist!${NC}"
            exit 1
        fi
        
        echo -e "${YELLOW}Contents of $custom_path:${NC}"
        ls -la "$custom_path" | head -10
        echo
        read -p "Is this the correct folder? (y/n): " confirm
        
        if [[ $confirm =~ ^[Yy]$ ]]; then
            folder_name=$(basename "$custom_path")
            do_sync "$custom_path/" "$DRIVE_PATH/$folder_name/" "$folder_name"
        else
            echo "Cancelled."
        fi
        ;;
    8) 
        choose_sync_type
        echo -e "${GREEN}Syncing all configured folders...${NC}"
        echo
        echo -e "${BLUE}Syncing Desktop...${NC}"
        rsync $SYNC_FLAGS "$HOME/Desktop/" "$DRIVE_PATH/Desktop/"
        echo
        echo -e "${BLUE}Syncing Documents...${NC}"
        rsync $SYNC_FLAGS "$HOME/Documents/" "$DRIVE_PATH/Documents/"
        echo
        echo -e "${BLUE}Syncing Downloads...${NC}"
        rsync $SYNC_FLAGS "$HOME/Downloads/" "$DRIVE_PATH/Downloads/"
        echo
        echo -e "${BLUE}Syncing Pictures...${NC}"
        rsync $SYNC_FLAGS "$HOME/Pictures/" "$DRIVE_PATH/Pictures/"
        echo
        # Add your custom folders to the "sync all" operation:
        # echo -e "${BLUE}Syncing Projects...${NC}"
        # rsync $SYNC_FLAGS "$HOME/Projects/" "$DRIVE_PATH/Projects/"
        echo -e "${GREEN}All syncs complete!${NC}"
        ;;
    9) exit ;;
    *) echo -e "${RED}Invalid option${NC}" ;;
esac
