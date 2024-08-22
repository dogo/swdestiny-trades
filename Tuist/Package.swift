// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "ImageSlideshow": .framework,
            "SwiftMessages": .framework
        ],
        targetSettings: [
            "iOSSnapshotTestCase": ["ENABLE_TESTING_SEARCH_PATHS": "YES"]
        ]
    )
#endif

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/dogo/SketchKit", from: "2.0.0"),
        .package(url: "https://github.com/danielgindi/Charts", from: "5.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "5.15.8"),
        .package(url: "https://github.com/dogo/PKHUD", branch: "fix/spm-resource"),
        .package(url: "https://github.com/liufengting/FTPopOverMenu_Swift", from: "0.4.5"),
        .package(url: "https://github.com/zvonicek/ImageSlideshow", from: "1.9.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.1.0"),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages", from: "10.0.0-beta"),
        .package(url: "https://github.com/uber/ios-snapshot-test-case", from: "8.0.0"),
        .package(url: "https://github.com/realm/realm-swift", exact: "10.46.0")
    ]
)
