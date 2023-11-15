#!/bin/bash

# Function to display file information
get_file_info() {
    local file=$1

    # Check if the file exists
    if [ ! -e "$file" ]; then
        echo "Error: File '$file' not found."
        exit 1
    fi

    # Get file information
    file_info=$(stat -c "File: %n\nAccess: %a\nSize(B): %s\nOwner: %U\nModify: %y" "$file")

    echo -e "$file_info"
}

# Check for command line arguments
if [ "$#" -lt 3 ]; then
    echo "Error: Insufficient arguments."
    echo "Usage: internsctl file getinfo <file-name>"
    exit 1
fi

# Parse command line options
command=$1
subcommand=$2
file_name=$3

case "$subcommand" in
    getinfo)
        get_file_info "$file_name"
        ;;
    *)
        echo "Error: Invalid subcommand '$subcommand'."
        echo "Usage: internsctl file getinfo <file-name>"
        exit 1
        ;;
esac

# Function to display file information
get_file_info() {
    local file=$1
    local size_option=$2
    local permissions_option=$3
    local owner_option=$4
    local last_modified_option=$5

    # Check if the file exists
    if [ ! -e "$file" ]; then
        echo "Error: File '$file' not found."
        exit 1
    fi

    # Initialize the format string
    format_string="File: %n"

    # Check options and modify the format string accordingly
    if [ "$size_option" = true ]; then
        format_string="$format_string\nSize(B): %s"
    fi

    if [ "$permissions_option" = true ]; then
        format_string="$format_string\nAccess: %a"
    fi

    if [ "$owner_option" = true ]; then
        format_string="$format_string\nOwner: %U"
    fi

    if [ "$last_modified_option" = true ]; then
        format_string="$format_string\nModify: %y"
    fi

    # Get file information
    file_info=$(stat -c "$format_string" "$file")

    echo -e "$file_info"
}

# Check for command line arguments
if [ "$#" -lt 3 ]; then
    echo "Error: Insufficient arguments."
    echo "Usage: internsctl file getinfo [options] <file-name>"
    exit 1
fi

# Parse command line options
file_name=${!#}  # Get the last argument, which is the file name
size_option=false
permissions_option=false
owner_option=false
last_modified_option=false

while [ "$#" -gt 0 ]; do
    case "$1" in
        -s|--size)
            size_option=true
            ;;
        -p|--permissions)
            permissions_option=true
            ;;
        -o|--owner)
            owner_option=true
            ;;
        -m|--last-modified)
            last_modified_option=true
            ;;
        *)
            ;;
    esac
    shift
done

# Call the function with the specified options
get_file_info "$file_name" "$size_option" "$permissions_option" "$owner_option" "$last_modified_option"