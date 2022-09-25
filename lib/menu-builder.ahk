; Build menu by walking a directory tree.
; Copyright (c) 2022 Patrick Lai
;-----------------------------------------------------------------------
buildMenuForDir(dir, menuName, submenuPrefix) {
	global myScriptName

	EnvGet, windowsDir, windir

	dirIconFile := myScriptName ".ico"

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
				if (fileCheck(iconPath := filePath "\" dirIconFile))
					Menu, %menuName%, Icon, %submenuLabel%, %iconPath%
				subdirNum += 1
			}
			Continue
		}

		; Skip directory icon file.
		if (fileNameSame(fileName, dirIconFile))
			Continue

		; Icon handling based on file type.
		iconFile := 0
		iconSetter := 0
		if (fileExt == "lnk")
			iconSetter := "setShortcutMenuIcon"
		else if (fileExt == "cmd" || fileExt == "bat")
			iconFile := windowsDir "\System32\cmd.exe"
		else if (fileExt == "exe")
			iconFile := filePath

		launcher := Func("launchMenuItem").Bind(filePath)
		itemCount += 1

		Menu, %menuName%, Add, %fileBase%, % launcher
		if (iconSetter)
			%iconSetter%(filePath, menuName, fileBase)
		else if (iconFile) {
			try {
			;	MsgBox, Setting icon for '%shortcut%': %iconFile%
				Menu, %menuName%, Icon, %fileBase%, %iconFile%
			}
			catch err {
			;	showError("Error setting icon for '" shortcut "': " err)
			}
		}
	}
	return itemCount + subdirNum - 1
}
;-----------------------------------------------------------------------
launchMenuItem(filePath, itemName, itemPos, menuName) {
	try {
	;	MsgBox, Running '%filePath%'
		Run, %filePath%
	}
	catch err {
		showError("Failed to launch '" itemName "'.")
	}
}
;-----------------------------------------------------------------------
setShortcutMenuIcon(shortcut, menuName, itemName) {
	try {
		FileGetShortcut, %shortcut%, target, dir, args, desc, icon, iconNum
	;	MsgBox, %shortcut%: icon=%icon% iconNum=%iconNum% target=%target
		if (icon != "")
			Menu, %menuName%, Icon, %itemName%, %icon%, %iconNum%
		else {
			; TODO: Target may be a command with arguments, and it
			; may even contain envrionment variable references.
			if (fileCheck(target)) {
			;	MsgBox, Setting '%itemName%' icon: %target%
				Menu, %menuName%, Icon, %itemName%, %target%
			}
		}
		return 1
	}
	catch err {
	;	showError("Error getting icon for '" shortcut "': " err)
		return 0
	}
}
;-----------------------------------------------------------------------
; vim: set ts=4 noexpandtab:
