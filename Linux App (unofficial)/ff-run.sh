#!/bin/bash

# Version 0.3
# Made by https://www.youtube.com/@flutterflowexpert/

# The project ID is passed as the first command-line argument
project_id=$1
# The status of flutter run (true/false) is passed as the second command-line argument
is_flutter_running=$2
# Device IP and port are passed as the third command-line argument
device_id=$3

if [ -z "$project_id" ]; then
    echo "You must provide a project ID as the first parameter."
    exit 1
fi

if [ "$is_flutter_running" = "true" ]; then
    echo "Flutter is reported to be running. Only executing FlutterFlow export-code..."
    flutterflow export-code --project $project_id --dest "ff-app" --token [TOKEN]
else
    # Initialize a flag to indicate that prerequisites are met
    prerequisites_met=true

    # Check if FlutterFlow CLI is installed
    if flutterflow | grep -q 'Token$'; then
        echo "FF CLI is installed"
    else
        echo "First, you need to install FlutterFlow CLI - https://pub.dev/packages/flutterflow_cli"
        prerequisites_met=false
    fi


    # Check for connected devices via adb
    if adb devices | grep -q 'device$'; then
        echo "Device connected."
    else
        echo "Connect your phone with your computer using USB."
        prerequisites_met=false
    fi

    echo "Prerequisites Met: $prerequisites_met"
    # Assuming prerequisites_met is a string 'true' or 'false'
    if [ "$prerequisites_met" = "true" ]; then
        echo "Attempting to export code with FlutterFlow CLI..."
        flutterflow export-code --project $project_id --dest "ff-app" --token [TOKEN]

        # Assuming 'ff-app' directory is successfully created
        cd ff-app || { echo "Failed to change directory to ff-app"; exit 1; }
        echo "Current directory after moving to 'ff-app': $(pwd)"

        # Extract the part before the hyphen
        project_prefix=$(echo "$project_id" | awk -F'-' '{print $1}')

        # Find the directory that starts with the project prefix
        project_dir_name=$(find . -maxdepth 1 -type d -name "${project_prefix}_*" | head -n 1)

        # Remove the leading './' from the directory name
        project_dir_name=${project_dir_name#./}

        echo "Found project directory name: '$project_dir_name'"

        if [ -n "$project_dir_name" ] && [ -d "$project_dir_name" ]; then
            echo "Changing directory to '$project_dir_name'..."
            cd "$project_dir_name" || { echo "Failed to change directory to '$project_dir_name'"; exit 1; }
            echo "Current directory: $(pwd)"
            # Use the provided device_id when running flutter run
            if [ -n "$device_id" ]; then
                echo "Running on specified device: $device_id"
                flutter run -d "$device_id"
            else
                echo "No device specified. Running on default device."
                flutter run
            fi
        else
            echo "The expected project directory does not exist."
        fi
    else
        echo "Prerequisites not met, skipping FlutterFlow export-code command."
    fi
fi