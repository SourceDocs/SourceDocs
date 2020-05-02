# Package: SourceDocs

## Products

| Product | Type | Targets |
| ------- | ---- | ------- |
| sourcedocs | executable | SourceDocsCLI |
| SourceDocsLib | automatic | SourceDocsLib |

## Targets

| Target | Type | Dependencies |
| ------ | ---- | ------------ |
| SourceDocsCLI | regular | SourceDocsLib, ArgumentParser, Rainbow |
| SourceDocsLib | regular | SourceKittenFramework, MarkdownGenerator, Rainbow, System, SwiftPM |
| SourceDocsDemo | regular |  |
| SourceDocsCLITests | test | System |
| SourceDocsLibTests | test | SourceDocsLib |

    digraph TargetDependenciesGraph {
        graph [fontname="Helvetica-light", style = filled, color = "#eaeaea"]
        node [shape=box, fontname="Helvetica", style=filled]
        edge [color="#545454"]

        subgraph clusterRegular {
        label = "Targets"
        node [color="#caecec"]
        SourceDocsCLI
        SourceDocsLib
        SourceDocsDemo
    }
        subgraph clusterTests {
        label = "Tests"
        node [color="#aaccee"]
        SourceDocsCLITests
        SourceDocsLibTests
    }
        subgraph clusterExternal {
        label = "Dependencies"
        node [color="#fafafa"]
        System
        Rainbow
        MarkdownGenerator
        SourceKittenFramework
        ArgumentParser
        SwiftPM
    }

        SourceDocsCLI -> SourceDocsLib
        SourceDocsCLI -> ArgumentParser
        SourceDocsCLI -> Rainbow
        SourceDocsLib -> SourceKittenFramework
        SourceDocsLib -> MarkdownGenerator
        SourceDocsLib -> Rainbow
        SourceDocsLib -> System
        SourceDocsLib -> SwiftPM
        SourceDocsCLITests -> System
        SourceDocsLibTests -> SourceDocsLib
    }