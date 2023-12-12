// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/dogo/SketchKit", from: "2.0.0"),
        .package(url: "https://github.com/danielgindi/Charts", from: "4.1.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "5.15.8"),
        .package(url: "https://github.com/dogo/PKHUD", branch: "fix/spm-resource"),
        .package(url: "https://github.com/liufengting/FTPopOverMenu_Swift", from: "0.4.4"),
        .package(url: "https://github.com/zvonicek/ImageSlideshow", from: "1.9.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.1.0"),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages", from: "9.0.6"),
        .package(url: "https://github.com/uber/ios-snapshot-test-case.git", from: "8.0.0")
    ]
)
