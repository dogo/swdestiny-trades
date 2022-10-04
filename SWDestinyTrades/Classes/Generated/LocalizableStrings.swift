// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
    /// A-Z
    internal static let aToZ = L10n.tr("Localizable", "A_TO_Z", fallback: "A-Z")
    /// Localizable.strings
    ///   swdestiny-trades
    ///
    ///   Created by Diogo Autilio on 10/01/17.
    ///   Copyright © 2017 Diogo Autilio. All rights reserved.
    internal static let about = L10n.tr("Localizable", "ABOUT", fallback: "About")
    /// By Diogo Autilio
    ///
    /// API Data by Paco %@
    ///
    /// The information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.
    internal static func aboutText(_ p1: Any) -> String {
        return L10n.tr("Localizable", "ABOUT_TEXT", String(describing: p1), fallback: "By Diogo Autilio\n\nAPI Data by Paco %@\n\nThe information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.")
    }

    /// Add card
    internal static let addCard = L10n.tr("Localizable", "ADD_CARD", fallback: "Add card")
    /// Add my card...
    internal static let addMyCard = L10n.tr("Localizable", "ADD_MY_CARD", fallback: "Add my card...")
    /// Added
    internal static let added = L10n.tr("Localizable", "ADDED", fallback: "Added")
    /// All Cards
    internal static let allCards = L10n.tr("Localizable", "ALL_CARDS", fallback: "All Cards")
    /// This card has already been added, please use the quantity control on the previous screen
    internal static let alreadyAdded = L10n.tr("Localizable", "ALREADY_ADDED", fallback: "This card has already been added, please use the quantity control on the previous screen")
    /// Blue
    internal static let blue = L10n.tr("Localizable", "BLUE", fallback: "Blue")
    /// Plural format key: "Borrowed %#@card@"
    internal static func borrowedCard(_ p1: Int) -> String {
        return L10n.tr("Localizable", "BORROWED_CARD", p1, fallback: "Plural format key: \"Borrowed %#@card@\"")
    }

    /// Card cost
    internal static let cardCost = L10n.tr("Localizable", "CARD_COST", fallback: "Card cost")
    /// Card #
    internal static let cardNumber = L10n.tr("Localizable", "CARD_NUMBER", fallback: "Card #")
    /// Card types
    internal static let cardTypes = L10n.tr("Localizable", "CARD_TYPES", fallback: "Card types")
    /// Cards
    internal static let cards = L10n.tr("Localizable", "CARDS", fallback: "Cards")
    /// Plural format key: "%#@card@"
    internal static func cardsCount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "CARDS_COUNT", p1, fallback: "Plural format key: \"%#@card@\"")
    }

    /// Close
    internal static let close = L10n.tr("Localizable", "CLOSE", fallback: "Close")
    /// Collection
    internal static let collection = L10n.tr("Localizable", "COLLECTION", fallback: "Collection")
    /// Color
    internal static let color = L10n.tr("Localizable", "COLOR", fallback: "Color")
    /// Deck Name
    internal static let deckName = L10n.tr("Localizable", "DECK_NAME", fallback: "Deck Name")
    /// Deck Statistics
    internal static let deckStatistics = L10n.tr("Localizable", "DECK_STATISTICS", fallback: "Deck Statistics")
    /// Decks
    internal static let decks = L10n.tr("Localizable", "DECKS", fallback: "Decks")
    /// Dice symbols
    internal static let diceSymbols = L10n.tr("Localizable", "DICE_SYMBOLS", fallback: "Dice symbols")
    /// Done
    internal static let done = L10n.tr("Localizable", "DONE", fallback: "Done")
    /// Downgrade
    internal static let downgrade = L10n.tr("Localizable", "DOWNGRADE", fallback: "Downgrade")
    /// Edit
    internal static let edit = L10n.tr("Localizable", "EDIT", fallback: "Edit")
    /// Elite
    internal static let elite = L10n.tr("Localizable", "ELITE", fallback: "Elite")
    /// Something is horribly wrong! Tap here to check if swdestinydb.com is online
    internal static let errorMessage = L10n.tr("Localizable", "ERROR_MESSAGE", fallback: "Something is horribly wrong! Tap here to check if swdestinydb.com is online")
    /// Event
    internal static let event = L10n.tr("Localizable", "EVENT", fallback: "Event")
    /// Expansions
    internal static let expansions = L10n.tr("Localizable", "EXPANSIONS", fallback: "Expansions")
    /// First Name
    internal static let firstName = L10n.tr("Localizable", "FIRST_NAME", fallback: "First Name")
    /// Gray
    internal static let gray = L10n.tr("Localizable", "GRAY", fallback: "Gray")
    /// Has borrowed my:
    internal static let hasBorrowedMy = L10n.tr("Localizable", "HAS_BORROWED_MY", fallback: "Has borrowed my:")
    /// Has lent me:
    internal static let hasLentMe = L10n.tr("Localizable", "HAS_LENT_ME", fallback: "Has lent me:")
    /// Last Name
    internal static let lastName = L10n.tr("Localizable", "LAST_NAME", fallback: "Last Name")
    /// Last update: %@
    internal static func lastUpdate(_ p1: Any) -> String {
        return L10n.tr("Localizable", "LAST_UPDATE", String(describing: p1), fallback: "Last update: %@")
    }

    /// Plural format key: "Lent me %#@card@ & borrowed %#@card@"
    internal static func lentMeAndBorrowedCards(_ p1: Int, _ p2: Int) -> String {
        return L10n.tr("Localizable", "LENT_ME_AND_BORROWED_CARDS", p1, p2, fallback: "Plural format key: \"Lent me %#@card@ & borrowed %#@card@\"")
    }

    /// Plural format key: "Lent me %#@card@"
    internal static func lentMeCard(_ p1: Int) -> String {
        return L10n.tr("Localizable", "LENT_ME_CARD", p1, fallback: "Plural format key: \"Lent me %#@card@\"")
    }

    /// Loans
    internal static let loans = L10n.tr("Localizable", "LOANS", fallback: "Loans")
    /// My Collection
    internal static let myCollection = L10n.tr("Localizable", "MY_COLLECTION", fallback: "My Collection")
    /// New Person
    internal static let newPerson = L10n.tr("Localizable", "NEW_PERSON", fallback: "New Person")
    /// No loans
    internal static let noLoans = L10n.tr("Localizable", "NO_LOANS", fallback: "No loans")
    /// Non-Elite
    internal static let nonElite = L10n.tr("Localizable", "NON_ELITE", fallback: "Non-Elite")
    /// People
    internal static let people = L10n.tr("Localizable", "PEOPLE", fallback: "People")
    /// Plot
    internal static let plot = L10n.tr("Localizable", "PLOT", fallback: "Plot")
    /// Red
    internal static let red = L10n.tr("Localizable", "RED", fallback: "Red")
    /// Search
    internal static let search = L10n.tr("Localizable", "SEARCH", fallback: "Search")
    /// Shared with SWD Trades for iOS
    internal static let shareText = L10n.tr("Localizable", "SHARE_TEXT", fallback: "Shared with SWD Trades for iOS")
    /// Plural format key: "%#@side@"
    internal static func sidesCount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "SIDES_COUNT", p1, fallback: "Plural format key: \"%#@side@\"")
    }

    /// Support
    internal static let support = L10n.tr("Localizable", "SUPPORT", fallback: "Support")
    /// https://swdestinydb.com
    internal static let swdestinydbWebsite = L10n.tr("Localizable", "SWDESTINYDB_WEBSITE", fallback: "https://swdestinydb.com")
    /// Upgrade
    internal static let upgrade = L10n.tr("Localizable", "UPGRADE", fallback: "Upgrade")
    /// version %@ (%@)
    internal static func version(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "VERSION", String(describing: p1), String(describing: p2), fallback: "version %@ (%@)")
    }

    /// Yellow
    internal static let yellow = L10n.tr("Localizable", "YELLOW", fallback: "Yellow")
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
