function codeprompt
    # Get the current directory
    set current_dir (pwd)

    # Create a temporary file to store all output
    set temp_file (mktemp)

    # Iterate over all files recursively
    for file in (find . -type f)
        set full_path "$current_dir/$file"

        # Print file name with path
        echo "File: $full_path" | tee -a $temp_file

        # Print file content
        cat $file | tee -a $temp_file
        echo "" | tee -a $temp_file
    end

    # Copy all to clipboard (detect platform)
    if test (uname) = "Darwin"
        cat $temp_file | pbcopy
    else if type xclip > /dev/null
        cat $temp_file | xclip -selection clipboard
    else if type xsel > /dev/null
        cat $temp_file | xsel --clipboard --input
    else
        echo "No clipboard utility found. Please install pbcopy, xclip, or xsel."
    end

    # Cleanup
    rm $temp_file
end
