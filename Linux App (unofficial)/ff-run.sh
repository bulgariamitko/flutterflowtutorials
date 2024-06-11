#!/bin/bash

# Version 0.5
# Made by https://www.youtube.com/@flutterflowexpert/

# Device IP and port are passed as the third command-line argument
device_id=$1
# The project ID is passed as the first command-line argument
project_id=$2
# The status of flutter run (true/false) is passed as the second command-line argument
is_flutter_running=$3

if [ -z "$project_id" ]; then
    echo "You must provide a project ID as the first parameter."
    exit 1
fi

if [ "$is_flutter_running" = "true" ]; then
    echo "Flutter is reported to be running. Only executing FlutterFlow export-code..."
    flutterflow export-code --project $project_id --dest "ff-app/$project_id" --token [TOKEN] --include-assets --no-parent-folder
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
        flutterflow export-code --project $project_id --dest "ff-app/$project_id" --token [TOKEN] --include-assets --no-parent-folder

        # Assuming 'ff-app/$project_id' directory is successfully created
        cd "ff-app/$project_id" || { echo "Failed to change directory to ff-app/$project_id"; exit 1; }
        echo "Current directory after moving to 'ff-app/$project_id': $(pwd)"

        # Use the provided device_id when running flutter run
        if [ -n "$device_id" ]; then
            echo "Running on specified device: $device_id"
            flutter run -d "$device_id"
        else
            echo "No device specified. Running on default device."
            flutter run
        fi
    else
        echo "Prerequisites not met, skipping FlutterFlow export-code command."
    fi
fi
