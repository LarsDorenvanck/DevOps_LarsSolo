# Create doctl directory if it doesn't exist
New-Item -ItemType Directory -Path "C:\Program Files\doctl" -Force

# Download doctl executable
$version = "1.119.0"
$downloadUrl = "https://github.com/digitalocean/doctl/releases/download/v$version/doctl-$version-windows-amd64.zip"
$zipPath = "$env:TEMP\doctl.zip"
$extractPath = "$env:TEMP\doctl"

# Download the zip file
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# Extract the zip file
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Move doctl executable to installation directory
Move-Item -Path "$extractPath\doctl.exe" -Destination "C:\Program Files\doctl" -Force

# Cleanup temporary files
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force

# Add doctl to system PATH
$doctlPath = "C:\Program Files\doctl"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

if ($currentPath -notlike "*$doctlPath*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$currentPath;$doctlPath",
        [EnvironmentVariableTarget]::Machine
    )
}

# Refresh current session PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")