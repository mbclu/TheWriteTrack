#!/usr/bin/osascript
on run argv
	set featureFiles to ""
	if (count of argv) > 0
		repeat with arg in argv
			set featureFiles to featureFiles & " " & arg
		end repeat
	end if

	set calabashBuildScript to "xctool -workspace OnTheWriteTrack.xcworkspace/ \\
	 -scheme OnTheWriteTrack-cal \\
	 -configuration Debug \\
	 -destination \"platform=iOS Simulator,name=iPhone 6,OS=8.3\" \\
	 clean \\
	 build"

	set cucumberRunScript to "bundle exec cucumber" & featureFiles

	tell application "Terminal"
		tell application "System Events" to keystroke "n" using {command down}
		do script "cd /Users/clutter/projects/theWriteTrack" in front window
		do script "bundle install" in front window
		do script "echo 'y' > bundle exec calabash-ios download" in front window
		do script calabashBuildScript in front window
		do script "bundle exec calabash-ios sim reset" in front window
		do script cucumberRunScript in front window
	end tell
end run
