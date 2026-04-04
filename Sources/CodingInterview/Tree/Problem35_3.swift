/**
Given a binary tree, we say a node is aligned if its value is equal to its depth (distance from root). Return the length of the longest path of aligned nodes. A path can start and end at any node.


Example:
                7
               / \
              1   4
             / \   \
            2   8   2
           / \     / \
          4   3   3   3

Output: 3
The aligned nodes are the circled ones:
Depth
  0             7
               / \
  1          (1)   3
             / \   \
  2        (2)  8  (2)
           / \     / \
  3       4  (3) (3) (3)

There are two paths of aligned nodes with maximum length: 1 -> 2 -> 3 on the
left subtree, and 3 -> 2 -> 3 on the right subtree.
*/

func alignedPath(root: TreeNode<Int>) -> Int {
    var currentMax = 0
    let rootChain = visitPath(root: root, level: 0, currentMax: &currentMax)

    return max(currentMax, rootChain)
}

func visitPath(root: TreeNode<Int>?, level: Int, currentMax: inout Int) -> Int {
    guard let root else { return 0 }
    let currentLeftChain = visitPath(root: root.left, level: level + 1, currentMax: &currentMax)
    let currentRightChain = visitPath(root: root.right, level: level + 1, currentMax: &currentMax)

    if root.value == level { 
        let currentChain = 1 + currentLeftChain + currentRightChain
        currentMax = max(currentChain, currentMax)
        return 1 + max(currentLeftChain, currentRightChain)
    } else {
        return 0
    }
}