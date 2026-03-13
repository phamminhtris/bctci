import Foundation

/**
push_front(v):
    Adds a node with value v at the beginning of the list.

pop_front():
    Removes the node at the beginning of the list and returns its value.
    If the list is empty, returns None.

push_back(v):
    Adds a node with value v at the end of the list.

pop_back():
    Removes the node at the end of the list and returns its value.
    If the list is empty, returns None.

size():
    Returns the number of nodes in the list.

contains(v):
    Return the first node with value v, if any, or null otherwise.
*/

final class DoublyListNode<T: Equatable> {
    var value: T
    var next: DoublyListNode<T>?
    var prev: DoublyListNode<T>?

    init(_ value: T, next: DoublyListNode<T>? = nil, prev: DoublyListNode<T>?) {
        self.value = value
        self.next = next
        self.prev = prev
    }
}

final class DoublyLinkedList<T: Equatable> {
    private var head: DoublyListNode<T>?
    private var tail: DoublyListNode<T>?
    private(set) var count: Int = 0

    // MARK: - Public Methods

    /// Adds a node with value v at the beginning of the list.
    func pushFront(v: T) {
        let oldHead = head
        head = DoublyListNode(v, next: head, prev: nil)
        if let oldHead {
            oldHead.prev = head
        }
        count += 1
        if count == 1 {
            tail = head
        }
    }

    /// Removes the node at the beginning of the list and returns its value.
    /// Returns nil if the list is empty.
    @discardableResult
    func popFront() -> T? {
        if let oldHead = head {
            head = head?.next
            head?.prev = nil
            count -= 1
            tail = count == 0 ? head : tail
            return oldHead.value
        }
        return nil
    }

    /// Adds a node with value v at the end of the list.
    func pushBack(v: T) {
        if let oldTail = tail {
            tail = DoublyListNode(v, prev: oldTail)
            oldTail.next = tail
        } else {
            head = DoublyListNode(v, next: nil, prev: nil)
            tail = head
        }
        count += 1
    }

    /// Removes the node at the end of the list and returns its value.
    /// Returns nil if the list is empty.
    @discardableResult
    func popBack() -> T? {
        if let oldTail = tail {
            oldTail.prev?.next = nil
            tail = oldTail.prev
            count -= 1
            if count == 0 {
                head = nil
            }
            return oldTail.value
        } else {
            return nil
        }
    }


    /// Returns the first node with value v, if any, or nil otherwise.
    func contains(v: T) -> DoublyListNode<T>? {
        var curr = head
        while curr != nil {
            if curr?.value == v {
                return curr
            }
            curr = curr?.next
        }
        return nil
    }
}
