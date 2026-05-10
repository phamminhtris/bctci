# Swift Standard Library Collections

This file covers types defined in the Swift Standard Library, **not** in the swift-collections package. Facts here are sourced from:

- **[A]** Apple Developer Documentation (e.g. https://developer.apple.com/documentation/swift/array)
- **[SE-NNNN]** Swift Evolution proposals (https://github.com/apple/swift-evolution/blob/main/proposals/)
- **[SS]** Swift Standard Library source (https://github.com/apple/swift/tree/main/stdlib/public/core)

These citations are URLs because the stdlib source isn't in the swift-collections repo. If a user disputes a claim, point them to the stdlib source directly.

---

# `Array<Element>`

**The default value-typed sequence.** COW, value semantics, bridges to `NSArray` on Darwin platforms.

## Memory layout (high level)

```
Array<T>
└── _ArrayBuffer<T>     ← class (an _NSSwiftArray on Darwin, or _ContiguousArrayBuffer otherwise)
    └── [header][T0, T1, T2, …, Tcap-1]
```

`Array` is one machine word that holds a tagged reference to `_ArrayBuffer`. The buffer class has a header (capacity, count) and tail-allocated `T` storage.

On non-Darwin platforms (Linux, server), `Array == ContiguousArray` essentially — no NSArray bridge.

Reference: [SE-0107](https://github.com/apple/swift-evolution/blob/main/proposals/0107-unsaferawpointer.md) (background on storage). The `_ContiguousArrayStorage` class is here: https://github.com/apple/swift/blob/main/stdlib/public/core/ContiguousArrayBuffer.swift

## Growth factor

**2×** geometric growth (doubling). The standard `_growArrayCapacity` rounds up to a power-of-two-ish size. Confirmed by reading https://github.com/apple/swift/blob/main/stdlib/public/core/ArrayShared.swift — function `_growArrayCapacity`.

(For comparison: `Deque` and `UniqueArray` from swift-collections use **1.5×**.)

## Operations — complexity

| Operation                          | Complexity                              | Source |
| ---------------------------------- | --------------------------------------- | ------ |
| `count`, `isEmpty`                 | O(1)                                    | [A] developer.apple.com/documentation/swift/array |
| `subscript(i)` get/set             | O(1) — RandomAccessCollection           | [A] |
| `append(_:)`                       | O(1) amortized, O(*n*) worst (reallocation) | [A] — "O(1) on average, over many calls" |
| `append(contentsOf:)`              | O(*m*) amortized                        | [A] |
| `insert(_:at:)`                    | O(*n*)                                  | [A] |
| `remove(at:)`                      | O(*n*)                                  | [A] |
| `removeLast()` / `popLast()`       | O(1)                                    | [A] |
| `removeFirst()` / `popFirst()`     | O(*n*) — shifts all elements             | [A] |
| `removeAll(keepingCapacity:)`      | O(*n*)                                  | [A] |
| `removeSubrange(_:)`               | O(*n*)                                  | [A] |
| `reserveCapacity(_:)`              | O(*n*) when grow needed                  | [A] |
| `contains(_:)`                     | O(*n*)                                  | [A] |
| `firstIndex(of:)` / `lastIndex(of:)` | O(*n*)                                | [A] Collection docs |
| `min()`, `max()` (Comparable)      | O(*n*)                                  | [A] |
| `sort()` / `sorted()`              | O(*n* log *n*) — Timsort-based since Swift 5 | https://github.com/apple/swift/blob/main/stdlib/public/core/Sort.swift — `_introsort` then `_insertionSort` |
| `reverse()`                        | O(*n*)                                  | [A] |
| `shuffle()`                        | O(*n*) Fisher-Yates                     | [A] |
| Slice (`array[a..<b]`) creation    | O(1) — `ArraySlice` shares storage      | [A] developer.apple.com/documentation/swift/arrayslice |
| Iteration                          | O(*n*)                                  | [A] |
| `==`                               | O(*n*)                                  | [A] |
| `+` concatenation                  | O(*n* + *m*)                             | [A] |
| `withUnsafeBufferPointer`          | O(1) — direct buffer view               | [A] |
| Copy on mutation of shared         | O(*n*)                                  | [A] |

## `Array` vs `ContiguousArray`

`ContiguousArray<Element>` is structurally identical but skips the NSArray bridge on Darwin. Use it when:

- You hold non-`AnyObject` elements and want a marginal perf boost (avoid the bridge check on every `withUnsafeBufferPointer`).
- You're sure you'll never need `as NSArray` interop.

Same complexity table as `Array`. Source: [A] developer.apple.com/documentation/swift/contiguousarray

## `ArraySlice<Element>`

`array[5..<20]` returns an `ArraySlice<Element>` that **shares** the underlying buffer with the original array. Indices into the slice are valid as if it were an Array (`startIndex` is wherever the slice was carved out — usually **not** zero). Converting back to `Array` is O(`slice.count`) and allocates a fresh buffer.

---

# `Dictionary<Key: Hashable, Value>`

**Open-addressing hash table with linear probing.** COW. Per-process randomised hash seed for collision-attack resistance.

## Memory layout (high level)

```
Dictionary<K, V>
└── _NativeDictionary<K, V>     ← class
    └── [_RawHashTable header][bucket-keys: K][bucket-values: V]
```

The hash table holds keys and values in parallel buffers within a single class allocation. Open addressing with linear probing on collisions. Source: https://github.com/apple/swift/blob/main/stdlib/public/core/Dictionary.swift and https://github.com/apple/swift/blob/main/stdlib/public/core/NativeDictionary.swift

Iteration order is **unspecified** and may differ between runs (because the hash seed is randomised — [SE-0205](https://github.com/apple/swift-evolution/blob/main/proposals/0205-withUnsafePointer-array.md) and the [stdlib `Hasher` docs](https://developer.apple.com/documentation/swift/hasher)).

## Operations — complexity

| Operation                          | Complexity                              | Source |
| ---------------------------------- | --------------------------------------- | ------ |
| `count`, `isEmpty`                 | O(1)                                    | [A] developer.apple.com/documentation/swift/dictionary |
| `subscript(key)` get               | O(1) avg                                | [A] |
| `subscript(key)` set (insert/update) | O(1) avg amortized                    | [A] |
| `subscript(key, default:)`         | O(1) avg                                | [A] |
| `subscript(key, default:)` write back | O(1) avg amortized                   | [A] |
| `updateValue(_:forKey:)`           | O(1) avg amortized                      | [A] |
| `removeValue(forKey:)`             | O(1) avg                                | [A] |
| `removeAll(keepingCapacity:)`      | O(*n*)                                  | [A] |
| `index(forKey:)`                   | O(1) avg                                | [A] |
| `remove(at:)`                      | O(*n*) worst (open-addressing tombstone fixup) | [A] |
| `keys`, `values` views             | O(1) lazy wrapper                       | [A] |
| Iteration                          | O(*capacity*) — visits empty slots too; effectively O(*n*) when load factor ≥ 0.5 | [SS] NativeDictionary.swift |
| Hash flooding worst case           | O(*n*) per op; mitigated by per-process random seed | [A] Hasher docs |
| Copy on mutation of shared         | O(*n*)                                  | [A] |
| Bridge to `NSDictionary`           | O(1) lazy on Darwin                     | [A] |

**Load factor**: stdlib `Dictionary` resizes when the table is 3/4 full, doubling capacity. (Same as swift-collections `OrderedSet` — see [ordered-collections.md](ordered-collections.md). The constants happen to match.)

## `Hashable` quality matters

If `Key.hash(into:)` is badly implemented (e.g. feeds only one field into `Hasher` when `==` compares many), adversarial inputs can produce massive hash collisions. The per-process random seed mitigates **remote** attacks but not in-process performance pathology. Always implement `hash(into:)` correctly — every bit used in `==` must be combined into the `Hasher`.

[A] Dictionary docs — "Hash Collisions" section.

---

# `Set<Element: Hashable>`

Same machinery as `Dictionary` but only keys, no values. Source: https://github.com/apple/swift/blob/main/stdlib/public/core/Set.swift

## Operations — complexity

| Operation                                | Complexity                              | Source |
| ---------------------------------------- | --------------------------------------- | ------ |
| `count`, `isEmpty`                       | O(1)                                    | [A] developer.apple.com/documentation/swift/set |
| `contains(_:)`                           | O(1) avg                                | [A] |
| `insert(_:)`                             | O(1) avg amortized                      | [A] |
| `update(with:)`                          | O(1) avg amortized                      | [A] |
| `remove(_:)`                             | O(1) avg                                | [A] |
| `removeAll(keepingCapacity:)`            | O(*n*)                                  | [A] |
| `union(_:)`, `intersection(_:)`, `subtracting(_:)`, `symmetricDifference(_:)` | O(*n* + *m*) | [A] SetAlgebra |
| `formUnion(_:)`, `formIntersection(_:)`, … | O(*n* + *m*)                          | [A] |
| `isSubset(of:)` / `isSuperset(of:)` / `isDisjoint(with:)` | O(*n* + *m*)         | [A] |
| `==`                                     | O(*n*) — order-independent              | [A] |
| Iteration                                | O(*n*), order unspecified               | [A] |

Note: `union` etc. between a `Set` and an arbitrary `Sequence` are still O(*n* + *m*) on average.

---

# `String` and `Substring`

UTF-8-native since Swift 5. COW. Small-string optimization stores up to **15 UTF-8 bytes inline** on 64-bit; longer strings use a heap-allocated `_StringStorage` buffer. Bridges to `NSString` on Darwin opportunistically.

Source: [SE-0178: UTF-8 String](https://github.com/apple/swift-evolution/blob/main/proposals/0178-character-unicode-view.md), https://github.com/apple/swift/tree/main/stdlib/public/core (search `StringStorage`, `_SmallString`).

## The grapheme-cluster gotcha

`String` is a `BidirectionalCollection` of `Character` (extended grapheme clusters). It is **not** `RandomAccessCollection`, because the position of the *k*-th grapheme cluster depends on all preceding bytes (Unicode segmentation is stateful).

| Property                 | Complexity                              | Why |
| ------------------------ | --------------------------------------- | --- |
| `count` (Character count) | **O(*n*)** — segmentation               | [A] — *"Counting the length of a string takes O(*n*) time"* |
| `isEmpty`                | O(1)                                    | [A] |
| `utf8.count`             | O(1) on native strings since Swift 5    | [A] String.UTF8View |
| `utf16.count`            | O(1) on native strings since Swift 5; O(*n*) on bridged NSStrings | [A] |
| `unicodeScalars.count`   | O(1) on native; O(*n*) on bridged       | [A] |
| `subscript(idx)`         | O(1) read, given a valid `String.Index` | [A] |
| `index(after:)` (Character) | Amortized O(1) (segmentation step)  | [A] |
| `index(_:offsetBy:)` (Character) | O(k)                              | [A] |
| `index(after:)` on `.utf8` / `.utf16` | O(1)                          | [A] |
| `+` concatenation        | O(*n* + *m*)                             | [A] |
| `==`                     | O(*n*) — Unicode canonical equivalence  | [A] — equality decomposes & compares |
| Hashing                  | O(*n*)                                  | [A] |
| `contains(_:)` substring | O(*n* · *m*) worst (naïve)              | [A] |

### Small-string inline storage

A `String` value is two 64-bit words on 64-bit platforms. When the content fits in 15 UTF-8 bytes, both words encode the content inline (no allocation, no reference). Above 15 bytes, the value holds a pointer to `_StringStorage`. See SE-0178 implementation and `_SmallString.swift` in stdlib.

So creating millions of short `String` values avoids `malloc` entirely when they fit in the inline budget — important for things like `Dictionary<String, …>` with short keys.

## `Substring`

`array[a..<b]` is to `Array` as `string[s..<e]` is to `String` — a slice that **shares storage** with the parent string. Indices into the substring are valid as if it were a String (positions are absolute, not relative).

| Operation                     | Complexity                            | Source |
| ----------------------------- | ------------------------------------- | ------ |
| Make a `Substring` from `String[range]` | O(1)                          | [A] |
| Read access                   | Same as `String`                       | [A] |
| `String(substring)`           | O(*n*) — copies                       | [A] |

A `Substring` keeps its base `String`'s storage alive — store it for long-term keeping at your peril; convert back to `String` if you want to release the base.

---

# `Range<Bound>` and `ClosedRange<Bound>`

A simple pair of bounds, struct, no allocation.

```swift
public struct Range<Bound: Comparable>: ... {
  public let lowerBound: Bound
  public let upperBound: Bound
  ...
}
```

Source: https://github.com/apple/swift/blob/main/stdlib/public/core/Range.swift

## Operations — complexity

| Operation                       | Complexity   | Source |
| ------------------------------- | ------------ | ------ |
| `lowerBound`, `upperBound`      | O(1)         | [A] developer.apple.com/documentation/swift/range |
| `isEmpty`                       | O(1)         | [A] |
| `contains(_:)`                  | O(1)         | [A] |
| `~=` (pattern match)            | O(1)         | [A] |
| `clamped(to:)`                  | O(1)         | [A] |
| `overlaps(_:)`                  | O(1)         | [A] |

When `Bound: Strideable` and `Bound.Stride: SignedInteger` (e.g. `Range<Int>`), `Range` also conforms to `RandomAccessCollection`:

| Operation                       | Complexity   | Source |
| ------------------------------- | ------------ | ------ |
| `count`                         | O(1)         | [A] (Strideable) |
| `subscript(i)`                  | O(1)         | [A] |
| Iteration                       | O(*n*)        | [A] |

`ClosedRange<Bound>` is the same but `lowerBound ≤ x ≤ upperBound` (inclusive on both ends).

## Why care?

`Range`-based APIs are pervasive in Swift (subscripting, `for i in 0..<n`, `Slice`s, etc.). Knowing they're zero-allocation, O(1) bounds helps you reason about hot loops.

---

# `KeyValuePairs<Key, Value>` (rare)

A `RandomAccessCollection` of `(Key, Value)` pairs preserving the literal source order. Backed by a tiny array. Use only in API surfaces that take dictionary literals where order matters.

| Operation       | Complexity | Source |
| --------------- | ---------- | ------ |
| `subscript(i)`  | O(1)       | [A] developer.apple.com/documentation/swift/keyvaluepairs |
| Iteration       | O(*n*)      | [A] |

KeyValuePairs is **immutable** — once constructed you can't add/remove. Useful only at API boundaries.

---

# Decision summary: when stdlib is enough

You should use stdlib types unless you can clearly state why a swift-collections type is better. Stdlib types:

- Are battle-tested.
- Bridge to ObjC on Darwin.
- Have years of compiler optimisation work behind them.

Reach for swift-collections when:

- You need a **specific** property stdlib doesn't offer (insertion order, persistence, bit-packing, deque semantics, double-ended priority queue).
- Profiling has shown a specific stdlib pattern is the bottleneck.
- You need noncopyable elements (use `Unique*`/`Rigid*` variants).
