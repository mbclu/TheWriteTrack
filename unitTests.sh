#!/bin/bash

TEST_CLASS=$1

killall 'iOS Simulator' 1&>/dev/null

bundle install
bundle exec pod install

xctool -workspace OnTheWriteTrack.xcworkspace/ \
	 -scheme OnTheWriteTrack \
	 -configuration Debug \
	 -destination "platform=iOS Simulator,name=iPhone 6,OS=8.3" \
	 -reporter pretty \
	 -reporter junit:unitTestResults.xml \
	 clean \
	 test \
	 -only OnTheWriteTrackTests $TEST_CLASS\
	 -freshSimulator \
	 -resetSimulator \
	 -freshInstall \
	 -parallelize \
	 -sdk "iphonesimulator"

killall 'iOS Simulator' 1&>/dev/null
