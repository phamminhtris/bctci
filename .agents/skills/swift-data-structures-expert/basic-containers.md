# `BasicContainers` — Noncopyable Array & Deque Variants

**Module**: `BasicContainers` (and `DequeModule` for `UniqueDeque`/`RigidDeque`)
**Public source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/BasicContainers/` and `Sources/DequeModule/`
**Requires**: Swift 6.2+ for `RigidArray`/`UniqueArray` — see `RigidArray.swift:19-24`; without 6.2 the types are declared `@available(unavailable)`.

## TL;DR

A family of ownership-aware container types that are **noncopyable**. They allow `~Copyable` elements and have **predictable, never-spiking** performance — there's no copy-on-write machinery, so a "subscript-set on a shared value" simply cannot happen.

Two axes:

| Axis     | Capacity behaviour     | Variants                               |
| -------- | ---------------------- | -------------------------------------- |
| Array    | Fixed                  | `RigidArray<Element>`                  |
| Array    | Auto-grows by 1.5×     | `UniqueArray<Element>`                 |
| Deque    | Fixed                  | `RigidDeque<Element>`                  |
| Deque    | Auto-grows by 1.5×     | `UniqueDeque<Element>`                 |

Plus:

- `UniqueBox<Value>` — heap-allocated noncopyable wrapper (`Sources/ContainersPreview/Types/UniqueBox.swift` referenced by the module README).
- `TrailingArray` — for C-interop with header-then-elements struct layouts. See [unstable.md](unstable.md) since `TrailingElementsModule` is a niche use case.

The unstable trait `UnstableHashedContainers` additionally enables `UniqueSet`/`RigidSet`/`UniqueDictionary`/`RigidDictionary` (Robin Hood hashing) — see `README.md:185-203`.

---

# `RigidArray<Element: ~Copyable>` — fixed-capacity noncopyable array

## Memory layout

`Sources/BasicContainers/RigidArray/RigidArray.swift:84-102`:

```swift
public struct RigidArray<Element: ~Copyable>: ~Copyable {
  internal var _storage: UnsafeMutableBufferPointer<Element>
  internal var _count: Int
  ...
}
```

No class wrapper — `RigidArray` owns its own buffer pointer directly. `deinit` deinitialises the live prefix and deallocates the buffer (line 92-95).

## Capacity behaviour

`RigidArray` is created with an explicit capacity and **never resizes itself**. Trying to append when full traps:

```swift
var items = RigidArray<Int>(capacity: 2)
items.append(1)  // OK
items.append(2)  // OK
items.append(3)  // ⚠️ Runtime error: RigidArray capacity overflow
```

(Citation: `Sources/BasicContainers/RigidArray/RigidArray.swift:51-54` doc-comment.) The DocC overview at `Sources/BasicContainers/BasicContainers.docc/BasicContainers.md:48-53` carries a parallel example with different numbers.

To resize, call `reallocate(capacity:)` (`RigidArray.swift:351-361`) — this is **explicit** and **O(`count`)** because it deallocates the old storage and moves elements over.

## Operations — complexity

All operations are O(1) per element, no COW costs. Citations are in `Sources/BasicContainers/RigidArray/*.swift`.

| Operation                          | Complexity                  | Source |
| ---------------------------------- | --------------------------- | ------ |
| `count`, `capacity`                | O(1)                        | `RigidArray.swift:113-118` |
| `isFull`, `freeCapacity`           | O(1)                        | `RigidArray.swift:124-138` |
| `subscript(i)` get/set             | O(1) — no COW                | `RigidArray+*` |
| `append(_:)`                       | O(1), **traps** when full   | `RigidArray+Append.swift` |
| `insert(_:at:)`                    | O(*n*) — shifts elements     | `RigidArray+Insertions.swift` |
| `remove(at:)`                      | O(*n*)                       | `RigidArray+Removals.swift` |
| `removeLast()`                     | O(1)                        | same |
| `reallocate(capacity:)`            | O(`count`)                   | `RigidArray.swift:351-361` |
| `reserveCapacity(_:)` (only grow)  | O(`count`) if grow needed   | `RigidArray.swift:371-375` |
| `span` / `mutableSpan`             | O(1) — direct view           | `RigidArray.swift:155-196` |
| `edit { OutputSpan in … }`         | O(1) overhead + body cost   | `RigidArray.swift:218-228` |
| `clone()` / `clone(capacity:)`     | O(`count`) — explicit copy   | `RigidArray.swift:383-407` |

`RigidArray` is **`@unchecked Sendable` when `Element: Sendable & ~Copyable`** (line 105).

## When to use `RigidArray`

Quoting `Sources/BasicContainers/RigidArray/RigidArray.swift:72-76`:

> *"This trading of usability in favor of stable performance limits `RigidArray` to the most resource-constrained of use cases, such as space-constrained environments that require carefully accounting of every heap allocation, or time-constrained applications that cannot accommodate unexpected latency spikes due to a reallocation getting triggered at an inopportune moment."*

So:
- Real-time / latency-sensitive code (audio render loops, deadline-driven systems).
- Embedded / memory-budgeted code where over-allocation is unacceptable.
- Foreign-function interop where capacity is dictated by an external constraint.

---

# `UniqueArray<Element: ~Copyable>` — dynamically growing noncopyable array

## Memory layout

`Sources/BasicContainers/UniqueArray/UniqueArray.swift:66-74`:

```swift
public struct UniqueArray<Element: ~Copyable>: ~Copyable {
  internal var _storage: RigidArray<Element>
  ...
}
```

So `UniqueArray` is **literally a wrapper around `RigidArray`** that forwards operations and adds automatic growth on append. Implementation detail confirmed in `BasicContainers.docc/BasicContainers.md:61`:

> *"`UniqueArray` is a relatively simple wrapper around rigid array instance, forwarding operations to it when possible."*

## Growth factor

`UniqueArray.swift:240-246`:

```swift
internal func _growUniqueArrayCapacity(_ capacity: Int) -> Int {
  // A growth factor of 1.5 seems like a reasonable compromise between
  // over-allocating memory and wasting cycles on repeatedly resizing storage.
  let c = (3 &* UInt(bitPattern: capacity) &+ 1) / 2
  return Int(bitPattern: c)
}
```

**1.5× geometric growth**, same as `Deque`. (Note: this is different from stdlib `Array` which uses 2×.)

## Why use `UniqueArray` over stdlib `Array`?

Citation: `BasicContainers.docc/BasicContainers.md:17-42`. The example shows how `Array`'s value-semantics + COW can produce hidden quadratic blowup when a snapshot is captured inside a hot loop:

```swift
var items = Array(100 ..< 200)
for i in items.indices {
    let old = items                 // takes a shared snapshot
    items[i] *= 2                   // 🐌 now forces a full COW copy on every iteration
    precondition(old[i] != items[i])
}
```

This is O(*n*²) and there is **no syntactic hint** of the cost. `UniqueArray` rejects this at compile time — you cannot take a shared snapshot (the value is consumed), so the subscript mutation is *guaranteed* O(1).

```swift
var items = UniqueArray(copying: 100 ..< 200)
for i in items.indices {
    let old = items        // error: 'items' used after consume
    items[i] *= 2
    precondition(old[i] != items[i])
}
```

(Quoted from the same doc.)

## Operations — complexity

`UniqueArray` forwards everything to `RigidArray`. The difference is `append(_:)` etc. transparently call `_ensureFreeCapacity` (`UniqueArray.swift:280-297`) which may trigger O(`count`) reallocation. Amortised complexity is therefore identical to stdlib `Array`, but **without the COW spike**.

| Operation                          | Complexity                   | Notes |
| ---------------------------------- | ---------------------------- | ----- |
| `append(_:)`                       | O(1) amortized                | reallocates at 1.5× when full |
| `subscript(i)` mutate              | **O(1) guaranteed**           | no COW; impossible to have shared storage |
| `insert(_:at:)`                    | O(*n*)                        | shift |
| `remove(at:)`                      | O(*n*)                        | shift |
| `reserveCapacity(_:)`              | O(`count`)                    | UniqueArray.swift:273-277 |
| `clone()`                          | O(`count`) — **explicit** copy | UniqueArray.swift:308-313 |

`UniqueArray` is `Sendable where Element: Sendable & ~Copyable` (line 77).

**Conditional conformances**: `UniqueArray.Equatable` and `UniqueArray.Hashable` are gated behind the experimental `UnstableContainersPreview` package trait and the `compiler(>=6.4)` check. Treat these as not-yet-stable; use `==` on `UniqueArray` only when the trait is explicitly enabled.

---

# `UniqueDeque<Element>` and `RigidDeque<Element>` — noncopyable Deque variants

**Module**: `DequeModule` (declared alongside `Deque`).
**Source**: `Sources/DequeModule/UniqueDeque/UniqueDeque.swift`, `Sources/DequeModule/RigidDeque/RigidDeque.swift`.

These mirror `UniqueArray`/`RigidArray` exactly, but with the circular-buffer algorithm from [deque.md](deque.md):

| Type             | Capacity                              | Algorithm                |
| ---------------- | ------------------------------------- | ------------------------ |
| `RigidDeque`     | Fixed, traps on overflow              | Ring buffer (start + count) |
| `UniqueDeque`    | Auto-grows by 1.5×                    | Ring buffer + reallocate |

Both are noncopyable, both expose `span`/`mutableSpan`, both support `prepend`/`popFirst` in O(1).

### Subdirectories

- `Sources/DequeModule/RigidDeque/RigidDeque+Append.swift` etc.
- `Sources/DequeModule/UniqueDeque/UniqueDeque+Append.swift` etc.

Each operation family is in its own file (Append, Prepend, Insertions, Removals, Replacements, Consumption, Container conformance).

## When to use `UniqueDeque` over `Deque`

Same rationale as `UniqueArray` over `Array`:
- Element is `~Copyable`.
- You need predictable performance (no COW spike).
- You don't need value-semantics — you're using the deque from a single owner.

---

# `UniqueBox<Value>` (in `ContainersPreview`)

A heap-allocated noncopyable wrapper for *any* (potentially noncopyable) value. Public, stable surface even though most of `ContainersPreview` is gated behind the `UnstableContainersPreview` package trait.

Citation: `README.md:120-123`. Source: `Sources/ContainersPreview/Types/UniqueBox.swift`.

Use cases:
- Forcing a value to live on the heap (e.g. recursive type with noncopyable wrapper).
- Holding a `~Copyable` value where Swift's stack-promotion rules wouldn't allow it.

---

# Unstable hashed variants (require `UnstableHashedContainers` trait)

| Type                          | Algorithm                | Source |
| ----------------------------- | ------------------------ | ------ |
| `UniqueSet<Element>`          | Robin Hood hashing       | `Sources/BasicContainers/UniqueSet/` |
| `RigidSet<Element>`           | Robin Hood hashing       | `Sources/BasicContainers/RigidSet/` |
| `UniqueDictionary<Key,Value>` | Robin Hood hashing       | `Sources/BasicContainers/UniqueDictionary/` |
| `RigidDictionary<Key,Value>`  | Robin Hood hashing       | `Sources/BasicContainers/RigidDictionary/` |

From `README.md:185-203`:

> *"Under the hood, these containers implement Robin Hood hashing, achieving better memory utilization and more consistent lookup performance when compared to the standard `Set` and `Dictionary` types."*

These need to remain unstable until generalised `Equatable`/`Hashable` for noncopyable types ships in the Standard Library.

---

# `TrailingElementsModule`

Provides `TrailingArray`, `TrailingElements`, `TrailingPadding` for **C interop** with the struct-with-flexible-array-member pattern:

```c
struct PacketWithPayload {
    int header_length;
    int payload_length;
    char payload[];   // flexible array
};
```

`TrailingArray` is a *low-level, ownership-aware variant of `ManagedBuffer`* for this layout. See `README.md:105-114`.

Not a general-purpose collection — only relevant for FFI. See its DocC docs for details: `Sources/TrailingElementsModule/TrailingElementsModule.docc/`.
