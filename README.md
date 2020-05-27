# SourceDocs

[![Release](https://img.shields.io/github/release/eneko/sourcedocs.svg)](https://github.com/eneko/SourceDocs/releases)
[![Build Status](https://travis-ci.org/eneko/SourceDocs.svg?branch=master)](https://travis-ci.org/eneko/SourceDocs)
[![codecov](https://codecov.io/gh/eneko/SourceDocs/branch/master/graph/badge.svg)](https://codecov.io/gh/eneko/SourceDocs)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Swift Package Manager Compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![codebeat badge](https://codebeat.co/badges/99fcf00c-0aec-40de-b3fe-0c7ed9a169cb)](https://codebeat.co/projects/github-com-eneko-sourcedocs-master)

![SourceDocs Header](http://www.enekoalonso.com/media/sourcedocs-header.jpg)

SourceDocs is a command line tool that generates markdown
documentation files from inline source code comments.

![Terminal Output](http://www.enekoalonso.com/media/sourcedocs-terminal.png)

Similar to Sphinx or Jazzy, SourceDocs parses your Swift source code and
generates beautiful reference documentation. In contrast to those other tools,
SourceDocs generates markdown files that you can store and browse inline
within your project repository. Or even render with GitHub Pages.

### Features
- ✅ Generate reference documentation from Xcode projects
- ✅ Generate reference documentation from Swift Packages
- ✅ Generate package description documentation from Swift Packages


## Generated documentation
SourceDocs writes documentation files to the `Documentation/Reference` directory relative
to your project root (path can be configured). This allows for the generated documentation to 
live along other hand-crafted documentation you might have written or will write in the future.

When specifying a module name, the documentation files will be written to
`Documentation/Reference/<module name>`.

It's recommended adding this generated documentation to the source code
repository, so it can be easily browsed inline. GitHub, BitBucket and other source control
platforms do a great job rendering Markdown files, so documentation is easy to read.

### Examples of Generated Documentation
- [SourceDocsLib](/docs/reference/SourceDocsLib)
- [SourceDocsDemo](/docs/reference/SourceDocsDemo)
- [SourceDocs Package](/docs/Package.md)
- [Apollo iOS API Reference](https://www.apollographql.com/docs/ios/api-reference/)
- [Workflow framework (by Square)](https://square.github.io/workflow/swift/api/Workflow/)



## Usage

### Swift Packages
To generate documentation for a Swift Package, run `sourcedocs` from the root
of your package repository.

    $ cd path/to/MyPackage
    $ sourcedocs generate --all-modules

This command will generate documentation for each module in your Swift package.

For a specific module, pass the module name using the `--spm-module` parameter.

    $ sourcedocs generate --spm-module SourceDocsDemo

### Xcode Projects
To generate documentation from your source code, run `sourcedocs` 
directly from the root your Xcode project.

    $ cd path/to/MyAppOrFramework
    $ sourcedocs generate

This command will analyze your Xcode project and generate reference
documentation from all public types found. 

Usually, for most Xcode projects, no parameters are needed at all. `xcodebuild`
should be able to find the default project and scheme.

If the command fails, try specifying the scheme (`-scheme SchemeName`) or the
workspace. Any arguments passed to `sourcedocs` after `--` will be passed to
`xcodebuild` without modification.

    $ sourcedocs generate -- -scheme MyScheme


## Usage options
Typing `sourcedocs help` we get a list of all available commands:

    $ sourcedocs help
    USAGE: source-docs <subcommand>

    OPTIONS:
      -h, --help              Show help information.

    SUBCOMMANDS:
      clean                   Delete the output folder and quit.
      generate                Generates the Markdown documentation
      package                 Generate PACKAGE.md from Swift package description.
      version                 Display the current version of SourceDocs

Typing `sourcedocs help <command>` we get a list of all options for that command:

    $ sourcedocs generate --help

    OVERVIEW: Generates the Markdown documentation

    USAGE: source-docs generate <options>

    ARGUMENTS:
      <xcode-arguments>       List of arguments to pass to xcodebuild 

    OPTIONS:
      -a, --all-modules       Generate documentation for all modules in a Swift package 
      --spm-module <spm-module>
                              Generate documentation for Swift Package Manager module 
      --module-name <module-name>
                              Generate documentation for a Swift module 
      --link-beginning <link-beginning>
                              The text to begin links with 
      --link-ending <link-ending>
                              The text to end links with (default: .md)
      -i, --input-folder <input-folder>
                              Path to the input directory (default: /Users/ramses.alonso/Development/eneko/SourceDocs)
      -o, --output-folder <output-folder>
                              Output directory to clean (default: Documentation/Reference)
      --min-acl <min-acl>     Access level to include in documentation [private, fileprivate, internal, public, open] (default: public)
      -m, --module-name-path  Include the module name as part of the output folder path 
      -c, --clean             Delete output folder before generating documentation 
      -l, --collapsible       Put methods, properties and enum cases inside collapsible blocks 
      -t, --table-of-contents Generate a table of contents with properties and methods for each type 
      -r, --reproducible-docs Generate documentation that is reproducible: only depends on the sources.
                              For example, this will avoid adding timestamps on the generated files. 
      -h, --help              Show help information


## Installation

### Download Binary

    $ curl -Ls https://github.com/eneko/SourceDocs/releases/download/latest/sourcedocs.macos.zip -o /tmp/sourcedocs.macos.zip
    $ unzip -j -d /usr/local/bin /tmp/sourcedocs.macos.zip 

### From Sources
Requirements:
- Swift 5.1 runtime and Xcode installed in your computer.

#### Using Homebrew

    $ brew install sourcedocs

#### Building with Swift Package Manager

    $ git clone https://github.com/eneko/SourceDocs.git
    $ cd SourceDocs
    $ make


## Contact
Follow and contact me on Twitter at [@eneko](https://www.twitter.com/eneko).


## Contributions
If you find an issue, just [open a ticket](https://github.com/eneko/SourceDocs/issues/new)
on it. Pull requests are warmly welcome as well.


## License
SourceDocs is licensed under the MIT license. See [LICENSE](/LICENSE) for more info.
