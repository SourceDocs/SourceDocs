**STRUCT**

# `FullMarkup`

```swift
public struct FullMarkup
```

This `FullType` struct intends to cover every markup delimiter supported by Xcode.

> Markup uses simple character-based delimiters to mark formatted text in playgrounds
> and in Quick Help for Swift symbols.

> The different delimiters include functionality for:

> - Formatting a line of text such as a creating a heading
> - Formatting multiple lines of text such as creating a bulleted list
> - Formatting a span of characters such as adding emphasis to a string
> - Inserting links to web based content
> - Inserting assets such as images and videos
> - Inserting callouts such as examples in playgrounds and parameters in Quick Help.
> - Escaping special characters, including markup delimiters

> Some of the delimiters are used for both rendered playground documentation and in
> Quick Help. Other delimiters are used with either playgrounds or with Quick Help. The documentation
> for each delimiter includes information on where it can be used.

> In Xcode, markup for Swift symbols is used for Quick Help and for the description shown in symbol completion.

List of markup delimiters can be found here:
https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/MarkupFunctionality.html

Example image:
![Quick Help in Xcode](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Art/MFR_quickhelp_eg_2x.png)

## Methods
### `hello(name:)`

```swift
public func hello(name: String) throws -> String
```

Method to say hello to a person or thing

This should be the discussion, where we can ellaborate what
the method does, providing details and examples.

---

# Heading 1
Foo

## Heading 2
Bar

### Heading 3
Baz

    print("This is some code")

> This should be blockquoted text

````
dump("Code block with backquotes")
````

An ordered list of elements:
1. Foo
1. Bar
1. Baz

A bulleted list:
* Foo
* Bar
* Baz

*Italics* and _italics_
**Bold** and **bold**

\* This is not a bullet item

***

- Attention: Use the callout to highlight information for the user of the symbol.
- Author: Use the callout to display the author of the code for a symbol.
- Authors:
    A

    List

    Of
    Authors
- Bug: Use the callout to display a bug for a symbol.
- Complexity: Use the callout to display the algorithmic complexity of a method or function.
- Copyright: Use the callout to display copyright information for a symbol.
- Date: May 28, 2020
- Experiment: Here is some example code:
  ```
  FullMarkup.hello(name: "Foo")
  ```
- Important: Use the callout to highlight information that can have adverse effects on the tasks a user is
    trying to accomplish.
- Invariant: Use the callout to display a condition that is guaranteed to be true during the execution of the
    documented symbol.
- Note: This is a note, that I'm sure of
- Parameter name: Name of the person or thing to salute
- Parameters:
  - name: Name of the person or thing to salute
- Postcondition: Use the callout to document conditions which have guaranteed values upon completion
    of the execution of the symbol.
- Precondition: Use the callout to document any conditions that are held for the documented symbol to work.
- Remark: This is _remarkable_
- Requires: Non-empty name
- Returns: `String` with salute (eg. "Hello, Kelly!")
- SeeAlso: Use the callout to add references to other information.
- Since: Use the callout to add information about when the symbol became available. Some example of
         the types of information include dates, framework versions, and operating system versions.
- Throws: `Error.noName` when name is empty
- ToDo: Use the callout to add tasks required to complete or update the functionality of the symbol.
- Version: v1.2.3
- Warning: So many delimiters
- Foo: Custom unsuported delimiters, appear as bulleted list items

This is more text after all the delimiters list. Still part of the main discussion.

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | Name of the person or thing to salute |
| name | Name of the person or thing to salute |