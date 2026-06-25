import ProjectDescription

// Project helpers are functions that simplify the way you define your project.
// Share code to create targets, settings, dependencies,
// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
// See https://docs.tuist.io/guides/helpers/

public extension Project {

    static let deploymentTarget: DeploymentTargets = .iOS("18.0")

    static func targets() -> [Target] {
        return [
            .target(
                name: "SWDestinyTrades",
                destinations: [.iPhone, .iPad],
                product: .app,
                bundleId: "br.com.anykey.SWDestiny-Trades",
                deploymentTargets: deploymentTarget,
                infoPlist: "SWDestinyTrades/Info.plist",
                sources: ["SWDestinyTrades/Classes/**"],
                resources: [
                    "GoogleService-Info.plist",
                    "SWDestinyTrades/Assets.xcassets",
                    "SWDestinyTrades/Base.lproj/**",
                    "SWDestinyTrades/Localization/**",
                    // Exclude the .mlpackage internals so the glob doesn't add the model's inner
                    // files as compile sources; the package is added as a CoreML resource below.
                    .glob(
                        pattern: "SWDestinyTrades/Resources/**",
                        excluding: ["SWDestinyTrades/Resources/MobileCLIPImage.mlpackage/**"]
                    ),
                    "SWDestinyTrades/Resources/MobileCLIPImage.mlpackage"
                ],
                scripts: Project.targetScripts(),
                dependencies: [
                    .external(name: "FirebaseAnalytics"),
                    .external(name: "FirebaseCrashlytics"),
                    .external(name: "Kingfisher")
                ]
            ),
            .target(
                name: "SWDestinyTradesTests",
                destinations: [.iPhone, .iPad],
                product: .unitTests,
                bundleId: "br.com.anykey.SWDestiny-TradesTests",
                deploymentTargets: deploymentTarget,
                infoPlist: "SWDestinyTradesTests/Info.plist",
                sources: ["SWDestinyTradesTests/**"],
                resources: [
                    "SWDestinyTradesTests/Json/*.json"
                ],
                dependencies: [
                    .target(name: "SWDestinyTrades"),
                    .external(name: "iOSSnapshotTestCase")
                ]
            )
        ]
    }
}
