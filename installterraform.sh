# Create Terraform directory if it doesn't exist
New-Item -ItemType Directory -Path "C:\Program Files\Terraform" -Force

# Download Terraform executable
$version = "1.5.7"
$downloadUrl = "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_windows_amd64.zip"
$zipPath = "$env:TEMP\terraform.zip"
$extractPath = "$env:TEMP\terraform"

# Download the zip file
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

# Extract the zip file
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Move terraform executable to installation directory
Move-Item -Path "$extractPath\terraform.exe" -Destination "C:\Program Files\Terraform" -Force

# Cleanup temporary files
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force

# Add Terraform to system PATH
$terraformPath = "C:\Program Files\Terraform"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

if ($currentPath -notlike "*$terraformPath*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$currentPath;$terraformPath",
        [EnvironmentVariableTarget]::Machine
    )
}

# Refresh current session PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine")