/**
You are given a list of (title, plays) tuples where the first element is the name of a song, and the second is the number of times the song has been played. You are also given a positive integer k. Return the k most played songs from the list, in any order.

If the list has fewer than k songs, return all of them.
Break ties in any way you want.
You can assume that song titles have a length of at most 50.

Example:
songs = [["All the Single Brackets", 132],
         ["Oops! I Broke Prod Again", 274],
         ["Coding In The Deep", 146],
         ["Boolean Rhapsody", 193],
         ["Here Comes The Bug", 291],
         ["All About That Base Case", 291]]
k = 3
Output: ["All About That Base Case", "Here Comes The Bug", "Oops! I Broke Prod
Again"]. Any order of these (excellent) songs would be valid.
Follow-up: Can you solve it using only O(k) space?
*/

import Collections

struct SongMetadata: Comparable {
    let name: String 
    let playCount: Int

    static func < (lhs: SongMetadata, rhs: SongMetadata) -> Bool {
        lhs.playCount < rhs.playCount 
    }
}

func kMostPlayed(songs: [SongMetadata], k: Int) -> [String] {
    var heap = Heap<SongMetadata>()
    for song in songs {
        heap.insert(song)
        if heap.count > k {
            _ = heap.popMin()
        }
    }

    var res = [String]()
    while !heap.isEmpty {
        if let next = heap.popMin() {
            res.append(next.name)
        }
    }
    return res
}

