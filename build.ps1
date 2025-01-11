# build.ps1 - Cross-platform build script for Windows and macOS

# Set the application name (output executable names will include platform-specific suffixes)
$appName = "BackupTool"

# Define the output directory for the compiled binaries
$outputDir = "dist"

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# Define the build targets
$targets = @(
    @{ GOOS = "windows"; GOARCH = "amd64"; Output = "$outputDir/$appName" + "_win.exe" }
    @{ GOOS = "darwin";  GOARCH = "arm64"; Output = "$outputDir/$appName" + "_mac" }
)

# Build the application for each target
foreach ($target in $targets) {
    # Set environment variables
    $env:GOOS = $target.GOOS
    $env:GOARCH = $target.GOARCH

    # Build the application
    Write-Host "Building for $($target.GOOS)/$($target.GOARCH)..."
    
    # Define the build command as an array
    $cmd = @("go", "build", "-o", $target.Output, "main.go")

    # Invoke the build command and capture output
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $cmd[0]
    $processInfo.Arguments = $cmd[1..($cmd.Length - 1)] -join " "
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
    $processInfo.UseShellExecute = $false

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo

    $process.Start() | Out-Null
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()

    if ($process.ExitCode -ne 0) {
        Write-Host "Build failed for $($target.GOOS)/$($target.GOARCH)." -ForegroundColor Red
        if ($stderr) {
            Write-Host "Error details (stderr):" -ForegroundColor Yellow
            Write-Host $stderr -ForegroundColor DarkGray
        }
        if ($stdout) {
            Write-Host "Error details (stdout):" -ForegroundColor Yellow
            Write-Host $stdout -ForegroundColor DarkGray
        }
        exit 1
    }

    Write-Host "Build successful: $($target.Output)" -ForegroundColor Green
}

Write-Host "All builds completed successfully!" -ForegroundColor Cyan
