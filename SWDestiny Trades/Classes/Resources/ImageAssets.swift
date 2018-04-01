// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias Image = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

@available(*, deprecated, renamed: "ImageAsset")
internal typealias AssetType = ImageAsset

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: Image {
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

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
  }
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum CardTypes {
    internal static let icBattlefield = ImageAsset(name: "ic_battlefield")
    internal static let icCharacter = ImageAsset(name: "ic_character")
    internal static let icEvent = ImageAsset(name: "ic_event")
    internal static let icPlot = ImageAsset(name: "ic_plot")
    internal static let icSupport = ImageAsset(name: "ic_support")
    internal static let icUpgrade = ImageAsset(name: "ic_upgrade")
  }
  internal enum Logo {
    internal static let largeIconBlack = ImageAsset(name: "LargeIconBlack")
    internal static let largeIconTransparent = ImageAsset(name: "LargeIconTransparent")
  }
  internal enum NavigationBar {
    internal static let icAbout = ImageAsset(name: "ic_about")
    internal static let icAccount = ImageAsset(name: "ic_account")
    internal static let icAddCollection = ImageAsset(name: "ic_add_collection")
    internal static let icChart = ImageAsset(name: "ic_chart")
    internal static let icSort = ImageAsset(name: "ic_sort")
  }
  internal enum Sets {
    internal static let icAwakenings = ImageAsset(name: "ic_awakenings")
    internal static let icEmpireAtWar = ImageAsset(name: "ic_empire_at_war")
    internal static let icLegacies = ImageAsset(name: "ic_legacies")
    internal static let icNotFound = ImageAsset(name: "ic_not_found")
    internal static let icRivals = ImageAsset(name: "ic_rivals")
    internal static let icSpiritOfRebellion = ImageAsset(name: "ic_spirit_of_rebellion")
    internal static let icTwoPlayerGame = ImageAsset(name: "ic_two_player_game")
  }
  internal enum Tabbar {
    internal static let icCards = ImageAsset(name: "ic_cards")
    internal static let icCardsFilled = ImageAsset(name: "ic_cards_filled")
    internal static let icCollection = ImageAsset(name: "ic_collection")
    internal static let icDecks = ImageAsset(name: "ic_decks")
    internal static let icLoans = ImageAsset(name: "ic_loans")
  }
  internal static let ic404 = ImageAsset(name: "ic_404")
  internal static let icCardback = ImageAsset(name: "ic_cardback")
  internal static let icDoneEdit = ImageAsset(name: "ic_done_edit")
  internal static let icEdit = ImageAsset(name: "ic_edit")

  // swiftlint:disable trailing_comma
  internal static let allColors: [ColorAsset] = [
  ]
  internal static let allImages: [ImageAsset] = [
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
    Sets.icLegacies,
    Sets.icNotFound,
    Sets.icRivals,
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
  internal static let allValues: [AssetType] = allImages
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

internal extension Image {
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

internal extension AssetColorTypeAlias {
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
