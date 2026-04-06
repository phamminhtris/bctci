import Testing
@testable import CodingInterview

struct Problem35_5Tests {
    enum Scenario {
        case promptExample1
        case promptExample2
        case singleNode
        case oneSidedLeftChain
        case rootOnlyOneLevelMatch
        case unevenChainsUsesShortestSide
        case perfectDepth2CountsAcrossAncestors
        case sideBranchesDoNotBreakDirectionalPaths
    }

    struct TestInput {
        let scenario: Scenario
        let expected: Int
    }

    @Test(
        "Problem 35.5 - triangleCount",
        arguments: [
            TestInput(scenario: .promptExample1, expected: 4),
            TestInput(scenario: .promptExample2, expected: 3),
            TestInput(scenario: .singleNode, expected: 0),
            TestInput(scenario: .oneSidedLeftChain, expected: 0),
            TestInput(scenario: .rootOnlyOneLevelMatch, expected: 1),
            TestInput(scenario: .unevenChainsUsesShortestSide, expected: 1),
            TestInput(scenario: .perfectDepth2CountsAcrossAncestors, expected: 4),
            TestInput(scenario: .sideBranchesDoNotBreakDirectionalPaths, expected: 4)
        ]
    )
    func testTriangleCount(_ testCase: TestInput) {
        #expect(triangleCount(root: makeTree(for: testCase.scenario)) == testCase.expected)
    }

    private func makeTree(for scenario: Scenario) -> TreeNode<Int> {
        switch scenario {
        case .promptExample1:
            return node(
                0,
                left: node(
                    1,
                    right: node(
                        3,
                        left: node(6),
                        right: node(7)
                    )
                ),
                right: node(
                    2,
                    left: node(
                        4,
                        left: node(8)
                    ),
                    right: node(
                        5,
                        right: node(9)
                    )
                )
            )

        case .promptExample2:
            return node(
                0,
                left: node(
                    1,
                    left: node(2),
                    right: node(3)
                ),
                right: node(
                    4,
                    right: node(5)
                )
            )

        case .singleNode:
            return node(0)

        case .oneSidedLeftChain:
            return node(
                0,
                left: node(
                    1,
                    left: node(
                        2,
                        left: node(3)
                    )
                )
            )

        case .rootOnlyOneLevelMatch:
            return node(
                0,
                left: node(1),
                right: node(2)
            )

        case .unevenChainsUsesShortestSide:
            return node(
                0,
                left: node(
                    1,
                    left: node(
                        3,
                        left: node(4)
                    )
                ),
                right: node(2)
            )

        case .perfectDepth2CountsAcrossAncestors:
            return node(
                0,
                left: node(
                    1,
                    left: node(3),
                    right: node(4)
                ),
                right: node(
                    2,
                    left: node(5),
                    right: node(6)
                )
            )

        case .sideBranchesDoNotBreakDirectionalPaths:
            return node(
                0,
                left: node(
                    1,
                    left: node(3, right: node(9)),
                    right: node(5)
                ),
                right: node(
                    2,
                    left: node(6),
                    right: node(4, left: node(8))
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
