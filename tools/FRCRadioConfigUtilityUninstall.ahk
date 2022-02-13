#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;;;;; Window Search Settings ;;;;;
; Title and text for npcap uninstall confirmation
winNPCapConfirmUninstallTitle := "Uninstall"
winNPCapConfirmUninstallText := "Uninstall Npcap?" ; Button1

; Title and texts for npcap uninstaller
winNPCapUninstallerTitle := "Npcap 0.9986 Uninstall"
winNPCapUninstallerText := "Uninstall Npcap 0.9986" ; Button2
winNPCapUninstallerCompleteText := "Uninstallation Complete" ; Button2

;;;;; Operations ;;;;;
; Selecting Yes on Uninstall NPCap Window 
WinWait, %winNPCapConfirmUninstallTitle%, %winNPCapConfirmUninstallText%, 
WinActivate, %winNPCapConfirmUninstallTitle%, %winNPCapConfirmUninstallText%,,
ControlClick, Button1, %winNPCapConfirmUninstallTitle%, %winNPCapConfirmUninstallText%,,, NA

;  Selecting Uninstall on NPCap uninstaller
WinWait, %winNPCapUninstallerTitle%, %winNPCapUninstallerText%
WinActivate, %winNPCapUninstallerTitle%, %winNPCapUninstallerText%,,
ControlClick, Button2, %winNPCapUninstallerTitle%, %winNPCapUninstallerText%,,, NA

; Selecting Close on NPCap uninstaller complete window
WinWait, %winNPCapUninstallerTitle%, %winNPCapUninstallerCompleteText%
ControlClick, Button2, %winNPCapUninstallerTitle%, %winNPCapUninstallerCompleteText%,,, NA