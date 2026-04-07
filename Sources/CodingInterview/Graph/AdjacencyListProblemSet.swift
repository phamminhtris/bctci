import Foundation

final class AdjGraph {
    var outerList: [[Int]]

    init(list: [[Int]]) {
        self.outerList = list
    }

    init(numVertex: Int, edges: [[Int]]) {
        self.outerList = Array<[Int]>(repeating: [], count: numVertex)
        for edge in edges {
            assert(edge.count == 2)
            let vertex1 = edge[0] 
            let vertex2 = edge[1]
            outerList[vertex1].append(vertex2)
            outerList[vertex2].append(vertex1)
        }
    }

    var numNodes: Int { outerList.count }

    var numEdges: Int { outerList.reduce(0) { $0 + $1.count } / 2 }

    func degree(of v: Int) -> Int { 
        precondition(v < outerList.count)
        return outerList[v].count
    }

    func printNeighbor(of v: Int) {
        precondition(v < outerList.count)

        let neighbors = outerList[v]
        neighbors.forEach { 
            print($0)
        }
    }
}
