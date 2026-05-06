/**
https://leetcode.com/problems/count-the-number-of-complete-components/description/
You are given an integer n. There is an undirected graph with n vertices, numbered from 0 to n - 1. You are given a 2D integer array edges where edges[i] = [ai, bi] denotes that there exists an undirected edge connecting vertices ai and bi.

Return the number of complete connected components of the graph.

A connected component is a subgraph of a graph in which there exists a path between any two vertices, and no vertex of the subgraph shares an edge with a vertex outside of the subgraph.

A connected component is said to be complete if there exists an edge between every pair of its vertices.

Example 1:
Input: n = 6, edges = [[0,1],[0,2],[1,2],[3,4]]
Output: 3
Explanation: From the picture above, one can see that all of the components of this graph are complete.

Example 2:
Input: n = 6, edges = [[0,1],[0,2],[1,2],[3,4],[3,5]]
Output: 1
Explanation: The component containing vertices 0, 1, and 2 is complete since there is an edge between every pair of two vertices. On the other hand, the component containing vertices 3, 4, and 5 is not complete since there is no edge between vertices 4 and 5. Thus, the number of complete components in this graph is 1.
*/

func countCompleteComponents(_ n: Int, _ edges: [[Int]]) -> Int {
    var outerList = [[Int]](repeating: [], count: n)
    for pair in edges {
        let first = pair[0]
        let second = pair[1]
        outerList[first].append(second)
        outerList[second].append(first)
    }

    let connectedComponentList = connectedComponents(outerList: outerList)
    var res = 0
    for vertices in connectedComponentList {
        if validateCompleteComponent(outerList: outerList, vertexList: vertices) {
            res += 1
        }
    }

    return res
}

func connectedComponents(outerList: [[Int]]) -> [[Int]] {
    var visited = Set<Int>()

    func findConnectedVertices(of node: Int, vertices: inout [Int]) {
        if visited.contains(node) {
            return
        } else {
            visited.insert(node)
            vertices.append(node)
        }
        for neighbor in outerList[node] {
            if !visited.contains(neighbor) {
                findConnectedVertices(of: neighbor, vertices: &vertices)
            }
        }
    }

    var connectedComponentList = [[Int]]()
    for (index, _) in outerList.enumerated() {
        var res = [Int]()
        findConnectedVertices(of: index, vertices: &res)
        if !res.isEmpty {
            connectedComponentList.append(res)
        }
    }

    return connectedComponentList
}

func validateCompleteComponent(outerList: [[Int]], vertexList: [Int]) -> Bool {
    for vertex in vertexList {
        let neighbors = Set(vertexList.filter { $0 != vertex })
        if neighbors != Set(outerList[vertex]) {
            return false
        }
    }
    return true
}
