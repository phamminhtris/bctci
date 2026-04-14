import Testing
@testable import CodingInterview

struct Problem36_2Tests {
    struct TestInput {
        let list: [[Int]]
        let node1: Int
        let node2: Int
        let expectedHasPath: Bool
    }

    @Test(
        "Problem 36.2 - simple path between two nodes",
        arguments: [
            TestInput(
                list: [
                    [1],
                    [0, 2, 5, 4],
                    [1, 4, 5],
                    [],
                    [5, 2, 1],
                    [1, 2, 4]
                ],
                node1: 0,
                node2: 4,
                expectedHasPath: true
            ),
            TestInput(
                list: [
                    [1],
                    [0, 2, 5, 4],
                    [1, 4, 5],
                    [],
                    [5, 2, 1],
                    [1, 2, 4]
                ],
                node1: 0,
                node2: 3,
                expectedHasPath: false
            ),
            TestInput(
                list: [
                    [1],
                    [0, 2],
                    [1]
                ],
                node1: 0,
                node2: 2,
                expectedHasPath: true
            ),
            TestInput(
                list: [
                    [1, 2],
                    [0, 3],
                    [0, 3],
                    [1, 2]
                ],
                node1: 0,
                node2: 3,
                expectedHasPath: true
            ),
            TestInput(
                list: [
                    [1],
                    [0],
                    [3],
                    [2]
                ],
                node1: 0,
                node2: 3,
                expectedHasPath: false
            )
        ]
    )
    func testSimplePath(_ testCase: TestInput) {
        let graph = AdjGraph(list: testCase.list)
        guard graph.validate() else {
            Issue.record("Invalid undirected graph fixture: \(testCase.list)")
            return
        }

        guard (0..<graph.numNodes).contains(testCase.node1),
              (0..<graph.numNodes).contains(testCase.node2) else {
            Issue.record(
                """
                Node indices are out of bounds for graph size \(graph.numNodes).
                node1=\(testCase.node1), node2=\(testCase.node2)
                """
            )
            return
        }

        guard testCase.node1 != testCase.node2 else {
            Issue.record("Test fixture must use distinct nodes. Both were \(testCase.node1).")
            return
        }

        let oracleHasPath = hasAnyPath(in: graph, from: testCase.node1, to: testCase.node2)
        guard oracleHasPath == testCase.expectedHasPath else {
            Issue.record(
                """
                Fixture expectation mismatch: expectedHasPath=\(testCase.expectedHasPath)
                but connectivity oracle says \(oracleHasPath).
                """
            )
            return
        }

        let path = graph.simplePath(from: testCase.node1, to: testCase.node2)

        if testCase.expectedHasPath {
            let errors = simplePathValidationErrors(
                path,
                in: graph,
                from: testCase.node1,
                to: testCase.node2
            )
            if !errors.isEmpty {
                Issue.record(
                    """
                    Expected a valid simple path from \(testCase.node1) to \(testCase.node2), got \(path).
                    Problems: \(errors.joined(separator: " | "))
                    """
                )
            }
        } else {
            if !path.isEmpty {
                Issue.record(
                    """
                    Expected no path from \(testCase.node1) to \(testCase.node2), but got \(path).
                    """
                )
            }
        }
    }

    private func hasAnyPath(in graph: AdjGraph, from start: Int, to end: Int) -> Bool {
        if start == end {
            return true
        }

        var visited: Set<Int> = [start]
        var queue = [start]
        var head = 0

        while head < queue.count {
            let current = queue[head]
            head += 1

            for neighbor in graph.outerList[current] where !visited.contains(neighbor) {
                if neighbor == end {
                    return true
                }
                visited.insert(neighbor)
                queue.append(neighbor)
            }
        }

        return false
    }

    private func simplePathValidationErrors(
        _ path: [Int],
        in graph: AdjGraph,
        from start: Int,
        to end: Int
    ) -> [String] {
        var errors = [String]()
        guard !path.isEmpty else {
            return ["path is empty"]
        }

        if path.first != start {
            errors.append("first node must be \(start), got \(String(describing: path.first))")
        }
        if path.last != end {
            errors.append("last node must be \(end), got \(String(describing: path.last))")
        }

        var seen = Set<Int>()
        for (index, node) in path.enumerated() {
            if node < 0 || node >= graph.numNodes {
                errors.append("path[\(index)] = \(node) is out of bounds for graph size \(graph.numNodes)")
                continue
            }

            if !seen.insert(node).inserted {
                errors.append("node \(node) repeats at index \(index)")
            }
        }

        if path.count >= 2 {
            for i in 0..<(path.count - 1) {
                let current = path[i]
                let next = path[i + 1]
                if current < 0 || current >= graph.numNodes || next < 0 || next >= graph.numNodes {
                    continue
                }
                if !graph.outerList[current].contains(next) {
                    errors.append("missing edge for step \(current) -> \(next) at indices \(i)->\(i + 1)")
                }
            }
        }

        return errors
    }
}
