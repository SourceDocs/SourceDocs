**CLASS**

# `Cat`

```swift
open class Cat : Animal, Nameable
```

> Common animal many people have as pets, which is not a dog
>
> ![The real head of the household?](https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif)
>
> [google it](http://www.google.com)
>
> ```html
>     <html>
>         <body>
>
>             <h1>My First Heading</h1>
>
>             <p>My first paragraph.</p>
>
>         </body>
>     </html>
> ```
>
> ```swift
> var unspecifiedLanguagueVar = 1
> ```
>
> ```swift
>     let swiftyConstant = 1
> ```

## Properties
### `name`

```swift
public let name: String
```

> All cats should have a name too

### `owner`

```swift
public var owner: String?
```

> Some cats have an owner

### `family`

```swift
public static let family: String
```

> All cats are felines

## Methods
### `init(name:owner:)`

```swift
public init(name: String, owner: String?)
```

> Initialize a new Cat with an name and an owner’s name
>
> The name of the cat.
>
>
>
> <details><summary markdown="span">Note</summary>
>
>
>
> Name must be fun!
>
> </details>
>
>
>
> <details><summary markdown="span">Warning</summary>
>
>
>
> Nyan Nyan Nyan Nyan Nyan
>
> </details>
>
>

#### Parameters

| Name | Description |
| ---- | ----------- |
| name | The name of the cat. |
| owner | The cat’s owners name. |

### `greet()`

```swift
func greet()
```

> Print a greeting message
