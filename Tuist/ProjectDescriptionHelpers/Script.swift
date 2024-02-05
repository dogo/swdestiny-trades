import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {

    static func targetScripts() -> [TargetScript] {
        return [
            TargetScript.pre(
                script:
                """
                # Add Mise to the PATH
                export PATH="$HOME/.local/share/mise/shims:$PATH"
                swiftgen
                """,
                name: "[SwiftGen] Run Script",
                basedOnDependencyAnalysis: false
            ),
            TargetScript.pre(
                script:
                """
                # Add Mise to the PATH
                export PATH="$HOME/.local/share/mise/shims:$PATH"
                swiftformat --config .swiftformat .
                """,
                name: "[SwiftFormat] Run Script",
                basedOnDependencyAnalysis: false
            ),
            TargetScript.pre(
                script:
                """
                # Add Mise to the PATH
                export PATH="$HOME/.local/share/mise/shims:$PATH"
                swiftlint
                """,
                name: "[SwiftLint] Run Script",
                basedOnDependencyAnalysis: false
            ),
            TargetScript.post(
                script: "${PROJECT_DIR}/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
                name: "[Crashlytics] Run Script",
                basedOnDependencyAnalysis: false
            )
        ]
    }
}
