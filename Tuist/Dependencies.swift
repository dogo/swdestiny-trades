import ProjectDescription

let swiftPackageManagerDependencies = SwiftPackageManagerDependencies(
    productTypes: [
        "ImageSlideshow": .framework,
        "SwiftMessages": .framework
    ],
    targetSettings: [
        "iOSSnapshotTestCase": ["ENABLE_TESTING_SEARCH_PATHS": "YES"]
    ]
)

let dependencies = Dependencies(
    swiftPackageManager: swiftPackageManagerDependencies,
    platforms: [.iOS]
)
