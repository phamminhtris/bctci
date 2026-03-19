/**
Given the head, head, of a singly linked list, reverse the nodes in place and return the new head of the list. The list may be empty.


Example 1:
Input: 1 -> 2 -> 3 -> null
Output: 3 -> 2 -> 1 -> null

Example 2:
Input: null
Output: null

Example 3:
Input: 1 -> null
Output: 1 -> null
Constraints:

You have to create the Node class with an integer val field and a next pointer.
The list can contain up to 10^5 nodes.
*/

import Foundation

func revertList(_ head: ListNode<Int>?) -> ListNode<Int>? {
    var curr = head 
    
    var res: ListNode<Int>?
    while curr != nil {
        let temp = curr?.next
        curr?.next = res
        res = curr
        curr = temp
    }
    return res
}