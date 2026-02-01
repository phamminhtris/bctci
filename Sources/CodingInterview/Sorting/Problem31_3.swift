/**
You're given an array of n integers, nums, and another array of at most n integers, operations, where each integer represents an operation to be performed on nums.

If the operation number is k ≥ 0, the operation is "delete the number at index k in the original array if it has not been deleted yet. Otherwise, do nothing."
If the operation number is -1, the operation is "delete the smallest number in nums that has not been deleted yet, breaking ties by smaller index."
Return the state of nums after applying all the operations. Every number in operations is guaranteed to be between -1 and n-1 inclusive.

Example 1: nums = [50, 30, 70, 20, 80], operations = [2, -1, 4, -1]
Output: [50]
Explanation:
- Delete index 2 in the original array, element 70: [50, 30, 20, 80]
- Delete 20, the smallest non-deleted number: [50, 30, 80]
- Delete index 4 in the original array, element 80: [50, 30]
- Delete 30, the smallest non-deleted number: [50]

Example 2: nums = [1, 2, 3], operations = []
Output: [1, 2, 3]. No operations to perform.

Example 3: nums = [1, 2, 3], operations = [-1, -1, -1]
Output: []. All elements are deleted.
*/

import Foundation

func deleteNums(_ nums: [Int], operations: [Int]) -> [Int] {
    guard !nums.isEmpty else { return [] }
    var sortedIndices = Array(0..<nums.count)
    
    sortedIndices.sort(by: { nums[$0] < nums[$1] })
    var smallestIndex: Int = 0
    var deleted = Set<Int>()
    for op in operations {
        if op >= 0 {
            deleted.insert(op)
        } else if op == -1 {
            while smallestIndex < nums.count && deleted.contains(sortedIndices[smallestIndex]) {
                smallestIndex += 1
            }
            deleted.insert(sortedIndices[smallestIndex])
            smallestIndex += 1
        }
    }
    return nums.enumerated().filter { (index, _) in
        !deleted.contains(index)
    }.map(\.element)
}
