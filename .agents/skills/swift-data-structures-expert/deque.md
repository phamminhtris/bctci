# `Deque<Element>` — Double-Ended Queue

**Module**: `DequeModule` (also re-exported from `Collections`)
**Header path**: `import DequeModule` or `import Collections`
**Public source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/DequeModule/Deque/`
**`@frozen`**: yes — `Sources/DequeModule/Deque/Deque.swift:84`
**Sendable**: `@unchecked Sendable where Element: Sendable` — `Deque.swift:109`

## TL;DR

A value-type collection that supports O(1) amortized push/pop at **both** ends. Same indexing as `Array`. COW. Backed by a ring buffer.

## Memory layout

The single stored property of `Deque<Element>` is `_storage: _Storage` (`Deque.swift:90`). `_Storage` wraps a `ManagedBufferPointer<_DequeBufferHeader, Element>` (`Deque._Storage.swift:19`), i.e. a single heap-allocated buffer with this layout:

```
┌──────────────────────────┐  ← class instance (_DequeBuffer)
│   ObjC ISA, refcount     │
├──────────────────────────┤
│  _DequeBufferHeader      │  ┐
│   ├ capacity: Int        │  │ header, 24 B + class overhead
│   ├ count: Int           │  │
│   └ startSlot: _DequeSlot│  ┘
├──────────────────────────┤
│  Element [0]             │  ┐
│  Element [1]             │  │ ManagedBuffer's tail-allocated
│       …                  │  │ Element storage (capacity slots)
│  Element [capacity-1]    │  ┘
└──────────────────────────┘
```

Header struct: `Sources/DequeModule/Deque/_DequeBufferHeader.swift:14-44`. Class: `Sources/DequeModule/Deque/_DequeBuffer.swift:14-35`.

## The ring-buffer trick

The live elements occupy slots `startSlot, startSlot+1, …, startSlot+count-1`, taken **modulo capacity**. That means when `startSlot + count > capacity`, the live region wraps to the front of the buffer and lives in two disjoint contiguous segments.

```
capacity = 8, count = 5, startSlot = 6:

  buffer index :  0    1    2    3    4    5    6    7
  contents     : [e2] [e3] [e4] .    .    .   [e0] [e1]
                  ↑                            ↑
                  second segment               first segment (startSlot)
```

The deinit handles this two-segment case: `_DequeBuffer.swift:19-32` calls `deinitialize(count:)` on the two regions separately.

`_DequeSlot` is a `@frozen` wrapper around `Int` that represents a slot index — `Sources/DequeModule/_DequeSlot.swift:14-26`. `advanced(by:)` (line 35-37) uses `&+` to allow positions to advance without trapping on `Int` overflow; the actual modulo-by-`capacity` translation (mapping a logical slot to its position inside the buffer) is performed separately by the storage handle.

## Why this layout = O(1) at both ends

- **`append(_:)`**: write into `slot(startSlot + count)`, increment `count`. No element shifting.
- **`prepend(_:)`**: decrement `startSlot` (mod capacity), write into the new `startSlot`, increment `count`. No shifting.
- **`popFirst()`**: read at `startSlot`, deinitialize, increment `startSlot`, decrement `count`.
- **`popLast()`**: read at `slot(startSlot + count - 1)`, deinitialize, decrement `count`.

All four are O(1). When `count == capacity`, append/prepend trigger reallocation — that single call becomes O(`count`), but amortized O(1) because growth is geometric (see below).

## Capacity growth

From `Sources/DequeModule/Deque/Deque._Storage.swift:160-167`:

```swift
internal func _growCapacity(
  to minimumCapacity: Int,
  linearly: Bool
) -> Int {
  if linearly { return Swift.max(capacity, minimumCapacity) }
  let c = (3 &* UInt(bitPattern: capacity) &+ 1) &>> 1
  return Swift.max(Int(bitPattern: c), minimumCapacity)
}
```

`(3 * capacity + 1) / 2` → **1.5× geometric growth**. (Compare `Array` which uses 2× in the stdlib.) This is the standard amortized-O(1) growth pattern.

## Copy-on-write

`Deque` exposes value semantics but shares storage until mutation. See `Deque._Storage.swift:140-156`:

```swift
mutating func ensureUnique() {
  if isUnique() { return }
  self._makeUniqueCopy()       // O(count) copy
}
```

When the buffer's reference count exceeds 1, the next mutation pays an O(`count`) deep copy. This is identical to `Array`'s COW model.

The doc-comment for the type explains this: `Deque.swift:45-48`:

> *"This is implemented with the copy-on-write optimization. Multiple copies of a deque share the same underlying storage until you modify one of the copies."*

## Operations — full table

| Operation                            | Complexity                | Source                                   |
| ------------------------------------ | ------------------------- | ---------------------------------------- |
| `init()`                             | O(1) (allocates empty)    | `Deque.swift:104-106`                    |
| `init(minimumCapacity:)`             | O(`capacity`)             | `Deque.swift:103-106`                    |
| `count`, `isEmpty`                   | O(1)                      | `Deque._Storage.swift:90-94`             |
| `subscript(i)` get                   | O(1)                      | `Deque+Collection.swift:353` — *"Reading an element from a deque is O(1)"* |
| `subscript(i)` set                   | O(1) when unique; O(`count`) otherwise (COW copy) | `Deque+Collection.swift:353-355` |
| `startIndex`, `endIndex`             | O(1)                      | always 0 and `count`                     |
| `append(_:)`                         | Amortized O(1)            | `Deque+Collection.swift:658` doc-comment |
| `append(contentsOf:)`                | Amortized O(`newElements.count`) | `Deque+Collection.swift:682, 724`  |
| `prepend(_:)`                        | Amortized O(1)            | `Deque+Extras.swift:111` doc-comment     |
| `prepend(contentsOf:)`               | Amortized O(`newElements.count`) | `Deque+Extras.swift:135, 172`      |
| `popFirst()`                         | O(1) when unique; O(`count`) otherwise | `Deque+Extras.swift:74-75` |
| `popLast()`                          | O(1) when unique; O(`count`) otherwise | `Deque+Collection.swift:155-156` |
| `removeFirst()`                      | O(1) when unique; O(`count`) otherwise | `Deque+Collection.swift:433-434` |
| `removeLast()`                       | O(1) when unique; O(`count`) otherwise | `Deque+Collection.swift:464-465` |
| `insert(_:at:)`                      | O(`count`); amortized O(1) at start or end | `Deque+Collection.swift:756-759` doc-comment: *"shifts existing elements either towards the beginning or the end of the deque to minimize the number of elements that need to be moved. When inserting at the start or the end, this reduces the complexity to amortized O(1)."* |
| `insert(contentsOf:at:)`             | O(`count + newElements.count`); amortized O(`newElements.count`) at start/end | `Deque+Collection.swift:791-794` |
| `remove(at:)`                        | O(`count`); amortized O(1) at start or end | `Deque+Collection.swift` — `remove(at:)` doc-comment mirrors `insert(_:at:)` |
| `removeSubrange(_:)`                 | O(`count`)                | `Deque+Collection.swift:524`             |
| `replaceSubrange(_:with:)`           | O(`self.count + newElements.count`) | `Deque+Collection.swift:544`       |
| `reserveCapacity(_:)`                | O(`count`) when reallocating | `Deque._Storage.swift:178-188`        |
| Iteration                            | O(`count`)                | `Deque+Collection.swift:18-97` — custom iterator handles segment swap at the wrap |
| Copy on shared mutation              | O(`count`)                | `Deque._Storage.swift:155`               |

## Things `Deque` deliberately doesn't expose

From `Documentation/Deque.md:89-93`:

- **No `capacity` property**: "the size of the storage buffer at any given point is an unstable implementation detail that should not affect application logic." Only `reserveCapacity` is offered.
- **No `withUnsafeBufferPointer`**: because storage may be two disjoint segments, no single buffer pointer can address the elements. (Use `Array(deque)` if you need this — O(`count`).)
- **No `NSArray` bridging**: Deque is a Swift-only construct.

## Custom iterator

`Deque` ships its own `IteratorProtocol`-conforming `Iterator` (`Deque+Collection.swift:25-97`) instead of using the default `IndexingIterator`. Why? The doc-comment at line 19-23: *"This custom implementation performs direct storage access to eliminate any and all index validation overhead. It also optimizes away repeated conversions from indices to storage slots."*

Internally the iterator carries `_nextSlot` and `_endSlot` (raw `_DequeSlot`s — `Deque+Collection.swift:31-34`). When the first segment is exhausted it calls `_swapSegment()` to re-arm itself for the second segment — `Deque+Collection.swift:66-79`. This avoids paying for the modulo on every `next()`.

## When to choose `Deque` over `Array`

| You want…                              | Reach for     |
| -------------------------------------- | ------------- |
| Fast `prepend` or `popFirst`           | **`Deque`**   |
| Random-access reads (`x[i]` hot loop)  | `Array` (slightly faster — single contiguous run, no slot arithmetic) |
| `NSArray` interop on Darwin            | `Array`       |
| `withUnsafeBufferPointer` for FFI      | `Array`       |
| Sliding-window / FIFO buffer           | **`Deque`**   |

Source for the comparison: `Documentation/Deque.md:57-69` — *"the operations have different performance characteristics. Mutations near the front are expected to be significantly faster in deques, but arrays may measure slightly faster for general random-access lookups."*

## Conformances

`Sequence`, `Collection`, `BidirectionalCollection`, `RandomAccessCollection`, `MutableCollection`, `RangeReplaceableCollection`, `ExpressibleByArrayLiteral`, `Hashable` (when `Element: Hashable`), `Equatable` (when `Element: Equatable`), `Encodable`/`Decodable` (when `Element` conforms), `CustomReflectable`, `CustomStringConvertible`, `CustomDebugStringConvertible`. Each conformance has a dedicated file in `Sources/DequeModule/Deque/`.

## Related: noncopyable variants

For noncopyable elements or strict-performance use cases, see `UniqueDeque` and `RigidDeque` in [basic-containers.md](basic-containers.md). Same circular-buffer algorithm, no COW.
