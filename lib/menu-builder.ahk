; Build menu by walking a directory tree.
; Copyright (c) 2022 Patrick Lai
;-----------------------------------------------------------------------
buildMenuForDir(dir, menuName, submenuPrefix) {
	global myScriptName

;	MsgBox, Building '%menuName%': dir=%dir%
	; Add shortcuts as menu items.
	itemCount := 0
	subdirNum := 1
	Loop, %dir%\*.*, 1
	{
		StringLower, fileExt, A_LoopFileExt
		fileName := A_LoopFileName
		fileBase := (fileExt == "")
			? fileName
			: SubStr(fileName, 1, StrLen(fileName)-StrLen(fileExt)-1)
		filePath := A_LoopFileLongPath

		attrs := FileExist(filePath)
	;	MsgBox, Entry %filePath%: attrs=%attrs%

		; Skip hidden entry.
		if (InStr(attrs, "H"))
			Continue

		; Dive into subdirectory.
		if (InStr(attrs, "D")) {
			submenuName := submenuPrefix "_" subdirNum
			submenuLabel := fileName
			try {
				Menu, %submenuName%, DeleteAll
			}
			catch err {
			;	MsgBox, DeleteAll failed on submenu: %submenuName%
			}
			if (buildMenuForDir(filePath, submenuName, submenuName)) {
				Menu, %menuName%, Add, %submenuLabel%, :%submenuName%
				if (FileExist(iconPath := filePath "\" myScriptName ".ico"))
					Menu, %menuName%, Icon, %submenuLabel%, %iconPath%
				subdirNum += 1
			}
			Continue
		}

		; Expect only shortcuts.
		if (fileExt != "lnk")
			Continue
		if (itemCount == 0)
			launcher := Func("launchMenuItem").Bind(dir)
		itemCount += 1

		Menu, %menuName%, Add, %fileBase%, % launcher
		setShortcutMenuIcon(filePath, menuName, fileBase)
	}
	return itemCount + subdirNum - 1
}
;-----------------------------------------------------------------------
launchMenuItem(itemDir, itemName) {
	shortcut := itemDir "\" itemName ".lnk"
	try {
	;	MsgBox, Running '%shortcut%'
		Run, %shortcut%
	}
	catch err {
		showError("Failed to launch '" itemName "'.")
	}
}
;-----------------------------------------------------------------------
setShortcutMenuIcon(shortcut, menuName, itemName) {
	try {
		FileGetShortcut, %shortcut%, target, dir, args, desc, icon, iconNum
	;	MsgBox, %shortcut%: icon=%icon% iconNum=%iconNum%
		if (icon != "") {
			Menu, %menuName%, Icon, %itemName%, %icon%, %iconNum%
			return 1
		}
	}
	catch err {
	;	showError("Error getting icon for '" shortcut "': " err)
		return 0
	}
}
;-----------------------------------------------------------------------
; vim: set ts=4 noexpandtab:
