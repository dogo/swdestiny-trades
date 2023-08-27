#!/bin/bash

set -eo pipefail

xcodebuild -workspace swdestiny-trades.xcworkspace \
            -scheme SWDestinyTrades \
            -destination platform=iOS\ Simulator,OS=16.4,name=iPhone\ 14 \
            -enableCodeCoverage YES \
            clean test | xcpretty
