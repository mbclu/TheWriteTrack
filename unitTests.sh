xctool -workspace OnTheWriteTrack.xcworkspace/ -scheme OnTheWriteTrack -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.3' clean build test -freshSimulator -resetSimulator -freshInstall -parallelize -sdk 'iphonesimulator'
killall 'iOS Simulator'

