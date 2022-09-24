; Build menu by walking a directory tree.
; Copyright (c) 2022 Patrick Lai

;-----------------------------------------------------------------------
	buildMenuForDir(dir, menuName, submenuPrefix) {
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

			; Dive into subdirectory.
			if (InStr(attrs, "D")) {
				submenuName := submenuPrefix "_" subdirNum
				submenuLabel := fileName
				if (buildMenuForDir(filePath, submenuName, submenuName)) {
					Menu, %menuName%, Add, %submenuLabel%, :%submenuName%
					subdirNum += 1
				}
				Continue
			}

			; Expect only shortcuts.
			if (fileExt != "lnk") {
				Continue
			}
			if (itemCount == 0) {
				launcher := Func("launchMenuItem").Bind(dir)
			}
			itemCount += 1

			Menu, %menuName%, Add, %fileBase%, % launcher
		;	Menu, %menuName%, Icon, %fileBase%, %filePath%
		}
		return itemCount + subdirNum - 1
	}
;-----------------------------------------------------------------------
	launchMenuItem(itemDir, itemName) {
		shortcut := itemDir "\" itemName ".lnk"
		if (FileExist(shortcut)) {
			Run, %shortcut%
		}
	}
;-----------------------------------------------------------------------
; vim: set ts=4 noexpandtab:
