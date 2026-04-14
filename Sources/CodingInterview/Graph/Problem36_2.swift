/**
Given the adjacency list of an undirected graph, graph, and two distinct nodes, node1 and node2, return a simple path from node1 to node2.

A simple path does not repeat any nodes. Return an empty array if there is no path from node1 to node2.


Example 1:
graph = [
  [1],
  [0, 2, 5, 4],
  [1, 4, 5],
  [],
  [5, 2, 1],
  [1, 2, 4]
]
node1 = 0
node2 = 4

Output: [0, 1, 4]
There are other valid answers, like [0, 1, 2, 5, 4].

Example 2:
graph = [
  [1],
  [0, 2, 5, 4],
  [1, 4, 5],
  [],
  [5, 2, 1],
  [1, 2, 4]
]
node1 = 0
node2 = 3

Output: []
There is no path to node 3.

Example 3:
graph = [
  [1],
  [0, 2],
  [1]
]
node1 = 0
node2 = 2

Output: [0, 1, 2]
A simple path through all nodes.
*/

import Collections

extension AdjGraph {
    func simplePath(from node1: Int, to node2: Int) -> [Int] {
        precondition((0..<outerList.count).contains(node1))
        precondition((0..<outerList.count).contains(node2))

        var predecessors = [Int: Int]()
        func visit(_ node: Int, prev: Int) -> Bool {
            if predecessors[node] != nil {
                return false
            }
            predecessors[node] = prev

            if node == node2 {
                return true
            }
            for nbr in outerList[node] {
                if visit(nbr, prev: node) {
                    return true
                }
            }

            return false
        }

        _ = visit(node1, prev: -1)
        if predecessors[node2] == nil {
            return []
        }

        var result = Deque<Int>()
        result.prepend(node2)
        var prev = predecessors[node2] 
        while let curr = prev, curr != -1 {
            result.prepend(curr)
            prev = predecessors[curr]
        }

        return Array(result)
    }
}
