/**
Given the adjacency list of an undirected, connected graph, graph, return a set of edges forming a spanning tree.

A spanning tree is a subset of edges that connects (i.e., "spans") every node and has no cycles.

Example 1:
graph = [
  [1],
  [0, 2, 5],
  [1, 3, 4],
  [2],
  [2, 5],
  [1, 4]
]
Output: [[0, 1], [1, 2], [2, 3], [2, 4], [4, 5]]
There are other valid answers

Example 2:
graph = [[1], [0]]
Output: [[0, 1]]
A single edge is a valid spanning tree for two nodes.

Example 3:
graph = [
  [1, 2],
  [0, 2],
  [0, 1]
]
Output: [[0, 1], [0, 2]]
There are other valid answers, like [[0, 1], [1, 2]].

Example 4:
graph = [[]]
Output: []
This graph has a single node and no edges.

*/

func spanningTree(adjGraph: [[Int]]) -> [[Int]] {
    guard !adjGraph.isEmpty else { return [] }
    var visited: [Int: Int] = [:]

    func visit(node: Int, from parent: Int) {
        if visited.keys.contains(node) { 
            return 
        } else {
            visited[node] = parent
        }
        for nbr in adjGraph[node] {
            visit(node: nbr, from: node)
        }
    }

    visit(node: 0, from: -1)
    visited[0] = nil
    var res = [[Int]]() 
    for (k, v) in visited {
        res.append([k, v])
    }

    return res
}

func buildGraph(edges: [[Int]]) -> [[Int]] {
    var adjGraph = [[Int]]()
    for edge in edges {
        let first = edge[0]
        let second = edge[1]
        ensureSpace(in: &adjGraph, edgeIndex: max(first, second))

        adjGraph[first].append(second)
        adjGraph[second].append(first)        
    }

    return adjGraph
}

func ensureSpace(in graph: inout [[Int]], edgeIndex: Int) {
    while graph.count < edgeIndex + 1 {
        graph.append([])
    }
}