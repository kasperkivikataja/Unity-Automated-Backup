# Unity-Automated-Backup
Automated PowerShell script that compresses a Unity project (Assets, ProjectSettings, Packages) using 7-Zip and backs it up to Google Drive. Builds the archive locally first for performance, then copies to the destination. <br>**Note**: This tool takes a snapshot of the project and overwrites the previous file in Google Drive.

**How to Use**
1. Download the .ps file and update the paths within the file.
2. Download & Install Google Drive application and make sure it is synced to your drive.
3. Execute the .ps file with PowerShell by right clicking the .ps and "Run with Powershell".

_______________________________________________________________

(Optional)
4. You can also add a task to your task scheduler:

Action: Start a Program
Program: powershell.exe
Details: -NoProfile -ExecutionPolicy Bypass -File "C:\your path here\Backup_Unity.ps1"
