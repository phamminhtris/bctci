/**
Problem prompt:
Given an array of integers, arr, and an integer, pivot, modify arr in place using only O(1) extra space so that (1) every element smaller than the pivot appears before every element greater than or equal to the pivot, and (2) every element larger than the pivot appears after every element smaller than or equal to the pivot.

The relative order of the elements smaller than or greater than the pivot does not matter.

Example 1:
Input: arr = [1, 7, 2, 3, 3, 5, 3], pivot = 4
Output: [1, 2, 3, 3, 3, 7, 5]
Explanation: The array is partitioned into:
- Elements less than 4: [1, 2, 3, 3, 3]
- Elements equal to 4: []
- Elements greater than 4: [7, 5]
Other orders, such as [3, 2, 1, 3, 3, 5, 7], would also be valid.

Example 2:
Input: arr = [1, 7, 2, 3, 3, 5, 3], pivot = 3
Output: [1, 2, 3, 3, 3, 7, 5]
Explanation: The array is partitioned into:
- Elements less than 3: [1, 2]
- Elements equal to 3: [3, 3, 3]
- Elements greater than 3: [7, 5]
Other orders, such as [2, 1, 3, 3, 3, 5, 7], would also be valid.

Constraints:
0 ≤ arr.length ≤ 10^6
-10^9 ≤ arr[i], pivot ≤ 10^9
*/

func quickSortPartition(_ arr: inout [Int], pivot: Int) {
    guard !arr.isEmpty else { return }

    var l = 0, r = arr.count - 1
    while l < r {
        if arr[l] <= pivot { 
            l += 1
        } else {
            arr.swapAt(l, r)
            r -= 1
        }
    }

    // second pass
    var boundary = 0
    while boundary < arr.count, arr[boundary] <= pivot {
        boundary += 1
    }

    l = 0
    r = boundary - 1
    while l < r {
        if arr[l] < pivot {
            l += 1 
        } else {
            arr.swapAt(l, r)
            r -= 1
        }
    }
}
