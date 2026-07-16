import Testing
@testable import CodingInterview

struct Problem35_4Tests {
    enum Scenario {
        case root2SingleNode
        case root3TwoLevels
        case root4Depth4
    }

    struct TestInput {
        let scenario: Scenario
        let expected: Int
    }

    @Test(
        "Problem 35.4 - treeLayout",
        arguments: [
            TestInput(scenario: .root2SingleNode, expected: 1),
            TestInput(scenario: .root3TwoLevels, expected: 1),
            TestInput(scenario: .root4Depth4, expected: 4)
        ]
    )
    func testTreeLayout(_ testCase: TestInput) {
        #expect(treeLayout(root: makeTree(for: testCase.scenario)) == testCase.expected)
    }

    private func makeTree(for scenario: Scenario) -> TreeNode<Int> {
        switch scenario {
        case .root2SingleNode:
            return node(1)

        case .root3TwoLevels:
            return node(
                1,
                left: node(2),
                right: node(3)
            )

        case .root4Depth4:
            return node(
                1,
                left: node(
                    2,
                    left: node(
                        4,
                        left: node(8),
                        right: node(9, right: node(16))
                    ),
                    right: node(
                        5,
                        left: node(10, right: node(17)),
                        right: node(11, left: node(18))
                    )
                ),
                right: node(
                    3,
                    left: node(
                        6,
                        left: node(12),
                        right: node(13)
                    ),
                    right: node(
                        7,
                        left: node(14, left: node(19)),
                        right: node(15, left: node(20))
                    )
                )
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
