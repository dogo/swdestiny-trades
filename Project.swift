import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

let options = Project.Options.options(
    automaticSchemesOptions: .disabled,
    disableBundleAccessors: true
)

let project = Project(
    name: "swdestiny-trades",
    organizationName: "Diogo Autilio",
    options: options,
    packages: [
        .remote(url: "https://github.com/realm/realm-swift",
                requirement: .upToNextMajor(from: "10.38.0"))
    ],
    settings: Project.settings(),
    targets: Project.targets(),
    schemes: Project.schemes(),
    additionalFiles: [
        .folderReference(path: "SWDestinyTradesTests/ReferenceImages")
    ],
    resourceSynthesizers: []
)
