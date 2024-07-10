#Debug lines can be printed by passing the flag -Debug
$ErrorActionPreference = 'Stop'; # stop on all errors
Write-Host "Beginning uninstall process of WPILib..."

# Variables that will need changed
$year = '2024'

# Generated Variables
$systemDriveLetter = (Get-WmiObject Win32_OperatingSystem).getPropertyValue("SystemDrive")
$publicUserHome = $systemDriveLetter + "\Users\Public"
$wpiFolder = "$publicUserHome\wpilib"
$wpiFolderCurrentYear = "$wpiFolder\$year"
$startMenuDirectories = @(
  "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs",
  "$systemDriveLetter\ProgramData\Microsoft\Windows\Start Menu\Programs"
)
$startMenuLinks = @(
  "$year WPILib Tools",
  "$year WPILib Documentation.lnk",
  "$year WPILib VS Code.lnk"
)
$possibleLinkDirectories = @(
  "$HOME\Desktop",
  "$publicUserHome\Desktop",
  "$HOME\OneDrive\Desktop"
)
$linkNames = @(
  "$year WPILib VS Code.lnk",
  "$year WPILib Documentation.lnk",
  "AdvantageScope (WPILib) $year.lnk",
  "Data Log Tool $year.lnk",
  "Glass $year.lnk",
  "OutlineViewer $year.lnk",
  "PathWeaver $year.lnk",
  "roboRIO Team Number Setter $year.lnk",
  "RobotBuilder $year.lnk",
  "Shuffleboard $year.lnk",
  "SmartDashboard $year.lnk",
  "SysId $year.lnk",
  "$year WPILib Tools"
)

##### Delete WPILib folder #####
# Check if the inside wpilib folder exists, attempt to delete it, check if was successful
Write-Host "`nRemoving the WPILib $year folder..."
if (Test-Path -Path $wpiFolderCurrentYear) {
  Remove-Item $wpiFolderCurrentYear -ErrorAction SilentlyContinue -Force -Recurse
  
  if (!(Test-Path -Path $wpiFolderCurrentYear)) {
    Write-Host "`tRemoved wpilib folder at `"$wpiFolderCurrentYear`"" -ForegroundColor Green
  } else {
    Write-Host "`tAn error occured while trying to delete the wpilib folder at `"$wpiFolderCurrentYear`"" -ForegroundColor Red
  }
} else {
  Write-Host "`tIt appears that the wpilib folder expected at `"$wpiFolderCurrentYear`" does not exists. This could be a good indicator that wpilib (for this year) is not/no longer installed, however the uninstall process will continue to ensure that all elements of wpilib are gone`n" -ForegroundColor Yellow
}

# Delete the outside wpilib folder if it exists and is now empty
if(Test-Path $wpiFolder){
  if ((Get-ChildItem $wpiFolder -force | Select-Object -First 1 | Measure-Object).Count -eq 0) {
    Write-Host "`nRemoving the WPILib parent folder as it is empty..."
    Remove-Item $wpiFolder -ErrorAction SilentlyContinue -Force -Recurse

    if (!(Test-Path -Path $wpiFolder)) {
      Write-Host "`tRemoved the main wpilib folder at `"$wpiFolder`" because it was empty" -ForegroundColor Green
    } else {
      Write-Host "`tAn error occured while trying to delete the wpilib parent folder at `"$wpiFolder`"" -ForegroundColor Red
    }
  }
} else {
  Write-Host "`tIt appears that the main wpilib folder at `"$wpiFolder`" does not exists. This could be a good indicator that wpilib is not/no longer installed, however the uninstall process will continue to ensure that all elements of wpilib are gone" -ForegroundColor Yellow
}

##### Delete Desktop Shortcuts ##### 
# Both public and current user desktop. It differes upon whether you select current user or all users when installing. 
# It might be infered that if one link is found the others will be next to it, but that's a dangerous game. Plus what if the links are in multiple places?
Write-Host "`nDeleteing Desktop Shortcuts..."
$LinksFound = ""
foreach ($directory in $possibleLinkDirectories) {
  Write-Host "`tSearching `"$directory`" for links to delete:"
  foreach ($link in $linkNames) {
    $linkPath = Join-Path -Path $directory -ChildPath $link
    # Check for link file, if its there attempt to delete it, recheck if its there.
    if (Test-Path -Path $linkPath) {
      $LinksFound = $TRUE
      Remove-Item $linkPath -ErrorAction SilentlyContinue -Force -Recurse

      if (!(Test-Path -Path $linkPath)) {
        Write-Host "`t`tFound and deleted `"$linkPath`"" -ForegroundColor Green
      } else {
        Write-Host "`t`tAttempted deleting `"$linkPath`" but could not delete" -ForegroundColor Red
      }
    } else {
      Write-Host "`t`tLooked for `"$linkPath`" but found nothing" -ForegroundColor Yellow
    }
  }
}
if (!$LinksFound) {
  Write-Host "`tUnable to find links to be deleted automatically. You will have to manually delete them if you have them in a place other than your desktop." -ForegroundColor Yellow
}

##### Remove Start Menu Shortcuts #####
Write-Host "`nRemoving Start Menu Shortcuts..."
$foundStartMenu = ""
# Check for and delete start menu shortcuts in each start menu folder
foreach($directory in $startMenuDirectories) {
  Write-Host "`tSearching `"$directory`" for links to delete:"
  foreach ($item in $startMenuLinks) {
    $itemPath = Join-Path -Path $directory -ChildPath $item
    if (Test-Path -Path $itemPath) {
      Remove-Item $itemPath -ErrorAction SilentlyContinue -Force -Recurse
      $foundStartMenu = $TRUE
      
      if (!(Test-Path -Path $itemPath)) {
        Write-Host "`t`tRemoved start menu item at `"$itemPath`"" -ForegroundColor Green
      } else {
        Write-Host "`t`tAn error occured while trying to delete the start menu item at `"$itemPath`"" -ForegroundColor Red
      }
    } else {
      Write-Host "`t`tLooked for `"$itemPath`" but found nothing" -ForegroundColor Yellow
    }
  }
}

if (!$foundStartMenu) {
  Write-Host "`tThere is no Start Menu folder to delete. It was either already removed or the wpilib uninstaller was run without admin privlages" -ForegroundColor Yellow
}

Write-Host "`nFinished uninstalling WPILib!" -ForegroundColor Green