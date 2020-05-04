# Package: SourceDocs

## Products

| Product | Type | Targets |
| ------- | ---- | ------- |
| sourcedocs | 🏎 Executable | SourceDocsCLI |
| SourceDocsLib | 💼 Library (automatic) | SourceDocsLib |

## Modules

| Module | Type | Dependencies |
| ------ | ---- | ------------ |
| SourceDocsCLI | regular | SourceDocsLib, ArgumentParser, Rainbow |
| SourceDocsLib | regular | SourceKittenFramework, MarkdownGenerator, Rainbow, System, SwiftPM |
| SourceDocsDemo | regular |  |
| SourceDocsCLITests | test | System |
| SourceDocsLibTests | test | SourceDocsLib |

### Module Dependency Graph

![](PackageModules.png)

## Package Dependecies

### Package Dependency Graph