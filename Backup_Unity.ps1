try {
    # === CONFIGURATION ===
    $ProjectPath = "C:\Users\USERNAME\Documents\GitHub\PROJECT_NAME" # Full path to your Unity project root folder
	$FoldersToBackup = @("Assets", "ProjectSettings", "Packages")  # Subfolders inside the project to include in the backup
    $BackupFolder = "G:\My Drive\Backups" # Destination Google Drive folder where the final .7z backup will be saved
    $BackupZipName = "MyProject.7z" # The name of the output zip file
    $BackupZipPath = Join-Path $BackupFolder $BackupZipName # Full destination path constructed automatically

    # Path to 7-Zip executable
    $SevenZipPath = "C:\Program Files\7-Zip\7z.exe" # Default 7-Zip install location
    if (!(Test-Path $SevenZipPath)) { throw "7-Zip not found at $SevenZipPath" } # Abort early if 7-Zip is missing

    # Temporary zip path on Desktop
    $TempFolder = "C:\Users\USERNAME\Desktop\Automated Backups\Unity" # Local temp folder where zipped backup is moved, before syncing to Google Cloud
    $TempZipPath = Join-Path $TempFolder $BackupZipName # Full temp zip path constructed automatically

    # Remove old temp zip if exists
    if (Test-Path $TempZipPath) { Remove-Item $TempZipPath -Force } # Clean up leftover from previous run

    # Build folder paths for 7-Zip
    $folderPaths = $FoldersToBackup | ForEach-Object { Join-Path $ProjectPath $_ } # Combine project root with each subfolder
    $folderPathsEscaped = $folderPaths | ForEach-Object { "`"$($_)`"" } # Wrap in quotes for 7-Zip compatibility

    Write-Host "Creating temp zip at: $TempZipPath"
    Write-Host "Source folders: $($folderPathsEscaped -join ', ')"

    # Run 7-Zip synchronously
    & "$SevenZipPath" a -t7z "$TempZipPath" $folderPathsEscaped -mx=5 # -t7z = 7z format, -mx=5 = balanced compression level (1-9)

    # Ensure temp zip exists
    if (!(Test-Path $TempZipPath)) { throw "Temp 7z file was not created: $TempZipPath" } # Abort if 7-Zip failed to create the file

    Write-Host "Temp zip created successfully."

    # --- DEBUG OUTPUT BEFORE COPY ---
    Write-Host "Attempting to copy zip..."
    Write-Host "Temp zip path: $TempZipPath"
    Write-Host "Destination zip path: $BackupZipPath"
    Write-Host "Does temp zip exist? " (Test-Path $TempZipPath)

    # Copy temp 7z to final backup location (overwrite if exists)
    Copy-Item -Path $TempZipPath -Destination $BackupZipPath -Force # Overwrite existing backup at destination

    # Remove temp zip
    Remove-Item $TempZipPath -Force # Clean up temp after successful copy

    Write-Output "Backup completed successfully to $BackupZipPath"
}

catch {
    Write-Error "Backup failed: $_"
}

finally {
    #Write-Host "`nPress Enter to exit..."
    #Read-Host
}