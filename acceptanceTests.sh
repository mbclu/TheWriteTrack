#!/bin/bash

FEATURE_FILES=${1}

killall 'iOS Simulator' 1&>/dev/null

bundle install

bundle exec pod install

echo 'y' | bundle exec calabash-ios download

xctool -workspace TheWriteTrack.xcworkspace/ \
	 -scheme TheWriteTrack-cal \
	 -configuration Debug \
	 -destination "platform=iOS Simulator,name=iPhone 6,OS=8.3" \
	 clean \
	 build

bundle exec calabash-ios sim reset

bundle exec cucumber ${FEATURE_FILES}

killall 'iOS Simulator' 1&>/dev/null
