TEST_CLASS=$1

killall 'iOS Simulator'

xctool -workspace OnTheWriteTrack.xcworkspace/ \
	 -scheme OnTheWriteTrack \
	 -configuration Debug \
	 -destination "platform=iOS Simulator,name=iPhone 6,OS=8.3" \
	 clean \
	 test \
	 -only OnTheWriteTrackTests $TEST_CLASS\
	 -freshSimulator \
	 -resetSimulator \
	 -freshInstall \
	 -parallelize \
	 -sdk "iphonesimulator"

killall 'iOS Simulator'
