import ProjectDescription

let tuist = Tuist(
    fullHandle: "AnyKey/swdestiny-trades",
    project: .tuist(
        generationOptions: .options(
            enableCaching: true
        )
    )
)
