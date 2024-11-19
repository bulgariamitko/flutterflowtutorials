# FlutterFlow Development Tool

A powerful development tool that streamlines the workflow between FlutterFlow and local development environments. This tool automates code export from FlutterFlow, handles device mirroring, and provides an interactive development environment with hot reload capabilities.

## Features

- **Cross-Platform Support**: Works on macOS, Linux, and Windows
- **Device Mirroring**: Integrated support for scrcpy to mirror your device screen
- **Interactive Development**: Hot reload and restart capabilities with keyboard shortcuts
- **Branch Support**: Ability to work with specific FlutterFlow branches
- **Automatic DevTools**: Opens Flutter DevTools automatically in your default browser
- **Real-time Monitoring**: Continuous monitoring of Flutter output with intelligent handling

## Prerequisites

Before you begin, ensure you have the following installed:

1. **FlutterFlow CLI**: Install from [FlutterFlow CLI on pub.dev](https://pub.dev/packages/flutterflow_cli)
2. **Flutter SDK**: Make sure Flutter is properly installed and in your PATH
3. **ADB**: Android Debug Bridge for device communication
4. **scrcpy** (Optional but recommended): For device screen mirroring
   - macOS: `brew install scrcpy`
   - Ubuntu/Debian: `sudo apt-get install scrcpy`
   - Arch Linux: `sudo pacman -S scrcpy`
   - Windows: Visit [scrcpy GitHub](https://github.com/Genymobile/scrcpy#get-the-app)

## Installation

1. Download the script from this repository
2. Make it executable:

```bash
chmod +x ff-run.sh
```

3. Configure your FlutterFlow token:
   - Open `ff-run.sh` in a text editor
   - Replace `[TOKEN]` with your FlutterFlow API token

## Usage

### Basic Usage

```bash
./ff-run.sh [DEVICE-ID] [PROJECT-ID] [BRANCH-NAME]
```

- `DEVICE-ID`: Your device's ADB identifier (required)
- `PROJECT-ID`: Your FlutterFlow project ID (required)
- `BRANCH-NAME`: The FlutterFlow branch to use (optional)

### Interactive Commands

While the tool is running, you can use the following keyboard commands:

- `r`: Download new code from FlutterFlow and trigger a hot restart
- `q`: Quit the application
- Other keys are forwarded directly to Flutter

### Features in Detail

1. **Device Mirroring**

   - Automatically starts scrcpy for device mirroring
   - Handles proper cleanup on exit
   - Configurable through scrcpy parameters

2. **Code Export**

   - Automatic code export from FlutterFlow
   - Support for branch-specific exports
   - Progress monitoring with status updates

3. **Development Environment**

   - Integrated Flutter run command
   - Automatic DevTools URL detection and browser opening
   - Real-time output monitoring
   - Interactive keyboard command handling

4. **OS-Specific Optimizations**
   - Adaptive behavior based on operating system
   - Native URL opening support
   - OS-specific keyboard simulation when needed

## Project Structure

The tool creates and maintains the following directory structure:

```
./ff-app/
└── [PROJECT-ID]/
    └── [Flutter project files]
```

## Error Handling

The tool includes comprehensive error handling for:

- Missing prerequisites
- Failed device connections
- Export failures
- Runtime errors

## Troubleshooting

If you encounter issues:

1. **Device Not Detected**

   - Ensure USB debugging is enabled
   - Check ADB connection with `adb devices`
   - Verify device ID if manually specified

2. **Export Failures**

   - Verify your FlutterFlow token
   - Check project ID
   - Ensure branch name is correct (if specified)

3. **Mirroring Issues**
   - Verify scrcpy installation
   - Check device USB connection
   - Ensure proper USB debugging permissions

## Contributing

Contributions are welcome! Please feel free to submit pull requests or create issues for bugs and feature requests.

## License

GPL-3.0 license

## Acknowledgments

- FlutterFlow team for their excellent platform
- Genymobile for scrcpy
- Flutter team for their amazing framework
