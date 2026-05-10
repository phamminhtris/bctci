# `TreeSet` and `TreeDictionary` — CHAMP Persistent Hashed Collections

**Module**: `HashTreeCollections` (also re-exported from `Collections`)
**Header path**: `import HashTreeCollections` or `import Collections`
**Public source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/HashTreeCollections/`
**`@frozen`**: marked but ABI-unstable — `Sources/HashTreeCollections/TreeSet/TreeSet.swift:62` *("Not really -- this package is not at all ABI stable")*

## TL;DR

A persistent (immutable-with-shared-structure) `Set`/`Dictionary`. Stores items in a hash-array-mapped prefix tree where each node has up to 32 buckets indexed by a 5-bit slice of a key's hash. Sharing across collection values is **structural** — mutating a shared copy only allocates new nodes along one root-to-leaf path (≤ 13 nodes on 64-bit), not the whole storage.

## Why "persistent"?

Citation: `Sources/HashTreeCollections/TreeSet/TreeSet.swift:14-46`:

> *"`TreeSet` has the same functionality as a standard `Set`… However, `TreeSet` is optimizing specifically for use cases that need to mutate shared copies or to compare a set value to one of its older snapshots. To use a term from functional programming, `TreeSet` implements a persistent data structure.*
>
> *The standard `Set` stores its members in a single, flat hash table, and it implements value semantics with all-or-nothing copy-on-write behavior: every time a shared copy of a set is mutated, the mutation needs to make a full copy of the set's storage. `TreeSet` takes a different approach: it organizes its members into a tree structure, the nodes of which can be freely shared across collection values. When mutating a shared copy of a set value, `TreeSet` is able to simply link the unchanged parts of the tree directly into the result, saving both time and memory."*

Example from the doc-comment (TreeSet.swift:40-46):

```swift
var set = TreeSet(0 ..< 10_000)
let copy = set
set.insert(20_000)              // O(log n) — copies ~log n nodes, shares the rest
let diff = set.subtracting(copy) // Also O(log n) — structural sharing short-circuits
// diff now holds {20_000}.
```

## CHAMP — the underlying algorithm

CHAMP = **C**ompressed **H**ash-**A**rray **M**apped **P**refix tree, from:

> *Michael J Steindorfer and Jurgen J Vinju. "Optimizing Hash-Array Mapped Tries for Fast and Lean Immutable JVM Collections." OOPSLA 2015, pp. 783-800.*
>
> doi:[10.1145/2814270.2814312](https://doi.org/10.1145/2814270.2814312)

Citation in this repo: `Sources/HashTreeCollections/HashTreeCollections.docc/Extensions/TreeSet.md:5-11`.

### Per-node structure (32 buckets, two bitmaps, compressed storage)

Each tree node logically has 32 buckets. The bucket for an item is determined by a **5-bit slice** of its hash value. At root level 0, slice = bits 0..<5. At level 1, slice = bits 5..<10. And so on.

The bucket may hold:
- A single **item** (key-value pair, for leaves), OR
- A **child node** reference (when multiple items would have collided here), OR
- Nothing.

Storage uses two `UInt32` bitmaps:
- `childMap`: bit *k* = 1 if bucket *k* holds a child node.
- `itemMap`: bit *k* = 1 if bucket *k* holds an item.

(A bucket cannot be both an item and a child at the same time.)

Citation: `Sources/HashTreeCollections/HashNode/_HashNode.swift:14-38`:

```
┌───┬───┬───┬───┬───┬──────────────────┬───┬───┬───┬───┐
│ 0 │ 1 │ 2 │ 3 │ 4 │→   free space   ←│ 3 │ 2 │ 1 │ 0 │
└───┴───┴───┴───┴───┴──────────────────┴───┴───┴───┴───┘
 children                                         items
```

Children grow from the start, items grow inward from the end. The bitmaps decide which slot in the **compressed** packed array holds each bucket's data.

Implementation:
- `_HashNode` wraps a single `_RawHashNode` (`_HashNode.swift:40-63`).
- `_RawHashNode` wraps a `_RawHashStorage` class (a `ManagedBuffer`). The actual storage of children and items lives in tail-allocated space of the buffer.
- The two 32-bit bitmaps live in the buffer's header (`_HashNodeHeader.swift`).

### Bitmap = UInt32 = 32 buckets

Citation: `Sources/HashTreeCollections/HashNode/_Bitmap.swift:22-23`:

```swift
internal struct _Bitmap {
  internal typealias Value = UInt32
  ...
```

And `_Bitmap.swift:78-79`: `capacity: Int { Value.bitWidth }` = 32. `bitWidth: Int { capacity.trailingZeroBitCount }` = 5.

So node fan-out = 32, hash slice = 5 bits.

### Tree depth is bounded

Citation: `Sources/HashTreeCollections/HashNode/_HashLevel.swift:14-17, 46-49`:

```swift
/// Hash trees have a maximum depth of ⎡UInt.bitWidth / _Bucket.bitWidth⎤, so
/// the level always fits in an UInt8 value.
...
internal static var limit: Int {
  (_Hash.bitWidth + _Bitmap.bitWidth - 1) / _Bitmap.bitWidth
}
```

`_Hash.bitWidth = UInt.bitWidth` (`_Hash.swift:54-56`). On 64-bit Swift, `limit = (64 + 5 − 1) / 5 = 13` levels. On 32-bit, `limit = ⌈32/5⌉ = 7`.

So the "O(log n)" in `TreeSet`/`TreeDictionary` ops is actually **bounded by a small constant** (13 on 64-bit), no matter how many items the collection holds. CHAMP is *effectively* constant-time for lookup, insert, and remove — except for the constant factor from pointer-chasing through 13 nodes vs a single flat-table probe.

### Collision nodes

When ≥ 2 items have identical 64-bit hashes (rare but possible — `Hashable` may legitimately collide), they're collected into a **collision node** that does linear search.

Citation: `Sources/HashTreeCollections/HashTreeCollections.docc/Extensions/TreeSet.md:58-62`:

> *"In practice, hash values aren't guaranteed to be unique though. Members with conflicting hash values need to be collected in special collision nodes that are able to grow as large as necessary to contain all colliding members that share the same hash. Looking up a member in one of these nodes requires a linear search, so it is crucial that such collisions do not happen often."*

Collision nodes are checked by `isCollisionNode` — `_HashNode.swift:104-108`.

## Lookup walkthrough

To find member `x`:

1. Compute `hash = x._rawHashValue(seed: 0)` (`_Hash.swift:21-25`).
2. At the root node (level = 0), extract the 5 lowest bits of `hash` → bucket index `b`.
3. Inspect the root's `itemMap` and `childMap`:
   - If `itemMap[b]` is set: there's an item in bucket `b`. Compare it with `x`.
   - If `childMap[b]` is set: descend into that child node. The next 5 bits of `hash` (bits 5..<10) form the bucket index at level 1.
   - If neither is set: `x` is not in the set.
4. Repeat until we either find `x`, prove its absence, or hit a collision node (in which case linear-scan the colliding items).

Implementation: `Sources/HashTreeCollections/HashNode/_HashNode+Lookups.swift`.

The traversal is **at most 13 levels deep on 64-bit**. Each level does a few bitmap operations + one pointer dereference.

## Operations — complexity (with citations)

All complexities are directly from doc-comments in `Sources/HashTreeCollections/TreeDictionary/TreeDictionary.swift`. `TreeSet` has analogous complexity for its operations.

### `TreeDictionary<Key, Value>` operations

| Operation                              | Complexity                                                            | Doc-comment line |
| -------------------------------------- | --------------------------------------------------------------------- | ---------------- |
| `subscript(key)` get                   | O(log *n*) tree traversal + O(1) hash/compare avg                     | `TreeDictionary.swift:152-156` |
| `subscript(key)` set                   | Copies ≤ O(log *n*) existing members                                  | `TreeDictionary.swift:157-158` |
| `subscript(key, default:)` set         | same                                                                   | `TreeDictionary.swift:248-250` |
| `index(forKey:)`                       | O(1) hashing/comparison avg                                            | `TreeDictionary.swift:286-289` |
| `updateValue(_:forKey:)`               | Copies ≤ O(log *n*) members + O(1) hash/compare avg                   | `TreeDictionary.swift:341-344` |
| `updateValue(forKey:default:_:)`       | same                                                                   | `TreeDictionary.swift:467-470` |
| `removeValue(forKey:)`                 | Copies ≤ O(log *n*) members + O(1) hash/compare avg                   | `TreeDictionary.swift:517-521` |
| `remove(at: Index)`                    | Copies ≤ O(log *n*) members + O(1) hash/compare avg                   | `TreeDictionary.swift:540-543` |
| `merge(_:uniquingKeysWith:)`, `merging(_:uniquingKeysWith:)` | O(*n* + *m*); structural sharing speeds up mostly-shared inputs | `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Merge.swift` |
| `mapValues(_:)`, `compactMapValues(_:)` | O(*n*)                                                                | `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+MapValues.swift` |
| `filter(_:)`                           | O(*n*)                                                                | `Sources/HashTreeCollections/TreeDictionary/TreeDictionary+Filter.swift` |
| Iteration (`for (k, v) in dict`)       | O(*n*)                                                                | `Sources/HashTreeCollections/HashNode/_HashTreeIterator.swift` |
| Comparing to a shared snapshot         | O(*differences*) thanks to structural sharing                          | `TreeDictionary.swift:30-44` (architectural promise) |

### `TreeSet<Element>` operations

`TreeSet` exposes the full `SetAlgebra`-compatible API plus extensions. Complexity:

| Operation                                 | Complexity                                                        | Source |
| ----------------------------------------- | ----------------------------------------------------------------- | ------ |
| `contains(_:)`                            | O(log *n*) tree, O(1) hash/compare avg                            | `Sources/HashTreeCollections/HashTreeCollections.docc/Extensions/TreeSet.md:64-67` |
| `firstIndex(of:)` / `lastIndex(of:)`      | O(1) avg                                                          | derived |
| `insert(_:)`                              | O(log *n*) copy                                                   | analogous to TreeDictionary insert |
| `update(with:)`                           | O(log *n*) copy                                                   | same |
| `remove(_:)`                              | O(log *n*) copy                                                   | `Sources/HashTreeCollections/TreeSet/TreeSet+SetAlgebra basics.swift:88-91` |
| `remove(at:)`                             | **O(log *n*) if storage is shared; O(1) otherwise**                 | `Sources/HashTreeCollections/TreeSet/TreeSet+Extras.swift` — `remove(at:)` doc-comment ends with: *"O(log(\`count\`)) if set storage might be shared; O(1) otherwise."* |
| `update(_:at:)`                           | **O(log *n*) if storage is shared; O(1) otherwise**                 | `Sources/HashTreeCollections/TreeSet/TreeSet+Extras.swift` — `update(_:at:)` doc-comment |
| `union`, `intersection`, `subtracting`, `symmetricDifference` of two `TreeSet`s | O(*n* + *m*) worst, but **subtree-sharing makes mostly-shared inputs effectively constant** | `Sources/HashTreeCollections/HashNode/_HashNode+Structural*.swift` (one file per op) |
| `isSubset(of:)` / `isSuperset(of:)` etc.  | O(*n*) worst, fast-path on shared subtrees                        | `_HashNode+Structural isSubset.swift` etc. |
| `==` (set equality of TreeSet)            | O(*n*); short-circuits when comparing identical root pointers      | `_HashNode+Structural isEqualSet.swift` |

### Where TreeSet/TreeDictionary **beats** stdlib Set/Dictionary

The architectural promise: when you have **many copies** that share most of their state, every mutation of a shared copy is O(log n) instead of O(n).

Concrete scenarios:
- Undo/redo stacks holding many dictionary snapshots.
- Observed state in a unidirectional-data-flow app where each store mutation produces a new state value.
- Algorithmic uses of immutable maps (memoization, persistent data structures in functional algorithms).
- Diffing two related collections — `setA.subtracting(setB)` can short-circuit on any subtree that is reference-identical in both.

Citation: `TreeSet.swift:30-46` (the architectural rationale).

### Where TreeSet/TreeDictionary **loses** to stdlib Set/Dictionary

The constant factor for pointer chasing through 13 levels is higher than one hash-table probe. So for **non-shared, throwaway** dictionaries that are mutated once and forgotten, stdlib `Dictionary` wins.

Citation: `TreeSet.swift:55-61`:

> *"switching to a tree structure comes with some trade offs. In particular, inserting new items, removing existing ones, and iterating over a `TreeSet` is expected to be a constant factor slower than a standard `Set` -- allocating/deallocating nodes isn't free, and navigating the tree structure requires more pointer dereferences than accessing a flat hash table."*

### Index invalidation

`TreeDictionary` carries a `_version: UInt` (`TreeDictionary.swift:79-82`) initialized from the root node's address (`_HashNode.swift:131-138`) and incremented on mutations that invalidate indices. The doc-comments explicitly call out which operations invalidate indices.

### Memory: nodes shrink/grow

Citation: `TreeSet.swift:48-53`:

> *"The tree structure also eliminates the need to reserve capacity in advance: `TreeSet` creates, destroys and resizes individual nodes as needed, always consuming just enough memory to store its contents. As of Swift 5.9, the standard collection types never shrink their storage, so temporary storage spikes can linger as unused but still allocated memory long after the collection has shrunk back to its usual size."*

So `TreeSet`/`TreeDictionary` actually **shrink** their memory footprint after deletions, unlike stdlib `Set`/`Dictionary`.

## Index design

Both expose `Index` values, but indices are invalidated by mutations (more aggressively than stdlib Dictionary). For a stable identity of an item, use the value itself or its key.

`TreeDictionary.Index._path` carries a path through the tree (`Sources/HashTreeCollections/HashNode/_UnsafePath.swift`), plus the snapshot version for cheap validation.

## Conformances

- `TreeSet`: `SetAlgebra`, `Sequence`, `Collection`, `Hashable` (when `Element: Hashable`), `Equatable`, `ExpressibleByArrayLiteral`, `Sendable` (conditional), `Encodable`/`Decodable`, `CustomStringConvertible`, `CustomReflectable`.
- `TreeDictionary`: `Sequence`, `Collection`, `Hashable` (when conformances hold), `Equatable`, `ExpressibleByDictionaryLiteral`, `Sendable` (conditional), `Encodable`/`Decodable`, `CustomStringConvertible`, `CustomReflectable`.

(Each conformance lives in its own file in `Sources/HashTreeCollections/TreeSet/` / `Sources/HashTreeCollections/TreeDictionary/`.)
