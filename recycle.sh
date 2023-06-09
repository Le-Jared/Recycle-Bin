#!/bin/bash

# Recycle bin directory
RECYCLE_BIN="$HOME/recyclebin"
RESTORE_INFO="$HOME/.restore.info"

# Create recycle bin directory if not exists
mkdir -p $RECYCLE_BIN

interactive=0
verbose=0
recursive=0

# Handle options
while getopts "ivr" opt; do
    case $opt in
        i) interactive=1;;
        v) verbose=1;;
        r) recursive=1;;
        \?) echo "Invalid option -$OPTARG" >&2; exit 1;;
    esac
done

# Remove the options from the positional parameters
shift $((OPTIND-1))

# Check if no arguments provided
if [ $# -eq 0 ]; then
    echo "No arguments supplied."
    exit 1
fi

# Function to handle recycling of files
recycle_file() {
    file=$1
    # Check if file exists
    if [ ! -e $file ]; then
        echo "File $file does not exist."
        return
    fi

    # Check if directory
    if [ -d $file ]; then
        if [ $recursive -eq 0 ]; then
            echo "Cannot remove '$file': Is a directory"
            return
        else
            for f in $(find $file -type f); do
                recycle_file "$f"
            done
            rm -rf "$file"
            return
        fi
    fi

    # Check if trying to delete recycle script itself
    if [ $(realpath $file) == $(realpath $0) ]; then
        echo "Attempting to delete recycle – operation aborted"
        exit 1
    fi

    # Interactive mode check
    if [ $interactive -eq 1 ]; then
        read -p "Are you sure you want to move $file to recycle bin? y/n " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy] ]]; then
            return
        fi
    fi

    inode=$(ls -i $file | cut -d " " -f 1)
    filename=$(basename $file)
    mv $file $RECYCLE_BIN/${filename}_$inode
    echo "${filename}_$inode:$(realpath $file)" >> $RESTORE_INFO

    # Verbose mode check
    if [ $verbose -eq 1 ]; then
        echo "Moved '$file' to recycle bin"
    fi
}

# Loop over all arguments
for arg in "$@"; do
    for file in $arg; do
        recycle_file "$file"
    done
done
