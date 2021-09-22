#!/bin/bash

set -eo pipefail

xcodebuild -workspace swdestiny-trades.xcworkspace \
            -scheme SWDestiny-Trades \
            -destination platform=iOS\ Simulator,OS=15.0,name=iPhone\ 11 \
            clean test | xcpretty
