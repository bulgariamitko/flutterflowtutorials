#!/bin/bash

# Version 1.0
# Run at least version flutterflow_cli: ^0.0.24 /dart pub global activate flutterflow_cli/
# Made by https://www.youtube.com/@dimitarklaturov/

# Token storage configuration
TOKEN_FILE="$HOME/.ff_token"

# Project ID storage configuration
PROJECT_HISTORY_FILE="$HOME/.ff_projects"

# Function to reset/clear the stored token
reset_token() {
    if [ -f "$TOKEN_FILE" ]; then
        rm "$TOKEN_FILE"
        echo "Token cleared successfully."
    else
        echo "No token found to clear."
    fi
}

# Function to add project ID to history
add_project_to_history() {
    local project_id=$1

    # Create the file if it doesn't exist
    touch "$PROJECT_HISTORY_FILE"
    chmod 600 "$PROJECT_HISTORY_FILE"

    # Remove the project ID if it already exists (to avoid duplicates)
    if [ -f "$PROJECT_HISTORY_FILE" ]; then
        grep -v "^$project_id$" "$PROJECT_HISTORY_FILE" > "$PROJECT_HISTORY_FILE.tmp" || true
        mv "$PROJECT_HISTORY_FILE.tmp" "$PROJECT_HISTORY_FILE"
    fi

    # Add the project ID to the top of the file
    echo "$project_id" > "$PROJECT_HISTORY_FILE.tmp"
    if [ -f "$PROJECT_HISTORY_FILE" ]; then
        cat "$PROJECT_HISTORY_FILE" >> "$PROJECT_HISTORY_FILE.tmp"
    fi
    mv "$PROJECT_HISTORY_FILE.tmp" "$PROJECT_HISTORY_FILE"

    # Keep only the last 10 projects
    if [ -f "$PROJECT_HISTORY_FILE" ]; then
        head -n 10 "$PROJECT_HISTORY_FILE" > "$PROJECT_HISTORY_FILE.tmp"
        mv "$PROJECT_HISTORY_FILE.tmp" "$PROJECT_HISTORY_FILE"
    fi
}

# Function to get project history
get_project_history() {
    if [ -f "$PROJECT_HISTORY_FILE" ]; then
        cat "$PROJECT_HISTORY_FILE"
    fi
}

# Global variables
SELECTED_DEVICE=""
SELECTED_PROJECT=""

# Function to select device interactively
select_device() {
    echo "Detecting available devices..."

    # Get flutter devices output and extract device lines
    local devices_output=$(flutter devices --no-version-check 2>&1)
    local devices=$(echo "$devices_output" | grep -E '^\s+.*\s•\s.*\s•\s.*\s•')

    if [ -z "$devices" ]; then
        echo "No devices found. Please connect a device and try again."
        return 1
    fi

    echo ""
    echo "Available devices:"
    echo "$devices" | nl -w2 -s') '
    echo ""

    # Simple device selection
    while true; do
        echo -n "Select device (enter number): "
        read selection

        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "$(echo "$devices" | wc -l)" ]; then
            local device_line=$(echo "$devices" | sed -n "${selection}p")
            if [ -n "$device_line" ]; then
                # Extract device ID (second field after splitting by •) and trim spaces
                SELECTED_DEVICE=$(echo "$device_line" | awk -F' • ' '{print $2}' | xargs)
                return 0
            fi
        fi

        echo "Invalid selection. Please try again."
    done
}

# Function to select project ID interactively
select_project_id() {
    local history=$(get_project_history)

    if [ -n "$history" ]; then
        echo ""
        echo "Recent project IDs:"
        echo "$history" | nl -w2 -s') '
        echo "$(($(echo "$history" | wc -l) + 1))) Enter new project ID"
        echo ""
        echo "Select a project number from the list above, or select $(($(echo "$history" | wc -l) + 1)) to enter a new project ID:"

        while true; do
            echo -n "Select project (enter number): "
            read selection

            if [[ "$selection" =~ ^[0-9]+$ ]]; then
                local max_option=$(($(echo "$history" | wc -l) + 1))

                if [ "$selection" -le "$(echo "$history" | wc -l)" ] && [ "$selection" -ge 1 ]; then
                    SELECTED_PROJECT=$(echo "$history" | sed -n "${selection}p")
                    return 0
                elif [ "$selection" -eq "$max_option" ]; then
                    break
                fi
            fi

            echo "Invalid selection. Please try again."
        done
    else
        # No project history - inform user they need to enter a new project ID
        echo ""
        echo "No recent project IDs found."
        echo "Please enter a new project ID below:"
        echo ""
    fi

    # Prompt for new project ID
    while true; do
        echo -n "Enter project ID: "
        read project_id

        if [ -n "$project_id" ]; then
            add_project_to_history "$project_id"
            SELECTED_PROJECT="$project_id"
            return 0
        fi

        echo "Project ID cannot be empty. Please try again."
    done
}

# Function to securely store the token
store_token() {
    local token=$1
    # Create the token file with restricted permissions (600 = read/write for owner only)
    touch "$TOKEN_FILE"
    chmod 600 "$TOKEN_FILE"
    echo "$token" > "$TOKEN_FILE"
}

# Function to retrieve the stored token
get_token() {
    if [ -f "$TOKEN_FILE" ]; then
        cat "$TOKEN_FILE"
    else
        echo ""
    fi
}

# Function to prompt for token input
prompt_for_token() {
    echo "FlutterFlow API token not found."
    echo "Please enter your FlutterFlow API token:"
    echo "(You can find your token at: https://app.flutterflow.io/settings/api)"
    echo ""
    read -s -p "Token: " token
    echo ""

    if [ -z "$token" ]; then
        echo "Error: Token cannot be empty."
        exit 1
    fi

    # Store the token securely
    store_token "$token"
    echo "Token stored securely."
    echo "$token"
}

# Function to get or prompt for token
get_or_prompt_token() {
    local token=$(get_token)
    if [ -z "$token" ]; then
        token=$(prompt_for_token)
    fi
    echo "$token"
}

# Check for help flag
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage:"
    echo "  $0                                    # Interactive mode (recommended)"
    echo "  $0 [device_id] [project_id] [--branch branch_name]  # Command line mode"
    echo "  $0 [project_id] [--branch branch_name]              # Command line mode (auto-detect device)"
    echo "  $0 --reset-token                      # Clear stored FlutterFlow API token"
    echo "  $0 --help                             # Show this help message"
    echo ""
    echo "Interactive Mode (no arguments):"
    echo "  - Prompts for FlutterFlow API token on first run"
    echo "  - Shows available devices to select from"
    echo "  - Shows recent project IDs or allows entering new ones"
    echo "  - Stores project history for future runs"
    echo "  - Branch can be specified with --branch flag"
    echo ""
    echo "Command Line Mode:"
    echo "  device_id    Device ID (optional, will auto-detect if not provided)"
    echo "  project_id   FlutterFlow project ID (required)"
    echo "  --branch     Branch name (optional flag)"
    echo ""
    echo "Options:"
    echo "  --reset-token  Clear stored FlutterFlow API token"
    echo "  --help, -h     Show this help message"
    echo ""
    echo "Features:"
    echo "  - Secure token storage (prompted once, reused automatically)"
    echo "  - Project ID history (last 10 projects remembered)"
    echo "  - iOS and Android device support"
    echo "  - Android device mirroring with scrcpy"
    exit 0
fi

# Check for reset token flag
if [ "$1" = "--reset-token" ]; then
    reset_token
    exit 0
fi

# Parse arguments for --branch flag
branch_name=""
args=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --branch)
            branch_name="$2"
            shift 2
            ;;
        *)
            args+=("$1")
            shift
            ;;
    esac
done

# Check if running in interactive mode (no arguments provided)
if [ ${#args[@]} -eq 0 ]; then
    echo "=== FlutterFlow Local Run Setup ==="
    echo ""

    # Check token first
    echo "Checking FlutterFlow API token..."
    token=$(get_or_prompt_token)
    echo "Token verified."
    echo ""

    # Get device interactively
    if ! select_device; then
        echo "Error: Failed to select device. Exiting."
        exit 1
    fi
    device_id="$SELECTED_DEVICE"

    # Get project ID interactively
    if ! select_project_id; then
        echo "Error: Failed to select project. Exiting."
        exit 1
    fi
    project_id="$SELECTED_PROJECT"

    echo ""
    echo "Selected configuration:"
    echo "  Device: $device_id"
    echo "  Project: $project_id"
    if [ -n "$branch_name" ]; then
        echo "  Branch: $branch_name"
    fi
    echo ""
else
    # Traditional argument parsing
    device_id="${args[0]}"
    project_id="${args[1]}"

    # If only one argument provided, treat it as project_id
    if [ ${#args[@]} -eq 1 ]; then
        project_id="${args[0]}"
        device_id=""
    fi

    if [ -z "$project_id" ]; then
        echo "Usage: $0 [device_id] [project_id] [--branch branch_name]"
        echo "   or: $0 [project_id] [--branch branch_name]"
        echo "   or: $0 (for interactive mode)"
        exit 1
    fi

    # Add project to history if provided via command line
    if [ -n "$project_id" ]; then
        add_project_to_history "$project_id"
    fi
fi

# Store the root directory at the start of the script
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$ROOT_DIR/ff-app/$project_id"

# Global variable for scrcpy process ID
SCRCPY_PID=""

# Function to check if a device is Android
is_android_device() {
    local device_id=$1
    # Check if device is Android by looking for it in flutter devices output
    flutter devices --no-version-check 2>/dev/null | grep "$device_id" | grep -q "android"
}

# Function to start scrcpy in the background (Android only)
start_scrcpy() {
    # Only start scrcpy for Android devices
    if ! is_android_device "$device_id"; then
        echo "Device mirroring is only available for Android devices"
        return 1
    fi

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

    # Get the API token (prompt if not stored)
    local token=$(get_or_prompt_token)

    # Base command without branch name
    local base_cmd="flutterflow export-code \
        --project \"$project_id\" \
        --dest \"$PROJECT_DIR\" \
        --token \"$token\" \
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
if flutter devices --no-version-check 2>/dev/null | grep -q -E '^\s+.*•.*•'; then
    echo "Device connected."
else
    echo "Connect your phone with your computer using USB or enable wireless debugging."
    prerequisites_met=false
fi

# Check for scrcpy
if ! command -v scrcpy >/dev/null; then
    echo "Warning: scrcpy is not installed. Device mirroring will not be available for Android devices."
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
        echo "Running on device: $device_id"
        # Check device type for scrcpy compatibility
        if is_android_device "$device_id"; then
            echo "Android device detected - device mirroring available"
        else
            echo "iOS device detected - device mirroring not available"
        fi
        run_flutter_with_monitoring
    else
        echo "No device specified. Running on default device."
        device_id=$(flutter devices --no-version-check 2>/dev/null | grep -E '^\s+.*•.*•' | head -1 | awk -F' • ' '{print $2}')
        if [ -n "$device_id" ]; then
            echo "Using detected device: $device_id"
            # Check device type for scrcpy compatibility
            if is_android_device "$device_id"; then
                echo "Android device detected - device mirroring available"
            else
                echo "iOS device detected - device mirroring not available"
            fi
            run_flutter_with_monitoring
        else
            echo "No devices found. Please connect a device and try again."
            exit 1
        fi
    fi
else
    echo "Prerequisites not met, skipping execution."
fi