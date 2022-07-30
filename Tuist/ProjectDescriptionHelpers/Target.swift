import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {

    public static func targets() -> [Target] {
        return [
            Target(
                name: "SWDestinyTrades",
                platform: .iOS,
                product: .app,
                bundleId: "br.com.anykey.SWDestiny-Trades",
                deploymentTarget: .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
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
                    .external(name: "SwiftMessages")
                ]
            ),
            Target(
                name: "SWDestinyTradesTests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "br.com.anykey.SWDestiny-TradesTests",
                infoPlist: "SWDestinyTradesTests/Info.plist",
                sources: ["SWDestinyTradesTests/**"],
                resources: [
                    "SWDestinyTradesTests/JSON/*.json"
                ],
                dependencies: [
                    .target(name: "SWDestinyTrades"),
                    .external(name: "Quick"),
                    .external(name: "Nimble"),
                    .external(name: "Nimble-Snapshots")
                ]
            )
        ]
    }
}
