/**
Implement a PopularSongs class that has two methods:

register_plays(title, plays) indicates that a song was played a given number of times. It returns nothing. The method is never called with the same title twice.
is_popular(title) returns whether the given song is popular. A song is popular if its play count is strictly higher than the median play count.
The median of a collection of integers with odd size is the middle element in sorted order; if the size is even, the median is the average of the two middle elements.


Example:

p = PopularSongs()
p.register_plays("Boolean Rhapsody", 193)
p.is_popular("Boolean Rhapsody")                   # Returns False
p.register_plays("Coding In The Deep", 140)
p.register_plays("All the Single Brackets", 132)
p.is_popular("Boolean Rhapsody")                   # Returns True
p.is_popular("Coding In The Deep")                 # Returns False
p.is_popular("All the Single Brackets")            # Returns False
p.register_plays("All About That Base Case", 291)
p.register_plays("Oops! I Broke Prod Again", 274)
p.register_plays("Here Comes The Bug", 223)
p.is_popular("Boolean Rhapsody")                   # Returns False
p.is_popular("Here Comes The Bug")                 # Returns True
Analyze the space and runtime of each operation in terms of the number of songs registered so far. The goal is to minimize the total runtime assuming we will make the same number of operations of each type.
*/

import Collections

struct PopularSongs {
    struct SongMeta: Comparable { 
        let title: String 
        let count: Int 
        static func < (lhs: SongMeta, rhs: SongMeta) -> Bool {
            lhs.count < rhs.count
        }
    }
    
    var seen = [String: Int]()


    var lowerMaxHeap = Heap<SongMeta>() 
    var upperMinHeap = Heap<SongMeta>() 

    mutating func registerPlay(_ title: String, _ count: Int) {
        let meta = SongMeta(title: title, count: count)
        seen[title] = count
        if upperMinHeap.isEmpty || upperMinHeap.min!.count <= count {
            upperMinHeap.insert(meta)
        } else {
            lowerMaxHeap.insert(meta)
        }

        // rebalance
        if lowerMaxHeap.count > upperMinHeap.count {
            upperMinHeap.insert(lowerMaxHeap.popMax()!)
        } else if lowerMaxHeap.count + 1 < upperMinHeap.count {
            lowerMaxHeap.insert(upperMinHeap.popMin()!)
        }
    }

    func isPopular(_ title: String) -> Bool {
        guard let songCount = seen[title] else { return false }

        if upperMinHeap.count > lowerMaxHeap.count {
            let median = upperMinHeap.min!
            return songCount > median.count
        } else {
            let medianCount = (upperMinHeap.min!.count + lowerMaxHeap.max!.count) / 2
            return songCount > medianCount
        }
    }
}