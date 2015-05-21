#!/usr/bin/osascript
on run argv
	set testClass to ""
	if (count of argv) > 0
		set testClass to ":" & (item 1 of argv)
	end if

	set changeDirectory to "cd /Users/clutter/projects/theWriteTrack"

	set xctoolScript to "./unitTests.sh"

	tell application "Terminal"
		tell application "System Events" to keystroke "n" using {command down}
		do script changeDirectory in front window
		do script xctoolScript in front window
	end tell
end run
