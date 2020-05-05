# Package: SourceDocs

## Products

| Product | Type | Targets |
| ------- | ---- | ------- |
| sourcedocs | Executable | SourceDocsCLI |
| SourceDocsLib | Library (automatic) | SourceDocsLib |

## Modules

| Module | Type | Dependencies |
| ------ | ---- | ------------ |
| SourceDocsCLI | Regular | ArgumentParser, SourceDocsLib, Rainbow |
| SourceDocsLib | Regular | SourceKittenFramework, SwiftPM-auto, MarkdownGenerator, Rainbow, System |
| SourceDocsDemo | Regular |  |
| SourceDocsCLITests | Test | System |
| SourceDocsLibTests | Test | SourceDocsLib |

### Module Dependency Graph

![](PackageModules.png)

## Package Dependecies

### Package Dependency Graph