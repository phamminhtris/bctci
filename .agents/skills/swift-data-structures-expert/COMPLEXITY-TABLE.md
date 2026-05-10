# Complexity Cheat Sheet — Every Swift Data Structure

**Legend**
- `n` = current count, `m` = other-collection count, `k` = parameter
- *avg* = expected when `Hashable` is high-quality. Worst case is O(n) for hashed collections under hash flooding.
- *amort* = amortized over many calls.
- All entries are followed by a citation. `[A]` = Apple Developer Docs. `[C]` = swift-collections repo (path is from `/Users/minhtri.pham/Developer/swift-collections/`).

---

## Array-shaped, contiguous

### `Array<Element>` — stdlib (COW, may bridge to NSArray on Darwin)

| Operation                       | Complexity                  | Source                                                                              |
| ------------------------------- | --------------------------- | ----------------------------------------------------------------------------------- |
| `count`, `isEmpty`              | O(1)                        | [A] developer.apple.com/documentation/swift/array                                  |
| `subscript(i)` get/set          | O(1)                        | [A] Array docs — RandomAccessCollection                                            |
| `append(_:)`                    | O(1) amortized, O(n) worst  | [A] Array docs — "O(1) on average, over many calls"                                |
| `append(contentsOf:)`           | O(m) amortized              | [A] Array docs                                                                     |
| `insert(_:at:)`                 | O(n)                        | [A] Array docs — shifts subsequent elements                                        |
| `remove(at:)`                   | O(n)                        | [A] Array docs                                                                     |
| `removeLast()` / `popLast()`    | O(1)                        | [A] Array docs                                                                     |
| `removeFirst()`                 | O(n)                        | [A] Array docs                                                                     |
| `reserveCapacity(_:)`           | O(n) when reallocating      | [A] Array docs                                                                     |
| `contains(_:)`                  | O(n)                        | [A] Sequence docs                                                                  |
| `firstIndex(of:)`               | O(n)                        | [A] Collection docs                                                                |
| Sort (`sort`, `sorted`)         | O(n log n)                  | [A] MutableCollection docs (Timsort-based since Swift 5)                           |
| Copy (on mutation of shared)    | O(n)                        | [A] Array docs — COW                                                               |
| Iteration                       | O(n)                        | [A] Sequence docs                                                                  |

**Growth factor**: 2× (Swift stdlib Array grows by doubling). Verifiable in the standard-library `Array.append` source.

### `ContiguousArray<Element>` — stdlib (COW, no NSArray bridging)

Identical complexity to `Array`. Distinguished only by storage guarantees: always Swift-native contiguous buffer (no `_ArrayBuffer` bridge), so iteration / `withUnsafeBufferPointer` is marginally faster. — [A] developer.apple.com/documentation/swift/contiguousarray

### `Deque<Element>` — swift-collections (COW, ring buffer)

| Operation                               | Complexity                 | Source |
| --------------------------------------- | -------------------------- | ------ |
| `count`, `isEmpty`                      | O(1)                       | `Sources/DequeModule/Deque/Deque._Storage.swift:91` |
| `subscript(i)` get                      | O(1)                       | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:353` doc-comment |
| `subscript(i)` set                      | O(1) when unique; O(`count`) otherwise (COW) | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:353-355` |
| `append(_:)`                            | Amortized O(1)             | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:658` doc-comment: *"Complexity: Amortized O(1)"* |
| `append(contentsOf:)`                   | Amortized O(`newElements.count`) | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:682, 724` |
| `prepend(_:)`                           | Amortized O(1)             | [C] `Sources/DequeModule/Deque/Deque+Extras.swift:111` doc-comment |
| `prepend(contentsOf:)`                  | Amortized O(`newElements.count`) | [C] `Sources/DequeModule/Deque/Deque+Extras.swift:135, 172` |
| `popFirst()`                            | O(1) when unique; O(`count`) otherwise | [C] `Sources/DequeModule/Deque/Deque+Extras.swift:74-75` doc-comment: *"O(1) when this instance has a unique reference to its underlying storage; O(`count`) otherwise."* |
| `popLast()`                             | O(1) when unique; O(`count`) otherwise | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:155-156` |
| `removeFirst()`                         | O(1) when unique; O(`count`) otherwise | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:433-434` |
| `removeLast()`                          | O(1) when unique; O(`count`) otherwise | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:464-465` |
| `insert(_:at:)`                         | O(`count`); amortized O(1) at start or end | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:756-759` doc-comment: *"shifts existing elements either towards the beginning or the end of the deque to minimize the number of elements that need to be moved. When inserting at the start or the end, this reduces the complexity to amortized O(1)."* |
| `insert(contentsOf:at:)`                | O(`count + newElements.count`); amortized O(`newElements.count`) at start/end | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:791-794` |
| `remove(at:)`                           | O(`count`); amortized O(1) at start or end | [C] same source as `insert(_:at:)` — `remove(at:)` doc-comment mirrors |
| `removeAll(keepingCapacity:)`           | O(`count`)                 | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:524` |
| `replaceSubrange(_:with:)`              | O(`self.count + newElements.count`) | [C] `Sources/DequeModule/Deque/Deque+Collection.swift:544` |
| Capacity growth                         | 1.5× geometric             | [C] `Sources/DequeModule/Deque/Deque._Storage.swift:165` (`(3 * capacity + 1) / 2`) |
| Copy of shared storage                  | O(n)                       | [C] `Sources/DequeModule/Deque/Deque._Storage.swift:155` (`_makeUniqueCopy`) |

**Underlying layout**: `ManagedBuffer<_DequeBufferHeader, Element>` where the header is `(capacity, count, startSlot)` — see `Sources/DequeModule/Deque/_DequeBufferHeader.swift:14-44`. The buffer is wrapped around (`startSlot` + `count` may overflow `capacity`), so the live region can be **two disjoint contiguous segments** — see `Sources/DequeModule/Deque/_DequeBuffer.swift:19-32` for the two-segment deinit.

---

## Hashed sets

### `Set<Element>` — stdlib (COW, open-addressing hash table)

| Operation                             | Complexity                                | Source |
| ------------------------------------- | ----------------------------------------- | ------ |
| `count`, `isEmpty`                    | O(1)                                      | [A] developer.apple.com/documentation/swift/set |
| `contains(_:)`                        | O(1) avg                                  | [A] Set docs |
| `insert(_:)`                          | O(1) avg amortized                        | [A] Set docs |
| `remove(_:)`                          | O(1) avg                                  | [A] Set docs |
| `union(_:)` / `intersection(_:)` / `subtracting(_:)` | O(n + m)                  | [A] Set docs / SetAlgebra |
| `isSubset(of:)`                       | O(n)                                      | [A] Set docs |
| Iteration                             | O(n), order is unspecified                | [A] Set docs |
| Worst-case lookup (adversarial)       | O(n)                                      | Per-process seeded hash mitigates; see swift-evolution SE-0205 |

**Internals**: open-addressing hash table with linear probing; storage in `_RawSetStorage` (Swift stdlib). Hash seeded with per-process randomness so adversarial inputs cannot reliably collide — same property exploited by swift-collections too (`Package.swift:71-77` mentions disabling this for testing).

### `OrderedSet<Element>` — swift-collections (Array + side hash table)

| Operation                  | Complexity                                | Source |
| -------------------------- | ----------------------------------------- | ------ |
| `count`, `isEmpty`         | O(1)                                      | derived from `_elements: ContiguousArray` |
| `subscript(i)`             | O(1)                                      | [C] random-access — `Sources/OrderedCollections/OrderedSet/OrderedSet.swift:120-141` |
| `contains(_:)`             | O(1) avg                                  | [C] `Documentation/OrderedSet.md:231-235` |
| `firstIndex(of:)`          | O(1) avg                                  | [C] `Sources/OrderedCollections/OrderedSet/OrderedSet.swift:463-469` |
| `append(_:)`               | O(1) amortized avg                        | [C] `Sources/OrderedCollections/OrderedSet/OrderedSet+Insertions.swift:85-87` |
| `insert(_:at:)` (non-end)  | O(n)                                      | [C] `Documentation/OrderedSet.md:248-255` — "linear time at the front (or in the middle)" |
| `remove(at:)`              | O(n)                                      | [C] same |
| `remove(_:)`               | O(n) — locates O(1), then removes from Array | [C] same |
| `removeLast()`             | O(1) amortized                            | [C] derived from `Array.removeLast` semantics |
| `reserveCapacity(_:)`      | O(n)                                      | [C] `Sources/OrderedCollections/OrderedSet/OrderedSet+ReserveCapacity.swift` |
| `difference(from:)` → `CollectionDifference<Element>` | O(*n* + *m*) — specialised algorithm exploiting member uniqueness | [C] `Sources/OrderedCollections/OrderedSet/OrderedSet+Diffing.swift` — `Complexity: O(self.count + other.count)` |
| `applying(_: CollectionDifference)` | O(*n* + *c*) (*c* = changes)         | [C] `Sources/OrderedCollections/OrderedSet/OrderedSet+Diffing.swift` |
| Iteration                  | O(n), insertion-order preserved           | [C] `Documentation/OrderedSet.md:39-48` — equality is order-sensitive |

**Hash-table parameters**:
- Min scale = 5 → min hash-table size = 32 buckets; sets with ≤15 items have **no hash table at all** (`maximumUnhashedCount = (1<<4)-1 = 15`) and lookup is linear-scan of the array — see `Sources/OrderedCollections/HashTable/_HashTable+Constants.swift:38-43`.
- Load factor range: `1/4 ≤ load ≤ 3/4` — `_HashTable+Constants.swift:47-53`.
- Max scale = `min(Int.bitWidth, 56)` — `_HashTable+Constants.swift:28-33`.
- Each hash-table entry is *scale*-bit wide (encoded array offset) rather than a full `Int` — packed in `[UInt64]` words. See header layout `_Hashtable+Header.swift:23-33`.

### `TreeSet<Element>` — swift-collections (CHAMP, persistent)

| Operation                        | Complexity                            | Source |
| -------------------------------- | ------------------------------------- | ------ |
| `contains(_:)`                   | O(log n) — effectively constant       | [C] `Sources/HashTreeCollections/HashTreeCollections.docc/Extensions/TreeSet.md:64-67` |
| `insert(_:)`                     | O(log n) copy + O(1) hash/compare avg | [C] `Sources/HashTreeCollections/TreeDictionary/TreeDictionary.swift:341-344` (analogous) |
| `remove(_:)`                     | O(log n) copy                         | [C] `Sources/HashTreeCollections/TreeDictionary/TreeDictionary.swift:517-520` |
| `remove(at: Index)` (TreeSet)    | O(log n) **if storage might be shared; O(1) otherwise** | [C] `Sources/HashTreeCollections/TreeSet/TreeSet+Extras.swift` — `remove(at:)` doc-comment |
| `update(_:at:)` (TreeSet)        | O(log n) **if storage might be shared; O(1) otherwise** | [C] `Sources/HashTreeCollections/TreeSet/TreeSet+Extras.swift` — `update(_:at:)` doc-comment |
| Iteration                        | O(n)                                  | [C] derived |
| `union` / `intersection` / `subtracting` / `symmetricDifference` of two `TreeSet`s | O(min(n,m)) average; structural sharing makes mostly-shared inputs **constant-time** for unchanged subtrees | [C] `Sources/HashTreeCollections/TreeSet/TreeSet.swift:40-50` — "parts shared across both inputs can typically be handled in constant time" |
| Copying a `TreeSet` value        | O(1) — just bumps a reference         | [C] persistent data structure (TreeSet.swift:25) |
| Comparing to older snapshot      | O(differences) thanks to sharing      | [C] TreeSet.swift:38-46 example |

**Log base**: the "log n" is `log₃₂ n`. The tree is hard-capped at **13 levels on 64-bit** (`⌈64 / 5⌉`) — see `Sources/HashTreeCollections/HashNode/_HashLevel.swift:46-49` `limit` property and `_Bitmap.bitWidth = 5` (the bit-width of `log₂(32)`). For all practical n, this is bounded by a small constant.

### `BitSet` — swift-collections (set of nonnegative Int)

| Operation                          | Complexity                                              | Source |
| ---------------------------------- | ------------------------------------------------------- | ------ |
| `contains(member: Int)`            | O(1)                                                    | [C] `Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift:39-43` |
| `insert(_ newMember: Int)`         | O(1) if uniquely-held & `newMember ≤ max`; else O(max(`newMember`, max)) — bits must be allocated | [C] `Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift:59-62` |
| `update(with:)`                    | Same conditional form as `insert`                       | [C] `Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift:103-106` |
| `remove(_:)`                       | O(1) if uniquely-held & removed value < max; else O(max) | [C] `Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift:129-131` |
| `union`, `intersection`, `symmetricDifference`, `subtracting` (vs another `BitSet`) | O(max(n, m)) over **word count** (i.e. O(max/64)) | [C] `Sources/BitCollections/BitSet/BitSet+SetAlgebra*.swift` — bitwise word ops |
| Iteration                          | O(max)                                                  | [C] derived; iterates UInt-sized words |
| `min()`, `max()`                   | O(words)                                                | [C] `Sources/BitCollections/BitSet/BitSet+Sorted Collection APIs.swift` |

**Storage**: `[_Word]` where `_Word = UInt`. Word width = `UInt.bitWidth` = 64 on 64-bit, 32 on 32-bit. Memory = `max_member / 8` bytes (≈12% of `Set<Int>` for dense sets). See `Sources/BitCollections/BitSet/BitSet.swift:27-36` and `Sources/InternalCollectionsUtilities/UnsafeBitSet/_UnsafeBitSet+_Word.swift:114-117`.

---

## Hashed dictionaries

### `Dictionary<Key, Value>` — stdlib (COW, open-addressing)

| Operation                             | Complexity              | Source |
| ------------------------------------- | ----------------------- | ------ |
| `count`, `isEmpty`                    | O(1)                    | [A] developer.apple.com/documentation/swift/dictionary |
| `subscript(key)` get / set            | O(1) avg                | [A] Dictionary docs |
| `updateValue(_:forKey:)`              | O(1) avg amortized      | [A] Dictionary docs |
| `removeValue(forKey:)`                | O(1) avg                | [A] Dictionary docs |
| `index(forKey:)`                      | O(1) avg                | [A] Dictionary docs |
| Iteration                             | O(n), unspecified order | [A] Dictionary docs |
| Hash flooding worst case              | O(n) per op             | Per-process seeded `Hasher` mitigates — SE-0205 |

### `OrderedDictionary<Key, Value>` — swift-collections

| Operation                  | Complexity                                 | Source |
| -------------------------- | ------------------------------------------ | ------ |
| `count`, `isEmpty`         | O(1)                                       | derived |
| `subscript(key)` get       | O(1) avg                                   | [C] `Documentation/OrderedDictionary.md:215-219` |
| `subscript(key)` set (add) | O(1) amortized avg (appends)               | [C] same |
| `subscript(key)` set (existing) | O(1) avg                              | [C] same |
| `removeValue(forKey:)`     | O(n) — locates O(1), shifts Array          | [C] `Documentation/OrderedDictionary.md:222-224` (inherits OrderedSet renumbering) |
| `index(forKey:)`           | O(1) avg                                   | [C] derived from OrderedSet.firstIndex |
| `elements[i]` (positional) | O(1)                                       | [C] `Documentation/OrderedDictionary.md:117-126` |
| `keys`                     | O(1) view — `OrderedSet<Key>`              | [C] `Documentation/OrderedDictionary.md:165-172` |
| `values[i]` get/set        | O(1)                                       | [C] `Documentation/OrderedDictionary.md:179-188` |
| Iteration                  | O(n), insertion order preserved            | [C] `Documentation/OrderedDictionary.md:39-50` |

**Implementation**: an `OrderedSet<Key>` plus a parallel `ContiguousArray<Value>`. See `Documentation/OrderedDictionary.md:222-225` and `Sources/OrderedCollections/OrderedDictionary/OrderedDictionary+Values.swift`.

### `TreeDictionary<Key, Value>` — swift-collections (CHAMP, persistent)

| Operation                             | Complexity                                      | Source |
| ------------------------------------- | ----------------------------------------------- | ------ |
| `subscript(key)` get                  | O(log n) tree traversal + O(1) hash/compare avg | [C] `Sources/HashTreeCollections/TreeDictionary/TreeDictionary.swift:152-156` |
| `subscript(key)` set                  | O(log n) — copies path of nodes                 | [C] `TreeDictionary.swift:157-158` — "copy at most O(log(count)) existing members" |
| `updateValue(_:forKey:)`              | same — O(log n)                                 | [C] `TreeDictionary.swift:341-344` |
| `removeValue(forKey:)`                | O(log n)                                        | [C] `TreeDictionary.swift:517-521` |
| `index(forKey:)`                      | O(1) avg                                        | [C] `TreeDictionary.swift:286-289` |
| `remove(at: Index)`                   | O(log n)                                        | [C] `TreeDictionary.swift:540-543` |
| Copying a `TreeDictionary` value      | O(1) — bumps ref                                | [C] TreeDictionary.swift:30-37 |
| Iteration                             | O(n)                                            | [C] `Sources/HashTreeCollections/HashNode/_HashTreeIterator.swift` |

---

## Priority queue

### `Heap<Element>` — swift-collections (array-backed min-max heap, Atkinson 1986)

| Operation                              | Complexity                  | Source |
| -------------------------------------- | --------------------------- | ------ |
| `count`, `isEmpty`                     | O(1)                        | [C] `Sources/HeapModule/Heap.swift:79-91` |
| `min` (peek smallest)                  | O(1)                        | [C] `Sources/HeapModule/Heap.swift:156-160` |
| `max` (peek largest)                   | O(1)                        | [C] `Sources/HeapModule/Heap.swift:164-179` (compares two children of root) |
| `insert(_:)`                           | O(log n) comparisons        | [C] `Sources/HeapModule/Heap.swift:143-152` |
| `popMin()` / `removeMin()`             | O(log n) comparisons        | [C] `Sources/HeapModule/Heap.swift:181-200` |
| `popMax()` / `removeMax()`             | O(log n) comparisons        | [C] `Sources/HeapModule/Heap.swift:202-225` |
| `replaceMin(with:)` / `replaceMax(with:)` | O(log n)                 | [C] `Sources/HeapModule/Heap.swift:249-272` / `Heap.swift:296-328` |
| `init(_: Sequence)` (Floyd's heapify)  | O(n)                        | [C] `Sources/HeapModule/Heap.swift:333-346` — "O(*n*), where *n* is the number of items" |
| `insert(contentsOf:)` (bulk)           | O(n + k) using Floyd, or k·log(n+k) using bubble-up — picks heuristically | [C] `Sources/HeapModule/Heap.swift:354-396` (selection rule at line 385) |
| `removeAll(where:)`                    | O(n)                        | [C] `Sources/HeapModule/Heap.swift:280-294` |
| `reserveCapacity(_:)`                  | O(n)                        | [C] `Sources/HeapModule/Heap.swift:135-139` |

---

## Bit-indexed sequences

### `BitArray` — swift-collections (bit-packed `[Bool]`)

| Operation                          | Complexity              | Source |
| ---------------------------------- | ----------------------- | ------ |
| `count`, `isEmpty`                 | O(1)                    | [C] `Sources/BitCollections/BitArray/BitArray.swift:36-44` |
| `subscript(i)` get/set             | O(1)                    | [C] random-access; `Sources/BitCollections/BitArray/BitArray+Collection.swift` |
| `append(_:)`                       | O(1) amortized          | [C] inherits `[_Word].append` |
| `prepend(_:)`                      | O(n)                    | [C] requires shift |
| `insert(_:at:)`                    | O(n)                    | [C] `Sources/BitCollections/BitArray/BitArray+RangeReplaceableCollection.swift` |
| `removeLast`                       | O(1)                    | [C] Public override at `Sources/BitCollections/BitArray/BitArray+RangeReplaceableCollection.swift:493-497` (`_customRemoveLast`) → internal helper at `Sources/BitCollections/BitArray/BitArray.swift:80-89` (`_removeLast`) |
| `static randomBits(count:)`        | O(*n* / 64)              | [C] `Sources/BitCollections/BitArray/BitArray+RandomBits.swift:23-26` |
| `static BitSet.random(upTo:)`      | O(*upTo* / 64)           | [C] `Sources/BitCollections/BitSet/BitSet+Random.swift:19-22` |
| `BitSet.Counted` — `count`         | O(1) (cached)           | [C] `Sources/BitCollections/BitSet/BitSet.Counted.swift` — wrapper that maintains a count cache; see bit-collections.md for conformance list |
| Bitwise operators (`&`, `\|`, `^`, `~`) — same length | O(n / word_width) | [C] `Sources/BitCollections/BitArray/BitArray+BitwiseOperations.swift` |
| Shifts (`<<`, `>>`)                | O(n / word_width)       | [C] `Sources/BitCollections/BitArray/BitArray+Shifts.swift` |

**Storage**: same `[_Word]` as `BitSet`, plus an explicit `_count: UInt`. Memory = `count / 8` bytes vs `[Bool]`'s `count * sizeof(Bool) = count` bytes — about an **8× memory win** for large boolean arrays.

---

## String

### `String` — stdlib (COW, UTF-8, with small-string inline storage)

| Operation                          | Complexity                 | Source |
| ---------------------------------- | -------------------------- | ------ |
| `isEmpty`                          | O(1)                       | [A] developer.apple.com/documentation/swift/string |
| `count` (Character grapheme count) | **O(n)** — grapheme-cluster segmentation | [A] String docs — "O(*n*), where *n* is the length of the string" |
| `unicodeScalars.count`             | O(n) for native, O(1) for some bridged cases | [A] |
| `utf8.count` / `utf16.count`       | O(1) on native strings since Swift 5 | [A] String UTF8View docs |
| `subscript(i: String.Index)`       | O(1) — but index *advancement* is O(k) | [A] String.Index docs |
| `index(after:)`                    | O(1) for utf8/utf16; O(k) for Character (grapheme breaking) | [A] |
| `append(_:)`                       | O(1) amortized             | [A] String.RangeReplaceableCollection |
| `+` concat                         | O(n+m)                     | [A] |
| Hashing                            | O(n)                       | [A] |
| Equality `==`                      | O(n) — Unicode canonical equivalence | [A] |
| `contains(_:)` (substring)         | O(n·m)                     | [A] |

**Storage**: small-string optimization stores up to **15 UTF-8 bytes inline** on 64-bit (Swift 5+), no allocation. Larger strings use a heap-allocated `_StringStorage` (UTF-8 buffer). NSString bridging on Darwin is opportunistic. — See Swift Evolution SE-0178 (UTF-8 string).

### `Substring` — stdlib (a slice of a `String`)

Same complexity as `String` for read ops. `Substring` keeps its base `String` alive — converting back to `String` is O(n) copy. — [A] developer.apple.com/documentation/swift/substring

---

## Ranges (lazy bounds, no storage)

### `Range<Bound>`, `ClosedRange<Bound>` — stdlib

| Operation                  | Complexity   | Source |
| -------------------------- | ------------ | ------ |
| `count` (for `Strideable.Stride == Int`) | O(1) | [A] developer.apple.com/documentation/swift/range |
| `contains(_:)`             | O(1)         | [A] |
| `isEmpty`                  | O(1)         | [A] |
| `subscript(i)`             | O(1)         | [A] (RandomAccessCollection over integer ranges) |
| Iteration of integer range | O(n)         | [A] |

Ranges store only their two bounds. There is no allocation — a `Range<Int>` is just `(lowerBound, upperBound): (Int, Int)`.

---

## Noncopyable variants — swift-collections `BasicContainers` & `DequeModule`

All entries are O(1) (no COW machinery to copy). Capacity behaviour differs:

| Type                            | Capacity behaviour                              | Source |
| ------------------------------- | ----------------------------------------------- | ------ |
| `UniqueArray<Element>`          | Auto-grows by 1.5×                              | [C] `Sources/BasicContainers/UniqueArray/UniqueArray.swift:243-246` |
| `RigidArray<Element>`           | Fixed, traps on overflow                        | [C] `Sources/BasicContainers/RigidArray/RigidArray.swift:50-55, 352-361` |
| `UniqueDeque<Element>`          | Auto-grows by 1.5×                              | [C] `Sources/DequeModule/UniqueDeque/UniqueDeque.swift` (uses RigidDeque internally) |
| `RigidDeque<Element>`           | Fixed, traps on overflow                        | [C] `Sources/DequeModule/RigidDeque/RigidDeque.swift` |

`UniqueArray.append` complexity: **O(1)** guaranteed (no COW; never does a shared-storage copy). Reallocation when full is still O(n) but is deterministic — no surprise COW spike. See `Sources/BasicContainers/BasicContainers.docc/BasicContainers.md:17-42` for the rationale.
