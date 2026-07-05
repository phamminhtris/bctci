/**
Problem prompt:
A valley-shaped array is an array of integers such that:

It can be split into a non-empty prefix and a non-empty suffix
The prefix is sorted in decreasing order (duplicates allowed)
The suffix is sorted in increasing order (duplicates allowed)
Given a valley-shaped array, arr, return a new array with the elements sorted.


Example 1: arr = [8, 4, 2, 6]
Output:	[2, 4, 6, 8]
Explanation: Note that the decreasing prefix is not necessarily unique. The
decreasing prefix could be [8, 4] or [8, 4, 2]. The corresponding increasing
suffixes would be [2, 6] or [6].

Example 2: arr = [1, 2]
Output:	[1, 2]. The array is already sorted (the decreasing prefix is just
[1]).

Example 3: arr = [2, 2, 1, 1]
Output:	[1, 1, 2, 2]
Constraints:

0 ≤ arr.length ≤ 10^6
-10^9 ≤ arr[i] ≤ 10^9
*/

func sortValleyArray(_ arr: [Int]) -> [Int] {
    guard !arr.isEmpty else { return [] }
    var res = Array<Int>(repeating: 0, count: arr.count)
    var current = res.count - 1
    var l = 0, r = arr.count - 1
    while l < r {
        if arr[l] > arr[r] {
            res[current] = arr[l]
            current -= 1
            l += 1
        } else {
            res[current] = arr[r]
            current -= 1
            r -= 1
        }
    }
    res[current] = arr[l]
    return res
}
