/**
You are given the root of a non-empty binary tree. We lay out the tree on a grid as follows:

We put the root at (r, c) = (0, 0)
We recursively lay out the left subtree one unit below the root (increasing r by one)
We recursively lay out the right subtree one unit to the root's right (increasing c by one)
For instance, the left child of the root goes on (1, 0) and the right child goes on (0, 1).

Two nodes are stacked if they are laid on the same (r, c) coordinates. For instance, root.left.right and root.right.left would overlap at (1, 1).

Return the maximum number of nodes stacked on the same coordinate.

Example:

Input:
         1
       /   \
     2       3
   /  \     /
  4    5   6
   \      / \
    7    8   9

Output: 2
The layout looks like this:

1 -- 3
|    |
2 - 5,6 - 9
|    |
4 - 7,8

The most stacked nodes are 5,6 or 7,8.
*/

func treeLayout(root: TreeNode<Int>) -> Int {
    var stackMap = [Coordinate: Int]()
    treeLayout(root: root, coordinate: .init(r: 0, c: 0), stackMap: &stackMap)

    return stackMap.values.max() ?? 0
}

private struct Coordinate: Hashable {
  let r: Int
  let c: Int
}

private func treeLayout(root: TreeNode<Int>?, coordinate: Coordinate, stackMap: inout Dictionary<Coordinate, Int>) {
  guard let root else { return }

  stackMap[coordinate, default: 0] += 1
  treeLayout(root: root.left, coordinate: .init(r: coordinate.r + 1, c: coordinate.c), stackMap: &stackMap)
  treeLayout(root: root.right, coordinate: .init(r: coordinate.r, c: coordinate.c + 1), stackMap: &stackMap)
}
