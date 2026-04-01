/**
Given the head, head, of a singly linked list, and two indices, left and right, with 0 ≤ left < right, reverse all nodes between the two indices in place and return the new head of the list.

If left is beyond the last index, do not modify the list. If only right is beyond the last index, reverse everything up to the last node.


Example 1:
head = 1 -> 2 -> 3 -> 4 -> 5 -> null
left = 1
right = 3

Output: 1 -> 4 -> 3 -> 2 -> 5 -> null
The first node (index 0) and the last node (index 4) stay the same

Example 2:
head = 1 -> 2 -> 3 -> 4 -> 5 -> null
left = 2
right = 7

Output: 1 -> 2 -> 5 -> 4 -> 3 -> null
All nodes starting at index 2 are reversed because index 7 is beyond
the last index

Example 3:
head = 1 -> 2 -> null
left = 5
right = 6

Output: 1 -> 2 -> null
left is out of bounds, so we leave the list untouched
Constraints:

You have to create the Node class with an integer val field and a next pointer.
The list can contain up to 10^5 nodes.
*/