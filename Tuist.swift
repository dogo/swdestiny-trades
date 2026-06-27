import Foundation
import ProjectDescription

// Caching is on by default (covers local dev — auth is via `tuist auth login`
// OIDC, not a token — and CI pushes/internal PRs). Fork PRs skip `tuist setup
// cache`, so the CAS socket never exists for them; the CI workflow sets
// TUIST_DISABLE_XCODE_CACHE=1 on fork generates to avoid wiring the project to a
// socket that won't be there (`CAS error: deadlineExceeded(... No such file)`).
let cacheDisabled = ProcessInfo.processInfo.environment["TUIST_DISABLE_XCODE_CACHE"] == "1"

let tuist = Tuist(
    fullHandle: "AnyKey Entertainment/swdestiny-trades",
    project: .tuist(
        generationOptions: .options(
            enableCaching: !cacheDisabled
        )
    )
)
