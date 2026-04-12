import Foundation

final class AdjGraph {
    var outerList: [[Int]]

    init(list: [[Int]]) {
        self.outerList = list
    }

    init(numVertex: Int, edges: [[Int]]) {
        precondition(numVertex >= 0, "numVertex must be non-negative.")
        self.outerList = Array<[Int]>(repeating: [], count: numVertex)

        for edge in edges {
            precondition(edge.count == 2, "Each edge must contain exactly two vertices.")

            let vertex1 = edge[0]
            let vertex2 = edge[1]

            precondition(
                vertex1 >= 0 && vertex1 < numVertex && vertex2 >= 0 && vertex2 < numVertex,
                "Edge contains vertex out of bounds."
            )

            outerList[vertex1].append(vertex2)
            outerList[vertex2].append(vertex1)
        }
    }

    var numNodes: Int { outerList.count }

    var numEdges: Int { outerList.reduce(0) { $0 + $1.count } / 2 }

    func degree(of v: Int) -> Int {
        precondition(v >= 0 && v < outerList.count, "Vertex index out of bounds.")
        return outerList[v].count
    }

    func printNeighbor(of v: Int) {
        precondition(v >= 0 && v < outerList.count, "Vertex index out of bounds.")

        let neighbors = outerList[v]
        neighbors.forEach {
            print($0)
        }
    }
}
