#!/usr/bin/env bash

TRAVIS_XCODE_WORKSPACE=Guanaco.xcworkspace
TRAVIS_XCODE_SCHEME=Guanaco-iOS
destination_id='platform=iOS Simulator,name=iPhone 6s'
TRAVIS_XCODE_SDK=iphonesimulator

set -o xtrace
xcodebuild \
-workspace "$TRAVIS_XCODE_WORKSPACE" \
-scheme "$TRAVIS_XCODE_SCHEME" \
${TRAVIS_XCODE_SDK+-sdk $TRAVIS_XCODE_SDK }\
${destination_id+-destination "$destination_id" }\
test
set +o xtrace