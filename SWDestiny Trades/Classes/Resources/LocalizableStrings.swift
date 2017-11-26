// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// A-Z
  static let aToZ = L10n.tr("Localizable", "A_TO_Z")
  /// About
  static let about = L10n.tr("Localizable", "ABOUT")
  /// By Diogo Autilio\n\nAPI Data by Paco http://swdestinydb.com\n\nThe information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.
  static let aboutText = L10n.tr("Localizable", "ABOUT_TEXT")
  /// Add card
  static let addCard = L10n.tr("Localizable", "ADD_CARD")
  /// Add my card...
  static let addMyCard = L10n.tr("Localizable", "ADD_MY_CARD")
  /// Added
  static let added = L10n.tr("Localizable", "ADDED")
  /// All Cards
  static let allCards = L10n.tr("Localizable", "ALL_CARDS")
  /// This card has already been added, please use the quantity control on the previous screen
  static let alreadyAdded = L10n.tr("Localizable", "ALREADY_ADDED")
  /// Blue
  static let blue = L10n.tr("Localizable", "BLUE")
  /// Card cost
  static let cardCost = L10n.tr("Localizable", "CARD_COST")
  /// Card #
  static let cardNumber = L10n.tr("Localizable", "CARD_NUMBER")
  /// Card types
  static let cardTypes = L10n.tr("Localizable", "CARD_TYPES")
  /// Cards
  static let cards = L10n.tr("Localizable", "CARDS")
  /// Close
  static let close = L10n.tr("Localizable", "CLOSE")
  /// Collection
  static let collection = L10n.tr("Localizable", "COLLECTION")
  /// Color
  static let color = L10n.tr("Localizable", "COLOR")
  /// Deck Name
  static let deckName = L10n.tr("Localizable", "DECK_NAME")
  /// Deck Statistics
  static let deckStatistics = L10n.tr("Localizable", "DECK_STATISTICS")
  /// Decks
  static let decks = L10n.tr("Localizable", "DECKS")
  /// Dice symbols
  static let diceSymbols = L10n.tr("Localizable", "DICE_SYMBOLS")
  /// Done
  static let done = L10n.tr("Localizable", "DONE")
  /// Edit
  static let edit = L10n.tr("Localizable", "EDIT")
  /// Something is horribly wrong! Tap here to check if swdestinydb.com is online
  static let errorMessage = L10n.tr("Localizable", "ERROR_MESSAGE")
  /// Expansions
  static let expansions = L10n.tr("Localizable", "EXPANSIONS")
  /// First Name
  static let firstName = L10n.tr("Localizable", "FIRST_NAME")
  /// Gray
  static let gray = L10n.tr("Localizable", "GRAY")
  /// Has borrowed my:
  static let hasBorrowedMy = L10n.tr("Localizable", "HAS_BORROWED_MY")
  /// Has lent me:
  static let hasLentMe = L10n.tr("Localizable", "HAS_LENT_ME")
  /// Last Name
  static let lastName = L10n.tr("Localizable", "LAST_NAME")
  /// Loans
  static let loans = L10n.tr("Localizable", "LOANS")
  /// My Collection
  static let myCollection = L10n.tr("Localizable", "MY_COLLECTION")
  /// New Person
  static let newPerson = L10n.tr("Localizable", "NEW_PERSON")
  /// No loans
  static let noLoans = L10n.tr("Localizable", "NO_LOANS")
  /// People
  static let people = L10n.tr("Localizable", "PEOPLE")
  /// Red
  static let red = L10n.tr("Localizable", "RED")
  /// Search
  static let search = L10n.tr("Localizable", "SEARCH")
  /// Shared with SWD Trades for iOS
  static let shareText = L10n.tr("Localizable", "SHARE_TEXT")
  /// version %@ (%@)
  static func version(_ p1: String, _ p2: String) -> String {
    return L10n.tr("Localizable", "VERSION", p1, p2)
  }
  /// Yellow
  static let yellow = L10n.tr("Localizable", "YELLOW")
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
