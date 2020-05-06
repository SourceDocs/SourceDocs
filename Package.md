# Package: **SourceDocs**

## Products

List of products in SourceDocs package.

| Product | Type | Targets |
| ------- | ---- | ------- |
| sourcedocs | Executable | SourceDocsCLI |
| SourceDocsLib | Library (automatic) | SourceDocsLib |

_Libraries denoted 'automatic' can be both static or dynamic._

## Modules

### Program Modules

| Module | Type | Dependencies |
| ------ | ---- | ------------ |
| SourceDocsCLI | Regular | ArgumentParser, Rainbow, SourceDocsLib |
| SourceDocsLib | Regular | MarkdownGenerator, Rainbow, SourceKittenFramework, SwiftPM-auto, System |
| SourceDocsDemo | Regular |  |

### Test Modules

| Module | Type | Dependencies |
| ------ | ---- | ------------ |
| SourceDocsCLITests | Test | System |
| SourceDocsLibTests | Test | SourceDocsLib |

### Module Dependency Graph

[![Module Dependency Graph](PackageModules.png)](PackageModules.png)

## Package Dependecies

| Package | Versions |
| ------- | -------- |
| swift-argument-parser  | 0.0.1..<1.0.0 |
| swift-package-manager  | branch[master] |
| SourceKitten  | 0.29.0..<1.0.0 |
| MarkdownGenerator  | 0.4.0..<1.0.0 |
| Rainbow  | 3.0.0..<4.0.0 |
| System  | 0.3.0..<1.0.0 |

### Package Dependency Graph

graph

## Requirements

### Minimum Required Versions

| Platform | Version |
| -------- | ------- |
| macOS | 10.13 |
