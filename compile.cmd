@echo off
setlocal

set "PATH=%ProgramFiles%\AutoHotKey\Compiler;%PATH%"

rem	set ico_file=icons\menu-green.ico
	set ico_file=icons\menu-list-blue.ico
	set exe_file=quick-launch.exe
	set ahk_file=quick-launch.ahk

@echo on
Ahk2Exe /in "%ahk_file%" /out "%exe_file%" /icon "%ico_file%
@echo off

endlocal
