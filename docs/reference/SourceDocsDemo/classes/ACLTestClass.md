**CLASS**

# `ACLTestClass`

```swift
open class ACLTestClass
```

> A class to test documentation of different access levels
> - By default, only `open` and `public` ACL are documented
> - Use `--min-acl` to specify different levels of ACL to be documented:
>   - `--min-acl private` will document `private`, `fileprivate`, `internal`, `public`, & `open`
>   - `--min-acl fileprivate` will document `fileprivate`, `internal`, `public`, & `open`
>   - `--min-acl internal` will document `internal`, `public`, & `open`
>   - `--min-acl public` will document `public`, & `open`
>   - `--min-acl open` will document `open`

## Methods
### `openMethod()`

```swift
open func openMethod()
```

> Method with `open` access level

### `publicMethod()`

```swift
public func publicMethod()
```

> Method with `public` access level

### `implicitInternalMethod()`

```swift
func implicitInternalMethod()
```

> Method with implicit `internal` access level

### `explicitInternalMethod()`

```swift
internal func explicitInternalMethod()
```

> Method with explicit `internal` access level

### `filePrivateMethod()`

```swift
fileprivate func filePrivateMethod()
```

> Method with explicit `fileprivate` access level

### `privateMethod()`

```swift
private func privateMethod()
```

> Method with explicit `private` access level
