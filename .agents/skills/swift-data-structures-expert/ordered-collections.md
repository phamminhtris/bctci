# `OrderedSet` and `OrderedDictionary` — Insertion-Order Preserving Hashed Collections

**Module**: `OrderedCollections` (also re-exported from `Collections`)
**Header path**: `import OrderedCollections` or `import Collections`
**Public source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/OrderedCollections/`
**`@frozen`**: yes — `Sources/OrderedCollections/OrderedSet/OrderedSet.swift:279`, `OrderedDictionary/OrderedDictionary.swift` (struct decl)

## The core idea: "Set / Dict + side hash table over a flat array"

Both `OrderedSet<Element>` and `OrderedDictionary<Key, Value>` use this dual representation:

1. A **`ContiguousArray`** holds the elements in their insertion (or user-specified) order.
2. A separate **hash table** maps element hashes → *offsets into that array*.

This is fundamentally different from `Set`/`Dictionary` (which store keys/values directly in the hash table) and from `TreeSet`/`TreeDictionary` (which use a tree). It gives O(1) avg lookup *and* O(1) positional access, at the cost of O(n) middle insert/remove.

Citation: `Documentation/OrderedSet.md:238-245`:

> *"An `OrderedSet` stores its members in a regular `Array` value (exposed by the `elements` property). It also maintains a standalone hash table containing array indices alongside the array…"*

---

# `OrderedSet<Element: Hashable>`

## Memory layout

```swift
public struct OrderedSet<Element> where Element: Hashable {
  internal var __storage: _HashTable.Storage?   // optional!
  internal var _elements: ContiguousArray<Element>
}
```

(`Sources/OrderedCollections/OrderedSet/OrderedSet.swift:285-289`.)

Notes:
- `__storage` is **optional**. For very small sets (≤ 15 elements), the hash table is omitted entirely and lookup falls back to a linear scan of the array. See `OrderedSet.swift:436-444` for the fallback.
- The hash table is a class (`_HashTable.Storage: ManagedBuffer<Header, UInt64>` — `_HashTable.swift:31-34`), so the side-table is shared via reference. Mutating triggers `_ensureUnique()` (`OrderedSet.swift:419-425`).

### Hash table parameters

From `Sources/OrderedCollections/HashTable/_HashTable+Constants.swift`:

| Parameter             | Value                                | Line       |
| --------------------- | ------------------------------------ | ---------- |
| `minimumScale`        | 5                                    | line 22    |
| `maximumScale`        | `min(Int.bitWidth, 56)`              | line 28-33 |
| `maximumUnhashedCount`| `(1 << (5−1)) − 1` = **15**          | line 38-43 |
| Max load factor       | 3/4                                  | line 48    |
| Min load factor       | 1/4                                  | line 53    |

A table of *scale n* holds **2^n** buckets, each storing an *n-bit* value (an offset into the array). So even with 8 million elements, each hash-table entry is only `⌈log₂(8M)⌉ = 23` bits, not a full 64-bit `Int`. This is one reason `OrderedSet` can use **less memory** than `Set` despite carrying both an array and a hash table.

Quote: `Sources/OrderedCollections/OrderedSet/OrderedSet.swift:242-249` doc-comment (same prose also appears verbatim at `Documentation/OrderedSet.md:240-249`):

> *"The hash table in an ordered set never needs to store larger indices than the current size of the storage array, and `OrderedSet` makes use of this observation to reduce the number of bits it uses to encode these integer values. Additionally, the actual hashed elements are stored in a flat array value rather than the hash table itself, so they aren't subject to the hash table's strict maximum load factor."*

### Header layout (packed bit fields)

`Sources/OrderedCollections/HashTable/_Hashtable+Header.swift:23-33`:

```
63                                           6 5      0
├──────────────────────────────────────────────┼────────┤
│                    seed                      │ scale  │   _scaleAndSeed
└──────────────────────────────────────────────┴────────┘
63                                           6 5      0
├──────────────────────────────────────────────┼────────┤
│                    bias                      │ rsvd   │   _reservedScaleAndBias
└──────────────────────────────────────────────┴────────┘
```

`bias` enables O(1) insertions at the front (shifts the logical zero of the buckets so renumbering can be skipped in some cases).

### Hash seeding

By default the seed = `Int(bitPattern: object_address)` (`_HashTable.swift:47-51`) — i.e. randomised per-allocation. With `COLLECTIONS_DETERMINISTIC_HASHING` defined, the seed is `scale << 6`. This is for testing; production code never uses deterministic hashing because adversarial inputs could trigger O(n) lookups.

## `OrderedSet` operations — complexity

All citations are in `Sources/OrderedCollections/OrderedSet/` unless noted.

| Operation                                | Complexity                          | Source |
| ---------------------------------------- | ----------------------------------- | ------ |
| `init()`                                 | O(1)                                | derived |
| `init(_:)` from sequence                 | O(*n*) avg                          | `OrderedSet+Initializers.swift` |
| `count`, `isEmpty`                       | O(1)                                | derived from `_elements: ContiguousArray` |
| `subscript(i)`                           | O(1) random-access                  | `Documentation/OrderedSet.md:127-141` |
| `contains(_:)`                           | O(1) avg                            | `Documentation/OrderedSet.md:231-235` |
| `firstIndex(of:)` / `lastIndex(of:)`     | O(1) avg                            | `OrderedSet.swift:463-484` |
| `append(_:)`                             | O(1) amortized avg                  | `OrderedSet+Insertions.swift:85-87` |
| `append(contentsOf:)`                    | O(*k*) amortized avg                | `OrderedSet+Insertions.swift:105-107` |
| `insert(_:at:)`                          | **O(*n*)** (Array shift + hash renumbering) | `Documentation/OrderedSet.md:248-255` |
| `update(at:with:)`                       | O(1) avg                            | replaces in place |
| `updateOrAppend(_:)`                     | O(1) amortized avg                  | `OrderedSet+Insertions.swift` |
| `remove(_:)`                             | **O(*n*)** — locates O(1), but shifts array | `Documentation/OrderedSet.md:248-255`, `OrderedSet.swift:534-558` |
| `remove(at:)`                            | **O(*n*)**                          | same |
| `removeLast()` / `removeFirst()`         | O(*n*) for `removeFirst`; O(1) amortized for `removeLast` | `Sources/OrderedCollections/OrderedSet/OrderedSet+Partial RangeReplaceableCollection.swift` |
| `swapAt(_:_:)`                           | O(1)                                | only renumbers two hash-table buckets |
| `partition(by:)`, `sort()`, `shuffle()`, `reverse()` | O(*n*) — must rebuild hash table at end | `Documentation/OrderedSet.md:155-162` |
| Set ops: `union`, `intersection`, `subtracting`, `symmetricDifference` | O(*n* + *m*) avg | `OrderedSet+Partial SetAlgebra*.swift` |
| `isSubset(of:)`, `isSuperset(of:)`, `isDisjoint(with:)` | O(*n* + *m*) avg | same |
| `==`                                     | O(*n*) — order-sensitive equality   | `OrderedSet+Equatable.swift`; `Documentation/OrderedSet.md:42-48` |
| `unordered == unordered`                 | O(*n* + *m*) avg — order-insensitive | `OrderedSet+UnorderedView.swift`; `Documentation/OrderedSet.md:96-107` |
| `reserveCapacity(_:)`                    | O(*n*)                              | `OrderedSet+ReserveCapacity.swift` |
| `difference(from:)`                      | O(*n* + *m*) — specialised diffing exploiting unique members | `OrderedSet+Diffing.swift` doc-comment: *"Complexity: O(`self.count + other.count`)"* |
| `applying(_: CollectionDifference)`      | O(*n* + *c*) where *c* = number of changes | `OrderedSet+Diffing.swift` doc-comment: *"Complexity: O(*n* + *c*)"* |

## Why `OrderedSet` does **not** conform to `SetAlgebra`

Citation: `Documentation/OrderedSet.md:85-88`:

> *"`OrderedSet` has an order-sensitive definition of equality… that is incompatible with `SetAlgebra`'s documented semantic requirements. Accordingly, `OrderedSet` does not (cannot) itself conform to `SetAlgebra`."*

For situations needing `SetAlgebra`, use the `.unordered` view — `OrderedSet+UnorderedView.swift`. The view conforms to `SetAlgebra` and uses order-insensitive equality.

## Why `OrderedSet` does **not** conform to `MutableCollection` / `RangeReplaceableCollection` (in full)

Because allowing `subscript`-set or `replaceSubrange` would let a caller insert duplicates. The library partially implements these protocols, supporting *removal* and *permutation* operations but not the duplicate-allowing setters (`Documentation/OrderedSet.md:132-152`).

---

# `OrderedDictionary<Key: Hashable, Value>`

## Memory layout

`OrderedDictionary` consists of:

1. An `OrderedSet<Key>` (the keys, with their side hash table).
2. A parallel `ContiguousArray<Value>` (the values, aligned 1-to-1 with the keys array).

Citation: `Documentation/OrderedDictionary.md:222-225`:

> *"An ordered dictionary consists of an ordered set of keys, alongside a regular `Array` value that contains their associated values."*

This means complexity for hashed ops is **identical** to `OrderedSet`. Look at the keys' hash table to find an offset, then index the values array.

## Operations — complexity

| Operation                                | Complexity                          | Source |
| ---------------------------------------- | ----------------------------------- | ------ |
| `count`, `isEmpty`                       | O(1)                                | derived |
| `subscript(key)` get                     | O(1) avg                            | `Documentation/OrderedDictionary.md:215-219` |
| `subscript(key)` set when key exists     | O(1) avg                            | overwrites the value |
| `subscript(key)` set when key is new     | O(1) amortized avg — **appends**    | `Documentation/OrderedDictionary.md:66-67` |
| `subscript(key, default:)`               | O(1) avg + amortized for append     | `Documentation/OrderedDictionary.md:74-87` |
| `updateValue(_:forKey:)`                 | O(1) amortized avg                  | `OrderedDictionary+Sequence.swift` |
| `removeValue(forKey:)`                   | **O(*n*)** — must shift the values array AND renumber hash table | `OrderedDictionary+Partial RangeReplaceableCollection.swift` |
| `index(forKey:)`                         | O(1) avg                            | derived |
| `keys` — view as `OrderedSet<Key>`       | O(1) — lightweight wrapper          | `Documentation/OrderedDictionary.md:165-172` |
| `values` — random-access mutable view    | O(1) — backed by the parallel array | `Documentation/OrderedDictionary.md:179-188` |
| `values[i] = …`                          | O(1)                                | same |
| `values.sort()`                          | O(*n* log *n*) — sorts the values array but keys remain unchanged | `Documentation/OrderedDictionary.md:185-188` |
| `elements[i]` (positional key-value pair) | O(1)                               | `Documentation/OrderedDictionary.md:117-126` |
| `mapValues(_:)`, `compactMapValues(_:)`  | O(*n*)                              | `OrderedDictionary+Sequence.swift` |
| `filter(_:)`                             | O(*n*)                              | same |
| `merge`, `merging`                       | O(*n* + *m*) avg                    | same |
| `init(uniqueKeysWithValues:)`            | O(*n*) avg                          | `OrderedDictionary+Initializers.swift` |
| `init(grouping:by:)`                     | O(*n*) avg                          | same |
| `==`                                     | O(*n*) — **order-sensitive**        | `OrderedDictionary+Equatable.swift`; `Documentation/OrderedDictionary.md:38-50` |

## Why does `OrderedDictionary` not conform to `Collection`?

Citation: `Documentation/OrderedDictionary.md:118-126`:

> *"to avoid ambiguity between key-based and indexing subscripts, `OrderedDictionary` doesn't directly conform to `Collection`. Instead, it only conforms to `Sequence`, and provides a random-access collection view over its key-value pairs."*

So you write `dict.elements[2]` to get a `(key, value)` pair by position. `dict[2]` is the **key-based** subscript and would return `Value?` for an integer key.

## Hash quality reminder

Both types carry this caveat in their docs (`Documentation/OrderedDictionary.md:195-219`, `Documentation/OrderedSet.md:212-235`):

> *"if a certain set of [keys/elements] all produce the same hash value, then hash table lookups regress to searching an element in an unsorted array, i.e., a linear operation."*

The remedy is to implement `Hashable` correctly — feeding every bit that participates in `==` into `Hasher` in `hash(into:)`. The `Hasher` itself is seeded per-allocation so adversarial collisions cannot be triggered remotely.

## Memory utilisation discussion

`OrderedSet` can be **more compact** than `Set` for these reasons (`Documentation/OrderedSet.md:240-249`):

- Hash table entries are *n-bit* offsets, not 64-bit pointers (`n` = scale, typically 5-20 bits for reasonable sizes).
- Elements are stored once in the contiguous array, not in slots in the hash table which must be kept at load factor ≤ 3/4 (so up to 33% of capacity is wasted).

For 1M elements:
- `OrderedSet`: ~`8 * 1_000_000` bytes for the array + ~`20-bits * 2_000_000` ≈ 5 MB for the hash table (with 2× load capacity).
- `Set`: ~`16 * 1_400_000` bytes (load factor) ≈ 22 MB.

So `OrderedSet` can be ~1.5–2× more memory-efficient.

(These are estimates; actual constants depend on `Element` size and scale.)
