// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#elseif os(tvOS) || os(watchOS)
    import UIKit
#endif
#if canImport(SwiftUI)
    import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
enum Asset {
    static let icBattlefield = ImageAsset(name: "ic_battlefield")
    static let icCharacter = ImageAsset(name: "ic_character")
    static let icDowngrade = ImageAsset(name: "ic_downgrade")
    static let icEvent = ImageAsset(name: "ic_event")
    static let icPlot = ImageAsset(name: "ic_plot")
    static let icSupport = ImageAsset(name: "ic_support")
    static let icUpgrade = ImageAsset(name: "ic_upgrade")
    enum Logo {
        static let largeIconBlack = ImageAsset(name: "Logo/LargeIconBlack")
        static let largeIconTransparent = ImageAsset(name: "Logo/LargeIconTransparent")
    }

    enum NavigationBar {
        static let icAbout = ImageAsset(name: "NavigationBar/ic_about")
        static let icAccount = ImageAsset(name: "NavigationBar/ic_account")
        static let icAddCollection = ImageAsset(name: "NavigationBar/ic_add_collection")
        static let icChart = ImageAsset(name: "NavigationBar/ic_chart")
        static let icSort = ImageAsset(name: "NavigationBar/ic_sort")
    }

    enum Sets {
        static let icAcrossTheGalaxy = ImageAsset(name: "Sets/ic_across_the_galaxy")
        static let icAlliesOfNecessity = ImageAsset(name: "Sets/ic_allies_of_necessity")
        static let icAwakenings = ImageAsset(name: "Sets/ic_awakenings")
        static let icConvergence = ImageAsset(name: "Sets/ic_convergence")
        static let icCovertMissions = ImageAsset(name: "Sets/ic_covert_missions")
        static let icEmpireAtWar = ImageAsset(name: "Sets/ic_empire_at_war")
        static let icEternalConflict = ImageAsset(name: "Sets/ic_eternal_conflict")
        static let icFalteringAllegiances = ImageAsset(name: "Sets/ic_faltering_allegiances")
        static let icHighStakes = ImageAsset(name: "Sets/ic_high_stakes")
        static let icLegacies = ImageAsset(name: "Sets/ic_legacies")
        static let icNotFound = ImageAsset(name: "Sets/ic_not_found")
        static let icPartingWords = ImageAsset(name: "Sets/ic_parting_words")
        static let icRedemption = ImageAsset(name: "Sets/ic_redemption")
        static let icRivals = ImageAsset(name: "Sets/ic_rivals")
        static let icSparkOfHope = ImageAsset(name: "Sets/ic_spark_of_hope")
        static let icSpiritOfRebellion = ImageAsset(name: "Sets/ic_spirit_of_rebellion")
        static let icTransformations = ImageAsset(name: "Sets/ic_transformations")
        static let icTwoPlayerGame = ImageAsset(name: "Sets/ic_two_player_game")
        static let icWayOfTheForce = ImageAsset(name: "Sets/ic_way_of_the_force")
    }

    enum Tabbar {
        static let icCards = ImageAsset(name: "Tabbar/ic_cards")
        static let icCardsFilled = ImageAsset(name: "Tabbar/ic_cards_filled")
        static let icCollection = ImageAsset(name: "Tabbar/ic_collection")
        static let icDecks = ImageAsset(name: "Tabbar/ic_decks")
        static let icLoans = ImageAsset(name: "Tabbar/ic_loans")
    }

    static let ic404 = ImageAsset(name: "ic_404")
    static let icCardback = ImageAsset(name: "ic_cardback")
    static let icDoneEdit = ImageAsset(name: "ic_done_edit")
    static let icEdit = ImageAsset(name: "ic_edit")
}

// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

struct ImageAsset {
    fileprivate(set) var name: String

    #if os(macOS)
        typealias Image = NSImage
    #elseif os(iOS) || os(tvOS) || os(watchOS)
        typealias Image = UIImage
    #endif

    @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
    var image: Image {
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
            fatalError("Unable to load image asset named \(name).")
        }
        return result
    }

    #if os(iOS) || os(tvOS)
        @available(iOS 8.0, tvOS 9.0, *)
        func image(compatibleWith traitCollection: UITraitCollection) -> Image {
            let bundle = BundleToken.bundle
            guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
                fatalError("Unable to load image asset named \(name).")
            }
            return result
        }
    #endif

    #if canImport(SwiftUI)
        @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
        var swiftUIImage: SwiftUI.Image {
            SwiftUI.Image(asset: self)
        }
    #endif
}

extension ImageAsset.Image {
    @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
    @available(macOS, deprecated,
               message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
    convenience init?(asset: ImageAsset) {
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

#if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
    extension SwiftUI.Image {
        init(asset: ImageAsset) {
            let bundle = BundleToken.bundle
            self.init(asset.name, bundle: bundle)
        }

        init(asset: ImageAsset, label: Text) {
            let bundle = BundleToken.bundle
            self.init(asset.name, bundle: bundle, label: label)
        }

        init(decorative asset: ImageAsset) {
            let bundle = BundleToken.bundle
            self.init(decorative: asset.name, bundle: bundle)
        }
    }
#endif

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
