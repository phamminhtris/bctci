/**
Given an adjacency list, graph, write a function that returns whether graph is a valid undirected graph, meaning that:

Every node is between 0 and V-1.
There are no self-loops: edges connecting a node to itself.
There are no parallel edges: two edges connecting the same two nodes.
If node1 appears in graph[node2], then node2 also appears in graph[node1].

Example 1: graph = [[1], [0]]
Output: True. This is a simple valid graph with two nodes connected by an edge.

Example 2: graph = [[2], [0]]
Output: False. Node index 2 is invalid since there are only 2 nodes.

Example 3: graph = [[0], []]
Output: False. Self-loop in node 0.

Example 4: graph = [[1, 1], [0, 0]]
Output: False. Parallel edges between nodes 0 and 1.

Example 5: graph = [[1], []]
Output: False. Node 0 has node 1 as a neighbor but not vice versa.
*/

extension AdjGraph {
    /// Validates this adjacency-list graph against the prompt rules.
    ///
    /// Returns `true` only if all conditions hold:
    /// - Every neighbor index is in `0..<numNodes`.
    /// - There are no self-loops (`u -> u`).
    /// - There are no parallel edges between the same two vertices.
    /// - Undirected symmetry holds:
    ///   if `v` appears in `outerList[u]`, then `u` appears in `outerList[v]`.
    func validate() -> Bool {
        var vertexNeighborMap = [Int: Set<Int>]()
        for (vertex, neighbors) in outerList.enumerated() {
            var seen = Set<Int>()
            for friend in neighbors { 
                guard friend >= 0 && friend < numNodes else { return false }
                guard friend != vertex else { return false }
                guard !seen.contains(friend) else { return false }
                seen.insert(friend)
            }
            vertexNeighborMap[vertex] = seen
        }

        for (vertex, neighbors) in outerList.enumerated() {
            for neighbor in neighbors {
                if let neighborEdges = vertexNeighborMap[neighbor] {
                    if !neighborEdges.contains(vertex) {
                        return false
                    }
                }
            }
        }

        return true

    }
}
