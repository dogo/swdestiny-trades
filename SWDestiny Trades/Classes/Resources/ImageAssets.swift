// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSImage
  internal typealias AssetColorTypeAlias = NSColor
  internal typealias AssetImageTypeAlias = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIImage
  internal typealias AssetColorTypeAlias = UIColor
  internal typealias AssetImageTypeAlias = UIImage
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let icBattlefield = ImageAsset(name: "ic_battlefield")
  internal static let icCharacter = ImageAsset(name: "ic_character")
  internal static let icDowngrade = ImageAsset(name: "ic_downgrade")
  internal static let icEvent = ImageAsset(name: "ic_event")
  internal static let icPlot = ImageAsset(name: "ic_plot")
  internal static let icSupport = ImageAsset(name: "ic_support")
  internal static let icUpgrade = ImageAsset(name: "ic_upgrade")
  internal enum Logo {

    internal static let largeIconBlack = ImageAsset(name: "Logo/LargeIconBlack")
    internal static let largeIconTransparent = ImageAsset(name: "Logo/LargeIconTransparent")
  }
  internal enum NavigationBar {

    internal static let icAbout = ImageAsset(name: "NavigationBar/ic_about")
    internal static let icAccount = ImageAsset(name: "NavigationBar/ic_account")
    internal static let icAddCollection = ImageAsset(name: "NavigationBar/ic_add_collection")
    internal static let icChart = ImageAsset(name: "NavigationBar/ic_chart")
    internal static let icSort = ImageAsset(name: "NavigationBar/ic_sort")
  }
  internal enum Sets {

    internal static let icAcrossTheGalaxy = ImageAsset(name: "Sets/ic_across_the_galaxy")
    internal static let icAlliesOfNecessity = ImageAsset(name: "Sets/ic_allies_of_necessity")
    internal static let icAwakenings = ImageAsset(name: "Sets/ic_awakenings")
    internal static let icConvergence = ImageAsset(name: "Sets/ic_convergence")
    internal static let icEmpireAtWar = ImageAsset(name: "Sets/ic_empire_at_war")
    internal static let icLegacies = ImageAsset(name: "Sets/ic_legacies")
    internal static let icNotFound = ImageAsset(name: "Sets/ic_not_found")
    internal static let icRivals = ImageAsset(name: "Sets/ic_rivals")
    internal static let icSpiritOfRebellion = ImageAsset(name: "Sets/ic_spirit_of_rebellion")
    internal static let icTwoPlayerGame = ImageAsset(name: "Sets/ic_two_player_game")
    internal static let icWayOfTheForce = ImageAsset(name: "Sets/ic_way_of_the_force")
  }
  internal enum Tabbar {

    internal static let icCards = ImageAsset(name: "Tabbar/ic_cards")
    internal static let icCardsFilled = ImageAsset(name: "Tabbar/ic_cards_filled")
    internal static let icCollection = ImageAsset(name: "Tabbar/ic_collection")
    internal static let icDecks = ImageAsset(name: "Tabbar/ic_decks")
    internal static let icLoans = ImageAsset(name: "Tabbar/ic_loans")
  }
  internal static let ic404 = ImageAsset(name: "ic_404")
  internal static let icCardback = ImageAsset(name: "ic_cardback")
  internal static let icDoneEdit = ImageAsset(name: "ic_done_edit")
  internal static let icEdit = ImageAsset(name: "ic_edit")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ColorAsset {
  internal fileprivate(set) var name: String

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, OSX 10.13, *)
  internal var color: AssetColorTypeAlias {
    return AssetColorTypeAlias(asset: self)
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

internal struct DataAsset {
  internal fileprivate(set) var name: String

  #if os(iOS) || os(tvOS) || os(OSX)
  @available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
  internal var data: NSDataAsset {
    return NSDataAsset(asset: self)
  }
  #endif
}

#if os(iOS) || os(tvOS) || os(OSX)
@available(iOS 9.0, tvOS 9.0, OSX 10.11, *)
internal extension NSDataAsset {
  convenience init!(asset: DataAsset) {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(OSX)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  internal var image: AssetImageTypeAlias {
    let bundle = Bundle(for: BundleToken.self)
    #if os(iOS) || os(tvOS)
    let image = AssetImageTypeAlias(named: name, in: bundle, compatibleWith: nil)
    #elseif os(OSX)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = AssetImageTypeAlias(named: name)
    #endif
    guard let result = image else { fatalError("Unable to load image named \(name).") }
    return result
  }
}

internal extension AssetImageTypeAlias {
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

private final class BundleToken {}
