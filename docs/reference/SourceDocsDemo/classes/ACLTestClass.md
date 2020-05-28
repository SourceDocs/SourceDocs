**CLASS**

# `ACLTestClass`

```swift
open class ACLTestClass
```

A class to test documentation of different access levels
- By default, only `open` and `public` ACL are documented
- Use `--min-acl` to specify different levels of ACL to be documented:
  - `--min-acl private` will document `private`, `fileprivate`, `internal`, `public`, & `open`
  - `--min-acl fileprivate` will document `fileprivate`, `internal`, `public`, & `open`
  - `--min-acl internal` will document `internal`, `public`, & `open`
  - `--min-acl public` will document `public`, & `open`
  - `--min-acl open` will document `open`

## Methods
### `openMethod()`

```swift
open func openMethod()
```

Method with `open` access level

### `publicMethod()`

```swift
public func publicMethod()
```

Method with `public` access level
