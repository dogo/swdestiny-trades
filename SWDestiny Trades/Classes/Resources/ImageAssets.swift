// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

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
    internal static let icCovertMissions = ImageAsset(name: "Sets/ic_covert_missions")
    internal static let icEmpireAtWar = ImageAsset(name: "Sets/ic_empire_at_war")
    internal static let icLegacies = ImageAsset(name: "Sets/ic_legacies")
    internal static let icNotFound = ImageAsset(name: "Sets/ic_not_found")
    internal static let icRivals = ImageAsset(name: "Sets/ic_rivals")
    internal static let icSparkOfHope = ImageAsset(name: "Sets/ic_spark_of_hope")
    internal static let icSpiritOfRebellion = ImageAsset(name: "Sets/ic_spirit_of_rebellion")
    internal static let icTransformations = ImageAsset(name: "Sets/ic_transformations")
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

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init!(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
