import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {

    public static func targetScripts() -> [TargetScript] {
        return [
            TargetScript.pre(
                script: "mint run swiftgen",
                name: "[SwiftGen] Run Script"
            ),
            TargetScript.pre(
                script: "mint run swiftformat --config .swiftformat .",
                name: "[SwiftFormat] Run Script"
            ),
            TargetScript.pre(
                script: "mint run swiftlint",
                name: "[SwiftLint] Run Script"
            ),
            TargetScript.post(
                script: "${PODS_ROOT}/FirebaseCrashlytics/run",
                name: "[Crashlytics] Run Script"
            )
        ]
    }
}
