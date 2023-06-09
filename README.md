## Unix Recycle and Restore Scripts
This project introduces a pair of shell scripts, recycle and restore, to provide a "recycle bin" functionality for Unix command line users. The recycle script moves a specified file into a recycle bin directory instead of permanently deleting it, and the restore script retrieves a specified file from the recycle bin and places it back in its original location.

# Installation
Clone the repository to your local machine or download the recycle and restore shell scripts.
Ensure that the scripts have the necessary execution permissions. You can add execution permission by running chmod +x recycle and chmod +x restore.
Move the scripts to a location in your PATH for easy access, e.g., mv recycle ~/bin and mv restore ~/bin.

# Usage
<u>Recycle Script</u>
The recycle script is designed to emulate the rm command. To delete a file, the script should be executed as follows:
<pre>bash recycle fileName</pre>
The deleted file is moved to a directory named recyclebin in your home directory. The filenames in the recyclebin will be in the format fileName_inode.

You can also delete multiple files or directories using the -r option, just like with the rm command. For instance:
<pre>bash recycle -r dirName</pre>
And to interactively delete files or display deletion messages, use the -i and -v options, respectively. For instance:

<pre>bash recycle -iv fileName</pre>

<u>Restore Script</u>
To restore a file, the script should be executed as follows:
<pre>bash restore fileName_inode</pre>
This command moves the file with the name fileName_inode from the recyclebin directory back to its original location.

The script checks if a file with the same name already exists in the target location. If so, it asks for confirmation before overwriting the existing file.
