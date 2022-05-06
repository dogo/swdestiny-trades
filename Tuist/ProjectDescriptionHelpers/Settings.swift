import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {

    public static func settings() -> Settings {
        Settings.settings(base: baseSettings())
    }

    private static func baseSettings() -> SettingsDictionary {
        let baseSettings = SettingsDictionary()
            .automaticCodeSigning(devTeam: "75C4E36ZA7")
            .currentProjectVersion("44")
            .marketingVersion("1.5.0")
            .debugInformationFormat(.dwarfWithDsym)
        return baseSettings
    }
}
