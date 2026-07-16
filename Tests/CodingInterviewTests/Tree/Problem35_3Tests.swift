import Testing
@testable import CodingInterview

struct Problem35_3Tests {
    enum Scenario {
        case promptExample
        case variation1
        case variation2
        case variation3
        case emptyTree
        case singleAlignedNode
        case singleUnalignedNode
        case pathThroughRoot
        case noAlignedNodes
        case snippetTest7
    }

    struct TestInput {
        let scenario: Scenario
        let expected: Int
    }

    @Test(
        "Problem 35.3 - alignedPath",
        arguments: [
            TestInput(scenario: .promptExample, expected: 3),
            TestInput(scenario: .variation1, expected: 3),
            TestInput(scenario: .variation2, expected: 3),
            TestInput(scenario: .variation3, expected: 1),
            TestInput(scenario: .emptyTree, expected: 0),
            TestInput(scenario: .singleAlignedNode, expected: 1),
            TestInput(scenario: .singleUnalignedNode, expected: 0),
            TestInput(scenario: .pathThroughRoot, expected: 3),
            TestInput(scenario: .noAlignedNodes, expected: 0),
            TestInput(scenario: .snippetTest7, expected: 4)
        ]
    )
    func testAlignedPath(_ testCase: TestInput) {
        #expect(alignedPathForOptionalRoot(makeTree(for: testCase.scenario)) == testCase.expected)
    }

    private func alignedPathForOptionalRoot(_ root: TreeNode<Int>?) -> Int {
        guard let root else { return 0 }
        return alignedPath(root: root)
    }

    private func makeTree(for scenario: Scenario) -> TreeNode<Int>? {
        switch scenario {
        case .promptExample:
            return node(
                7,
                left: node(
                    1,
                    left: node(2, left: node(4), right: node(3)),
                    right: node(8)
                ),
                right: node(
                    3,
                    left: node(2, left: node(3), right: node(3))
                )
            )

        case .variation1:
            return node(
                7,
                left: node(
                    1,
                    left: node(20, left: node(4), right: node(3)),
                    right: node(8)
                ),
                right: node(
                    3,
                    left: node(2, left: node(3), right: node(3))
                )
            )

        case .variation2:
            return node(
                7,
                left: node(
                    1,
                    left: node(2, left: node(4), right: node(3)),
                    right: node(8)
                ),
                right: node(
                    3,
                    left: node(20, left: node(3), right: node(3))
                )
            )

        case .variation3:
            return node(
                7,
                left: node(
                    1,
                    left: node(20, left: node(4), right: node(3)),
                    right: node(8)
                ),
                right: node(
                    3,
                    left: node(20, left: node(3), right: node(3))
                )
            )

        case .emptyTree:
            return nil

        case .singleAlignedNode:
            return node(0)

        case .singleUnalignedNode:
            return node(1)

        case .pathThroughRoot:
            return node(0, left: node(1), right: node(1))

        case .noAlignedNodes:
            return node(5, left: node(4), right: node(2))

        case .snippetTest7:
            return node(
                0,
                left: node(1, left: node(2), right: node(2)),
                right: node(1)
            )
        }
    }

    private func node(
        _ value: Int,
        left: TreeNode<Int>? = nil,
        right: TreeNode<Int>? = nil
    ) -> TreeNode<Int> {
        TreeNode(val: value, left: left, right: right)
    }
}
