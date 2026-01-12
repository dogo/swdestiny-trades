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
  /// Add Card
  internal static let addCard1 = L10n.tr("Localizable", "ADD_CARD_1", fallback: "Add Card")
  /// Add Cards
  internal static let addCards = L10n.tr("Localizable", "ADD_CARDS", fallback: "Add Cards")
  /// Add cards to start building your deck
  internal static let addCardsToStartBuildingYourDeck = L10n.tr("Localizable", "ADD_CARDS_TO_START_BUILDING_YOUR_DECK", fallback: "Add cards to start building your deck")
  /// Add cards to your deck to see statistics
  internal static let addCardsToYourDeckToSeeStatistics = L10n.tr("Localizable", "ADD_CARDS_TO_YOUR_DECK_TO_SEE_STATISTICS", fallback: "Add cards to your deck to see statistics")
  /// Add my card...
  internal static let addMyCard = L10n.tr("Localizable", "ADD_MY_CARD", fallback: "Add my card...")
  /// Add people to track loans
  internal static let addPeopleToTrackLoans = L10n.tr("Localizable", "ADD_PEOPLE_TO_TRACK_LOANS", fallback: "Add people to track loans")
  /// Add Person
  internal static let addPerson = L10n.tr("Localizable", "ADD_PERSON", fallback: "Add Person")
  /// Added
  internal static let added = L10n.tr("Localizable", "ADDED", fallback: "Added")
  /// All Cards
  internal static let allCards = L10n.tr("Localizable", "ALL_CARDS", fallback: "All Cards")
  /// All Sets
  internal static let allSets = L10n.tr("Localizable", "ALL_SETS", fallback: "All Sets")
  /// This card has already been added, please use the quantity control on the previous screen
  internal static let alreadyAdded = L10n.tr("Localizable", "ALREADY_ADDED", fallback: "This card has already been added, please use the quantity control on the previous screen")
  /// App initialized successfully!
  internal static let appInitializedSuccessfully = L10n.tr("Localizable", "APP_INITIALIZED_SUCCESSFULLY", fallback: "App initialized successfully!")
  /// Apply
  internal static let apply = L10n.tr("Localizable", "APPLY", fallback: "Apply")
  /// Are you sure you want to delete %@ %@? This will also remove all associated loan records.
  internal static func areYouSureYouWantToDeletePersonname(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "ARE_YOU_SURE_YOU_WANT_TO_DELETE_PERSONNAME", String(describing: p1), String(describing: p2), fallback: "Are you sure you want to delete %@ %@? This will also remove all associated loan records.")
  }
  /// Are you sure you want to remove %@ from the loan list?
  internal static func areYouSureYouWantToRemove(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ARE_YOU_SURE_YOU_WANT_TO_REMOVE", String(describing: p1), fallback: "Are you sure you want to remove %@ from the loan list?")
  }
  /// Blue
  internal static let blue = L10n.tr("Localizable", "BLUE", fallback: "Blue")
  /// Plural format key: "Borrowed %#@card@"
  internal static func borrowedCard(_ p1: Int) -> String {
    return L10n.tr("Localizable", "BORROWED_CARD", p1, fallback: "Plural format key: \"Borrowed %#@card@\"")
  }
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "CANCEL", fallback: "Cancel")
  /// Card cost
  internal static let cardCost = L10n.tr("Localizable", "CARD_COST", fallback: "Card cost")
  /// Card Information
  internal static let cardInformation = L10n.tr("Localizable", "CARD_INFORMATION", fallback: "Card Information")
  /// Card #
  internal static let cardNumber = L10n.tr("Localizable", "CARD_NUMBER", fallback: "Card #")
  /// Card Text
  internal static let cardText = L10n.tr("Localizable", "CARD_TEXT", fallback: "Card Text")
  /// Card types
  internal static let cardTypes = L10n.tr("Localizable", "CARD_TYPES", fallback: "Card types")
  /// %@
  internal static func cardquantity(_ p1: Any) -> String {
    return L10n.tr("Localizable", "CARDQUANTITY", String(describing: p1), fallback: "%@")
  }
  /// Cards
  internal static let cards = L10n.tr("Localizable", "CARDS", fallback: "Cards")
  /// Plural format key: "%#@card@"
  internal static func cardsCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "CARDS_COUNT", p1, fallback: "Plural format key: \"%#@card@\"")
  }
  /// Clear
  internal static let clear = L10n.tr("Localizable", "CLEAR", fallback: "Clear")
  /// Clear All Filters
  internal static let clearAllFilters = L10n.tr("Localizable", "CLEAR_ALL_FILTERS", fallback: "Clear All Filters")
  /// Clear Search
  internal static let clearSearch = L10n.tr("Localizable", "CLEAR_SEARCH", fallback: "Clear Search")
  /// Close
  internal static let close = L10n.tr("Localizable", "CLOSE", fallback: "Close")
  /// Collection
  internal static let collection = L10n.tr("Localizable", "COLLECTION", fallback: "Collection")
  /// Color
  internal static let color = L10n.tr("Localizable", "COLOR", fallback: "Color")
  /// Create New Deck
  internal static let createNewDeck = L10n.tr("Localizable", "CREATE_NEW_DECK", fallback: "Create New Deck")
  /// Create your first deck to get started
  internal static let createYourFirstDeckToGetStarted = L10n.tr("Localizable", "CREATE_YOUR_FIRST_DECK_TO_GET_STARTED", fallback: "Create your first deck to get started")
  /// Deck Graph
  internal static let deckGraph = L10n.tr("Localizable", "DECK_GRAPH", fallback: "Deck Graph")
  /// Deck Name
  internal static let deckName = L10n.tr("Localizable", "DECK_NAME", fallback: "Deck Name")
  /// Deck Statistics
  internal static let deckStatistics = L10n.tr("Localizable", "DECK_STATISTICS", fallback: "Deck Statistics")
  /// Decks
  internal static let decks = L10n.tr("Localizable", "DECKS", fallback: "Decks")
  /// Decks
  internal static let decks1 = L10n.tr("Localizable", "DECKS_1", fallback: "Decks")
  /// Delete Card
  internal static let deleteCard = L10n.tr("Localizable", "DELETE_CARD", fallback: "Delete Card")
  /// Delete Deck
  internal static let deleteDeck = L10n.tr("Localizable", "DELETE_DECK", fallback: "Delete Deck")
  /// Dice symbols
  internal static let diceSymbols = L10n.tr("Localizable", "DICE_SYMBOLS", fallback: "Dice symbols")
  /// Done
  internal static let done = L10n.tr("Localizable", "DONE", fallback: "Done")
  /// Done
  internal static let done1 = L10n.tr("Localizable", "DONE_1", fallback: "Done")
  /// Downgrade
  internal static let downgrade = L10n.tr("Localizable", "DOWNGRADE", fallback: "Downgrade")
  /// Edit
  internal static let edit = L10n.tr("Localizable", "EDIT", fallback: "Edit")
  /// Elite
  internal static let elite = L10n.tr("Localizable", "ELITE", fallback: "Elite")
  /// Empty Deck
  internal static let emptyDeck = L10n.tr("Localizable", "EMPTY_DECK", fallback: "Empty Deck")
  /// Enter a card name, type, or any keyword to search through all available cards
  internal static let enterACardNameTypeOrAnyKeywordToSearch = L10n.tr("Localizable", "ENTER_A_CARD_NAME_TYPE_OR_ANY_KEYWORD_TO_SEARCH", fallback: "Enter a card name, type, or any keyword to search through all available cards")
  /// Enter the person's name to track loans with them.
  internal static let enterThePersonsNameToTrackLoansWithThem = L10n.tr("Localizable", "ENTER_THE_PERSONS_NAME_TO_TRACK_LOANS_WITH_THEM", fallback: "Enter the person's name to track loans with them.")
  /// Error
  internal static let error = L10n.tr("Localizable", "ERROR", fallback: "Error")
  /// Something is horribly wrong! Tap here to check if swdestinydb.com is online
  internal static let errorMessage = L10n.tr("Localizable", "ERROR_MESSAGE", fallback: "Something is horribly wrong! Tap here to check if swdestinydb.com is online")
  /// Event
  internal static let event = L10n.tr("Localizable", "EVENT", fallback: "Event")
  /// Expansions
  internal static let expansions = L10n.tr("Localizable", "EXPANSIONS", fallback: "Expansions")
  /// Filter Cards
  internal static let filterCards = L10n.tr("Localizable", "FILTER_CARDS", fallback: "Filter Cards")
  /// Filter Collection
  internal static let filterCollection = L10n.tr("Localizable", "FILTER_COLLECTION", fallback: "Filter Collection")
  /// First Name
  internal static let firstName = L10n.tr("Localizable", "FIRST_NAME", fallback: "First Name")
  /// Flavor Text
  internal static let flavorText = L10n.tr("Localizable", "FLAVOR_TEXT", fallback: "Flavor Text")
  /// Generating charts...
  internal static let generatingCharts = L10n.tr("Localizable", "GENERATING_CHARTS", fallback: "Generating charts...")
  /// Graph
  internal static let graph = L10n.tr("Localizable", "GRAPH", fallback: "Graph")
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
  /// Loading...
  internal static let loading = L10n.tr("Localizable", "LOADING", fallback: "Loading...")
  /// Loading deck...
  internal static let loadingDeck = L10n.tr("Localizable", "LOADING_DECK", fallback: "Loading deck...")
  /// Loading decks...
  internal static let loadingDecks = L10n.tr("Localizable", "LOADING_DECKS", fallback: "Loading decks...")
  /// Loans
  internal static let loans = L10n.tr("Localizable", "LOANS", fallback: "Loans")
  /// Local
  internal static let local = L10n.tr("Localizable", "LOCAL", fallback: "Local")
  /// Max Cost:
  internal static let maxCost = L10n.tr("Localizable", "MAX_COST", fallback: "Max Cost:")
  /// Max Cost
  internal static let maxCost1 = L10n.tr("Localizable", "MAX_COST_1", fallback: "Max Cost")
  /// Min Cost:
  internal static let minCost = L10n.tr("Localizable", "MIN_COST", fallback: "Min Cost:")
  /// Min Cost
  internal static let minCost1 = L10n.tr("Localizable", "MIN_COST_1", fallback: "Min Cost")
  /// My Collection
  internal static let myCollection = L10n.tr("Localizable", "MY_COLLECTION", fallback: "My Collection")
  /// My Collection
  internal static let myCollection1 = L10n.tr("Localizable", "MY_COLLECTION_1", fallback: "My Collection")
  /// New Person
  internal static let newPerson = L10n.tr("Localizable", "NEW_PERSON", fallback: "New Person")
  /// New Person
  internal static let newPerson1 = L10n.tr("Localizable", "NEW_PERSON_1", fallback: "New Person")
  /// No cards match '%@'. Try a different search term.
  internal static func noCardsMatchViewmodelcurrentqueryTryA(_ p1: Any) -> String {
    return L10n.tr("Localizable", "NO_CARDS_MATCH_VIEWMODELCURRENTQUERY_TRY_A", String(describing: p1), fallback: "No cards match '%@'. Try a different search term.")
  }
  /// No Data Available
  internal static let noDataAvailable = L10n.tr("Localizable", "NO_DATA_AVAILABLE", fallback: "No Data Available")
  /// No decks match '%@'
  internal static func noDecksMatchViewmodelsearchtext(_ p1: Any) -> String {
    return L10n.tr("Localizable", "NO_DECKS_MATCH_VIEWMODELSEARCHTEXT", String(describing: p1), fallback: "No decks match '%@'")
  }
  /// No Decks Yet
  internal static let noDecksYet = L10n.tr("Localizable", "NO_DECKS_YET", fallback: "No Decks Yet")
  /// No loans
  internal static let noLoans = L10n.tr("Localizable", "NO_LOANS", fallback: "No loans")
  /// No people found
  internal static let noPeopleFound = L10n.tr("Localizable", "NO_PEOPLE_FOUND", fallback: "No people found")
  /// No people yet
  internal static let noPeopleYet = L10n.tr("Localizable", "NO_PEOPLE_YET", fallback: "No people yet")
  /// No Results
  internal static let noResults = L10n.tr("Localizable", "NO_RESULTS", fallback: "No Results")
  /// No Results Found
  internal static let noResultsFound = L10n.tr("Localizable", "NO_RESULTS_FOUND", fallback: "No Results Found")
  /// Non-Elite
  internal static let nonElite = L10n.tr("Localizable", "NON_ELITE", fallback: "Non-Elite")
  /// People
  internal static let people = L10n.tr("Localizable", "PEOPLE", fallback: "People")
  /// Person Information
  internal static let personInformation = L10n.tr("Localizable", "PERSON_INFORMATION", fallback: "Person Information")
  /// %@ %@
  internal static func personnamePersonlastname(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "PERSONNAME_PERSONLASTNAME", String(describing: p1), String(describing: p2), fallback: "%@ %@")
  }
  /// Plot
  internal static let plot = L10n.tr("Localizable", "PLOT", fallback: "Plot")
  /// Popular Searches
  internal static let popularSearches = L10n.tr("Localizable", "POPULAR_SEARCHES", fallback: "Popular Searches")
  /// %@
  internal static func quantity(_ p1: Any) -> String {
    return L10n.tr("Localizable", "QUANTITY", String(describing: p1), fallback: "%@")
  }
  /// Red
  internal static let red = L10n.tr("Localizable", "RED", fallback: "Red")
  /// Remote
  internal static let remote = L10n.tr("Localizable", "REMOTE", fallback: "Remote")
  /// Retry
  internal static let retry = L10n.tr("Localizable", "RETRY", fallback: "Retry")
  /// Save Person
  internal static let savePerson = L10n.tr("Localizable", "SAVE_PERSON", fallback: "Save Person")
  /// Search
  internal static let search = L10n.tr("Localizable", "SEARCH", fallback: "Search")
  /// Search
  internal static let search1 = L10n.tr("Localizable", "SEARCH_1", fallback: "Search")
  /// Search for Cards
  internal static let searchForCards = L10n.tr("Localizable", "SEARCH_FOR_CARDS", fallback: "Search for Cards")
  /// Searching for '%@'...
  internal static func searchingForQuery(_ p1: Any) -> String {
    return L10n.tr("Localizable", "SEARCHING_FOR_QUERY", String(describing: p1), fallback: "Searching for '%@'...")
  }
  /// (%@)
  internal static func sectioncardcount(_ p1: Any) -> String {
    return L10n.tr("Localizable", "SECTIONCARDCOUNT", String(describing: p1), fallback: "(%@)")
  }
  /// Shared with SWD Trades for iOS
  internal static let shareText = L10n.tr("Localizable", "SHARE_TEXT", fallback: "Shared with SWD Trades for iOS")
  /// Plural format key: "%#@side@"
  internal static func sidesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SIDES_COUNT", p1, fallback: "Plural format key: \"%#@side@\"")
  }
  /// Suggestions
  internal static let suggestions = L10n.tr("Localizable", "SUGGESTIONS", fallback: "Suggestions")
  /// Support
  internal static let support = L10n.tr("Localizable", "SUPPORT", fallback: "Support")
  /// SWDestiny Trades
  internal static let swdestinyTrades = L10n.tr("Localizable", "SWDESTINY_TRADES", fallback: "SWDestiny Trades")
  /// https://swdestinydb.com
  internal static let swdestinydbWebsite = L10n.tr("Localizable", "SWDESTINYDB_WEBSITE", fallback: "https://swdestinydb.com")
  /// SwiftUI Migration in Progress
  internal static let swiftuiMigrationInProgress = L10n.tr("Localizable", "SWIFTUI_MIGRATION_IN_PROGRESS", fallback: "SwiftUI Migration in Progress")
  /// Total Cards: %@
  internal static func totalCardsViewmodeltotalcardcount(_ p1: Any) -> String {
    return L10n.tr("Localizable", "TOTAL_CARDS_VIEWMODELTOTALCARDCOUNT", String(describing: p1), fallback: "Total Cards: %@")
  }
  /// Try adjusting your search terms
  internal static let tryAdjustingYourSearchTerms = L10n.tr("Localizable", "TRY_ADJUSTING_YOUR_SEARCH_TERMS", fallback: "Try adjusting your search terms")
  /// Unique Cards: %@
  internal static func uniqueCardsViewmodeluniquecardcount(_ p1: Any) -> String {
    return L10n.tr("Localizable", "UNIQUE_CARDS_VIEWMODELUNIQUECARDCOUNT", String(describing: p1), fallback: "Unique Cards: %@")
  }
  /// Upgrade
  internal static let upgrade = L10n.tr("Localizable", "UPGRADE", fallback: "Upgrade")
  /// version %@ (%@)
  internal static func version(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "VERSION", String(describing: p1), String(describing: p2), fallback: "version %@ (%@)")
  }
  /// %@ results for '%@'
  internal static func viewmodelsearchresultscountResultsFor(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "VIEWMODELSEARCHRESULTSCOUNT_RESULTS_FOR", String(describing: p1), String(describing: p2), fallback: "%@ results for '%@'")
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
