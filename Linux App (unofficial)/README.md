# FlutterFlow Linux Unofficial Alpha

Welcome to the unofficial alpha version of FlutterFlow for Linux. This project aims to facilitate Flutter developers working on Linux to seamlessly integrate FlutterFlow into their development workflow. This tool automates the process of exporting code from FlutterFlow and running it on your connected device.

## Setup

Before you begin, ensure your environment is ready:

- FlutterFlow CLI must be installed on your system. If you haven't done so, you can install it from [FlutterFlow CLI on pub.dev](https://pub.dev/packages/flutterflow_cli).
- Your phone must be connected to your computer via USB. Ensure that your device is in "Developer mode" and that USB debugging is enabled.

## Installation

Follow these steps to get started with the FlutterFlow Linux tool:

1. **Download the script**: Download `ff-run.sh` from this repository.
2. **Set executable permissions**: You need to make the script executable. Open a terminal in the directory where ff-run.sh is located and run:
```bash
chmod +x ff-run.sh
```
3. Configure your token: Open `ff-run.sh` in your favorite text editor and replace `[TOKEN]` with your FlutterFlow API token.

## Usage

To use the tool, open a terminal in the directory containing ff-run.sh and follow these instructions:

- **First Run**: If you are running the app for the first time or if the app is not currently running on your phone, execute the script with the `false` flag. Replace `[PROJECT-ID]` with your actual FlutterFlow project ID.
```bash
./ff-run.sh [PROJECT-ID] false
```
This command will export the project from FlutterFlow, install it on your connected device, and launch the app.

- **Subsequent Runs**: If your app is already running on your phone and you want to update the code without restarting the app, use the `true` flag. This tells the script that `flutter run` is already executing, and it will only export and update the code without re-launching the app.
```bash
./ff-run.sh [PROJECT-ID] true
```
Please note that this tool is in its alpha stage and is unofficial. Feedback and contributions are welcome to improve its functionality and coverage.