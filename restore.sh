#!/bin/bash

# File and directory for restore
RECYCLE_BIN="$HOME/recyclebin"
RESTORE_INFO="$HOME/.restore.info"

# Check if no arguments provided
if [ $# -eq 0 ]; then
    echo "No arguments supplied."
    exit 1
fi

# Function to restore a file
restore_file() {
    file=$1
    # Check if file exists in recycle bin
    if [ ! -e $RECYCLE_BIN/$file ]; then
        echo "File $file does not exist in the recycle bin."
        return
    fi

    # Get the original path of the file
    original_path=$(grep "^$file:" $RESTORE_INFO | cut -d ":" -f 2)

    # Check if file already exists at the original path
    if [ -e $original_path ]; then
        read -p "File $original_path already exists. Do you want to overwrite? y/n " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy] ]]; then
            return
        fi
    fi

    # Recreate directory if it does not exist
    mkdir -p $(dirname $original_path)

    # Move file back to the original location
    mv $RECYCLE_BIN/$file $original_path

    # Remove the entry from the restore info
    sed -i "/^$file:/d" $RESTORE_INFO
}

# Loop over all arguments
for file in "$@"; do
    restore_file "$file"
done
