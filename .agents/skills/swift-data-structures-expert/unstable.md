# Unstable / Preview Data Structures

These types are present in the `swift-collections` repo but are **not part of the stable public API**. They are gated behind package traits (`UnstableSortedCollections`, `UnstableContainersPreview`, `UnstableHashedContainers`) and may change in any release — including patch releases.

Reference these only when the user explicitly asks about them. Do not recommend them for production code without flagging the instability.

Source for the stability policy: `/Users/minhtri.pham/Developer/swift-collections/README.md:226-249`.

---

## `SortedSet<Element: Comparable>` and `SortedDictionary<Key: Comparable, Value>`

**Module**: `SortedCollections` (requires `UnstableSortedCollections` package trait)
**Source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/SortedCollections/`

A **B-tree-backed** sorted set and sorted dictionary. Elements/keys are kept in strictly increasing order at all times, enabling fast in-order iteration and efficient range queries.

### Underlying B-tree

`Sources/SortedCollections/BTree/_BTree.swift:16-22`:

> *"A bidirectional collection representing a BTree which efficiently stores its elements in sorted order and maintains roughly O(log count) performance for most operations."*

Node capacity heuristics (line 29-48):

```swift
// Internal node (release builds):
let capacityInBytes = 128
return Swift.min(16, capacityInBytes / MemoryLayout<Key>.stride)

// Leaf node (release builds):
let capacityInBytes = 2000
return Swift.min(16, capacityInBytes / MemoryLayout<Key>.stride)
```

So leaves are sized to fit in ~2 KB and hold up to 16 keys; internal nodes are smaller (~128 B). This is cache-line tuned.

### Operations — complexity (approximate)

These are not officially documented (the API is unstable), but inferred from the B-tree implementation:

| Operation                    | Complexity                         |
| ---------------------------- | ---------------------------------- |
| `contains(_:)`               | O(log *n*) tree, O(log *k*) within node (binary search on keys) |
| `insert(_:)`                 | O(log *n*) — may split nodes upward |
| `remove(_:)`                 | O(log *n*) — may merge / rebalance  |
| `first`, `last`              | O(log *n*) (walk to leftmost/rightmost leaf) |
| `min()`, `max()`             | O(log *n*)                         |
| Iteration (sorted order)     | O(*n*)                              |
| Range subscript              | O(log *n*) lookup + O(*k*) for the slice |

### When to consider

- You need elements visited in **sorted order** during iteration.
- You need efficient `lowerBound` / `upperBound` queries (B-tree gives O(log n)).
- `Comparable` is available for your key type.

### Why "unstable"?

`README.md:215-218`:

> *"They remain unstable for now because they have known API deficiencies -- we expect many of their interfaces will need to be adjusted in source breaking ways."*

So even though the implementation works, the API will change. Don't depend on it from a library that gets shipped to others.

### Alternatives

- For a min/max priority queue without full sorted iteration: use `Heap`. See [heap.md](heap.md).
- For an unordered Set/Dict with structural sharing: use `TreeSet`/`TreeDictionary`. See [hash-tree-collections.md](hash-tree-collections.md).
- For arbitrary sorted iteration of a stdlib `Set`: `set.sorted()` produces an `Array<Element>` in O(*n* log *n*).

---

## `BigString` / `_RopeModule`

**Module**: `_RopeModule` (the leading underscore makes it private). Source: `/Users/minhtri.pham/Developer/swift-collections/Sources/RopeModule/`.

A **rope-based String** for efficient editing of very large text. Storage is a tree of UTF-8 chunks; edits affect only the path of nodes from root to leaf.

### Top-level types

- `Rope<Element: RopeElement>` (generic rope, parameterised by the leaf element type) — `Sources/RopeModule/Rope/`
- `BigString` (concrete `Rope<...>` specialized for text, plus character views) — `Sources/RopeModule/BigString/`

### Approximate complexity

| Operation                                | Complexity            |
| ---------------------------------------- | --------------------- |
| `contains` / `index(of:)`                | O(*n*) (linear search) |
| `insert(_:at:)` / `remove(at:)`          | O(log *n*) — splits/merges a path |
| `append`, `prepend`                      | O(log *n*) amortized   |
| `count`                                  | O(1) (cached via summary) |
| Iteration                                | O(*n*)                 |
| Concatenation of two ropes               | O(log *n*) (link the trees) |

### Why unstable?

The module is private (leading underscore). `README.md:241`: *"the list of stable modules above intentionally does not include `SortedCollections` nor `_RopeModule` -- these experimental modules are unstable and need more time in the oven."*

### When to consider

- Editor buffers, document trees, large-scale text manipulation where stdlib `String`'s O(*n*) edit cost is unaffordable.
- Otherwise stick with `String`.

---

## `UnstableContainersPreview` trait — protocols & helpers

Enables a number of preview protocols intended for inclusion in the Swift stdlib eventually:

- `BorrowingSequence`, `BorrowingIteratorProtocol` — borrowing-iteration with ephemeral elements.
- `Container`, `BidirectionalContainer`, `RandomAccessContainer` — container analogues of `Collection`.
- `PermutableContainer`, `MutableContainer`, `RangeReplaceableContainer`, `DynamicContainer` — mutation refinements.
- `Producer`, `Drain` — generative iterators / consumable sources.
- `Ref<Target>`, `MutableRef<Target>` — borrowing / mutating references.
- `InputSpan<Element>` — reference to a contiguous region of consumable items.

Source: `Sources/ContainersPreview/`. Citation: `README.md:148-183`.

These are previews of potential Swift Evolution additions. They will likely move into the stdlib and be removed from this package.

### When to consider

- You're building infrastructure that wants to work generically with both copyable and noncopyable container types.
- You're contributing to Swift Evolution or building libraries that will track future stdlib additions.

Do **not** ship public API depending on these types unless you can commit to chasing breaking changes.

---

## `UnstableHashedContainers` trait — `UniqueSet` / `RigidSet` / `UniqueDictionary` / `RigidDictionary`

Noncopyable hashed collections, with Robin Hood hashing. Briefly covered in [basic-containers.md](basic-containers.md). `README.md:185-203`:

> *"Under the hood, these containers implement Robin Hood hashing, achieving better memory utilization and more consistent lookup performance when compared to the standard `Set` and `Dictionary` types.*
>
> *These types need to remain unstable for now, as they depend on compiler/stdlib features that have not shipped yet."*

### Robin Hood hashing — brief

Open-addressing variant where probe-distance is tracked per slot. On collision, the new entry "robs from the rich" — displaces an existing entry with a shorter probe distance and re-inserts it. This bounds the maximum probe distance and reduces variance in lookup time.

Trade-offs:
- More consistent worst-case probe length.
- Slightly more bookkeeping per slot (probe distance counter).

The classic Swift `Dictionary` uses simpler open-addressing with linear probing. The unstable hashed containers improve on that, but the API needs more time to settle before becoming stable.

---

## Summary: should I use any of these?

| Use case                                   | Verdict on unstable types                                                |
| ------------------------------------------ | ------------------------------------------------------------------------ |
| Production code in your own app            | **Avoid.** Use stable alternatives.                                       |
| Library you ship to other Swift users      | **Don't.** Source-breaking changes will land.                             |
| Prototype / experiment                     | OK, but expect to update on every package version bump.                  |
| You need sorted iteration **right now**    | `Array.sorted()` + sticking with `Set`/`Dictionary`, or `OrderedCollection` (sort-then-store). |
| You need rope-like text editing            | Use a dedicated 3rd-party rope, or accept the unstable surface.          |
