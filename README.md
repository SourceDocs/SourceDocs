# SourceDocs

![SourceDocs Header](http://www.enekoalonso.com/media/sourcedocs-header.jpg)

SourceDocs is a command line tool, written in Swift, that generates markdown
documentation files from inline source code comments.

    $ sourcedocs --spm-module SourceDocsDemo
    Parsing SampleCode.swift (1/1)
    Generating Markdown documentation...
      Writting documentation file: Docs/Reference/SourceDocsDemo/extensions/Nameable.md ✔
      Writting documentation file: Docs/Reference/SourceDocsDemo/extensions/Dog.md ✔
      Writting documentation file: Docs/Reference/SourceDocsDemo/protocols/Animal.md ✔
      Writting documentation file: Docs/Reference/SourceDocsDemo/protocols/Nameable.md ✔
      Writting documentation file: Docs/Reference/SourceDocsDemo/protocols/Speaker.md ✔
      Writting documentation file: Docs/Reference/SourceDocsDemo/README.md ✔
    Done 🎉

Similar to Sphinx or Jazzy, SourceDocs parses your Swift source code and
generates beautiful reference documentation. In contrast to those other tools,
SourceDocs generates markdown files that you can store and browse inline
within your project repository.


## Installation
Make sure the Swift 4 runtime is installed in your computer
(Swift 4 comes with Xcode 9).

### Homebrew

    $ brew install eneko/tap/sourcedocs

### Swift Package Manager

    $ git clone https://github.com/eneko/SourceDocs.git
    $ cd SourceDocs
    $ make


## Usage
To generate documentation from your source code, run the `sourcedocs` command
directly from the root your project.

    $ cd ~/path/to/MyAppOrFramework
    $ sourcedocs

This command will analyze your MyAppOrFramework project and generate reference
documentation from all public types found. The documentation is written to
the directory `Docs/Reference` relative to the root of your project repository.

### Usage options
Typing `sourcedocs --help` we get a list of all available options:

    $ sourcedocs --help
    SourceDocs v0.2.0

    OVERVIEW: Generate Markdown reference documentation from inline source code comments

    USAGE:
        sourcedocs [xcodebuild arguments]
        sourcedocs --spm-module <module name>
        sourcedocs --module <module name> [xcodebuild arguments]

    OPTIONS:
      [xcodebuild arguments]
        Optional parameters to pass to xcodebuild needed to build (scheme, workspace, etc)

      --spm-module <module name>
        Name of the Swift Package Manager module to build

      --module <module name> (optional)
        Name of the Swift module to build with xcodebuild

      --clean
        Delete reference documentation directory (Docs/Reference)

      --version
        Prints the executable version

      --help
        Prints this help

Usually, for most Xcode projects, no parameters are needed at all. `xcodebuild`
should be able to find the default project and scheme.

If the command fails, try specifying the scheme (`-scheme SchemeName`) or the
workspace. Any arguments passed to `sourcedocs` will be passed to `xcodebuild`
without modification.

If you are not using Xcode, you can specify a module name using the
`--spm-module` or `--module` parameters.


## Generated documentation
SourceDocs writes documentation files to the `Docs/Reference` directory relative
to your project root. This allows for the generated documentation to live along
other hand-crafted documentation you might have written or will write in the future.

When specifying a module name, the documentation files will be written to
`Docs/Reference/<module name>`.

We highly recommend adding the generated documentation to your source code
repository, so it can be easily browsed inline. GitHub and BitBucket do a great
job rendering Markdown files, so your documentation will be very nice to read.

**Example Generated Documentation**
![SourceDocs Example](http://www.enekoalonso.com/media/sourcedocs-example.png)


## Contact
Follow and contact me on Twitter at [@eneko](https://www.twitter.com/eneko).


## Contributions
If you find an issue, just [open a ticket](https://github.com/eneko/SourceDocs/issues/new)
on it. Pull requests are warmly welcome as well.


## License
SourceDocs is licensed under the MIT license. See [LICENSE](/LICENSE) for more info.
