/**
Given a binary tree, we say a node is aligned if its value is equal to its depth (distance from root). A descendant chain is a sequence of nodes where each node is the parent of the next node. Return the length of the longest descendant chain of aligned nodes. The chain does not need to start at the root.

Example:
                7
               / \
              1   3
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

The longest descendant chain of aligned nodes is 1 -> 2 -> 3 on the left
subtree.

*/

func alignedChain(root: TreeNode<Int>) -> Int {
  var maxChain = 0
  _ = visit(node: root, level: 0, currentMax: &maxChain)
  
  return maxChain
}

func visit(node: TreeNode<Int>?, level: Int, currentMax: inout Int) -> Int {
  guard let node else { return 0 }

  let chainLeft = visit(node: node.left, level: level + 1, currentMax: &currentMax)
  let chainRight = visit(node: node.right, level: level + 1, currentMax: &currentMax)
  
  if node.value == level {
    let maxChain = 1 + max(chainLeft, chainRight)
    currentMax = max(maxChain, currentMax)
    return maxChain
  } else {
    return 0
  }
}

