import Testing
@testable import CodingInterview

struct Problem35_6Tests {
    enum Scenario {
        case promptExample
        case emptyTree
        case singleNode
        case leftChainBecomesRightChain
    }

    @Test(
        "Problem 35.6 - invertTree",
        arguments: [
            Scenario.promptExample,
            Scenario.emptyTree,
            Scenario.singleNode,
            Scenario.leftChainBecomesRightChain
        ]
    )
    func testInvertTree(_ scenario: Scenario) {
        let (root, expected) = makeTrees(for: scenario)
        let got = invertTreeForOptionalRoot(root)

        #expect(sameValues(got, expected))
    }

    private func makeTrees(for scenario: Scenario) -> (root: TreeNode<Int>?, expected: TreeNode<Int>?) {
        switch scenario {
        case .promptExample:
            let root = node(
                1,
                left: node(
                    6,
                    left: node(
                        4,
                        right: node(5)
                    ),
                    right: node(11)
                ),
                right: node(
                    7,
                    left: node(
                        2,
                        right: node(9)
                    )
                )
            )

            let expected = node(1)
            expected.left = node(7)
            expected.right = node(6)
            expected.left?.right = node(2)
            expected.left?.right?.left = node(9)
            expected.right?.left = node(11)
            expected.right?.right = node(4)
            expected.right?.right?.left = node(5)
            return (root, expected)

        case .emptyTree:
            return (nil, nil)

        case .singleNode:
            return (node(1), node(1))

        case .leftChainBecomesRightChain:
            let root = node(
                1,
                left: node(
                    2,
                    left: node(3)
                )
            )
            let expected = node(
                1,
                right: node(
                    2,
                    right: node(3)
                )
            )
            return (root, expected)
        }
    }

    private func invertTreeForOptionalRoot(_ root: TreeNode<Int>?) -> TreeNode<Int>? {
        guard let root else { return nil }
        return invertTree(root: root)
    }

    private func sameValues(_ lhs: TreeNode<Int>?, _ rhs: TreeNode<Int>?) -> Bool {
        switch (lhs, rhs) {
        case (nil, nil):
            return true
        case let (.some(lhsNode), .some(rhsNode)):
            return lhsNode.value == rhsNode.value
                && sameValues(lhsNode.left, rhsNode.left)
                && sameValues(lhsNode.right, rhsNode.right)
        default:
            return false
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
