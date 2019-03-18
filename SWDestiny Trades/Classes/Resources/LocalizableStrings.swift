// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// A-Z
  internal static let aToZ = L10n.tr("Localizable", "A_TO_Z")
  /// About
  internal static let about = L10n.tr("Localizable", "ABOUT")
  /// By Diogo Autilio\n\nAPI Data by Paco http://swdestinydb.com\n\nThe information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.
  internal static let aboutText = L10n.tr("Localizable", "ABOUT_TEXT")
  /// Add card
  internal static let addCard = L10n.tr("Localizable", "ADD_CARD")
  /// Add my card...
  internal static let addMyCard = L10n.tr("Localizable", "ADD_MY_CARD")
  /// Added
  internal static let added = L10n.tr("Localizable", "ADDED")
  /// All Cards
  internal static let allCards = L10n.tr("Localizable", "ALL_CARDS")
  /// This card has already been added, please use the quantity control on the previous screen
  internal static let alreadyAdded = L10n.tr("Localizable", "ALREADY_ADDED")
  /// Blue
  internal static let blue = L10n.tr("Localizable", "BLUE")
  /// Card cost
  internal static let cardCost = L10n.tr("Localizable", "CARD_COST")
  /// Card #
  internal static let cardNumber = L10n.tr("Localizable", "CARD_NUMBER")
  /// Card types
  internal static let cardTypes = L10n.tr("Localizable", "CARD_TYPES")
  /// Cards
  internal static let cards = L10n.tr("Localizable", "CARDS")
  /// Close
  internal static let close = L10n.tr("Localizable", "CLOSE")
  /// Collection
  internal static let collection = L10n.tr("Localizable", "COLLECTION")
  /// Color
  internal static let color = L10n.tr("Localizable", "COLOR")
  /// Deck Name
  internal static let deckName = L10n.tr("Localizable", "DECK_NAME")
  /// Deck Statistics
  internal static let deckStatistics = L10n.tr("Localizable", "DECK_STATISTICS")
  /// Decks
  internal static let decks = L10n.tr("Localizable", "DECKS")
  /// Dice symbols
  internal static let diceSymbols = L10n.tr("Localizable", "DICE_SYMBOLS")
  /// Done
  internal static let done = L10n.tr("Localizable", "DONE")
  /// Downgrade
  internal static let downgrade = L10n.tr("Localizable", "DOWNGRADE")
  /// Edit
  internal static let edit = L10n.tr("Localizable", "EDIT")
  /// Elite
  internal static let elite = L10n.tr("Localizable", "ELITE")
  /// Something is horribly wrong! Tap here to check if swdestinydb.com is online
  internal static let errorMessage = L10n.tr("Localizable", "ERROR_MESSAGE")
  /// Event
  internal static let event = L10n.tr("Localizable", "EVENT")
  /// Expansions
  internal static let expansions = L10n.tr("Localizable", "EXPANSIONS")
  /// First Name
  internal static let firstName = L10n.tr("Localizable", "FIRST_NAME")
  /// Gray
  internal static let gray = L10n.tr("Localizable", "GRAY")
  /// Has borrowed my:
  internal static let hasBorrowedMy = L10n.tr("Localizable", "HAS_BORROWED_MY")
  /// Has lent me:
  internal static let hasLentMe = L10n.tr("Localizable", "HAS_LENT_ME")
  /// Last Name
  internal static let lastName = L10n.tr("Localizable", "LAST_NAME")
  /// Last update: %@
  internal static func lastUpdate(_ p1: String) -> String {
    return L10n.tr("Localizable", "LAST_UPDATE", p1)
  }
  /// Loans
  internal static let loans = L10n.tr("Localizable", "LOANS")
  /// My Collection
  internal static let myCollection = L10n.tr("Localizable", "MY_COLLECTION")
  /// New Person
  internal static let newPerson = L10n.tr("Localizable", "NEW_PERSON")
  /// No loans
  internal static let noLoans = L10n.tr("Localizable", "NO_LOANS")
  /// Non-Elite
  internal static let nonElite = L10n.tr("Localizable", "NON_ELITE")
  /// People
  internal static let people = L10n.tr("Localizable", "PEOPLE")
  /// Plot
  internal static let plot = L10n.tr("Localizable", "PLOT")
  /// Red
  internal static let red = L10n.tr("Localizable", "RED")
  /// Search
  internal static let search = L10n.tr("Localizable", "SEARCH")
  /// Shared with SWD Trades for iOS
  internal static let shareText = L10n.tr("Localizable", "SHARE_TEXT")
  /// Support
  internal static let support = L10n.tr("Localizable", "SUPPORT")
  /// Upgrade
  internal static let upgrade = L10n.tr("Localizable", "UPGRADE")
  /// version %@ (%@)
  internal static func version(_ p1: String, _ p2: String) -> String {
    return L10n.tr("Localizable", "VERSION", p1, p2)
  }
  /// Yellow
  internal static let yellow = L10n.tr("Localizable", "YELLOW")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
