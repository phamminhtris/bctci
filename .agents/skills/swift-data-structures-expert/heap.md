# `Heap<Element: Comparable>` — Array-Backed Min-Max Heap

**Module**: `HeapModule` (also re-exported from `Collections`)
**Header path**: `import HeapModule` or `import Collections`
**Public source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/HeapModule/`
**`@frozen`**: yes — `Sources/HeapModule/Heap.swift:62`
**Sendable**: `Sendable where Element: Sendable` — `Heap.swift:74`

## TL;DR

A double-ended priority queue: O(1) peek-min, O(1) peek-max, O(log n) insert/pop on either end. Backed by a single `ContiguousArray<Element>` (no class allocation for the tree itself — the tree is *implicit* in the array offsets).

## The min-max heap idea (Atkinson 1986)

Citation: full reference block at `Documentation/Heap.md:150-153` (also referenced from `Sources/HeapModule/Heap.swift:27-34` doc-comment):

> *M.D. Atkinson, J.-R. Sack, N. Santoro, T. Strothotte. "Min-Max Heaps and Generalized Priority Queues." Communications of the ACM, vol. 29, no. 10, Oct. 1986., pp. 996-1000, doi:10.1145/6617.6621*

A min-max heap is a complete binary tree where levels alternate between "min level" and "max level":

```
level 0 (min):              A
                          /   \
level 1 (max):           J     G          ← children >= all descendants
                        / \   / \
level 2 (min):         D   B F   C        ← children <= all descendants
                      /|   |
level 3 (max):       I E   H

Array layout (breadth-first):
[A, J, G, D, B, F, C, I, E, H]
 0  1  2  3  4  5  6  7  8  9
```

(Diagram adapted from `Documentation/Heap.md:133-141`.)

**Invariant**: each node on an even level is ≤ every descendant; each node on an odd level is ≥ every descendant.

Therefore:
- The **minimum** is always at index 0 (root, even level).
- The **maximum** is at index 1 or 2 — whichever child of the root is larger (both children sit on level 1, an odd/max level).

This is why `Heap.max` does a single comparison of buffer[1] vs buffer[2] — see `Heap.swift:164-179`.

## Memory layout

```swift
public struct Heap<Element: Comparable> {
  internal var _storage: ContiguousArray<Element>
}
```

(`Heap.swift:62-72`)

That's the entire storage. The tree is encoded implicitly: for the node at array offset `i`:

- left child at `2i + 1`
- right child at `2i + 2`
- parent at `(i - 1) / 2`
- grandparent at `(i - 3) / 4`
- first grandchild at `4i + 3`

These formulas live in `Sources/HeapModule/_HeapNode.swift:111-148`.

Level of an offset: `_HeapNode.level(forOffset:)` returns `(offset + 1)._binaryLogarithm()` (`_HeapNode.swift:58-61`). Even level → "min level". `_HeapNode.isMinLevel(_:)`: `level & 0b1 == 0` (`_HeapNode.swift:75-78`).

## Algorithms

All references below point to `Sources/HeapModule/Heap+UnsafeHandle.swift`.

### `bubbleUp(node)` — used by `insert`

After appending the new element at the end of the array, walk it upward to its correct level:

1. If new node is on a min level and its parent is smaller, OR new node is on a max level and its parent is larger → swap with parent (move to opposite level).
2. Then walk up by **grandparent** (skipping one level so we stay on the same min/max level), swapping while the invariant is violated.

Algorithm at `Heap+UnsafeHandle.swift:102-128`. Complexity is O(log n) because the tree height is `⌈log₂ count⌉`.

### `trickleDownMin(node)` — used after `popMin`

Move the recently-swapped-in element at `node` (a min-level node) downward. At each step compare with **children and grandchildren** (4 grandchildren max per node when fully populated) — the smallest of these descendants is the candidate. Swap and repeat.

Why grandchildren? Because they're on the same min level as `node`. Children are on the max level, so they may temporarily violate the invariant; we re-establish it on the way down by checking the parent (which is one of the children) at the end.

Implementation at `Heap+UnsafeHandle.swift:131-203`. Complexity O(log n).

### `trickleDownMax(node)` — symmetric for max nodes

`Heap+UnsafeHandle.swift:248-314`.

### `heapify()` — used by `init(_: Sequence)` and bulk insert

Floyd's algorithm: walk the array from the last internal node back to the root, calling `trickleDown` on each. Total cost is O(n), not O(n log n), because most nodes are near the bottom and trickle short distances. Implementation at `Heap+UnsafeHandle.swift:362-389`.

Floyd's complexity citation: `Heap.swift:336-338` — *"Initializes a heap from a sequence. Complexity: O(*n*)…"* and the comment in `Heap+UnsafeHandle.swift:363`: *"This is Floyd's linear-time heap construction algorithm."*

### Bulk `insert(contentsOf:)` heuristic

`Heap.swift:354-396`. When you append `k` items to a heap of size `n`, the code chooses between:

- Re-heapify (Floyd): O(n + k)
- Bubble-up each new item: O(k · log(n + k))

The heuristic threshold (`Heap.swift:385`):

```swift
let heuristicLimit = 2 &* newCount / newCount._binaryLogarithm()
let useFloyd = (newCount - origCount) > heuristicLimit
```

i.e. use Floyd when `k > 2(n+k) / log₂(n+k)`.

## Public operations — full table

All complexities are taken directly from the doc-comments in `Sources/HeapModule/Heap.swift`.

| Operation                          | Complexity                       | Doc-comment line |
| ---------------------------------- | -------------------------------- | ---------------- |
| `init()`                           | O(1)                             | `Heap.swift:67-71` |
| `init(_: some Sequence)`           | O(*n*) Floyd                     | `Heap.swift:336-338` |
| `init(minimumCapacity:)`           | O(1) allocations                 | `Heap.swift:115-120` |
| `count`, `isEmpty`                 | O(1)                             | `Heap.swift:79-91` |
| `min` (peek smallest)              | O(1)                             | `Heap.swift:156-160` |
| `max` (peek largest)               | O(1) — one comparison of children of root | `Heap.swift:164-179` |
| `unordered` (snapshot of backing) | O(1) — doc-comment states O(1); `Array(contiguousArray)` shares storage in current stdlib | `Heap.swift:93-103` |
| `insert(_:)`                       | O(log *count*) comparisons       | `Heap.swift:143-152` |
| `insert(contentsOf:)`              | O(*n* + *k*) (Floyd) or O(*k* · log(*n*+*k*)) — picks heuristically | `Heap.swift:352-396` |
| `popMin()`                         | O(log *count*)                   | `Heap.swift:183-200` |
| `popMax()`                         | O(log *count*)                   | `Heap.swift:202-225` |
| `removeMin()` (precondition: non-empty) | O(log *count*)              | `Heap.swift:227-236` |
| `removeMax()`                      | O(log *count*)                   | `Heap.swift:238-247` |
| `replaceMin(with:)`                | O(log *count*)                   | `Heap.swift:249-272` |
| `replaceMax(with:)`                | O(log *count*)                   | `Heap.swift:296-328` |
| `removeAll(where:)`                | O(*n*) — uses Array.removeAll then full heapify | `Heap.swift:280-294` |
| `reserveCapacity(_:)`              | O(*count*)                       | `Heap.swift:135-139` |

## Important non-features

### `Heap` doesn't conform to `Sequence`

`Heap` deliberately does not conform to `Sequence` or `Collection`. Quote from `Heap.swift:43-49`:

> *"Unlike most container types, `Heap` doesn't provide a direct way to iterate over the elements it contains -- it isn't a `Sequence` (nor a `Collection`). This is because the order of items in a heap is unspecified and unstable: it may vary between heaps that contain the same set of items, and it may sometimes change in between versions of this library. In particular, the items are (almost) never expected to be in sorted order."*

If you want to read elements directly use `heap.unordered` which gives you an `Array<Element>` snapshot — but the order is intentionally undefined.

### Why not `Equatable` / `Hashable`?

Two heaps with the same set of elements can legally have different internal arrangements (the min-max invariant doesn't determine a unique tree). So array-equality of `_storage` doesn't model element-set equality, and the library doesn't synthesise it.

### No O(log n) arbitrary lookup

There's no `heap.contains(x)` better than O(n). Heaps only give fast access to the **extremes**. If you need O(log n) lookup of arbitrary elements, you want a balanced BST or a hash set, not a heap.

## When to use `Heap`

- Priority queue with both ends needed (job scheduler with deadlines & priorities, k-largest-and-k-smallest, sliding-window median).
- Top-k / bottom-k problem.
- Event loop with timestamp-ordered events (use min-heap behaviour via `popMin`).

When **not** to use:
- You need a sorted iteration — use `Array.sorted()` (one-shot, O(n log n)) or `SortedSet` (unstable).
- You need arbitrary element removal in O(log n) — heaps don't provide it.

## Related types

For comparison-based ordered structures with sorted iteration, see [unstable.md](unstable.md) — the experimental `SortedSet` / `SortedDictionary` (in-memory B-tree).
