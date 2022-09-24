rem @echo off
setlocal

set "PATH=%ProgramFiles%\AutoHotKey\Compiler;%PATH%"

set ico_file=icons\Menu_icon_icon-icons.com_71858.ico
set ico_file=icons\1486564397-menu-green_81507.ico
set exe_file=quick-launch.exe
set ahk_file=quick-launch.ahk

Ahk2Exe /in "%ahk_file%" /out "%exe_file%" /icon "%ico_file%

endlocal
