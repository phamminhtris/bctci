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

final class ListNode<T> {
    var value: T
    var next: ListNode<T>?

    init(_ value: T, next: ListNode<T>? = nil) {
        self.value = value
        self.next = next
    }
}

final class SinglyLinkList<T: Equatable> {
    private var head: ListNode<T>?
    private(set) var size: Int = 0
    init() {}

    func pushFront(_ value: T) {
        head = ListNode(value, next: head)
        size += 1
    }

    func pushBack(_ value: T) {
        if head != nil {
            var curr: ListNode<T>? = head
            while curr?.next != nil {
                curr = curr?.next
            }
            curr?.next = ListNode(value)
        } else {
            head = ListNode(value)
        }
        size += 1
    }

    func popBack() -> T? {
        guard head != nil else { return nil }
        if size == 1 {
            let ret = head?.value
            head = nil
            size -= 1
            return ret
        }

        var curr = head
        while curr?.next?.next != nil {
            curr = curr?.next
        }

        let val = curr?.next?.value
        curr?.next = nil
        size -= 1

        return val
    }

    func contains(_ value: T) -> Bool {
        var curr = head 
        while curr != nil {
            if curr?.value == value {
                return true
            }
            curr = curr?.next
        }
        return false
    }
}
