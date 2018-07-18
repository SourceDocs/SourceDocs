**ENUM**

# `DomesticationState`

```swift
public enum DomesticationState
```

> Describes the state of domestication
>
> - domesticated: For animal that are domesticated.
> - undomesticated: For animal that are not domesticated.
> - unknown: For animals which have an unknown domestication state.
>
> Here is a comment with raw html
>
> <svg width="100" height="100"><rect width="100" height="100" style="fill:rgba(0,150,0,1);"></rect></svg>

## Cases
### `domesticated`

```swift
case domesticated
```

> For animal that are domesticated.

### `undomesticated`

```swift
case undomesticated
```

> For animal that are not domesticated.

### `unknown`

```swift
case unknown(String)
```

> For animals which have an unknown domestication state.
