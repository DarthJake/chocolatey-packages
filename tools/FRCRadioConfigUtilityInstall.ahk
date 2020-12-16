#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay, -1

;;;;; Window Search Settings ;;;;;
; Title and text for the initial popup window informing of no npcap
winSetupTitle := "Setup"
winSetupText := "Npcap not detected" ; Button1

; Title and texts for npcap install window
winNPCapInstallTitle := "Npcap 0.9986 Setup"
winNPCapAcceptLicenseText := "License Agreement" ; Button2
winNPCapOptionsText := "Installation Options" ; Button2
winNPCapCompleteText := "Installation Complete" ; Button2
winNPCapFinishedText := "Finished" ; Button2

;;;;; Operations ;;;;;
; Selecting OK button on setup window
WinWait, %winSetupTitle%, %winSetupText%
WinActivate, %winSetupTitle%,,,
ControlClick, Button1, %winSetupTitle%, %winSetupText%,,, NA

; Selecting I Agree for license agreement
WinWait, %winNPCapInstallTitle%, %winNPCapAcceptLicenseText%
WinActivate, %winNPCapInstallTitle%,,,
ControlClick, Button2, %winNPCapInstallTitle%, %winNPCapAcceptLicenseText%,,, NA

; Selecting Install on the Options Page
WinWait, %winNPCapInstallTitle%, %winNPCapOptionsText%
ControlClick, Button2, %winNPCapInstallTitle%, %winNPCapOptionsText%,,, NA

; Selecting Next on the Complete Page
WinWait, %winNPCapInstallTitle%, %winNPCapCompleteText%
ControlClick, Button2, %winNPCapInstallTitle%, %winNPCapCompleteText%,,, NA

; Selecting Finish on the Finished Page
WinWait, %winNPCapInstallTitle%, %winNPCapFinishedText%
ControlClick, Button2, %winNPCapInstallTitle%, %winNPCapFinishedText%,,, NA
