# Package: SourceDocs

## Products

| Product | Type | Targets |
| ------- | ---- | ------- |
| sourcedocs | Executable | SourceDocsCLI |
| SourceDocsLib | Library (automatic) | SourceDocsLib |

## Modules

| Module | Type | Dependencies |
| ------ | ---- | ------------ |
| SourceDocsCLI | Regular | SourceDocsLib, ArgumentParser, Rainbow |
| SourceDocsLib | Regular | SourceKittenFramework, MarkdownGenerator, Rainbow, System, SwiftPM |
| SourceDocsDemo | Regular |  |
| SourceDocsCLITests | Test | System |
| SourceDocsLibTests | Test | SourceDocsLib |

### Module Dependency Graph

![](PackageModules.png)

## Package Dependecies

### Package Dependency Graph