import Foundation

/**
Implement a Stack class using a linked list implementation.
*/

final class Stack<T: Equatable> {
    private var list = DoublyLinkedList<T>()

    /// Adds a value v at the top of the stack.
    func push(_ value: T) {
        list.pushBack(v: value)
    }

    /// Removes and returns the value at the top of the stack.
    /// Returns nil when stack is empty.
    @discardableResult
    func pop() -> T? {
        list.popBack()
    }

    /// Returns the value at the top without removing it.
    /// Returns nil when stack is empty.
    func peek() -> T? {
        if let top = list.popBack() {
            list.pushBack(v: top)
            return top
        } else {
            return nil
        }
    }

    /// Returns the number of elements in the stack.
    func size() -> Int {
        list.count
    }

    /// Returns true when the stack has no elements.
    func empty() -> Bool {
        list.count == 0
    }
}
