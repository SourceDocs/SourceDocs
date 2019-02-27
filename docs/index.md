---
title: SourceDocs
permalink: /
desc: Command Line Tool that generates Markdown documentation from inline source code comments
---

# SourceDocs

[![Release](https://img.shields.io/github/release/eneko/sourcedocs.svg)](https://github.com/eneko/SourceDocs/releases)
[![Build Status](https://travis-ci.org/eneko/SourceDocs.svg?branch=master)](https://travis-ci.org/eneko/SourceDocs)
[![codecov](https://codecov.io/gh/eneko/SourceDocs/branch/master/graph/badge.svg)](https://codecov.io/gh/eneko/SourceDocs)
![Swift 4.1](https://img.shields.io/badge/Swift-4.1-orange.svg)
[![Swift Package Manager Compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg)](https://swift.org/package-manager)

![SourceDocs Header](http://www.enekoalonso.com/media/sourcedocs-header.jpg)

SourceDocs is a command line tool that generates markdown
documentation files from inline source code comments.

![Terminal Output](http://www.enekoalonso.com/media/sourcedocs-terminal.png)

Similar to Sphinx or Jazzy, SourceDocs parses your Swift source code and
generates beautiful reference documentation. In contrast to those other tools,
SourceDocs generates markdown files that you can store and browse inline
within your project repository or render with GitHub Pages.

### Features
- ✅ Browse reference documentation within the project repository (great for
  private projects)
- ✅ Browse reference documentation on GitHub Pages (great for public projects)


## Usage
To generate documentation from your source code, run the `sourcedocs` command
directly from the root your project.

    $ cd ~/path/to/MyAppOrFramework
    $ sourcedocs generate

This command will analyze your MyAppOrFramework project and generate reference
documentation from all public types found. The documentation is written to
the directory `Documentation/Reference` relative to the root of your project repository.

### Usage options
Typing `sourcedocs help` we get a list of all available commands:

    $ sourcedocs help
    Available commands:

    clean      Delete the output folder and quit.
    generate   Generates the Markdown documentation
    help       Display general or command-specific help
    version    Display the current version of SourceDocs

Typing `sourcedocs help <command>` we get a list of all options for that command:

    $ sourcedocs help generate

    Generates the Markdown documentation

    [--spm-module (string)]
    	Generate documentation for Swift Package Manager module.

    [--module-name (string)]
    	Generate documentation for a Swift module.

    [--output-folder (string)]
    	Output directory (defaults to Documentation/Reference).

    --clean|-c
    	Delete output folder before generating documentation.

    [[]]
    	List of arguments to pass to xcodebuild.

Usually, for most Xcode projects, no parameters are needed at all. `xcodebuild`
should be able to find the default project and scheme.

If the command fails, try specifying the scheme (`-scheme SchemeName`) or the
workspace. Any arguments passed to `sourcedocs` after `--` will be passed to
`xcodebuild` without modification.

    $ sourcedocs generate -- -scheme MyScheme

For Swift Package Manager modules, you can the module name using the
`--spm-module` parameter.

    $ sourcedocs generate --spm-module SourceDocsDemo


## Generated documentation
SourceDocs writes documentation files to the `Documentation/Reference` directory relative
to your project root. This allows for the generated documentation to live along
other hand-crafted documentation you might have written or will write in the future.

When specifying a module name, the documentation files will be written to
`Documentation/Reference/<module name>`.

We highly recommend adding the generated documentation to your source code
repository, so it can be easily browsed inline. GitHub and BitBucket do a great
job rendering Markdown files, so your documentation will be very nice to read.

**Example Generated Documentation**

![SourceDocs Example](http://www.enekoalonso.com/media/sourcedocs-example.png)


## Installation

### Download Binary

    $ curl -Ls https://github.com/eneko/SourceDocs/releases/download/latest/sourcedocs.macos.zip -o /tmp/sourcedocs.macos.zip
    $ unzip -j -d /usr/local/bin /tmp/sourcedocs.macos.zip 

### From Sources
Requirements:
- Swift 4 runtime and Xcode installed in your computer.

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
