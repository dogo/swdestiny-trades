#!/bin/bash

set -eo pipefail

xcodebuild -workspace swdestiny-trades-tuist.xcworkspace \
            -scheme SWDestinyTrades \
            -destination platform=iOS\ Simulator,OS=15.2,name=iPhone\ 11 \
            clean test | xcpretty
