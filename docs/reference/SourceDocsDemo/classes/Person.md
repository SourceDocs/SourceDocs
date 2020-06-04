**CLASS**

# `Person`

```swift
open class Person: Human
```

All persons are humans.

## Properties
### `kind`

```swift
open var kind: AnimalKind = .mammal
```

### `isAlive`

```swift
open var isAlive: Bool
```

### `age`

```swift
open var age: UInt
```

### `givenName`

```swift
open var givenName: String
```

### `familyName`

```swift
open var familyName: String?
```

### `animals`

```swift
open var animals: [OwnableAnimal] = []
```

## Methods
### `init(givenName:familyName:)`

```swift
public init(givenName: String, familyName: String)
```
