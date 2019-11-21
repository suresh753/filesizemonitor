#!/bin/bash
 
#  Script To monitor the folders and files size
#  This will check the files & folders size present in the binary_sizes.config file

check_file_size()
{
    filename=$1
    maxsize=$2

    if [[ -d $filename ]]; then
        filesize=$(du -s -B1 $filename | cut -f1)  # get exact dir size in bytes
    elif [[ -f $filename ]]; then
        filesize=$(stat -L -c%s "$filename") # get exact file size in bytes
    else
        echo "Unable to locate $filename"
        return
    fi

    if (( filesize > maxsize)); then
        echo "$filename size $filesize is larger than usual size $maxsize"
    fi
}


cur_dir=$PWD
basepath=$1 

( cat $cur_dir/binary_sizes.config; echo ) | while read -r line; do
    if [[ ! -z "$line" ]] && [[ ! "$line" =~ ^#.*$ ]]; then   #skip emptylines and comments
        ref_file="$(echo $line | cut -d'=' -f1)"
        ref_size="$(echo $line | cut -d'=' -f2)"
        check_file_size $basepath$ref_file $ref_size
    fi
done