/**
Given a non-empty adjacency list of an undirected graph, graph, return whether it is a tree. A graph is a tree if it is acyclic and connected.

Example 1:
graph = [
  [2],           # Node 0
  [2, 5],        # Node 1
  [0, 1, 3, 4],  # Node 2
  [2],           # Node 3
  [2],           # Node 4
  [1]            # Node 5
]
Output: True
See left graph in the picture above

Example 2:
graph = [
  [2],           # Node 0
  [5],           # Node 1
  [0, 3],        # Node 2
  [2],           # Node 3
  [],            # Node 4
  [1]            # Node 5
]
Output: False
This graph is not connected
See center graph in the picture above

Example 3:
graph = [
  [1],           # Node 0
  [0, 2, 5],     # Node 1
  [1, 3, 4],     # Node 2
  [2],           # Node 3
  [2, 5],        # Node 4
  [1, 4]         # Node 5
]
Output: False
This graph is not acyclic
See right graph in the picture above
*/

extension AdjGraph {
    func isTree() -> Bool {
        var visited = Set<Int>()
        func visit(node: Int, from parent: Int) -> Bool {
            visited.insert(node)
            for neighbor in outerList[node] {
                if !visited.contains(neighbor) {
                    if !visit(node: neighbor, from: node) {
                        return false
                    }
                } else {
                    if neighbor != parent {
                        return false
                    }
                }
            }
            return true
        }

        let isAcyclic = visit(node: 0, from: -1)
        return visited.count == outerList.count && isAcyclic
    }
}