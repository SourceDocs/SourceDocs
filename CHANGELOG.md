## Master

#### Breaking
- None

#### Enhancements
- None

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
