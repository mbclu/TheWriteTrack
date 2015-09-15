#!/bin/bash --login

FEATURE_FILES=${1}

CURRENT_DIR=`pwd`
BUILD_DIR="$CURRENT_DIR/build_acceptanceTest"
APP_NAME="TheWriteTrack"

killall 'iOS Simulator' 1&>/dev/null

rm -rf $BUILD_DIR

bundle install

bundle exec pod install

xctool \
     -workspace $APP_NAME.xcworkspace/ \
	 -scheme $APP_NAME-cal \
     CONFIGURATION_BUILD_DIR=$BUILD_DIR \
	 -destination "platform=iOS Simulator,name=iPhone 6,OS=8.3" \
     -configuration Debug \
     -sdk iphonesimulator \
	 clean \
	 build

bundle exec calabash-ios sim reset

bundle exec "APP_BUNDLE_PATH=$BUILD_DIR/$APP_NAME.app TARGET_DEVICE='iPhone 6 (iOS 8.3)' cucumber ${FEATURE_FILES}"

killall 'iOS Simulator' 1&>/dev/null
