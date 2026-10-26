// swift-tools-version: 6.2
import PackageDescription

#if TUIST
    import ProjectDescription
    import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        targetSettings: [
            "iOSSnapshotTestCase": .settings(base: [
                "ENABLE_TESTING_SEARCH_PATHS": "YES"
            ])
        ]
    )
#endif

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.14.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "13.1.1", traits: []),
        .package(url: "https://github.com/uber/ios-snapshot-test-case", from: "8.0.0")
    ]
)
