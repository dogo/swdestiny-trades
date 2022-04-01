SWDestiny Trades
============

[![Testing Status](https://github.com/dogo/swdestiny-trades/workflows/Testing/badge.svg)](https://github.com/dogo/swdestiny-trades/actions)
[![codecov](https://codecov.io/gh/dogo/swdestiny-trades/branch/develop/graph/badge.svg)](https://codecov.io/gh/dogo/swdestiny-trades)

### About SWDTrades

SWD Trades gives you the tools you need for Star Wars Destiny, right at your fingertips. It includes card search by expansion or card name, allows you to track cards you have loaned or borrowed and manage your collection.

Features:  
• The most complete cards database.  
• Track cards you have lent out or borrowed from other people.  
• Sort the card list alphabetically, by color or by collection number.  
• Deck-builder with statistics.  
• Share cards, your collection or decks with your friends.  
• Universal app for iPhone and iPad.  
• Collection manager.  
• Ready for iOS 14.  

This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.  

<img src="https://github.com/dogo/swdestiny-trades/raw/develop/fastlane/screenshots/en-US/1_iphone6Plus_1.Simulator Screen Shot - iPhone 8 Plus.png" alt="SWDestiny Trades Screenshot" width="310" height="552" />

### Building SWDTrades

Run the Tuist command:

```bash
$ tuist fetch
```

Then:

```bash
$ tuist generate --no-open
```

Run the CocoaPods command:

```bash
$ pod install
```

Then, open the `swdestiny-trades.xcworkspace`

```bash
$ open swdestiny-trades.xcworkspace
```

Now, just build :D

### Collaboration
I'm sure there are ways of improving and adding more features, so feel free to collaborate with ideas, issues and/or pull requests.

## License

SWDestiny Trades is released under the MIT license. See LICENSE for details.
