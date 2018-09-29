## Master

#### Breaking
- None

#### Enhancements
- None

#### Bug Fixes
- None

## 0.6.1

#### Breaking
- None

#### Enhancements
- None

#### Bug Fixes
- Throw an error where there are no public interfaces
- Remove undocumentated status for obsoleted interfaces

## 0.6.0

#### Breaking
- Change `--output-file` to `--output`.

#### Enhancements
- Enable specification of source directory with `--source`.
- Enable specification of contents filename with `--contents-filename`.
- Support for callouts.
- redesign comment output.
- SVG badge added to contents file.

#### Bug Fixes
- Generate markdown for `open` classes.

## 0.5.1

#### Breaking
- None

#### Enhancements
- None

#### Bug Fixes
- Cannot be installed via Homebrew on Mojave (#10)


## 0.5.0

#### Breaking
- None

#### Enhancements
- Enable collapsible blocks for a cleaner output with `--collapsible`.
- Enable table of contents for each type with `--table-of-contents`.

#### Bug Fixes
- None


## 0.4.0

#### Breaking
- Updated command line argument handling:
  - Use `sourcedocs generate <options>` to generate documentation.
  - Use `sourcedocs clean <options>` to delete the output folder.
  - Use `sourcedocs help <command>` for more help.
- Update default output directory to `Documentation/Reference`

#### Enhancements
- Customize output folder with `--output-folder`.
- Clean output before generating documentation with `--clean`.
- Terminal output is now routed through stdout/stderr.
- Removed "Declaration" title to reduce noise.
- New flag `--module-name-path` to explicitly include module name in output path.

#### Bug Fixes
- Documentation links now work both on Markdown and rendered GitHub Pages.


## 0.3.0

#### Breaking
- None

#### Enhancements
- Use [MarkdownGenerator](https://www.github,com/eneko/MarkdownGenerator)
  framework to generate Markdown output.
- Remove inferred type from output to reduce noise.
- Add contents table for structs, classes and enums.
- Comment output is now block-quoted for better formatting.
- Green checkmarks when writing Markdown files to disk.
- Remove `<sub>` HTML tags for a cleaner Markdown output.
- Remove horizontal guides to reduce noise.

#### Bug Fixes
- None


## 0.2.0

#### Breaking
- Update output directory to `Docs/Reference` to follow Swift Package Manager
  naming conventions for the project folder structure.

#### Enhancements
- Add `--clean` option to remove Reference Docs folder
- Add `--version` option to display current version
- Update `--help` command
- Add `Makefile` for easier manual build and installation

#### Bug Fixes
- None


## 0.1.0
- Initial Release
