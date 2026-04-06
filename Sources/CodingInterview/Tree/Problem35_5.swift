/**
Given the root of a binary tree, return the number of triangles. A triangle is a set of three distinct nodes, a, b, and c, where:

a is the lowest common ancestor of b and c.
b and c have the same depth.
the path from a to b only consists of left children (the nodes in the path can have right children).
the path from a to c only consists of right children (the nodes in the path can have left children).

Example 1:
         0
     /       \
    1         2
     \       / \
      3     4   5
     / \   /     \
    6   7 8       9

Output: 4.
The triangles are: (0, 1, 2), (3, 6, 7), (2, 4, 5), (2, 8, 9).

Example 2:
      0
   /      \
  1        4
 /  \       \
2    3       5
Output: 3.
The triangles are: (0, 1, 4), (1, 2, 3), (0, 2, 5).
*/

private struct TriangleResult {
    let leftEdge: Int
    let rightEdge: Int 
    let triangle: Int
}

func triangleCount(root: TreeNode<Int>?) -> Int {
    guard let root else { return 0 }
    return triangleCountHelper(root: root).triangle
}

private func triangleCountHelper(root: TreeNode<Int>) -> TriangleResult {
    var totalCount = 0
    var leftCount = 0
    if let left = root.left {
        let leftResult = triangleCountHelper(root: left)
        leftCount = 1 + leftResult.leftEdge
        totalCount += leftResult.triangle
    }
    var rightCount = 0
    if let right = root.right {
        let rightResult = triangleCountHelper(root: right)
        rightCount = 1 + rightResult.rightEdge
        totalCount += rightResult.triangle
    }

    totalCount = totalCount + min(leftCount, rightCount)

    return TriangleResult(leftEdge: leftCount, rightEdge: rightCount, triangle: totalCount)

}

