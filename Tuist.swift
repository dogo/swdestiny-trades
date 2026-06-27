import Foundation
import ProjectDescription

// Caching is on by default for local dev (auth via `tuist auth login` OIDC).
// CI disables it entirely by setting TUIST_DISABLE_XCODE_CACHE=1 in the
// workflow: the remote Xcode cache (CAS) served corrupt artifacts
// (`downloadCASArtifact ... isn't in the correct format`) that surfaced as
// spurious compiler errors (e.g. "Recursive expansion of macro 'require'") and
// broke the build. With caching off, the project is never wired to the CAS
// socket, so there's nothing to corrupt or to time out against.
let cacheDisabled = ProcessInfo.processInfo.environment["TUIST_DISABLE_XCODE_CACHE"] == "1"

let tuist = Tuist(
    fullHandle: "AnyKey Entertainment/swdestiny-trades",
    project: .tuist(
        generationOptions: .options(
            enableCaching: !cacheDisabled
        )
    )
)
