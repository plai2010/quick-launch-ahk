; AHK script to launch programs from system tray.
; This is like Windows "Quick Launch" toolbar.
; Copyright (c) 2022 Patrick Lai
;-----------------------------------------------------------------------
;	#NoTrayIcon
	#Persistent
	#SingleInstance Off

	#Include, %A_ScriptDir%\lib\menu-builder.ahk

	SplitPath, A_ScriptName, , , , myScriptName
	buildMenu(A_WorkingDir)
;-----------------------------------------------------------------------
buildMenu(toolbarDirPath) {
	global myScriptName

	SplitPath, toolbarDirPath, , , , toolbarName

	Menu, Tray, NoStandard
	Menu, Tray, DeleteAll
	Menu, Tray, Click, 1
	Menu, Tray, Tip, Toolbar: %toolbarName%
	if (icon := getIconForDirectory(toolbarDirPath))
		Menu, Tray, Icon, % icon[1], % icon[2]
	else if (fileCheck(iconPath := A_ScriptDir "\icons\menu-list-blue.ico"))
		Menu, Tray, Icon, %iconPath%

	buildMenuForDir(toolbarDirPath, "Tray", "Submenu")

	;------------------------------------------------
	; Reload and Exit menu items.
	;------------------------------------------------
	reloader := Func("buildMenu").Bind(toolbarDirPath)
	Menu, Tray, Add
	Menu, Tray, Add, Reload, % reloader
	Menu, Tray, Add, Exit, doExit
}
;-----------------------------------------------------------------------
doExit() {
	ExitApp
}
;-----------------------------------------------------------------------
fileCheck(filePath) {
	attrs := FileExist(filePath)
	if (attrs == "" || InStr(attrs, "D"))
		return 0
	return 1
}
;-----------------------------------------------------------------------
fileNameSame(f1, f2) {
	StringLower f1, f1
	StringLower f2, f2
	return f1 == f2 ? 1 : 0
}
;-----------------------------------------------------------------------
getIconForDirectory(dirPath) {
	global myScriptName

	; Use ico file with script name, if available, in the directory.
	if (fileCheck(iconPath := dirPath "\" myScriptName ".ico")) {
		return [ iconPath, 1 ]
	}

	dsktopIni := dirPath "\desktop.ini"

	; Check for IconResource info in desktop.ini file.
	IniRead, iconResource, %dsktopIni%, .ShellClassInfo, IconResource, %A_Space%
	if (iconResource != "") {
		StringGetPos, commaIndex, iconResource, `,, R1
		if (ErrorLevel != 0) {
			return [ iconResource, 1 ]
		}
		else {
			iconFile := SubStr(iconResource, 1, commaIndex)
			iconIndex := 0 + SubStr(iconResource, commaIndex + 2)
			iconNumber := iconIndex >= 0 ? iconIndex + 1 : iconIndex
			return [ iconFile, iconNumber ]
		}
	}

	; Check for iconFile and iconIndex in desktop.ini file.
	IniRead, iconFile, %dsktopIni%, .ShellClassInfo, IconFile, %A_Space%
	if (iconFile != "") {
		IniRead, iconIndex, %dsktopIni%, .ShellClassInfo, IconIndex, %A_Space%
		iconNumber := iconIndex != "" ? iconIndex + 1 : 1
		return [ iconFile, iconNumber ]
	}

	return 0
}
;-----------------------------------------------------------------------
showError(msg) {
	global myScriptName

	title := myScriptName
	StringReplace, title, title, -, %A_Space%, All
	StringReplace, title, title, ., %A_Space%, All
	StringUpper, title, title, T

	MsgBox, 16, %title%, %msg%
}
;-----------------------------------------------------------------------
showMenu(menuName) {
	Menu, %menuName%, Show
}
;-----------------------------------------------------------------------
; vim: set ts=4 noexpandtab:
