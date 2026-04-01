import Foundation

final class BiTreeNode<T: Equatable> {
    let id: Int
    weak var parent: BiTreeNode<T>?
    var left: BiTreeNode<T>?
    var right: BiTreeNode<T>?

    init(
        id: Int,
        parent: BiTreeNode<T>? = nil,
        left: BiTreeNode<T>? = nil,
        right: BiTreeNode<T>? = nil
    ) {
        self.id = id
        self.parent = parent
        self.left = left
        self.right = right

        self.left?.parent = self
        self.right?.parent = self
    }
}
