import Testing
@testable import CodingInterview

struct Problem35_2Tests {
    enum Scenario {
        case promptExample
        case emptyTree
        case bOrderNodeLeftRight
        case iOrderLeftNodeRight
        case aOrderLeftRightNode
        case mixedOrdersDeepTree
        case sparseMixedTree
        case fullMixedTreeWithDigits
        case snippetSingleBefore
        case snippetSingleIn
        case snippetSingleAfter
        case snippetAllBefore
        case snippetAllIn
        case snippetAllAfter
        case snippetMixedHello
        case snippetInvalidFirstCharacter
        case snippetTextTooShort
        case snippetTextTooLong
    }

    struct TestInput {
        let scenario: Scenario
        let expected: String
    }

    @Test(
        "Problem 35.2 - hiddenMessage",
        arguments: [
            TestInput(scenario: .promptExample, expected: "nice_try!"),
            TestInput(scenario: .emptyTree, expected: ""),
            TestInput(scenario: .bOrderNodeLeftRight, expected: "xyz"),
            TestInput(scenario: .iOrderLeftNodeRight, expected: "yxz"),
            TestInput(scenario: .aOrderLeftRightNode, expected: "yzx"),
            TestInput(scenario: .mixedOrdersDeepTree, expected: "AFBGHCMDIEJZ"),
            TestInput(scenario: .sparseMixedTree, expected: "QVXTSUWR"),
            TestInput(scenario: .fullMixedTreeWithDigits, expected: "0374152689"),
            TestInput(scenario: .snippetSingleBefore, expected: "x"),
            TestInput(scenario: .snippetSingleIn, expected: "x"),
            TestInput(scenario: .snippetSingleAfter, expected: "x"),
            TestInput(scenario: .snippetAllBefore, expected: "1245367"),
            TestInput(scenario: .snippetAllIn, expected: "4251637"),
            TestInput(scenario: .snippetAllAfter, expected: "4526731"),
            TestInput(scenario: .snippetMixedHello, expected: "hello"),
            TestInput(scenario: .snippetInvalidFirstCharacter, expected: "x"),
            TestInput(scenario: .snippetTextTooShort, expected: ""),
            TestInput(scenario: .snippetTextTooLong, expected: "x")
        ]
    )
    func testHiddenMessage(_ testCase: TestInput) {
        #expect(hiddenMessage(root: makeTree(for: testCase.scenario)) == testCase.expected)
    }

    private func makeTree(for scenario: Scenario) -> TreeNode<String>? {
        switch scenario {
        case .promptExample:
            /*
                     bn
                   /    \
                 i_      a!
                /  \     /
              ae    it  br
             /  \         \
           bi    bc        ay
             */
            return node(
                "bn",
                left: node(
                    "i_",
                    left: node(
                        "ae",
                        left: node("bi"),
                        right: node("bc")
                    ),
                    right: node("it")
                ),
                right: node(
                    "a!",
                    left: node(
                        "br",
                        right: node("ay")
                    )
                )
            )

        case .emptyTree:
            return nil

        case .bOrderNodeLeftRight:
            // b: node, left, right
            return node("bx", left: node("by"), right: node("bz"))

        case .iOrderLeftNodeRight:
            // i: left, node, right
            return node("ix", left: node("by"), right: node("bz"))

        case .aOrderLeftRightNode:
            // a: left, right, node
            return node("ax", left: node("by"), right: node("bz"))

        case .mixedOrdersDeepTree:
            /*
                           iM
                         /    \
                       bA      aZ
                      /  \    /  \
                    iB   aC bD   iE
                    / \    \  \    \
                  bF  bG   iH aI   bJ
             Expected: AFBGHCMDIEJZ
             */
            return node(
                "iM",
                left: node(
                    "bA",
                    left: node("iB", left: node("bF"), right: node("bG")),
                    right: node("aC", right: node("iH"))
                ),
                right: node(
                    "aZ",
                    left: node("bD", right: node("aI")),
                    right: node("iE", right: node("bJ"))
                )
            )

        case .sparseMixedTree:
            /*
                        aR
                       /
                     bQ
                       \
                       iS
                      /  \
                    aT    bU
                   /      /
                 iV     aW
                  \
                  bX
             Expected: QVXTSUWR
             */
            return node(
                "aR",
                left: node(
                    "bQ",
                    right: node(
                        "iS",
                        left: node(
                            "aT",
                            left: node("iV", right: node("bX"))
                        ),
                        right: node(
                            "bU",
                            left: node("aW")
                        )
                    )
                )
            )

        case .fullMixedTreeWithDigits:
            /*
                           b0
                         /    \
                       a1      i2
                      /  \    /  \
                    b3   i4  a5   b6
                        /        /  \
                      b7       i8   a9
             Expected: 0374152689
             */
            return node(
                "b0",
                left: node(
                    "a1",
                    left: node("b3"),
                    right: node("i4", left: node("b7"))
                ),
                right: node(
                    "i2",
                    left: node("a5"),
                    right: node(
                        "b6",
                        left: node("i8"),
                        right: node("a9")
                    )
                )
            )

        case .snippetSingleBefore:
            return node("bx")

        case .snippetSingleIn:
            return node("ix")

        case .snippetSingleAfter:
            return node("ax")

        case .snippetAllBefore:
            return node(
                "b1",
                left: node("b2", left: node("b4"), right: node("b5")),
                right: node("b3", left: node("b6"), right: node("b7"))
            )

        case .snippetAllIn:
            return node(
                "i1",
                left: node("i2", left: node("i4"), right: node("i5")),
                right: node("i3", left: node("i6"), right: node("i7"))
            )

        case .snippetAllAfter:
            return node(
                "a1",
                left: node("a2", left: node("a4"), right: node("a5")),
                right: node("a3", left: node("a6"), right: node("a7"))
            )

        case .snippetMixedHello:
            return node(
                "bh",
                left: node(
                    "be",
                    left: node("bl"),
                    right: node("il")
                ),
                right: node("ao")
            )

        case .snippetInvalidFirstCharacter:
            return node("cx")

        case .snippetTextTooShort:
            return node("i")

        case .snippetTextTooLong:
            return node("bxy")
        }
    }

    private func node(
        _ value: String,
        left: TreeNode<String>? = nil,
        right: TreeNode<String>? = nil
    ) -> TreeNode<String> {
        TreeNode(val: value, left: left, right: right)
    }
}
