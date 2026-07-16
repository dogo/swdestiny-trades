import ProjectDescription

// Project helpers are functions that simplify the way you define your project.
// Share code to create targets, settings, dependencies,
// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
// See https://docs.tuist.io/guides/helpers/

public extension Project {

    // swiftlint:disable:next function_body_length
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
                inputPaths: [
                    "$SRCROOT/swiftgen.yml",
                    "$SRCROOT/SWDestinyTrades/Localization/Base.lproj",
                    "$SRCROOT/SWDestinyTrades/Assets.xcassets"
                ],
                outputPaths: [
                    "$SRCROOT/SWDestinyTrades/Classes/Generated/LocalizableStrings.swift",
                    "$SRCROOT/SWDestinyTrades/Classes/Generated/ImageAssets.swift"
                ],
                basedOnDependencyAnalysis: true
            ),
            TargetScript.pre(
                script:
                """
                if [[ -n "${CI:-}" ]]; then
                  echo "Skipping SwiftFormat on CI."
                  exit 0
                fi

                # Add Mise to the PATH
                export PATH="$HOME/.local/share/mise/shims:$PATH"
                swiftformat --swiftversion 5.10 --config .swiftformat .
                touch "$DERIVED_FILE_DIR/swiftformat.stamp"
                """,
                name: "[SwiftFormat] Run Script",
                inputPaths: [
                    "$SRCROOT/.swiftformat"
                ],
                outputPaths: [
                    "$(DERIVED_FILE_DIR)/swiftformat.stamp"
                ],
                basedOnDependencyAnalysis: true
            ),
            TargetScript.pre(
                script:
                """
                if [[ -z "${CI:-}" ]]; then
                  echo "Skipping SwiftLint outside CI."
                  exit 0
                fi

                # Add Mise to the PATH
                export PATH="$HOME/.local/share/mise/shims:$PATH"
                swiftlint
                touch "$DERIVED_FILE_DIR/swiftlint.stamp"
                """,
                name: "[SwiftLint] Run Script",
                inputPaths: [
                    "$SRCROOT/.swiftlint.yml"
                ],
                outputPaths: [
                    "$(DERIVED_FILE_DIR)/swiftlint.stamp"
                ],
                basedOnDependencyAnalysis: true
            ),
            TargetScript.post(
                script:
                """
                if [[ "$CONFIGURATION" != "Release" ]]; then
                  echo "Skipping Crashlytics for non-Release configuration."
                  exit 0
                fi

                if [[ -z "${CI:-}" ]]; then
                  echo "Skipping Crashlytics outside CI."
                  exit 0
                fi

                "${PROJECT_DIR}/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
                touch "$DERIVED_FILE_DIR/crashlytics.stamp"
                """,
                name: "[Crashlytics] Run Script",
                inputPaths: [
                    "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
                    "$(TARGET_BUILD_DIR)/$(INFOPLIST_PATH)",
                    "$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)"
                ],
                outputPaths: [
                    "$(DERIVED_FILE_DIR)/crashlytics.stamp"
                ],
                basedOnDependencyAnalysis: true
            )
        ]
    }
}
