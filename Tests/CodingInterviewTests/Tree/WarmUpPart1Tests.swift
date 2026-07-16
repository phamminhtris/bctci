import Testing
@testable import CodingInterview

struct WarmUpPart1Tests {
    @Test("WarmUp Part 1 - isLeaf")
    func testIsLeaf() {
        let leaf = TreeNode(val: 4)
        let parent = TreeNode(val: 2, left: leaf)

        #expect(leaf.isLeaf)
        #expect(parent.isLeaf == false)
    }

    @Test("WarmUp Part 1 - childrenAsArray")
    func testChildrenAsArray() {
        let leaf = TreeNode(val: 10)
        let leftOnly = TreeNode(val: 1, left: TreeNode(val: 2))
        let rightOnly = TreeNode(val: 1, right: TreeNode(val: 3))
        let both = TreeNode(
            val: 1,
            left: TreeNode(val: 2),
            right: TreeNode(val: 3)
        )

        #expect(leaf.childrenAsArray() == [])
        #expect(leftOnly.childrenAsArray() == [2])
        #expect(rightOnly.childrenAsArray() == [3])
        #expect(both.childrenAsArray() == [2, 3])
    }

    @Test("WarmUp Part 1 - grandchildrenAsArray")
    func testGrandchildrenAsArray() {
        let node4 = TreeNode(val: 4)
        let node5 = TreeNode(val: 5)
        let node6 = TreeNode(val: 6)
        let node2 = TreeNode(val: 2, left: node4, right: node5)
        let node3 = TreeNode(val: 3, left: node6)
        let root = TreeNode(val: 1, left: node2, right: node3)

        let onlyLeftGrandchildren = TreeNode(
            val: 10,
            left: TreeNode(val: 20, left: TreeNode(val: 30), right: TreeNode(val: 31))
        )

        #expect(root.grandchildrenAsArray() == [4, 5, 6])
        #expect(onlyLeftGrandchildren.grandchildrenAsArray() == [30, 31])
        #expect(node4.grandchildrenAsArray() == [])
    }

    @Test("WarmUp Part 1 - sizeOfSubtree")
    func testSizeOfSubtree() {
        let node4 = TreeNode(val: 4)
        let node5 = TreeNode(val: 5)
        let node6 = TreeNode(val: 6)
        let node2 = TreeNode(val: 2, left: node4, right: node5)
        let node3 = TreeNode(val: 3, left: node6)
        let root = TreeNode(val: 1, left: node2, right: node3)

        #expect(root.sizeOfSubtree() == 6)
        #expect(node2.sizeOfSubtree() == 3)
        #expect(node6.sizeOfSubtree() == 1)
    }

    @Test("WarmUp Part 1 - heightOfSubTree")
    func testHeightOfSubTree() {
        let leaf = TreeNode(val: 9)

        let shallow = TreeNode(
            val: 1,
            left: TreeNode(val: 2),
            right: TreeNode(val: 3)
        )

        let deep = TreeNode(
            val: 1,
            left: TreeNode(
                val: 2,
                left: TreeNode(
                    val: 4,
                    left: TreeNode(val: 8)
                )
            ),
            right: TreeNode(val: 3)
        )

        #expect(leaf.heightOfSubTree() == 0)
        #expect(shallow.heightOfSubTree() == 1)
        #expect(deep.heightOfSubTree() == 3)
    }
}
