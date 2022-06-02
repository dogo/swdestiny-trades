import ProjectDescription

let swiftPackageManagerDependencies = SwiftPackageManagerDependencies(
    [
        .remote(url: "https://github.com/dogo/SketchKit", requirement: .upToNextMajor(from: "2.0.0")),
        .remote(url: "https://github.com/danielgindi/Charts", requirement: .upToNextMajor(from: "4.0.2")),
        .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "5.15.8")),
        .remote(url: "https://github.com/dogo/PKHUD", requirement: .branch("fix/spm-resource")),
        .remote(url: "https://github.com/liufengting/FTPopOverMenu_Swift", requirement: .upToNextMajor(from: "0.4.4")),
        .remote(url: "https://github.com/zvonicek/ImageSlideshow", requirement: .upToNextMajor(from: "1.9.1")),
        .remote(url: "https://github.com/Quick/Nimble", requirement: .upToNextMajor(from: "10.0.0")),
        .remote(url: "https://github.com/Quick/Quick", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/ashfurrow/Nimble-Snapshots", requirement: .upToNextMajor(from: "9.4.0")),
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "9.1.0")),
        .remote(url: "https://github.com/SwiftKickMobile/SwiftMessages", requirement: .upToNextMajor(from: "9.0.6"))
    ],
    productTypes: [
        "ImageSlideshow": .framework
    ],
    targetSettings: [
        "Nimble-Snapshots": ["ENABLE_TESTING_SEARCH_PATHS": "YES"],
        "iOSSnapshotTestCase": ["ENABLE_TESTING_SEARCH_PATHS": "YES"]
    ]
)

let dependencies = Dependencies(
    swiftPackageManager: swiftPackageManagerDependencies,
    platforms: [.iOS]
)
