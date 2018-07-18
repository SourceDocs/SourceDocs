**EXTENSION**

# `Dictionary`

## Properties
### `hasPublicACL`

```swift
var hasPublicACL: Bool { get }
```

> public info
>
>

## Methods
### `get(_:)`

```swift
func get<T>(_ key: SwiftDocKey) -> T?
```

> Get the value for the key
>
>

#### Parameters

| Name | Description |
| ---- | ----------- |
| key | a `SwiftDocKey` key |

### `isKind(_:)`

```swift
func isKind(_ kind: SwiftDeclarationKind) -> Bool
```

> The kind
>
>

#### Parameters

| Name | Description |
| ---- | ----------- |
| kind | a `SwiftDeclarationKind` |

### `isKind(_:)`

```swift
func isKind(_ kinds: [SwiftDeclarationKind]) -> Bool
```

> The kinds
>
>

#### Parameters

| Name | Description |
| ---- | ----------- |
| kinds | an array of `SwiftDeclarationKind` |