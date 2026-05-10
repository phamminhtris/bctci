# `BitSet` and `BitArray` — Bit-Packed Collections

**Module**: `BitCollections` (also re-exported from `Collections`)
**Header path**: `import BitCollections` or `import Collections`
**Public source**: `/Users/minhtri.pham/Developer/swift-collections/Sources/BitCollections/`
**Sendable**: both — `BitSet.swift:38`, `BitArray.swift:53`

## TL;DR

Two views on the same underlying representation, `[_Word]` where `_Word` wraps a single `UInt`:

- **`BitSet`** — a `SetAlgebra` of nonnegative `Int` values. Bit *k* set means *k* is a member.
- **`BitArray`** — a `RangeReplaceableCollection` of `Bool`. Bit *k* set means `array[k] == true`.

Both use ~`max / 8` bytes for sparse-ish data — ~8× less than `Set<Int>` or `[Bool]` respectively.

## Word size

`_Word` (defined in `Sources/InternalCollectionsUtilities/UnsafeBitSet/_UnsafeBitSet+_Word.swift:14-41`) wraps a single `UInt`:

```swift
package struct _Word {
  package var value: UInt
  ...
}
```

`_Word.capacity = UInt.bitWidth` = **64 on 64-bit, 32 on 32-bit** (`_UnsafeBitSet+_Word.swift:114-117`). `wordShift` = 6 on 64-bit / 5 on 32-bit (`_UnsafeBitSet+_Word.swift:85-95`).

---

# `BitSet` — a set of nonnegative `Int`

## Memory layout

`Sources/BitCollections/BitSet/BitSet.swift:27-36`:

```swift
public struct BitSet {
  internal var _storage: [_Word]
  ...
}
```

That's it. The `_storage` array holds `_Word`s in ascending bit order. Bit position *k* lives in:
- word index = `k / 64`
- bit index within word = `k % 64`

(Or `k >> 6` and `k & 63` on 64-bit. See `_UnsafeBitSet+_Word.swift:85-101`.)

## Operations — complexity

All citations are from `Sources/BitCollections/BitSet/`.

| Operation                          | Complexity                                                        | Source |
| ---------------------------------- | ----------------------------------------------------------------- | ------ |
| `init()`                           | O(1)                                                              | derived |
| `init(_:)` from sequence           | O(*max*) — must allocate `[_Word]` up to max value                 | derived |
| `init(reservingCapacity:)`         | O(`capacity / 64`)                                                | `BitSet+Initializers.swift` |
| `count`                            | O(*max*) — sums `nonzeroBitCount` over all words                  | `BitSet.swift` & `_UnsafeBitSet` (no cached count!) |
| `isEmpty`                          | O(*max* / 64) — checks all words for zero                          | `BitSet.swift` |
| `contains(_:)`                     | **O(1)** — one bit test                                            | `BitSet+SetAlgebra basics.swift:39-43` |
| `insert(_:)`                       | O(1) if uniquely-held and `newMember ≤ current max`, else **O(*max*(`newMember`, max))** because storage grows | `BitSet+SetAlgebra basics.swift:59-62, 83-86` |
| `remove(_:)`                       | O(1) if uniquely-held and removed value < max; else **O(*max*)** | `BitSet+SetAlgebra basics.swift:129-131` |
| `update(with:)`                    | same conditional form as insert                                   | `BitSet+SetAlgebra basics.swift:103-106` |
| `union(_:)`, `intersection(_:)`, `subtracting(_:)`, `symmetricDifference(_:)` (vs another BitSet) | O(max(*n*, *m*) / 64) — bitwise per word | `BitSet+SetAlgebra*.swift` |
| `isSubset(of:)`, `isSuperset(of:)`, `isDisjoint(with:)` (vs another BitSet) | O(max(*n*, *m*) / 64) | same |
| `==` (BitSet vs BitSet)            | O(*n* / 64)                                                       | `BitSet+Equatable.swift` |
| `min()`                            | O(*n* / 64) — finds first non-zero word, then trailing-zero count | `BitSet+Sorted Collection APIs.swift` |
| `max()`                            | O(*n* / 64) — finds last non-zero word                            | same |
| Iteration                          | O(*max*) — must walk all words, return each set bit               | `BitSet+BidirectionalCollection.swift` |
| Set ops vs `Range<Int>`            | O(range length / 64) — efficient because Range maps to bit-range mask | `BitSet+SetAlgebra*.swift` overloads with Range |
| `static random(upTo:)` (system RNG) | O(*upTo* / 64)              | `BitSet+Random.swift:19-22` |
| `static random(upTo:using:)` (custom RNG) | O(*upTo* / 64)         | `BitSet+Random.swift:24` |

### Why is `insert` not strictly O(1)?

Citation: `Sources/BitCollections/BitSet/BitSet+SetAlgebra basics.swift:59-62`:

> *"Complexity: O(1) if the set is a unique value (with no other copies), and the inserted value is not greater than the largest value currently contained in the set (named *max*). Otherwise the complexity is O(max(`newMember`, *max*))."*

So inserting a value larger than the current max forces a re-allocation of the `[_Word]` backing array up to the new max — that's the linear cost.

For practical use: don't blindly insert arbitrarily-large `Int`s into a `BitSet`. Either:
- Pre-size with `init(reservingCapacity:)` (`BitSet+Initializers.swift`), or
- Use `Set<Int>` if member values aren't bounded.

### Conformances

`BitSet` conforms to `SetAlgebra`, `BidirectionalCollection` (with `Index = BitSet.Index`, not `Int`), `Hashable`, `Equatable`, `Encodable`/`Decodable`, `ExpressibleByArrayLiteral`, `CustomStringConvertible`, `CustomDebugStringConvertible`, `CustomReflectable`. — `Sources/BitCollections/BitSet/`.

Note: `BitSet` is `BidirectionalCollection` (not random-access), because skipping to "the *k*-th set bit" requires linear time in general.

### `BitSet.Counted` — variant with O(1) count

`BitSet.Counted` (`Sources/BitCollections/BitSet/BitSet.Counted.swift`) is a wrapper that maintains a cached `count`. The base `BitSet` doesn't keep a count to avoid the per-mutation update cost. Access via `bitset.counted` (O(*n*/64) one-time cost).

**Conformances** (`BitSet.Counted.swift:33-200`): `Sendable` (line 33), `Sequence` (line 116), `BidirectionalCollection` (line 134), `Codable` (line 181), `CustomStringConvertible` (line 193), `CustomDebugStringConvertible` (line 200), and the package-internal `_UniqueCollection` marker (line 49). Notably it does **not** conform to `SetAlgebra` directly — pull the unwrapped `BitSet` via the `bitset` accessor for `SetAlgebra` operations, and rewrap with `.counted` if you need the cached count back.

Operation costs are identical to `BitSet`, except `count` is O(1) (cached) and mutations carry an extra O(1) bookkeeping update of the cache.

---

# `BitArray` — a packed `[Bool]`

## Memory layout

`Sources/BitCollections/BitArray/BitArray.swift:27-44`:

```swift
public struct BitArray {
  internal var _storage: [_Word]
  internal var _count: UInt
}
```

Identical storage form to `BitSet`, but tracks an explicit `_count` because trailing bits in the last word may be unused. Invariant (line 41-42):

```swift
assert(count <= _storage.count * _Word.capacity)
assert(count > (_storage.count - 1) * _Word.capacity)
```

So `_storage` is always *exactly* big enough to hold `_count` bits, no more.

## Operations — complexity

All citations in `Sources/BitCollections/BitArray/`.

| Operation                          | Complexity                  | Source |
| ---------------------------------- | --------------------------- | ------ |
| `init()`                           | O(1)                        | derived |
| `init(_:)` from sequence of Bool   | O(*n* / 64)                  | `BitArray+Initializers.swift` |
| `init(_ bitPattern:)` from BinaryInteger | O(1)                  | same |
| `count`, `isEmpty`                 | O(1) — `_count` is stored   | `BitArray.swift:36-44` |
| `subscript(i)` get/set             | O(1)                        | `BitArray+Collection.swift` (RandomAccessCollection) |
| `append(_:)`                       | O(1) amortized              | inherits Array's append amortization |
| `prepend(_:)`                      | O(*n*)                      | requires shift |
| `insert(_:at:)`                    | O(*n*)                      | RangeReplaceableCollection conformance |
| `remove(at:)`                      | O(*n*)                      | same |
| `removeLast()`                     | O(1)                        | Public override at `BitArray+RangeReplaceableCollection.swift:493-497` (`_customRemoveLast`) → internal `BitArray.swift:80-89` |
| `removeLast(_:)`                   | O(1) amortized              | Public override at `BitArray+RangeReplaceableCollection.swift:501-505` (`_customRemoveLast(_:)`) → internal `BitArray.swift:91-103` |
| `removeFirst()`                    | O(*n*)                      | same as `remove(at: 0)` |
| `replaceSubrange(_:with:)`         | O(*n* + *m*)                | `BitArray+RangeReplaceableCollection.swift` |
| Bitwise `&`, `\|`, `^`, `~` (same-length) | O(*n* / 64)            | `BitArray+BitwiseOperations.swift` |
| Shifts `<<`, `>>`                  | O(*n* / 64)                  | `BitArray+Shifts.swift` |
| `fill(_:)`                         | O(*n* / 64)                  | `BitArray+Fill.swift` |
| Conversion to/from `String("0101...")` | O(*n*)                  | `BitArray+LosslessStringConvertible.swift`, `BitArray+ExpressibleByStringLiteral.swift` |
| `static randomBits(count:)`        | O(*n* / 64)                  | `BitArray+RandomBits.swift:23-26` (and `:33` for the RNG-taking overload) — uses the system RNG by default |
| `static randomBits(count:using:)`  | O(*n* / 64)                  | `BitArray+RandomBits.swift:33` |

## Memory comparison (rough estimates)

**Caveat**: numbers below are first-principles estimates, not measurements. Actual stdlib `Set<Int>` and `[Bool]` size depend on load factor (~0.75 max in `Dictionary`/`Set`), per-allocation alignment padding, and storage class headers (`_ContiguousArrayStorage` / `_HashTableStorage` instance overhead).

| Type                          | Approximate bytes for N=1M items                                  | Notes |
| ----------------------------- | ----------------------------------------------------------------- | ----- |
| `[Bool]`                      | ≈ 1,000,000 (1 byte per `Bool`, no packing) + ~32 B class header  | Each `Bool` is 1 byte in `Array<Bool>`. |
| `BitArray`                    | ≈ 125,000 = `N / 8` + small header                                | 64 bits per `_Word`. |
| `Set<Int>` of N members       | Roughly **2× to 4× of `8 × N` = 16-32 MB**                         | Open-addressing keeps load ≤ 0.75, so storage is sized to ~1.33×N slots. Each slot holds an `Int`. Plus class header & hash bookkeeping. |
| `BitSet` with values up to N  | ≈ 125,000 = `max / 8` + small header                              | Only economical when bits are dense. |

So if you have a "boolean mask of 10 million pixels", `BitArray` saves approximately 8× memory over `[Bool]`. If you have a "set of 100k IDs from `0..<1_000_000`", `BitSet` (~125 KB) saves roughly an order of magnitude over `Set<Int>` (likely 1.5–3 MB). **Profile or sysctl real numbers if you depend on these for a budget.**

## Conformances

`BitArray` conforms to `MutableCollection`, `RandomAccessCollection`, `RangeReplaceableCollection`, `Equatable`, `Hashable`, `Encodable`/`Decodable`, `ExpressibleByArrayLiteral` (of `Bool`), `ExpressibleByStringLiteral` (of `"0101..."`), `LosslessStringConvertible`. — `Sources/BitCollections/BitArray/`.

## When **not** to use these

- **Sparse data with unbounded values**: a `BitSet` containing `{1, 1_000_000_000}` allocates ~125 MB. Use `Set<Int>`.
- **Performance-critical iteration over `true` indices in a sparse `BitArray`**: iteration is O(`count`), not O(`true count`). For sparse-true data prefer keeping the indices in a `BitSet` or `Set<Int>`.
- **Random-access in a `BitArray.SubSequence` that hot-loops a single bit**: per-bit access in tight loops is still slower than `[Bool]` because of the per-access mask + shift + word lookup. Profile both.
