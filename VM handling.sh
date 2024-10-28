#!/bin/bash

display_menu() {
    echo "Please choose an instruction:"
    echo "1) Start a CVD instance"
    echo "2) Stop a CVD instance"
    echo "3) Display the list of running CVD instances"
    echo "4) Display the CVD version"
    echo "5) Display the temporary files associated with each CVD instance"
    echo "6) Display the path of the CVD executable"
    echo "7) Display the processes associated with CVD"
    echo "8) Quit"
    echo "c) Return to the main menu"
}

execute_choice() {
    case $1 in
        1)
            echo "Starting a CVD instance..."
            if cvd start; then
                echo "CVD instance started successfully."
            else
                echo "Failed to start CVD instance."
            fi
            ;;
        2)
            echo "Stopping a CVD instance..."
            if cvd stop; then
                echo "CVD instance stopped successfully."
            else
                echo "Failed to stop CVD instance."
            fi
            ;;
        3)
            echo "=== List of CVD instances ==="
            cvd fleet
            ;;
        4)
            echo "=== CVD version ==="
            cvd version
            ;;
        5)
            echo "=== Temporary files associated with CVD ==="
            cvd_tmp_dir="/tmp/cvd/"
            if [ -d "$cvd_tmp_dir" ]; then
                list_temp_files
                access_temp_files
            else
                echo "No temporary files directory found for CVD at $cvd_tmp_dir"
            fi
            ;;
        6)
            echo "=== Path of the CVD executable ==="
            cvd_path=$(which cvd)
            if [ -n "$cvd_path" ]; then
                echo "CVD executable path: $cvd_path"
            else
                echo "CVD executable not found in the PATH"
            fi
            ;;
        7)
            echo "=== Processes associated with CVD ==="
            top -p $(pgrep -d',' cvd)
            ;;
        8)
            echo "Exiting..."
            exit 0
            ;;
        c|C)
            display_menu
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
}

list_temp_files()
{
    find -type d -iname "cuttlefish_runtime.*"
}

access_temp_files() {
    while true; do
        read -p "Enter the number of the file you want to open (or type 'c' to return to the main menu): " file_number
        if [[ $file_number == "c" || $file_number == "C" ]]; then
            display_menu
            break
        elif [[ $file_number =~ ^[0-9]+$ && $file_number -gt 0 && $file_number -le ${#file_list[@]} ]]; then
            file_path="${file_list[$((file_number-1))]}"
            extension="${file_path##*.}"
            case "$extension" in
                img)
                    echo "Opening $file_path with the default image viewer..."
                    xdg-open "$file_path"
                    ;;
                json)
                    echo "Opening $file_path with the default JSON viewer..."
                    xdg-open "$file_path"
                    ;;
                log)
                    echo "Opening $file_path with the default text editor..."
                    xdg-open "$file_path"
                    ;;
                xml)
                    echo "Opening $file_path with the default XML viewer..."
                    xdg-open "$file_path"
                    ;;
                *)
                    echo "Unsupported file extension. Opening with the default application..."
                    xdg-open "$file_path"
                    ;;
            esac
        else
            echo "Invalid choice. Please try again."
        fi
    done
}

display_menu
while true; do
    read -p "Enter your choice number: " choice
    execute_choice $choice
    if [[ $choice != "c" && $choice != "C" ]]; then
        echo
    fi
done

exit 0
