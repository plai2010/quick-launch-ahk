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
	if (fileCheck(iconPath := toolbarDirPath "\" myScriptName ".ico"))
		Menu, Tray, Icon, %iconPath%
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
