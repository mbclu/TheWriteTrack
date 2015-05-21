#!/usr/bin/osascript
on run argv
	set featureFiles to ""
	if (count of argv) > 0
		set i to 0
		repeat with arg in argv
		if (i > 0)
			set featureFiles to featureFiles & " " & arg
		else
			set featureFiles to arg
		end if
		set i to (i + 1)
		end repeat
	end if

	set cucumberRunScript to "./acceptanceTests.sh \"" & featureFiles & "\""

	tell application "Terminal"
		tell application "System Events" to keystroke "n" using {command down}
		do script "cd /Users/clutter/projects/theWriteTrack" in front window
		do script cucumberRunScript in front window
	end tell
end run
