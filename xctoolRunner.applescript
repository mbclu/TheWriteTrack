#!/usr/bin/osascript

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
	tell application "System Events" to keystroke "t" using {command down}
	do script xctoolScript in front window
end tell
