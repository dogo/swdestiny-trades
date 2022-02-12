import ProjectDescription

// MARK: - Project

let options = Project.Options.options(
    disableBundleAccessors: true
)

let settings = Settings.settings(
    base: baseSettings(),
    defaultSettings: .recommended
)

let scripts = [
    TargetScript.pre(script: "mint run swiftgen",
                     name: "[SwiftGen] Run Script"),
    TargetScript.pre(script: "mint run swiftformat --config .swiftformat .",
                     name: "[SwiftFormat] Run Script"),
    TargetScript.pre(script: "mint run swiftlint",
                     name: "[SwiftLint] Run Script"),
    TargetScript.post(script: "${PODS_ROOT}/FirebaseCrashlytics/run",
                      name: "[Crashlytics] Run Script")
]

let targets = [
    Target(
        name: "SWDestinyTrades",
        platform: .iOS,
        product: .app,
        bundleId: "br.com.anykey.SWDestiny-Trades",
        deploymentTarget: .iOS(targetVersion: "12.0", devices: [.iphone, .ipad]),
        infoPlist: "SWDestiny Trades/Info.plist",
        sources: ["SWDestiny Trades/Classes/**"],
        resources: [
            "GoogleService-Info.plist",
            "SWDestiny Trades/Assets.xcassets",
            "SWDestiny Trades/Base.lproj/**",
            "SWDestiny Trades/Localization/**"
        ],
        scripts: scripts,
        dependencies: [
            .external(name: "SketchKit"),
            .external(name: "Charts"),
            .external(name: "Kingfisher"),
            .external(name: "PKHUD"),
            .external(name: "FTPopOverMenu"),
            .external(name: "ImageSlideshow")
        ]
    ),
    Target(
        name: "SWDestinyTradesTests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "br.com.anykey.SWDestiny-TradesTests",
        infoPlist: "SWDestiny TradesTests/Info.plist",
        sources: ["SWDestiny TradesTests/**"],
        resources: [
            "SWDestiny TradesTests/JSON/*.json"
        ],
        dependencies: [
            .target(name: "SWDestinyTrades"),
            .external(name: "Quick"),
            .external(name: "Nimble"),
            .external(name: "Nimble-Snapshots")
        ]
    )
]

let project = Project(
    name: "swdestiny-trades-tuist",
    organizationName: "Diogo Autilio",
    options: options,
    settings: settings,
    targets: targets,
    additionalFiles: [
        .folderReference(path: "SWDestiny TradesTests/ReferenceImages")
    ],
    resourceSynthesizers: []
)

func baseSettings() -> SettingsDictionary {
    let baseSettings = SettingsDictionary()
        .automaticCodeSigning(devTeam: "75C4E36ZA7")
        .currentProjectVersion("44")
        .marketingVersion("1.5.0")
        .debugInformationFormat(.dwarfWithDsym)
    return baseSettings
}
