/**
Problem prompt:
Reverse an array of letters, arr, in place using O(1) extra space.

Example 1:
Input: arr = ['h', 'e', 'l', 'l', 'o']
Output: ['o', 'l', 'l', 'e', 'h']

Example 2:
Input: arr = ['a']
Output: ['a']

Example 3:
Input: arr = []
Output: []
*/

func reverseLettersInPlace(_ arr: inout [Character]) {
    guard !arr.isEmpty else { return }
    var l = 0, r = arr.count - 1
    while l < r { 
        arr.swapAt(l, r)
        l += 1
        r -= 1
    }
}
