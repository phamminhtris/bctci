/**
Problem prompt:
Given a sorted array of integers, arr, and a target value, target, return the target's index if it exists in the array or -1 if it doesn't.


Example 1: arr = [-2, 0, 3, 4, 7, 9, 11], target = 3
Output: 2. The target 3 is at index 2.

Example 2: arr = [-2, 0, 3, 4, 7, 9, 11], target = 2
Output: -1. The target 2 is not in the array.

Example 3: arr = [1, 2, 3], target = 1
Output: 0. The target 1 is at index 0.
Constraints:

0 ≤ arr.length ≤ 10^6
-10^9 ≤ arr[i], target ≤ 10^9
arr is sorted in ascending order, without duplicates
*/

func binarySearch(_ arr: [Int], _ target: Int) -> Int {
    guard !arr.isEmpty else { return -1 }

    var l = 0
    var r = arr.count - 1

    func valueIsBefore(_ i: Int) -> Bool {
        arr[i] < target
    }

    guard valueIsBefore(l) else { 
        return arr[l] == target ? l : -1
    }
    guard !valueIsBefore(r) else { return -1 }

    while r - l > 1 {
        let mid = (l + r) / 2
        if valueIsBefore(mid) {
            l = mid
        } else {
            r = mid
        }
    }
    return arr[r] == target ? r : -1
}
