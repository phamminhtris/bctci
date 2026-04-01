import Foundation 

final class TreeNode<T: Equatable> {
    var value: T
    var left: TreeNode<T>?
    var right: TreeNode<T>?


    init(val: T, left: TreeNode<T>? = nil, right: TreeNode<T>? = nil) {
        self.value = val
        self.left = left
        self.right = right
    }
}