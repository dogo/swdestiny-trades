import ProjectDescription

let swiftPackageManagerDependencies = SwiftPackageManagerDependencies(
    [
        .remote(url: "https://github.com/dogo/SketchKit.git", requirement: .upToNextMajor(from: "1.5.0")),
        .remote(url: "https://github.com/danielgindi/Charts.git", requirement: .upToNextMajor(from: "3.6.0")),
        .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "5.15.0")),
        .remote(url: "https://github.com/dogo/PKHUD.git", requirement: .branch("fix/spm-resource")),
        .remote(url: "https://github.com/liufengting/FTPopOverMenu_Swift.git", requirement: .upToNextMajor(from: "0.4.0")),
        .remote(url: "https://github.com/zvonicek/ImageSlideshow.git", requirement: .upToNextMajor(from: "1.9.0")),
        .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "9.2.1")),
        .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/ashfurrow/Nimble-Snapshots.git", requirement: .upToNextMajor(from: "9.3.1"))
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
