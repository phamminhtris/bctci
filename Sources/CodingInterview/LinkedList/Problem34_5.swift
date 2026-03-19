import Foundation

/**
Given the head, head, of a singly linked list, return a new list with the same values. The list may be empty.


Example 1:
Input: 1 -> 2 -> 3 -> null
Output: 1 -> 2 -> 3 -> null

Example 2:
Input: null
Output: null

Example 3:
Input: 1 -> null
Output: 1 -> null
*/

func copyList<T>(head: ListNode<T>) -> ListNode<T> {
    let res = ListNode(head.value)
    var tail: ListNode<T> = res
    var curr: ListNode<T>? = head.next

    while let toCopy = curr {
        tail.next = ListNode(toCopy.value)
        tail = tail.next!
        curr = curr?.next
    }

    return res
}
