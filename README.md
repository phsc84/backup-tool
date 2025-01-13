# BackupTool

## Installation and configuration
### Windows
tbd
### macOS
On macOS you need to code sign the application and remove the malware check.
1. Navigate to the path where you place BackupTool
    > cd "/path/to/BackupTool"
2. Code sign BackupTool
    > codesign --entitlements mac.entitlements -s - "BackupTool"
3. Remove malware check (quarantine attribute)
    > xattr -d com.apple.quarantine $appPath "BackupTool"
