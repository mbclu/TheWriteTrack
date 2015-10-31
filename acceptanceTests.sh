#!/bin/bash --login

FEATURE_FILES=${1}

CURRENT_DIR=`pwd`
BUILD_DIR="$CURRENT_DIR/build"
BUILD_OUTPUT_DIR="$BUILD_DIR/Build/Products/Debug-iphonesimulator"
APP_NAME="TheWriteTrack"
SIM_DEVICE='iPhone 6'
OS_VERSION='9.0'
PLATFORM='iOS Simulator'


function stop_sim_if_necessary {
    if [[ "$PLATFORM" == "iOS Simulator" ]]; then
        killall 'iOS Simulator' 1&>/dev/null
    fi
}

function clean_environment {
    rm -rf $BUILD_DIR
    bundle install
    bundle exec pod install
    bundle exec calabash-ios sim reset
}

function run_tests {
    xcrun xcodebuild \
     -derivedDataPath "${BUILD_DIR}" \
     ARCHS="i386 x86_64" \
     VALID_ARCHS="i386 x86_64" \
     ONLY_ACTIVE_ARCH=NO \
     -workspace $APP_NAME.xcworkspace/ \
     -scheme $APP_NAME-cal \
     -sdk iphonesimulator \
     -configuration Debug \
     clean build

    export DEVICE_TARGET=`instruments -s devices | grep -v "+" | grep "${SIM_DEVICE} (${OS_VERSION})"`
    export APP="$BUILD_DIR/Build/Products/Debug-iphonesimulator/$APP_NAME.app"
    bundle exec "DEBUG=1 cucumber ${FEATURE_FILES}"
}

#______EXECUTE_________________________

stop_sim_if_necessary

clean_environment

run_tests

stop_sim_if_necessary

#______FIN______________________________

