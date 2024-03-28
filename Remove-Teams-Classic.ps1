# Morganthau1
# Teams Classic Cleanup Script
# 3/6/2024
# The purpose of this script is to uninstall teams classic and delete the leftover folders & cache data.

# Get all user profiles from C:\Users and store them in UserProfiles variable, assign Teams Machinewide Installer location variable
$UserProfiles = Get-ChildItem "C:\Users\" -Directory
$InstallerPath = "C:\Program Files (x86)\Teams Installer"

# Loop through each user profile
foreach ($UserProfile in $UserProfiles) {
    $TeamsPath = Join-Path -Path $UserProfile.FullName -ChildPath "AppData\Local\Microsoft\Teams" # Path to uninstaller location
    $CachePath = Join-Path -Path $UserProfile.FullName -ChildPath "AppData" # Path to user AppData folder
    
    # Check if Teams is installed for the current user
    if (Test-Path (Join-Path -Path $TeamsPath -ChildPath "current\Teams.exe")) {

        # Stop Teams process
        Stop-Process -Name "Teams.exe" -Force -ErrorAction SilentlyContinue
        
        # Uninstall Teams silently
        Start-Process -FilePath (Join-Path -Path $TeamsPath -ChildPath "Update.exe") -ArgumentList "/uninstall /s" -Wait -PassThru

        # Remove Leftover Folders
        Remove-Item -Recurse -Force -Path $CachePath\Local\Microsoft\Teams -ErrorAction SilentlyContinue
        Remove-Item -Recurse -Force -Path $CachePath\Local\Microsoft\TeamsPresenceAddin -ErrorAction SilentlyContinue
        Remove-Item -Recurse -Force -Path $CachePath\Roaming\Microsoft\Teams -ErrorAction SilentlyContinue
    }
}

# Remove Teams Installer
if (Test-Path $InstallerPath) {
    Remove-Item -Recurse -Force -Path $InstallerPath -ErrorAction SilentlyContinue # Since it is outside the UserProfile loop, this will run regardless of profile installations.
}