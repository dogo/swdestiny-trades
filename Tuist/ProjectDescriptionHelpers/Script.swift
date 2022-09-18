import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {

    static func targetScripts() -> [TargetScript] {
        return [
            TargetScript.pre(
                script: "mint run swiftgen",
                name: "[SwiftGen] Run Script",
                basedOnDependencyAnalysis: false
            ),
            TargetScript.pre(
                script: "mint run swiftformat --config .swiftformat .",
                name: "[SwiftFormat] Run Script",
                basedOnDependencyAnalysis: false
            ),
            TargetScript.pre(
                script: "mint run swiftlint",
                name: "[SwiftLint] Run Script",
                basedOnDependencyAnalysis: false
            ),
            TargetScript.post(
                script: "${PROJECT_DIR}/Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
                name: "[Crashlytics] Run Script",
                basedOnDependencyAnalysis: false
            )
        ]
    }
}
