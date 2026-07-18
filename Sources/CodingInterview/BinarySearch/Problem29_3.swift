/**
Problem prompt:
A valley-shaped array is an array of integers such that:

It can be split into a non-empty prefix and a non-empty suffix,
The prefix is sorted in decreasing order,
The suffix is sorted in increasing order,
All the elements are unique.
Given a valley-shaped array, arr, return the smallest value.

Example 1: arr = [6, 5, 4, 7, 9]
Output: 4

Example 2: arr = [5, 6, 7]
Output: 5. The prefix sorted in decreasing order is just [5].

Example 3: arr = [7, 6, 5]
Output: 5. The suffix sorted in increasing order is just [5].
Constraints:

2 <= arr.length <= 10^6
-10^9 <= arr[i] <= 10^9
*/

func smallestInValley(_ arr: [Int]) -> Int {
    precondition(arr.count >= 2, "A valley-shaped array has at least two elements")

    func isBefore(_ i: Int) -> Bool {
        i == 0 || arr[i] < arr[i - 1]
    }

    var l = 0 
    var r = arr.count - 1
    while r - l > 1 {
        let mid = (r + l) / 2
        if isBefore(mid) {
            l = mid
        } else { 
            r = mid
        }
    }

    return arr[r] < arr[l] ? arr[r] : arr[l]
}
