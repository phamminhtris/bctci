import Testing
@testable import CodingInterview

struct Problem35_1Tests {
    enum Scenario {
        case promptExample
        case noAlignedNodes
        case chainStartsBelowRoot
        case misalignedNodeBreaksChain
        case singleAlignedRoot
        case allAlignedOnRightSpine
        case deepestOfCompetingChains
        case singleAlignedLeafOnly
        case twoEqualBestChains
        case rootAlignedChildrenMisaligned
    }

    struct TestInput {
        let scenario: Scenario
        let expected: Int
    }

    @Test(
        "Problem 35.1 - alignedChain",
        arguments: [
            TestInput(scenario: .promptExample, expected: 3),
            TestInput(scenario: .noAlignedNodes, expected: 0),
            TestInput(scenario: .chainStartsBelowRoot, expected: 3),
            TestInput(scenario: .misalignedNodeBreaksChain, expected: 2),
            TestInput(scenario: .singleAlignedRoot, expected: 1),
            TestInput(scenario: .allAlignedOnRightSpine, expected: 5),
            TestInput(scenario: .deepestOfCompetingChains, expected: 4),
            TestInput(scenario: .singleAlignedLeafOnly, expected: 1),
            TestInput(scenario: .twoEqualBestChains, expected: 3),
            TestInput(scenario: .rootAlignedChildrenMisaligned, expected: 1)
        ]
    )
    func testAlignedChain(_ testCase: TestInput) {
        let root = makeTree(for: testCase.scenario)

        #expect(alignedChain(root: root) == testCase.expected)
    }

    private func makeTree(for scenario: Scenario) -> TreeNode<Int> {
        switch scenario {
        case .promptExample:
            /*
             Level
             L0            7
                          / \
             L1        (1)   3
                       / \    \
             L2      (2)  8   (2)
                     / \      / \
             L3     4 (3)   (3) (3)
             Best aligned chain length = 3
             */
            let node4 = TreeNode(val: 4)
            let node3Left = TreeNode(val: 3)
            let node3RightLeft = TreeNode(val: 3)
            let node3RightRight = TreeNode(val: 3)
            let node2Left = TreeNode(val: 2, left: node4, right: node3Left)
            let node8 = TreeNode(val: 8)
            let node2Right = TreeNode(val: 2, left: node3RightLeft, right: node3RightRight)
            let node1 = TreeNode(val: 1, left: node2Left, right: node8)
            let node3 = TreeNode(val: 3, right: node2Right)
            return TreeNode(val: 7, left: node1, right: node3)

        case .noAlignedNodes:
            /*
             L0        5
                      / \
             L1      9   4
                    /
             L2    6
             No node matches its depth.
             */
            let left = TreeNode(val: 9, left: TreeNode(val: 6))
            let right = TreeNode(val: 4)
            return TreeNode(val: 5, left: left, right: right)

        case .chainStartsBelowRoot:
            /*
             L0         9
                       / \
             L1      (1) 10
                     /
             L2    (2)
                   /
             L3  (3)
             Root is misaligned; best chain starts at depth 1.
             */
            let node3 = TreeNode(val: 3)
            let node2 = TreeNode(val: 2, left: node3)
            let node1 = TreeNode(val: 1, left: node2)
            return TreeNode(val: 9, left: node1, right: TreeNode(val: 10))

        case .misalignedNodeBreaksChain:
            /*
             L0      (0)
                     /
             L1    (1)
                   /
             L2    9   <- mismatch breaks chain
                   /
             L3  (3)
                 /
             L4 (4)
             Longest contiguous aligned chain length = 2.
             */
            let node4 = TreeNode(val: 4)
            let node3 = TreeNode(val: 3, left: node4)
            let node9 = TreeNode(val: 9, left: node3)
            let node1 = TreeNode(val: 1, left: node9)
            return TreeNode(val: 0, left: node1)

        case .singleAlignedRoot:
            /*
             L0  (0)
             */
            return TreeNode(val: 0)

        case .allAlignedOnRightSpine:
            /*
             L0  (0)
                   \
             L1    (1)
                     \
             L2      (2)
                       \
             L3        (3)
                           \
             L4            (4)
             */
            let node4 = TreeNode(val: 4)
            let node3 = TreeNode(val: 3, right: node4)
            let node2 = TreeNode(val: 2, right: node3)
            let node1 = TreeNode(val: 1, right: node2)
            return TreeNode(val: 0, right: node1)

        case .deepestOfCompetingChains:
            /*
             L0            8
                         /   \
             L1       (1)   (1)
                      /       \
             L2     (2)       (2)
                    /           \
             L3   (3)            9
                  /
             L4 (4)
             Left chain length 4 beats right chain length 2.
             */
            let left4 = TreeNode(val: 4)
            let left3 = TreeNode(val: 3, left: left4)
            let left2 = TreeNode(val: 2, left: left3)
            let left1 = TreeNode(val: 1, left: left2)

            let right2 = TreeNode(val: 2, right: TreeNode(val: 9))
            let right1 = TreeNode(val: 1, right: right2)
            return TreeNode(val: 8, left: left1, right: right1)

        case .singleAlignedLeafOnly:
            /*
             L0         9
                       /
             L1       8
                     /
             L2     7
                   /
             L3   (3)
             Only one aligned node exists, so best length is 1.
             */
            let leaf = TreeNode(val: 3)
            let node7 = TreeNode(val: 7, left: leaf)
            let node8 = TreeNode(val: 8, left: node7)
            return TreeNode(val: 9, left: node8)

        case .twoEqualBestChains:
            /*
             L0            7
                         /   \
             L1       (1)   (1)
                      /       \
             L2     (2)       (2)
                    /           \
             L3   (3)           (3)
             Two equal best chains, each length 3.
             */
            let left = TreeNode(val: 1, left: TreeNode(val: 2, left: TreeNode(val: 3)))
            let right = TreeNode(val: 1, right: TreeNode(val: 2, right: TreeNode(val: 3)))
            return TreeNode(val: 7, left: left, right: right)

        case .rootAlignedChildrenMisaligned:
            /*
             L0    (0)
                   / \
             L1   9   9
                    /
             L2    8
             Root is aligned but no aligned child at depth 1.
             */
            let right = TreeNode(val: 9, left: TreeNode(val: 8))
            return TreeNode(val: 0, left: TreeNode(val: 9), right: right)
        }
    }
}
