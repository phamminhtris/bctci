/**
Problem prompt:
Given a sorted array of integers, arr, remove duplicates in place while preserving the order, and return the number of unique elements. It doesn't matter what remains in arr beyond the unique elements.


Example 1:
Input: arr = [1, 2, 2, 3, 3, 3, 5]
Output: 4
After the operation, the first 4 elements should be [1, 2, 3, 5]
The last 3 values could be anything

Example 2:
Input: arr = []
Output: 0
After the operation, the array remains empty

Example 3:
Input: arr = [1, 1, 1]
Output: 1
After the operation, the first element should be [1]
The last 2 values could be anything.
*/

func removeDuplicatesInPlace(_ arr: inout [Int]) -> Int {
    guard !arr.isEmpty else { return 0 }
    var s = 0, w = 0
    while s < arr.count {
        let shouldKeep = s == 0 || arr[s] != arr[s - 1]
        if shouldKeep {
            arr[w] = arr[s]
            w += 1
        }
        s += 1
    }
    return w
}
