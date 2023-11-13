#!/bin/bash

set -eo pipefail

xcodebuild -workspace swdestiny-trades.xcworkspace \
            -scheme SWDestinyTrades \
            -destination platform=iOS\ Simulator,OS=17.0,name=iPhone\ 15 Pro \
            -enableCodeCoverage YES \
            clean test | xcpretty
