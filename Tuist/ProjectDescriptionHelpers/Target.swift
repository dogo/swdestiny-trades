import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {

    static func targets() -> [Target] {
        return [
            Target(
                name: "SWDestinyTrades",
                destinations: [.iPhone, .iPad],
                product: .app,
                bundleId: "br.com.anykey.SWDestiny-Trades",
                deploymentTargets: .iOS("13.0"),
                infoPlist: "SWDestinyTrades/Info.plist",
                sources: ["SWDestinyTrades/Classes/**"],
                resources: [
                    "GoogleService-Info.plist",
                    "SWDestinyTrades/Assets.xcassets",
                    "SWDestinyTrades/Base.lproj/**",
                    "SWDestinyTrades/Localization/**"
                ],
                scripts: Project.targetScripts(),
                dependencies: [
                    .external(name: "Charts"),
                    .external(name: "FirebaseAnalytics"),
                    .external(name: "FirebaseCrashlytics"),
                    .external(name: "FTPopOverMenu"),
                    .external(name: "ImageSlideshow"),
                    .external(name: "Kingfisher"),
                    .external(name: "PKHUD"),
                    .external(name: "SketchKit"),
                    .external(name: "SwiftMessages"),
                    .package(product: "RealmSwift")
                ],
                settings: Settings.default
            ),
            Target(
                name: "SWDestinyTradesTests",
                destinations: [.iPhone, .iPad],
                product: .unitTests,
                bundleId: "br.com.anykey.SWDestiny-TradesTests",
                deploymentTargets: .iOS("13.0"),
                infoPlist: "SWDestinyTradesTests/Info.plist",
                sources: ["SWDestinyTradesTests/**"],
                resources: [
                    "SWDestinyTradesTests/JSON/*.json"
                ],
                dependencies: [
                    .target(name: "SWDestinyTrades"),
                    .external(name: "iOSSnapshotTestCase"),
                    .package(product: "Realm") // Fix unit test linkage issue
                ]
            )
        ]
    }
}

public extension Settings {

    static let `default`: Settings = .settings(
        base: SettingsDictionary().otherLinkerFlags(["-ObjC"]),
        configurations: [],
        defaultSettings: .recommended
    )
}
