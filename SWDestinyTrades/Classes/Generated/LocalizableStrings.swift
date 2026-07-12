// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// A–Z
  internal static let aToZ = L10n.tr("Localizable", "A_TO_Z", fallback: "A–Z")
  /// Localizable.strings
  ///   swdestiny-trades
  /// 
  ///   Created by Diogo Autilio on 10/01/17.
  ///   Copyright © 2017 Diogo Autilio. All rights reserved.
  internal static let about = L10n.tr("Localizable", "ABOUT", fallback: "About")
  /// By Diogo Autilio
  /// 
  /// API Data by ARH Team %@
  /// 
  /// The information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.
  internal static func aboutText(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ABOUT_TEXT", String(describing: p1), fallback: "By Diogo Autilio\n\nAPI Data by ARH Team %@\n\nThe information presented on this app about Star Wars Destiny, both literal and graphical, is copyrighted by Fantasy Flight Games. This app is not produced, endorsed, supported, or affiliated with Fantasy Flight Games.")
  }
  /// Add Borrowed Card
  internal static let addBorrowedCard = L10n.tr("Localizable", "ADD_BORROWED_CARD", fallback: "Add Borrowed Card")
  /// Add card
  internal static let addCard = L10n.tr("Localizable", "ADD_CARD", fallback: "Add card")
  /// Add cards
  internal static let addCards = L10n.tr("Localizable", "ADD_CARDS", fallback: "Add cards")
  /// Add cards to start building your deck
  internal static let addCardsToStartBuildingYourDeck = L10n.tr("Localizable", "ADD_CARDS_TO_START_BUILDING_YOUR_DECK", fallback: "Add cards to start building your deck")
  /// Add cards to your deck to see statistics
  internal static let addCardsToYourDeckToSeeStatistics = L10n.tr("Localizable", "ADD_CARDS_TO_YOUR_DECK_TO_SEE_STATISTICS", fallback: "Add cards to your deck to see statistics")
  /// Add Lent Card
  internal static let addLentCard = L10n.tr("Localizable", "ADD_LENT_CARD", fallback: "Add Lent Card")
  /// Add my card…
  internal static let addMyCard = L10n.tr("Localizable", "ADD_MY_CARD", fallback: "Add my card…")
  /// Add people to track loans
  internal static let addPeopleToTrackLoans = L10n.tr("Localizable", "ADD_PEOPLE_TO_TRACK_LOANS", fallback: "Add people to track loans")
  /// Add person
  internal static let addPerson = L10n.tr("Localizable", "ADD_PERSON", fallback: "Add person")
  /// Add to collection
  internal static let addToCollection = L10n.tr("Localizable", "ADD_TO_COLLECTION", fallback: "Add to collection")
  /// Added
  internal static let added = L10n.tr("Localizable", "ADDED", fallback: "Added")
  /// Affiliation
  internal static let affiliation = L10n.tr("Localizable", "AFFILIATION", fallback: "Affiliation")
  /// All cards
  internal static let allCards = L10n.tr("Localizable", "ALL_CARDS", fallback: "All cards")
  /// All sets
  internal static let allSets = L10n.tr("Localizable", "ALL_SETS", fallback: "All sets")
  /// This card has already been added. Please use the quantity control on the previous screen.
  internal static let alreadyAdded = L10n.tr("Localizable", "ALREADY_ADDED", fallback: "This card has already been added. Please use the quantity control on the previous screen.")
  /// App failed to initialize
  internal static let appFailedToInitialize = L10n.tr("Localizable", "APP_FAILED_TO_INITIALIZE", fallback: "App failed to initialize")
  /// App initialized successfully!
  internal static let appInitializedSuccessfully = L10n.tr("Localizable", "APP_INITIALIZED_SUCCESSFULLY", fallback: "App initialized successfully!")
  /// Apply
  internal static let apply = L10n.tr("Localizable", "APPLY", fallback: "Apply")
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
  /// Card Added
  internal static let cardAdded = L10n.tr("Localizable", "CARD_ADDED", fallback: "Card Added")
  /// %@ has been added successfully!
  internal static func cardAddedSuccessfully(_ p1: Any) -> String {
    return L10n.tr("Localizable", "CARD_ADDED_SUCCESSFULLY", String(describing: p1), fallback: "%@ has been added successfully!")
  }
  /// Card cost
  internal static let cardCost = L10n.tr("Localizable", "CARD_COST", fallback: "Card cost")
  /// Card information
  internal static let cardInformation = L10n.tr("Localizable", "CARD_INFORMATION", fallback: "Card information")
  /// Card #
  internal static let cardNumber = L10n.tr("Localizable", "CARD_NUMBER", fallback: "Card #")
  /// Card text
  internal static let cardText = L10n.tr("Localizable", "CARD_TEXT", fallback: "Card text")
  /// Card types
  internal static let cardTypes = L10n.tr("Localizable", "CARD_TYPES", fallback: "Card types")
  /// Cards
  internal static let cards = L10n.tr("Localizable", "CARDS", fallback: "Cards")
  /// Plural format key: "%#@card@"
  internal static func cardsCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "CARDS_COUNT", p1, fallback: "Plural format key: \"%#@card@\"")
  }
  /// Clear
  internal static let clear = L10n.tr("Localizable", "CLEAR", fallback: "Clear")
  /// Clear all filters
  internal static let clearAllFilters = L10n.tr("Localizable", "CLEAR_ALL_FILTERS", fallback: "Clear all filters")
  /// Clear search
  internal static let clearSearch = L10n.tr("Localizable", "CLEAR_SEARCH", fallback: "Clear search")
  /// Close
  internal static let close = L10n.tr("Localizable", "CLOSE", fallback: "Close")
  /// Collection
  internal static let collection = L10n.tr("Localizable", "COLLECTION", fallback: "Collection")
  /// Your collection is empty. Tap + to add cards.
  internal static let collectionEmpty = L10n.tr("Localizable", "COLLECTION_EMPTY", fallback: "Your collection is empty. Tap + to add cards.")
  /// Color
  internal static let color = L10n.tr("Localizable", "COLOR", fallback: "Color")
  /// Cost
  internal static let cost = L10n.tr("Localizable", "COST", fallback: "Cost")
  /// Cost Range
  internal static let costRange = L10n.tr("Localizable", "COST_RANGE", fallback: "Cost Range")
  /// Create new deck
  internal static let createNewDeck = L10n.tr("Localizable", "CREATE_NEW_DECK", fallback: "Create new deck")
  /// Create your first deck to get started
  internal static let createYourFirstDeckToGetStarted = L10n.tr("Localizable", "CREATE_YOUR_FIRST_DECK_TO_GET_STARTED", fallback: "Create your first deck to get started")
  /// Deck graph
  internal static let deckGraph = L10n.tr("Localizable", "DECK_GRAPH", fallback: "Deck graph")
  /// Deck Limit
  internal static let deckLimit = L10n.tr("Localizable", "DECK_LIMIT", fallback: "Deck Limit")
  /// Deck name
  internal static let deckName = L10n.tr("Localizable", "DECK_NAME", fallback: "Deck name")
  /// Deck statistics
  internal static let deckStatistics = L10n.tr("Localizable", "DECK_STATISTICS", fallback: "Deck statistics")
  /// Decks
  internal static let decks = L10n.tr("Localizable", "DECKS", fallback: "Decks")
  /// Decrease quantity
  internal static let decreaseQuantity = L10n.tr("Localizable", "DECREASE_QUANTITY", fallback: "Decrease quantity")
  /// Delete
  internal static let delete = L10n.tr("Localizable", "DELETE", fallback: "Delete")
  /// Delete card
  internal static let deleteCard = L10n.tr("Localizable", "DELETE_CARD", fallback: "Delete card")
  /// Delete deck
  internal static let deleteDeck = L10n.tr("Localizable", "DELETE_DECK", fallback: "Delete deck")
  /// Deleted Person
  internal static let deletedPerson = L10n.tr("Localizable", "DELETED_PERSON", fallback: "Deleted Person")
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
  /// Empty deck
  internal static let emptyDeck = L10n.tr("Localizable", "EMPTY_DECK", fallback: "Empty deck")
  /// Enter a card name, type, or any keyword to search through all available cards
  internal static let enterACardNameTypeOrAnyKeywordToSearch = L10n.tr("Localizable", "ENTER_A_CARD_NAME_TYPE_OR_ANY_KEYWORD_TO_SEARCH", fallback: "Enter a card name, type, or any keyword to search through all available cards")
  /// Enter the person's name to track loans with them.
  internal static let enterThePersonsNameToTrackLoansWithThem = L10n.tr("Localizable", "ENTER_THE_PERSONS_NAME_TO_TRACK_LOANS_WITH_THEM", fallback: "Enter the person's name to track loans with them.")
  /// Error
  internal static let error = L10n.tr("Localizable", "ERROR", fallback: "Error")
  /// Something went wrong! Tap here to check if db.swdrenewedhope.com is online.
  internal static let errorMessage = L10n.tr("Localizable", "ERROR_MESSAGE", fallback: "Something went wrong! Tap here to check if db.swdrenewedhope.com is online.")
  /// Event
  internal static let event = L10n.tr("Localizable", "EVENT", fallback: "Event")
  /// Expansions
  internal static let expansions = L10n.tr("Localizable", "EXPANSIONS", fallback: "Expansions")
  /// Faction
  internal static let faction = L10n.tr("Localizable", "FACTION", fallback: "Faction")
  /// Filter cards
  internal static let filterCards = L10n.tr("Localizable", "FILTER_CARDS", fallback: "Filter cards")
  /// Filter collection
  internal static let filterCollection = L10n.tr("Localizable", "FILTER_COLLECTION", fallback: "Filter collection")
  /// First name
  internal static let firstName = L10n.tr("Localizable", "FIRST_NAME", fallback: "First name")
  /// First name must be at least 2 characters
  internal static let firstNameMinLength = L10n.tr("Localizable", "FIRST_NAME_MIN_LENGTH", fallback: "First name must be at least 2 characters")
  /// First name is required
  internal static let firstNameRequired = L10n.tr("Localizable", "FIRST_NAME_REQUIRED", fallback: "First name is required")
  /// Flavor text
  internal static let flavorText = L10n.tr("Localizable", "FLAVOR_TEXT", fallback: "Flavor text")
  /// Generating charts…
  internal static let generatingCharts = L10n.tr("Localizable", "GENERATING_CHARTS", fallback: "Generating charts…")
  /// Graph
  internal static let graph = L10n.tr("Localizable", "GRAPH", fallback: "Graph")
  /// Gray
  internal static let gray = L10n.tr("Localizable", "GRAY", fallback: "Gray")
  /// Has borrowed my:
  internal static let hasBorrowedMy = L10n.tr("Localizable", "HAS_BORROWED_MY", fallback: "Has borrowed my:")
  /// Has Die
  internal static let hasDie = L10n.tr("Localizable", "HAS_DIE", fallback: "Has Die")
  /// Has lent me:
  internal static let hasLentMe = L10n.tr("Localizable", "HAS_LENT_ME", fallback: "Has lent me:")
  /// Health
  internal static let health = L10n.tr("Localizable", "HEALTH", fallback: "Health")
  /// Illustrator
  internal static let illustrator = L10n.tr("Localizable", "ILLUSTRATOR", fallback: "Illustrator")
  /// Increase quantity
  internal static let increaseQuantity = L10n.tr("Localizable", "INCREASE_QUANTITY", fallback: "Increase quantity")
  /// Last name
  internal static let lastName = L10n.tr("Localizable", "LAST_NAME", fallback: "Last name")
  /// Last name must be at least 2 characters
  internal static let lastNameMinLength = L10n.tr("Localizable", "LAST_NAME_MIN_LENGTH", fallback: "Last name must be at least 2 characters")
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
  /// Loading…
  internal static let loading = L10n.tr("Localizable", "LOADING", fallback: "Loading…")
  /// Loading deck…
  internal static let loadingDeck = L10n.tr("Localizable", "LOADING_DECK", fallback: "Loading deck…")
  /// Loading decks…
  internal static let loadingDecks = L10n.tr("Localizable", "LOADING_DECKS", fallback: "Loading decks…")
  /// Loading people...
  internal static let loadingPeople = L10n.tr("Localizable", "LOADING_PEOPLE", fallback: "Loading people...")
  /// Loans
  internal static let loans = L10n.tr("Localizable", "LOANS", fallback: "Loans")
  /// Local
  internal static let local = L10n.tr("Localizable", "LOCAL", fallback: "Local")
  /// Max
  internal static let max = L10n.tr("Localizable", "MAX", fallback: "Max")
  /// Max cost
  internal static let maxCost = L10n.tr("Localizable", "MAX_COST", fallback: "Max cost")
  /// Min
  internal static let min = L10n.tr("Localizable", "MIN", fallback: "Min")
  /// Min cost
  internal static let minCost = L10n.tr("Localizable", "MIN_COST", fallback: "Min cost")
  /// My collection
  internal static let myCollection = L10n.tr("Localizable", "MY_COLLECTION", fallback: "My collection")
  /// Name
  internal static let name = L10n.tr("Localizable", "NAME", fallback: "Name")
  /// New person
  internal static let newPerson = L10n.tr("Localizable", "NEW_PERSON", fallback: "New person")
  /// No cards borrowed
  internal static let noBorrowedCards = L10n.tr("Localizable", "NO_BORROWED_CARDS", fallback: "No cards borrowed")
  /// No Cards Found
  internal static let noCardsFound = L10n.tr("Localizable", "NO_CARDS_FOUND", fallback: "No Cards Found")
  /// No cards in your collection
  internal static let noCardsInCollection = L10n.tr("Localizable", "NO_CARDS_IN_COLLECTION", fallback: "No cards in your collection")
  /// No cards match your search
  internal static let noCardsMatchSearch = L10n.tr("Localizable", "NO_CARDS_MATCH_SEARCH", fallback: "No cards match your search")
  /// No cards match “%@”. Try a different search term.
  internal static func noCardsMatchViewmodelcurrentqueryTryA(_ p1: Any) -> String {
    return L10n.tr("Localizable", "NO_CARDS_MATCH_VIEWMODELCURRENTQUERY_TRY_A", String(describing: p1), fallback: "No cards match “%@”. Try a different search term.")
  }
  /// No data available
  internal static let noDataAvailable = L10n.tr("Localizable", "NO_DATA_AVAILABLE", fallback: "No data available")
  /// No decks match “%@”
  internal static func noDecksMatchViewmodelsearchtext(_ p1: Any) -> String {
    return L10n.tr("Localizable", "NO_DECKS_MATCH_VIEWMODELSEARCHTEXT", String(describing: p1), fallback: "No decks match “%@”")
  }
  /// No decks yet
  internal static let noDecksYet = L10n.tr("Localizable", "NO_DECKS_YET", fallback: "No decks yet")
  /// No cards lent
  internal static let noLentCards = L10n.tr("Localizable", "NO_LENT_CARDS", fallback: "No cards lent")
  /// No loans
  internal static let noLoans = L10n.tr("Localizable", "NO_LOANS", fallback: "No loans")
  /// No people found
  internal static let noPeopleFound = L10n.tr("Localizable", "NO_PEOPLE_FOUND", fallback: "No people found")
  /// No people yet
  internal static let noPeopleYet = L10n.tr("Localizable", "NO_PEOPLE_YET", fallback: "No people yet")
  /// No results
  internal static let noResults = L10n.tr("Localizable", "NO_RESULTS", fallback: "No results")
  /// No results found
  internal static let noResultsFound = L10n.tr("Localizable", "NO_RESULTS_FOUND", fallback: "No results found")
  /// No Sets Found
  internal static let noSetsFound = L10n.tr("Localizable", "NO_SETS_FOUND", fallback: "No Sets Found")
  /// No sets match your search
  internal static let noSetsMatchSearch = L10n.tr("Localizable", "NO_SETS_MATCH_SEARCH", fallback: "No sets match your search")
  /// Non-elite
  internal static let nonElite = L10n.tr("Localizable", "NON_ELITE", fallback: "Non-elite")
  /// Open Settings
  internal static let openSettings = L10n.tr("Localizable", "OPEN_SETTINGS", fallback: "Open Settings")
  /// People
  internal static let people = L10n.tr("Localizable", "PEOPLE", fallback: "People")
  /// %@ %@ was successfully deleted.
  internal static func personDeletedSuccessfully(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "PERSON_DELETED_SUCCESSFULLY", String(describing: p1), String(describing: p2), fallback: "%@ %@ was successfully deleted.")
  }
  /// Person information
  internal static let personInformation = L10n.tr("Localizable", "PERSON_INFORMATION", fallback: "Person information")
  /// Plot
  internal static let plot = L10n.tr("Localizable", "PLOT", fallback: "Plot")
  /// Points
  internal static let points = L10n.tr("Localizable", "POINTS", fallback: "Points")
  /// Popular searches
  internal static let popularSearches = L10n.tr("Localizable", "POPULAR_SEARCHES", fallback: "Popular searches")
  /// Pull to refresh to load cards
  internal static let pullToRefreshToLoadCards = L10n.tr("Localizable", "PULL_TO_REFRESH_TO_LOAD_CARDS", fallback: "Pull to refresh to load cards")
  /// Pull to refresh to load sets
  internal static let pullToRefreshToLoadSets = L10n.tr("Localizable", "PULL_TO_REFRESH_TO_LOAD_SETS", fallback: "Pull to refresh to load sets")
  /// Quantity
  internal static let quantity = L10n.tr("Localizable", "QUANTITY", fallback: "Quantity")
  /// Rarity
  internal static let rarity = L10n.tr("Localizable", "RARITY", fallback: "Rarity")
  /// Red
  internal static let red = L10n.tr("Localizable", "RED", fallback: "Red")
  /// Remote
  internal static let remote = L10n.tr("Localizable", "REMOTE", fallback: "Remote")
  /// Retry
  internal static let retry = L10n.tr("Localizable", "RETRY", fallback: "Retry")
  /// Save person
  internal static let savePerson = L10n.tr("Localizable", "SAVE_PERSON", fallback: "Save person")
  /// Add %d
  internal static func scanAddSelected(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SCAN_ADD_SELECTED", p1, fallback: "Add %d")
  }
  /// Added %d card(s) to your collection
  internal static func scanAddedSummary(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SCAN_ADDED_SUMMARY", p1, fallback: "Added %d card(s) to your collection")
  }
  /// Scan again
  internal static let scanAgain = L10n.tr("Localizable", "SCAN_AGAIN", fallback: "Scan again")
  /// Align the card within the frame
  internal static let scanAlignHint = L10n.tr("Localizable", "SCAN_ALIGN_HINT", fallback: "Align the card within the frame")
  /// Enable camera access in Settings to scan cards.
  internal static let scanCameraDeniedMessage = L10n.tr("Localizable", "SCAN_CAMERA_DENIED_MESSAGE", fallback: "Enable camera access in Settings to scan cards.")
  /// Camera access needed
  internal static let scanCameraDeniedTitle = L10n.tr("Localizable", "SCAN_CAMERA_DENIED_TITLE", fallback: "Camera access needed")
  /// Capture
  internal static let scanCapture = L10n.tr("Localizable", "SCAN_CAPTURE", fallback: "Capture")
  /// Scan card
  internal static let scanCard = L10n.tr("Localizable", "SCAN_CARD", fallback: "Scan card")
  /// Card detected
  internal static let scanCardDetected = L10n.tr("Localizable", "SCAN_CARD_DETECTED", fallback: "Card detected")
  /// Point your camera at a card
  internal static let scanCardHint = L10n.tr("Localizable", "SCAN_CARD_HINT", fallback: "Point your camera at a card")
  /// Scan a card
  internal static let scanCardTitle = L10n.tr("Localizable", "SCAN_CARD_TITLE", fallback: "Scan a card")
  /// %d cards detected
  internal static func scanCardsDetected(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SCAN_CARDS_DETECTED", p1, fallback: "%d cards detected")
  }
  /// Choose a different match
  internal static let scanChooseMatch = L10n.tr("Localizable", "SCAN_CHOOSE_MATCH", fallback: "Choose a different match")
  /// Match confidence: %d%%
  internal static func scanConfidence(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SCAN_CONFIDENCE", p1, fallback: "Match confidence: %d%%")
  }
  /// Couldn't load card data
  internal static let scanIndexFailed = L10n.tr("Localizable", "SCAN_INDEX_FAILED", fallback: "Couldn't load card data")
  /// No card detected
  internal static let scanNoCardDetected = L10n.tr("Localizable", "SCAN_NO_CARD_DETECTED", fallback: "No card detected")
  /// Not recognized
  internal static let scanNotRecognized = L10n.tr("Localizable", "SCAN_NOT_RECOGNIZED", fallback: "Not recognized")
  /// Point at one or more cards
  internal static let scanPointAtCards = L10n.tr("Localizable", "SCAN_POINT_AT_CARDS", fallback: "Point at one or more cards")
  /// Preparing… %d%%
  internal static func scanPreparing(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SCAN_PREPARING", p1, fallback: "Preparing… %d%%")
  }
  /// Review cards
  internal static let scanReviewTitle = L10n.tr("Localizable", "SCAN_REVIEW_TITLE", fallback: "Review cards")
  /// Search manually
  internal static let scanSearchManually = L10n.tr("Localizable", "SCAN_SEARCH_MANUALLY", fallback: "Search manually")
  /// Search
  internal static let search = L10n.tr("Localizable", "SEARCH", fallback: "Search")
  /// Search cards...
  internal static let searchCards = L10n.tr("Localizable", "SEARCH_CARDS", fallback: "Search cards...")
  /// Search collection...
  internal static let searchCollection = L10n.tr("Localizable", "SEARCH_COLLECTION", fallback: "Search collection...")
  /// Search decks...
  internal static let searchDecks = L10n.tr("Localizable", "SEARCH_DECKS", fallback: "Search decks...")
  /// Search people...
  internal static let searchPeople = L10n.tr("Localizable", "SEARCH_PEOPLE", fallback: "Search people...")
  /// Search sets...
  internal static let searchSets = L10n.tr("Localizable", "SEARCH_SETS", fallback: "Search sets...")
  /// Searching for “%@”…
  internal static func searchingForQuery(_ p1: Any) -> String {
    return L10n.tr("Localizable", "SEARCHING_FOR_QUERY", String(describing: p1), fallback: "Searching for “%@”…")
  }
  /// Set
  internal static let `set` = L10n.tr("Localizable", "SET", fallback: "Set")
  /// Set Filter
  internal static let setFilter = L10n.tr("Localizable", "SET_FILTER", fallback: "Set Filter")
  /// Share
  internal static let share = L10n.tr("Localizable", "SHARE", fallback: "Share")
  /// Shared with SWD Trades for iOS
  internal static let shareText = L10n.tr("Localizable", "SHARE_TEXT", fallback: "Shared with SWD Trades for iOS")
  /// Plural format key: "%#@side@"
  internal static func sidesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "SIDES_COUNT", p1, fallback: "Plural format key: \"%#@side@\"")
  }
  /// Sort By
  internal static let sortBy = L10n.tr("Localizable", "SORT_BY", fallback: "Sort By")
  /// Suggestions
  internal static let suggestions = L10n.tr("Localizable", "SUGGESTIONS", fallback: "Suggestions")
  /// Support
  internal static let support = L10n.tr("Localizable", "SUPPORT", fallback: "Support")
  /// SWDestiny Trades
  internal static let swdestinyTrades = L10n.tr("Localizable", "SWDESTINY_TRADES", fallback: "SWDestiny Trades")
  /// https://db.swdrenewedhope.com
  internal static let swdestinydbWebsite = L10n.tr("Localizable", "SWDESTINYDB_WEBSITE", fallback: "https://db.swdrenewedhope.com")
  /// SwiftUI migration in progress
  internal static let swiftuiMigrationInProgress = L10n.tr("Localizable", "SWIFTUI_MIGRATION_IN_PROGRESS", fallback: "SwiftUI migration in progress")
  /// Total cards: %@
  internal static func totalCardsViewmodeltotalcardcount(_ p1: Any) -> String {
    return L10n.tr("Localizable", "TOTAL_CARDS_VIEWMODELTOTALCARDCOUNT", String(describing: p1), fallback: "Total cards: %@")
  }
  /// Try adjusting your search terms
  internal static let tryAdjustingYourSearchTerms = L10n.tr("Localizable", "TRY_ADJUSTING_YOUR_SEARCH_TERMS", fallback: "Try adjusting your search terms")
  /// Type
  internal static let type = L10n.tr("Localizable", "TYPE", fallback: "Type")
  /// Unique
  internal static let unique = L10n.tr("Localizable", "UNIQUE", fallback: "Unique")
  /// Unique cards: %@
  internal static func uniqueCardsViewmodeluniquecardcount(_ p1: Any) -> String {
    return L10n.tr("Localizable", "UNIQUE_CARDS_VIEWMODELUNIQUECARDCOUNT", String(describing: p1), fallback: "Unique cards: %@")
  }
  /// Unnamed Deck
  internal static let unnamedDeck = L10n.tr("Localizable", "UNNAMED_DECK", fallback: "Unnamed Deck")
  /// Upgrade
  internal static let upgrade = L10n.tr("Localizable", "UPGRADE", fallback: "Upgrade")
  /// Version %@ (%@)
  internal static func version(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "VERSION", String(describing: p1), String(describing: p2), fallback: "Version %@ (%@)")
  }
  /// %@ results for “%@”
  internal static func viewmodelsearchresultscountResultsFor(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "VIEWMODELSEARCHRESULTSCOUNT_RESULTS_FOR", String(describing: p1), String(describing: p2), fallback: "%@ results for “%@”")
  }
  /// Yellow
  internal static let yellow = L10n.tr("Localizable", "YELLOW", fallback: "Yellow")
  /// Yes
  internal static let yes = L10n.tr("Localizable", "YES", fallback: "Yes")
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
