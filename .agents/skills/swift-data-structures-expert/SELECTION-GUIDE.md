# Selection Guide — Which Swift Data Structure for X?

A decision tree to match access patterns to the right collection. Each leaf cites the relevant reference file in this skill for follow-up.

## Top-level question

> **What is the access pattern?**

```
┌─ Ordered linear access (subscript by integer, traversal, append) ─────────────┐
│                                                                                │
│   ├─ "I never share copies of this collection in a hot path; or my element     │
│   │   is noncopyable; or I need predictable performance with no COW spike."    │
│   │     → UniqueArray  (auto-grow) or RigidArray  (fixed cap)                  │
│   │       see basic-containers.md                                              │
│   │                                                                            │
│   ├─ "Standard COW value type with NSArray bridging on Darwin."                │
│   │     → Array  (stdlib)            see swift-stdlib.md                       │
│   │                                                                            │
│   ├─ "I want guaranteed contiguous storage (no NSArray bridging)."             │
│   │     → ContiguousArray  (stdlib)  see swift-stdlib.md                       │
│   │                                                                            │
│   └─ "I need fast push/pop on BOTH ends (queue, deque, sliding-window)."       │
│         → Deque  (COW)              see deque.md                               │
│         → UniqueDeque / RigidDeque  if noncopyable element or no COW           │
│           see basic-containers.md                                              │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

┌─ Unordered set (membership, set operations, uniqueness) ──────────────────────┐
│                                                                                │
│   ├─ Element is a small nonnegative Int and the *max value* is bounded.        │
│   │     → BitSet                   see bit-collections.md                      │
│   │                                                                            │
│   ├─ I want predictable O(1) insertion/removal anywhere, in any order.         │
│   │     → Set  (stdlib)            see swift-stdlib.md                         │
│   │                                                                            │
│   ├─ I need to preserve insertion order AND have O(1) lookup.                  │
│   │   (Trade: middle insertions/removals become O(n))                          │
│   │     → OrderedSet              see ordered-collections.md                   │
│   │                                                                            │
│   └─ I keep many shared snapshots and diff them, or I do "structural mutations │
│      of shared copies" (e.g. undo/redo, version history, observable state).    │
│        → TreeSet                  see hash-tree-collections.md                 │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

┌─ Key-value dictionary ────────────────────────────────────────────────────────┐
│                                                                                │
│   ├─ Order doesn't matter, predictable O(1).                                   │
│   │     → Dictionary  (stdlib)    see swift-stdlib.md                          │
│   │                                                                            │
│   ├─ I need to iterate keys/values in insertion order, or index-by-position.   │
│   │     → OrderedDictionary       see ordered-collections.md                   │
│   │                                                                            │
│   └─ Snapshots, sharing, version-diffs.                                        │
│        → TreeDictionary           see hash-tree-collections.md                 │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

┌─ Priority queue ──────────────────────────────────────────────────────────────┐
│                                                                                │
│   "I want fast O(log n) push and pop of min OR max."                           │
│     → Heap  (min-max heap)        see heap.md                                  │
│                                                                                │
│   "I want a sorted iteration order at all times" (B-tree-backed)               │
│     → SortedSet / SortedDictionary  (unstable trait, B-tree)                   │
│       see unstable.md                                                          │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

┌─ Compact boolean storage ─────────────────────────────────────────────────────┐
│                                                                                │
│   "Fixed-length packed booleans, indexed 0..<count."                           │
│     → BitArray                    see bit-collections.md                       │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

┌─ Text ────────────────────────────────────────────────────────────────────────┐
│                                                                                │
│   "Normal text, possibly multi-script, Unicode-correct."                       │
│     → String  (stdlib)            see swift-stdlib.md                          │
│                                                                                │
│   "Editing huge text efficiently (megabytes), with O(log n) edits."            │
│     → BigString  (unstable, RopeModule)  see unstable.md                       │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘

┌─ Range / interval ────────────────────────────────────────────────────────────┐
│                                                                                │
│   → Range, ClosedRange  (stdlib)   see swift-stdlib.md                         │
│                                                                                │
└────────────────────────────────────────────────────────────────────────────────┘
```

## Common dilemmas, decided

### `Array` vs `Deque` — when?

**Use `Deque` if any of**:
- You `prepend` or `removeFirst` at a non-negligible rate. `Array.removeFirst()` is O(n). `Deque.popFirst()` is O(1).
- You implement a queue or sliding-window.
- You routinely both push-back and pop-front.

**Use `Array` if any of**:
- You only `append` and `removeLast`.
- You need NSArray bridging on Darwin (`Deque` doesn't bridge to Foundation).
- You need to call APIs that take `Array` parameters (Deque can be passed as `[Element](deque)` but that's O(n)).
- You want marginally faster random-access reads — `Array`'s storage is one contiguous run, while `Deque` is a ring buffer with potential wrap-around (extra modulo per index).

Quote from `Documentation/Deque.md:67-70`: *"Mutations near the front are expected to be significantly faster in deques, but arrays may measure slightly faster for general random-access lookups."*

### `Set` vs `OrderedSet` vs `TreeSet` — when?

| Need                                                | Use                  |
| --------------------------------------------------- | -------------------- |
| Pure membership, no ordering needed                 | `Set` (stdlib)       |
| Insertion order preserved + O(1) random access      | `OrderedSet`         |
| Many shared snapshots, structural diffs, undo state | `TreeSet`            |
| Sorted iteration over `Comparable` elements         | `SortedSet` (unstable) |

Critical caveat: `OrderedSet` is O(n) for *non-end* insertions and removals — see `Documentation/OrderedSet.md:248-255`. If you remove from the middle a lot, prefer `Set`.

### `Dictionary` vs `OrderedDictionary` vs `TreeDictionary` — when?

Same trichotomy as the set case. Important: `OrderedDictionary` provides a `keys: OrderedSet<Key>` view that's an O(1) lightweight wrapper — see `Documentation/OrderedDictionary.md:165-172`.

### `OrderedSet` vs `Array` — when?

Use `OrderedSet` when you need *both* `Set`-like membership (`contains` is O(1) avg) *and* `Array`-like positional indexing (`set[3]` is O(1)). The cost is extra memory for the side hash table (about 1.25× to 4× the array bytes depending on load factor).

Use `Array` when uniqueness isn't a constraint or you check it manually.

### `Set<Int>` vs `BitSet` — when?

If the largest member you'll insert is bounded and the set is dense enough:
- `BitSet` storage ≈ `max / 8` bytes (1 bit per possible value in the range `0...max`).
- `Set<Int>` storage ≈ `n * sizeof(Int) / load_factor` ≈ `8n` to `16n` bytes (open-addressing, load factor ≤ 0.75), plus class header overhead.

For a set of integers in 0..<1_000_000 with 100k members, `BitSet` ≈ **125 KB** (exact: `1_000_000 / 8`); `Set<Int>` is roughly **1.5–3 MB** depending on hash-table sizing. (Estimates — measure before committing to a memory budget.)

But: `BitSet.insert(x)` where `x > current max` triggers an O(max) allocation (`Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift:59-62`). Use `Set<Int>` if the set is sparse or members can be arbitrarily large.

### `Heap` vs sorted Array — when?

| Need                                                  | Use                          |
| ----------------------------------------------------- | ---------------------------- |
| Repeated extract-min, push                            | `Heap`                       |
| Need full sorted iteration *once* at the end          | `Array.sorted()` (O(n log n)) |
| Need to peek arbitrary k-th element                   | sorted Array (O(1) after sort) |
| Need both min and max in O(1) — *and* extract both    | `Heap` (it's a **min-max** heap) — `Documentation/Heap.md:15-16` |

### `String.count` is slow — alternatives?

If you only need byte length: `string.utf8.count` is O(1) on native strings. If you only need code-unit length: `string.utf16.count` is O(1). `string.count` (grapheme cluster count) is O(n) and unavoidable — grapheme boundaries depend on the entire string. — [A] String docs.

### Persistent vs mutable — when does `TreeDictionary` beat `Dictionary`?

`TreeDictionary` is **slower** than `Dictionary` for a one-shot mutation sequence (constant-factor overhead from pointer chasing through tree nodes).

`TreeDictionary` is **faster** when:

- You take *many copies* and mutate each independently — Dictionary's COW copies the whole storage on every mutation of a shared value; TreeDictionary copies at most O(log n) nodes.
- You **compare** two related dictionaries — TreeDictionary's structural sharing lets `subtracting`/`isEqual` short-circuit on shared subtrees.

Quote from `Sources/HashTreeCollections/TreeSet/TreeSet.swift:30-37`: *"every time a shared copy of a set is mutated, the mutation needs to make a full copy of the set's storage. `TreeSet` takes a different approach…"*

### COW vs noncopyable variants — when?

| Need                                                       | Use                                    |
| ---------------------------------------------------------- | -------------------------------------- |
| Convenient value semantics, may make copies                | `Array`, `Deque`, `OrderedSet`, etc.   |
| Element is *noncopyable* (e.g. `~Copyable` type)           | `UniqueArray`, `RigidArray`, `UniqueDeque`, `RigidDeque`, `UniqueBox` |
| Performance MUST be predictable (no surprise COW copy)     | `UniqueArray` family                    |
| Memory budget is strict — no growth allowed                | `RigidArray` family (traps if full)    |
| C interop with header-then-elements layout                 | `TrailingArray`                        |

Rationale: see `Sources/BasicContainers/BasicContainers.docc/BasicContainers.md:17-42`.

## Anti-patterns to call out

- ❌ **Using `Array` as a FIFO queue**. `removeFirst()` is O(n). Use `Deque`.
- ❌ **Using `OrderedSet` as a substitute for `Set` "for stability of iteration order"** when you don't need random access and you do middle removals. Stdlib `Set`'s iteration order is unspecified but doesn't make middle-remove cost O(n).
- ❌ **Calling `string.count == 0` instead of `string.isEmpty`** — `count` walks all graphemes, O(n).
- ❌ **`for i in 0..<dict.count { dict[i] }`** — `Dictionary` isn't subscriptable by integer; you're iterating a Range and doing key lookups. If you need positional access, use `OrderedDictionary`.
- ❌ **Using `TreeDictionary` for short-lived dictionaries that are never shared** — pure overhead vs `Dictionary`.
- ❌ **Calling `someArray.reserveCapacity(huge)` "to make append fast"** — `reserveCapacity` itself allocates `huge` bytes and may copy. Only useful when you actually know the final count.
- ❌ **Treating `BitSet.insert(largeValue)` as O(1)** — it allocates words up to `largeValue`. See `bit-collections.md`.
