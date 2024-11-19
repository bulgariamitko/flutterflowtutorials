#!/bin/bash

# Version 1.0
# Run at least version flutterflow_cli: ^0.0.24 /dart pub global activate flutterflow_cli/
# Made by https://www.youtube.com/@flutterflowexpert/

# Device IP and port are passed as the first command-line argument
device_id=$1
# The project ID is passed as the second command-line argument
project_id=$2
# The branch name is passed as the third (optional) command-line argument
branch_name=$3

if [ -z "$project_id" ]; then
    echo "You must provide a project ID as the second parameter."
    exit 1
fi

# Store the root directory at the start of the script
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$ROOT_DIR/ff-app/$project_id"

# Global variable for scrcpy process ID
SCRCPY_PID=""

# Function to start scrcpy in the background
start_scrcpy() {
    # Kill any existing scrcpy processes first
    pkill scrcpy 2>/dev/null

    # Check if scrcpy is installed
    if ! command -v scrcpy >/dev/null; then
        echo "scrcpy is not installed. Please install it to use device mirroring."
        return 1
    fi

    # Start scrcpy with the device ID
    echo "Starting device mirroring with scrcpy..."
    scrcpy -s "$device_id" &
    SCRCPY_PID=$!

    # Check if scrcpy started successfully
    if [ $? -eq 0 ]; then
        echo "Device mirroring started successfully (PID: $SCRCPY_PID)"
    else
        echo "Failed to start device mirroring"
        SCRCPY_PID=""
    fi
}

# Function to stop scrcpy
stop_scrcpy() {
    if [ -n "$SCRCPY_PID" ]; then
        echo "Stopping device mirroring..."
        kill $SCRCPY_PID 2>/dev/null
        SCRCPY_PID=""
    fi
}

# Ensure scrcpy is cleaned up on script exit
cleanup() {
    stop_scrcpy
    # Add any other cleanup tasks here
    rm -rf "$temp_dir" 2>/dev/null
    exit 0
}

# Set up trap for cleanup on script exit
trap cleanup EXIT SIGINT SIGTERM

# Detect OS
OS="unknown"
case "$(uname)" in
    "Darwin")
        OS="macos"
        ;;
    "Linux")
        OS="linux"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        OS="windows"
        ;;
esac

echo "Detected OS: $OS"

# Function to open URL based on OS
open_url() {
    local url=$1
    case "$OS" in
        "macos")
            /usr/bin/open "$url"
            ;;
        "linux")
            xdg-open "$url" >/dev/null 2>&1 || (
                echo "Failed to open URL with xdg-open. Trying alternative methods..."
                if command -v google-chrome >/dev/null; then
                    google-chrome "$url"
                elif command -v firefox >/dev/null; then
                    firefox "$url"
                else
                    echo "Please open this URL manually: $url"
                fi
            )
            ;;
        "windows")
            cmd.exe /c "start $url" >/dev/null 2>&1 || echo "Please open this URL manually: $url"
            ;;
    esac
}

# Function to execute FlutterFlow export-code command and wait for completion
execute_flutterflow_export() {
    local log_file=$(mktemp)
    local success=false

    echo "Starting code download..."

    # Ensure we're in the project directory
    cd "$PROJECT_DIR" 2>/dev/null || {
        # If project directory doesn't exist, create it first
        mkdir -p "$PROJECT_DIR"
        cd "$PROJECT_DIR" || exit 1
    }

    # Base command without branch name
    local base_cmd="flutterflow export-code \
        --project \"$project_id\" \
        --dest \"$PROJECT_DIR\" \
        --token \"[TOKEN]\" \
        --include-assets \
        --no-parent-folder \
        --as-debug"

    # Add branch name flag only if specified
    if [ -n "$branch_name" ]; then
        base_cmd+=" --branch-name \"$branch_name\""
    fi

    # Execute the command and capture output
    eval "$base_cmd" 2>&1 | tee "$log_file"

    # Check if download was successful
    if grep -q "All done!" "$log_file"; then
        success=true
    elif grep -q "Downloading assets..." "$log_file"; then
        # Wait for assets download to complete
        tail -f "$log_file" | while read line; do
            echo "$line"
            if [[ "$line" == *"All done!"* ]]; then
                success=true
                break
            fi
        done
    fi

    rm -f "$log_file"

    if [ "$success" = true ]; then
        echo "Download completed successfully!"
        return 0
    else
        echo "Download failed or incomplete."
        return 1
    fi
}

# Function to send hot restart command based on OS
send_hot_restart() {
    local input_pipe=$1

    # First try direct pipe input
    if [ -n "$input_pipe" ] && [ -p "$input_pipe" ]; then
        echo "R" > "$input_pipe"
        return
    fi

    # Fallback to OS-specific keyboard simulation
    case "$OS" in
        "macos")
            osascript <<EOF
                tell application "System Events"
                    tell process "Terminal"
                        keystroke "R" using shift down
                    end tell
                end tell
EOF
            ;;
        "linux")
            if command -v xdotool > /dev/null; then
                xdotool key shift+r
            else
                echo "xdotool is required for keyboard simulation on Linux"
            fi
            ;;
        "windows")
            if command -v AutoHotkey.exe > /dev/null; then
                echo 'Send, +r' | AutoHotkey.exe /ErrorStdOut *
            else
                echo "AutoHotkey is required for keyboard simulation on Windows"
            fi
            ;;
    esac
}

# Define send_flutter_command as a global function
send_flutter_command() {
    local cmd=$1
    local pipe=$2
    echo -n "$cmd" > "$pipe"
}

# Function to run Flutter with proper IO handling
run_flutter_with_monitoring() {
    local temp_dir=$(mktemp -d)
    local input_pipe="$temp_dir/input_pipe"
    local output_file="$temp_dir/flutter_output"

    # Create named pipe for input
    mkfifo "$input_pipe"

    # Start Flutter with input from the pipe
    (flutter run -d "$device_id" < "$input_pipe" 2>&1 | tee "$output_file" | while IFS= read -r line; do
        echo "$line"
        if [[ "$line" == *"Flutter DevTools"* ]] || [[ "$line" == *"debugger and profiler"* ]]; then
            local devtools_url
            devtools_url=$(echo "$line" | grep -o 'http[s]*://[^[:space:]]*')
            if [ -n "$devtools_url" ]; then
                echo "Opening DevTools URL: $devtools_url"
                open_url "$devtools_url"
            fi
        fi
    done) &

    flutter_pid=$!

    # Keep the input pipe open
    exec 3>"$input_pipe"

    echo "Press 'r' to download new code and hot restart"
    echo "Press 'q' to quit"

    # Monitor keyboard input
    while true; do
        read -rsn1 key
        case "$key" in
            r)
                if execute_flutterflow_export; then
                    echo "Download successful, triggering hot restart..."
                    # Send capital R for hot restart
                    send_flutter_command "R" "$input_pipe"
                fi
                ;;
            q)
                echo "Quitting..."
                exec 3>&-  # Close the pipe
                stop_scrcpy  # Stop device mirroring
                kill $flutter_pid 2>/dev/null
                rm -rf "$temp_dir"
                exit 0
                ;;
            *)
                # Forward all other keypresses to Flutter
                send_flutter_command "$key" "$input_pipe"
                ;;
        esac
    done
}

# Main execution logic
prerequisites_met=true

# Check for FlutterFlow CLI
if flutterflow | grep -q 'Token$'; then
    echo "FF CLI is installed"
else
    echo "First, you need to install FlutterFlow CLI - https://pub.dev/packages/flutterflow_cli"
    prerequisites_met=false
fi

# Check for connected devices
if adb devices | grep -q 'device$'; then
    echo "Device connected."
else
    echo "Connect your phone with your computer using USB."
    prerequisites_met=false
fi

# Check for scrcpy
if ! command -v scrcpy >/dev/null; then
    echo "Warning: scrcpy is not installed. Device mirroring will not be available."
    echo "To install scrcpy:"
    case "$(uname)" in
        "Darwin")
            echo "    brew install scrcpy"
            ;;
        "Linux")
            echo "    sudo apt-get install scrcpy  # For Ubuntu/Debian"
            echo "    sudo pacman -S scrcpy       # For Arch Linux"
            ;;
        *)
            echo "    Please visit: https://github.com/Genymobile/scrcpy#get-the-app"
            ;;
    esac
fi

# Update the main execution logic
if [ "$prerequisites_met" = "true" ]; then
    # Start scrcpy once at the beginning
    start_scrcpy

    echo "Attempting to export code with FlutterFlow CLI..."
    if [ -n "$branch_name" ]; then
        echo "Using branch: $branch_name"
    fi

    # Initial export
    execute_flutterflow_export

    # Stay in project directory for Flutter commands
    cd "$PROJECT_DIR" || { echo "Failed to change directory to $PROJECT_DIR"; exit 1; }
    echo "Current directory: $(pwd)"

    if [ -n "$device_id" ]; then
        echo "Running on specified device: $device_id"
        run_flutter_with_monitoring
    else
        echo "No device specified. Running on default device."
        device_id=$(flutter devices | grep -m 1 -o '^[^ ]*')
        if [ -n "$device_id" ]; then
            echo "Using detected device: $device_id"
            run_flutter_with_monitoring
        else
            echo "No devices found. Please connect a device and try again."
            exit 1
        fi
    fi
else
    echo "Prerequisites not met, skipping execution."
fi