/**
Problem prompt:
Given an array of integers arr, modify it in place so that all even numbers come before all odd numbers. The relative order of even numbers does not need to be maintained. The same goes for odd numbers.


Example 1:
Input: arr = [1, 2, 3, 4, 5]
Output: [2, 4, 1, 3, 5]
Explanation: There are other valid outputs, e.g. [4, 2, 3, 1, 5].

Example 2:
Input: arr = [5, 1, 3, 1, 5]
Output: [5, 1, 3, 1, 5]
Explanation: Since all numbers are odd, any ordering is valid.

Example 3:
Input: arr = [1, 3, 2, 4]
Output: [2, 4, 1, 3]
Explanation: Any arrangement where the even numbers (2, 4) come before the odd
numbers (1, 3) is valid.
Constraints:

The length of arr is at most 10^6
Each element in arr is an integer in the range [-10^9, 10^9]
*/

func partitionEvensBeforeOdds(_ arr: inout [Int]) {
    guard !arr.isEmpty else { return }
    var l = 0, r = arr.count - 1
    while l < r {
        if abs(arr[l]) % 2 == 1 {
            // odd
            arr.swapAt(l, r)
            r -= 1
        } else {
            // even
            l += 1
        }
    }
}
