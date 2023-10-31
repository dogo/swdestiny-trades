import ProjectDescription

let swiftPackageManagerDependencies = SwiftPackageManagerDependencies(
    productTypes: [
        "ImageSlideshow": .framework,
        "SwiftMessages": .framework
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
