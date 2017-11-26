// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  typealias AssetColorTypeAlias = NSColor
  typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  typealias AssetColorTypeAlias = UIColor
  typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
typealias AssetType = ImageAsset

struct ImageAsset {
  fileprivate var name: String

  var image: Image {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

struct ColorAsset {
  fileprivate var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum Asset {
  enum CardTypes {
    static let icBattlefield = ImageAsset(name: "ic_battlefield")
    static let icCharacter = ImageAsset(name: "ic_character")
    static let icEvent = ImageAsset(name: "ic_event")
    static let icPlot = ImageAsset(name: "ic_plot")
    static let icSupport = ImageAsset(name: "ic_support")
    static let icUpgrade = ImageAsset(name: "ic_upgrade")
  }
  enum Logo {
    static let largeIconBlack = ImageAsset(name: "LargeIconBlack")
    static let largeIconTransparent = ImageAsset(name: "LargeIconTransparent")
  }
  enum NavigationBar {
    static let icAbout = ImageAsset(name: "ic_about")
    static let icAccount = ImageAsset(name: "ic_account")
    static let icAddCollection = ImageAsset(name: "ic_add_collection")
    static let icChart = ImageAsset(name: "ic_chart")
    static let icSort = ImageAsset(name: "ic_sort")
  }
  enum Sets {
    static let icAwakenings = ImageAsset(name: "ic_awakenings")
    static let icEmpireAtWar = ImageAsset(name: "ic_empire_at_war")
    static let icNotFound = ImageAsset(name: "ic_not_found")
    static let icSpiritOfRebellion = ImageAsset(name: "ic_spirit_of_rebellion")
    static let icTwoPlayerGame = ImageAsset(name: "ic_two_player_game")
  }
  enum Tabbar {
    static let icCards = ImageAsset(name: "ic_cards")
    static let icCardsFilled = ImageAsset(name: "ic_cards_filled")
    static let icCollection = ImageAsset(name: "ic_collection")
    static let icDecks = ImageAsset(name: "ic_decks")
    static let icLoans = ImageAsset(name: "ic_loans")
  }
  static let ic404 = ImageAsset(name: "ic_404")
  static let icCardback = ImageAsset(name: "ic_cardback")
  static let icDoneEdit = ImageAsset(name: "ic_done_edit")
  static let icEdit = ImageAsset(name: "ic_edit")

  // swiftlint:disable trailing_comma
  static let allColors: [ColorAsset] = [
  ]
  static let allImages: [ImageAsset] = [
    CardTypes.icBattlefield,
    CardTypes.icCharacter,
    CardTypes.icEvent,
    CardTypes.icPlot,
    CardTypes.icSupport,
    CardTypes.icUpgrade,
    Logo.largeIconBlack,
    Logo.largeIconTransparent,
    NavigationBar.icAbout,
    NavigationBar.icAccount,
    NavigationBar.icAddCollection,
    NavigationBar.icChart,
    NavigationBar.icSort,
    Sets.icAwakenings,
    Sets.icEmpireAtWar,
    Sets.icNotFound,
    Sets.icSpiritOfRebellion,
    Sets.icTwoPlayerGame,
    Tabbar.icCards,
    Tabbar.icCardsFilled,
    Tabbar.icCollection,
    Tabbar.icDecks,
    Tabbar.icLoans,
    ic404,
    icCardback,
    icDoneEdit,
    icEdit,
  ]
  // swiftlint:enable trailing_comma
  @available(*, deprecated, renamed: "allImages")
  static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

extension Image {
  @available(iOS 1.0, tvOS 1.0, watchOS 1.0, *)
  @available(OSX, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = Bundle(for: BundleToken.self)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

extension AssetColorTypeAlias {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  convenience init!(asset: ColorAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {}
