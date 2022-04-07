#SingleInstance, Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;;; Contstants ;;;;;
DriverInstallerTitle := "Windows Security"
DriverInstallerButtonText := "&Install"

;;;;; Operations ;;;;;
WinWait, %DriverInstallerTitle%, , 300
if (ErrorLevel = 1) {
    Exit
    ; MsgBox % "AHK Timed Out!" ; For testing
}
WinActivate, %DriverInstallerTitle%
Sleep, 3000
ControlClick, %DriverInstallerButtonText%, %DriverInstallerTitle%,,,, NA

if !(ErrorLevel) {
    ; MsgBox % "No AHK errors!" ; For testing
} else {
    ; MsgBox % "AHK ERROR!!" 
}