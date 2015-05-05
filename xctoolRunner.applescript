#!/usr/bin/osascript

set changeDirectory to "cd /Users/clutter/projects/theWriteTrack"

set xctoolScript to "xctool -workspace OnTheWriteTrack.xcworkspace/ \\
 -scheme OnTheWriteTrack \\
 -configuration Debug \\
 -destination \"platform=iOS Simulator,name=iPhone 6,OS=8.3\" \\
 clean \\
 build \\
 test \\
 -freshSimulator \\
 -resetSimulator \\
 -freshInstall \\
 -parallelize \\
 -sdk \"iphonesimulator\""

tell application "Terminal"
	tell application "System Events" to keystroke "n" using {command down}
	do script changeDirectory in front window
	do script xctoolScript in front window
end tell
