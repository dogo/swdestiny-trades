#!/bin/sh

rm -Rf ~/Library/Developer/Xcode/DerivedData/*
rm -Rf coverage_report
xcodebuild clean build -workspace swdestiny-trades.xcworkspace -scheme SWDestiny-Trades -destination 'platform=iOS Simulator,name=iPhone 5s' VALID_ARCHS=x86_64 test | xcpretty -tc
bundle exec slather
open coverage_report/index.html
