# FlutterFlow Development Tool

A powerful development tool that streamlines the workflow between FlutterFlow and local development environments. This tool automates code export from FlutterFlow, handles device mirroring, and provides an interactive development environment with hot reload capabilities.

## Features

- **Interactive Mode**: User-friendly interface with device and project selection
- **Secure Token Management**: One-time token setup with secure storage
- **Project History**: Remembers last 10 projects for quick access
- **Cross-Platform Support**: Works on macOS, Linux, and Windows
- **Device Mirroring**: Integrated scrcpy support for Android device mirroring
- **Hot Reload**: Real-time code updates with 'r' key shortcut
- **Branch Support**: Work with specific FlutterFlow branches using `--branch` flag
- **Auto DevTools**: Automatically opens Flutter DevTools in browser
- **Smart Device Detection**: Auto-detects devices when not specified

## Prerequisites

1. **FlutterFlow CLI**: Version 0.0.24 or higher
   ```bash
   dart pub global activate flutterflow_cli
   ```
2. **Flutter SDK**: Properly installed and in your PATH
3. **Connected Device**: iOS or Android device with USB debugging enabled
4. **scrcpy** (Optional for Android mirroring):
   - macOS: `brew install scrcpy`
   - Ubuntu/Debian: `sudo apt-get install scrcpy`
   - Arch Linux: `sudo pacman -S scrcpy`

## Installation

1. Download `ff-run.sh` from this repository
2. Make it executable:
   ```bash
   chmod +x ff-run.sh
   ```

## Usage

### Interactive Mode (Recommended)

Simply run without arguments for the best experience:

```bash
./ff-run.sh
```

This mode will:
- Prompt for your FlutterFlow API token (first time only)
- Show available devices to select from
- Display recent project IDs or allow entering new ones
- Remember your choices for future runs

### Command Line Mode

```bash
# Full specification
./ff-run.sh [device_id] [project_id] [--branch branch_name]

# Auto-detect device
./ff-run.sh [project_id] [--branch branch_name]

# With branch
./ff-run.sh my-project-id --branch feature-branch
```

### Available Commands

```bash
./ff-run.sh --help          # Show detailed help
./ff-run.sh --reset-token   # Clear stored API token
```

## Interactive Controls

While running:
- **`r`**: Download latest code and hot restart
- **`q`**: Quit application and cleanup
- **Other keys**: Forwarded to Flutter

## Token Management

On first run, you'll be prompted for your FlutterFlow API token:
- Find your token at: https://app.flutterflow.io/settings/api
- Token is stored securely in `~/.ff_token` with restricted permissions
- Use `--reset-token` to clear and re-enter token

## Project History

The tool maintains a history of your last 10 projects in `~/.ff_projects`:
- Recent projects shown as numbered list
- Most recently used appears first
- Easy selection by number or enter new project ID

## Device Mirroring (Android Only)

For Android devices, scrcpy automatically starts for device mirroring:
- Provides real-time screen mirroring
- Handles cleanup on exit
- Shows warning if scrcpy not installed

## Project Structure

```
./ff-app/
└── [PROJECT-ID]/
    └── [Downloaded Flutter project]
```

## Advanced Features

### Branch Support
```bash
./ff-run.sh --branch feature-branch
```

### Token Reset
```bash
./ff-run.sh --reset-token
```

### Help Documentation
```bash
./ff-run.sh --help
```

## Error Handling

Comprehensive checks for:
- FlutterFlow CLI installation
- Device connectivity
- Token validation
- Export success/failure
- Cleanup on interruption

## Troubleshooting

### Device Issues
- Enable USB debugging on your device
- Check connection with `flutter devices`
- For Android: Ensure ADB drivers are installed

### Export Issues
- Verify FlutterFlow API token is valid
- Check project ID spelling
- Ensure you have project access permissions
- Verify branch name if using `--branch`

### Mirroring Issues
- Install scrcpy for Android mirroring
- Check USB connection stability
- Grant necessary permissions on device

## OS-Specific Notes

### macOS
- Uses native `open` command for URLs
- Integrated with system keyboard events

### Linux
- Requires `xdg-open` for URL handling
- Falls back to common browsers if needed

### Windows
- Uses `cmd.exe` for URL opening
- Supports standard Windows conventions

## Version Information

- **Version**: 1.0
- **Minimum FlutterFlow CLI**: 0.0.24
- **Created by**: [FlutterFlow Expert YouTube Channel](https://www.youtube.com/@flutterflowexpert)

## Contributing

Contributions welcome! Please submit pull requests or create issues for bugs and feature requests.

## License

GPL-3.0 license

## Acknowledgments

- FlutterFlow team for their excellent platform
- Genymobile for the amazing scrcpy tool
- Flutter team for their fantastic framework
