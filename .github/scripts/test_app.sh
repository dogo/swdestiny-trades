#!/bin/bash

set -eo pipefail

xcodebuild -workspace swdestiny-trades.xcworkspace \
            -scheme SWDestinyTrades \
            -destination platform=iOS\ Simulator,OS=16.0,name=iPhone\ 11 \
            -enableCodeCoverage YES \
            clean test | xcpretty
