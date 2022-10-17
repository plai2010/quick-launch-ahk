# Quick Launch AHK #

[autohotkey]: https://www.autohotkey.com
[icon-menu-green]: https://icon-icons.com/icon/Menu-green/81507
[icon-menu-list-blue]: https://icon-icons.com/icon/menu-list/81519
[git-quick-launch-ahk]: https://github.com/plai2010/quick-launch-ahk.git
[quick-launch-ahk]: https://github.com/plai2010/quick-launch-ahk

Windows 10 allows a folder to be added as a toolbar in the taskbar.
This is a convenient way to add a quick-launch menus - just organize
shortcuts in a folder ("menu folder") and make it a toolbar.  Windows 11
unfortunately has removed this feature. This is an [AutoHotKey][autohotkey]
script that turns a menu folder into a menu in the system tray
(or "taskbar corner").

## Installation ##

First, download and install [AutoHotKey (v1.x)][autohotkey] if it not
already in the system. Next, download a release of
[quick-launch-ahk][quick-launch-ahk] from GitHub, and extract
to some folder, say "`%UserProfile%\quick-launch-ahk`".

Optionally run the [`compile.cmd`](compile.cmd) script to compile the
`quick-launch.ahk` script to binary executable `quick-launch.exe`.
The `exe` file is self-contained, so it can be dropped it in any `%PATH%`
folder.

## Running Quick Launch AHK ##

To make a menu folder into a quick-launch menu, simply run `quick-launch.ahk`
(or `quick-launch.exe`) from there. For example, if our
menu folder is "`%APPDATA%\Microsoft\Internet Explorer\Quick Launch`"
and it contains the following items:

	* Google Chrome.lnk
	* Microsoft Edge.lnk
	* Shows Desktop.lnk
	* Window Switcher.lnk

then one may run these commands:

	cd "%APPDATA%\Microsoft\Internet Explorer\Quick Launch"
	"%UserProfile%\quick-launch-ahk\quick-launch.ahk"

and get a system tray menu like this:

![`example-quick-launch.png`](doc/images/example-quick-launch.png)

Right-click on the icon to bring up expand the menu.

One can create a shortcut with `quick-launch.ahk` (or `exe`) as target and
a menu folder as working directory for launch from Windows Explorer. Put
the shortcut in the startup folder if desired for auto-run at login.

Multiple menus are straighforward; run `quick-launch.ahk/exe` a second
time from another folder for a second menu in the system tray.

Here are some more details about `quick-launch-ahk`:

1. Hidden shortcuts and sub-folders are skipped.

1. Changes to the folder are not reflected automatically in the menu.
Select `Reload` to refresh menu as needed.

1. Menu items are not limited to shortcuts. On the other hand, shortcuts
with explicit icon setting work best.

## Customization ##

The icon for menu in the system tray is configurable, as is any submenu icon.
Quick Launch AHK honors the icon resource specified in the `desktop.ini`
file of a folder, so simply customize the icon of the folder through Windows.
For example, here both the menu folder and the "`Ubuntu Terminals`"
submenu have a custom icon:

![`example-demo.png`](doc/images/example-demo.png)

If a `quick-launch.ico` file exists in the menu folder, it takes precedence
over the `desktop.ini` setting. When the script or the compiled executable
is renamed, the name of the custom icon file is expected to follow.

## Acknowledgment ##

Some icon files are from thirdparty:

1. [`icons/menu-list-blue.ico`](icons/menu-list-blue.ico) downloaded
from [icons-icons.com][icon-menu-list-blue]. (Designer: Juliia Osadcha)
1. [`icons/menu-green.ico`](icons/menu-green.ico) downloaded
from [icons-icons.com][icon-menu-green]. (Designer: Juliia Osadcha)
