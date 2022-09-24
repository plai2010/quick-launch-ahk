; AHK script to launch programs from system tray.
; This is like Windows "Quick Launch" toolbar.
; Copyright (c) 2022 Patrick Lai

;	#NoTrayIcon

	#Include, %A_ScriptDir%\lib\menu-builder.ahk

	SplitPath, A_WorkingDir, , , , dirName

;-----------------------------------------------------------------------
	Menu, Tray, NoStandard
	Menu, Tray, Click, 1
	Menu, Tray, Tip, Quick Launch (%dirName%)

;	Menu, Tray, Add
;	buildMenuForDir(A_WorkingDir "\Tools", "Tray", "Submenu")
	buildMenuForDir(A_WorkingDir, "Tray", "Submenu")

;	------------------------------------------------
	Menu, Tray, Add

	Menu, Tray, Add, Exit, doExit
	Menu, Tray, NoIcon, Exit

	!^#t::showMenu("Tray")
;-----------------------------------------------------------------------
	doExit() {
		ExitApp
	}

	showMenu(menuName) {
		Menu, %menuName%, Show
	}

; vim: set ts=4 noexpandtab:
