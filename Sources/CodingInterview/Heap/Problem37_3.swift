/**
Implement a TopSongs class that receives an integer k > 0 during initialization and has two methods:

register_plays(title, plays) indicates that a song was played a given number of times. It returns nothing. The method is never called with the same title twice.
top_k() returns the (up to) k registered song titles with the most plays, in any order, and breaking ties arbitrarily.

Example:
s = TopSongs(3)
s.register_plays("Boolean Rhapsody", 193)
s.register_plays("Coding In The Deep", 146)
s.top_k()  # Returns ["Coding In The Deep", "Boolean Rhapsody"]
s.register_plays("All About That Base Case", 291)
s.register_plays("Here Comes The Bug", 223)
s.register_plays("Oops! I Broke Prod Again", 274)
s.register_plays("All the Single Brackets", 132)
s.top_k()  # Returns ["All About That Base Case", "Here Comes The Bug", "Oops!
I Broke Prod Again"]
Analyze the space and runtime of each operation in terms of the number of songs registered so far. The goal is to minimize the total runtime assuming we will make the same number of operations of each type and that k will be relatively small compared to the number of songs.
*/

import Collections

struct TopSongs {
    let k: Int
    private var heap = Heap<SongMeta>()

    init(_ k: Int) {
        self.k = k
    }

    mutating func registerPlays(_ title: String, _ playCount: Int) {
        guard let min = heap.min else {
            heap.insert(SongMeta(title: title, play: playCount))
            return
        }
        if heap.count >= k {
            if min.play < playCount {
                _ = heap.popMin()
                heap.insert(SongMeta(title: title, play: playCount))
            }
        } else {
            heap.insert(SongMeta(title: title, play: playCount))
        }
    }

    func topK() -> [String] {
        heap.unordered.map(\.title)
    }

    private struct SongMeta: Comparable {
        let title: String 
        let play: Int

        static func < (lhs: SongMeta, rhs: SongMeta) -> Bool {
            lhs.play < rhs.play
        }
    }
}
