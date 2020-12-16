#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
SetTitleMatchMode, 1
SetControlDelay, -1

;;;;; Window Search Settings ;;;;;
; Title and text for the uninstall confirmation window
winConfirmUninstallTitle := "FRC Radio Configuration Utility Uninstall"
winConfirmUninstallText := "Are you sure you want to completely remove FRC Radio" ; Button1

; Title and text for npcap uninstall confirmation
winNPCapConfirmUninstallTitle := "Uninstall"
winNPCapConfirmUninstallText := "Uninstall Npcap?" ; Button1

; Title and texts for npcap uninstaller
winNPCapUninstallerTitle := "Npcap 0.9986 Uninstall"
winNPCapUninstallerText := "Uninstall Npcap 0.9986" ; Button2
winNPCapUninstallerCompleteText := "Uninstallation Complete" ; Button2

; Title and text for succesfully removed from your computer window
winUninstallFinishedTitle := "FRC Radio Configuration Utility Uninstall"
winUninstallFinishedText := "FRC Radio Configuration Utility was successfully remove" ; Button1

;;;;; Operations ;;;;;
; Selecting Yes on Confirmation Window
WinWait, %winConfirmUninstallTitle%, %winConfirmUninstallText%
WinActivate, %winConfirmUninstallTitle%, %winConfirmUninstallText%,,
ControlClick, Button1, %winConfirmUninstallTitle%, %winConfirmUninstallText%,,, NA

; Selecting Yes on Uninstall NPCap Window 
WinWait, %winNPCapConfirmUninstallTitle%, %winNPCapConfirmUninstallText%
WinActivate, %winNPCapConfirmUninstallTitle%, %winNPCapConfirmUninstallText%,,
ControlClick, Button1, %winNPCapConfirmUninstallTitle%, %winNPCapConfirmUninstallText%,,, NA

;  Selecting Uninstall on NPCap uninstaller
WinWait, %winNPCapUninstallerTitle%, %winNPCapUninstallerText%
WinActivate, %winNPCapUninstallerTitle%, %winNPCapUninstallerText%,,
ControlClick, Button2, %winNPCapUninstallerTitle%, %winNPCapUninstallerText%,,, NA

; Selecting Close on NPCap uninstaller complete window
WinWait, %winNPCapUninstallerTitle%, %winNPCapUninstallerCompleteText%
ControlClick, Button2, %winNPCapUninstallerTitle%, %winNPCapUninstallerCompleteText%,,, NA

; Selecting OK on Uninstall finished window
WinWait, %winUninstallFinishedTitle%, %winUninstallFinishedText%
WinActivate, %winUninstallFinishedTitle%, %winUninstallFinishedText%,,
ControlClick, Button1, %winUninstallFinishedTitle%, %winUninstallFinishedText%,,, NA
