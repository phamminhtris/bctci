/**
Given a pointer to a specific node in a tree, node, that might be null, and might or might not be the root, implement the following functions:
a. Return whether it is a leaf.
b. Return the values of its children as an array of length at most 2.
c. Return the values of its grandchildren as an array of length at most 4.
d. Return the size of the node's subtree. A node's subtree includes itself and all of its descendants.
e. Return the height of its subtree.
*/

extension TreeNode {
    var isLeaf: Bool {
        return left == nil && right == nil
    }

    func childrenAsArray() -> [T] {
        [left, right].compactMap { $0 }.map { $0.value }
    }

    func grandchildrenAsArray() -> [T] {
        let leftGrand = left?.childrenAsArray() ?? []
        let rightGrand = right?.childrenAsArray() ?? []
        return leftGrand + rightGrand
    }

    func sizeOfSubtree() -> Int {
        var count = 1
        if let left {
            count += left.sizeOfSubtree()
        }
        if let right {
            count += right.sizeOfSubtree()
        }
        return count
    }

    func heightOfSubTree() -> Int {
        func heightOfSubTree(node: TreeNode<T>?) -> Int {
            guard let node else {
                return -1
            }

            return 1 + max(
                heightOfSubTree(node: node.left),
                heightOfSubTree(node: node.right)
            )
        }

        return heightOfSubTree(node: self)
    }
}
