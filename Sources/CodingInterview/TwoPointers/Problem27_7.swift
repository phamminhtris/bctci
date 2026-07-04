/**
Problem prompt:
Given a sorted array of integers, arr, return whether there are two distinct indices, i and j, such that arr[i] + arr[j] = 0.


Example 1:
Input: arr = [-5, -2, -1, 1, 1, 10]
Output: true
Explanation: The elements -1 and 1 sum to zero.

Example 2:
Input: arr = [-3, 0, 0, 1, 2]
Output: true
Explanation: The two 0s sum to zero.

Example 3:
Input: arr = [-5, -3, -1, 0, 2, 4, 6]
Output: false
Explanation: No two elements sum to zero.
Constraints:

arr is sorted in ascending order
0 ≤ arr.length ≤ 10^6
-10^9 ≤ arr[i] ≤ 10^9
*/

func hasZeroSumPair(_ arr: [Int]) -> Bool {
    var l = 0, r = arr.count - 1
    while l < r {
        let currentSum = arr[l] + arr[r]
        if currentSum == 0 {
            return true
        } else if currentSum < 0 {
            l += 1
        } else {
            r -= 1
        }
    }
    return false
}
