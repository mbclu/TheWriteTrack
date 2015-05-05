#!/usr/bin/osascript

set calabashBuildScript to "xctool -workspace OnTheWriteTrack.xcworkspace/ \\
 -scheme OnTheWriteTrack-cal \\
 -configuration Debug \\
 -destination \"platform=iOS Simulator,name=iPhone 6,OS=8.3\" \\
 clean \\
 build"

tell application "Terminal"
	tell application "System Events" to keystroke "n" using {command down}
	do script "cd /Users/clutter/projects/theWriteTrack" in front window
	do script "bundle install" in front window
	do script "echo 'y' > bundle exec calabash-ios download" in front window
	do script calabashBuildScript in front window
	do script "bundle exec calabash-ios sim reset" in front window
	do script "bundle exec cucumber" in front window
end tell
