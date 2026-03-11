import Foundation

final class ListNode<T> {
    var value: T
    var next: ListNode<T>?

    init(_ value: T, next: ListNode<T>? = nil) {
        self.value = value
        self.next = next
    }
}