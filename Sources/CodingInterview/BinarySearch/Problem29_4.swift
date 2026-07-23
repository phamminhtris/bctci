/**
Problem prompt:
You are given two non-empty arrays of integers, sorted_arr and unsorted_arr. The first one is sorted, but the second is not. The goal is to find one element from each array with sum 0. If you can find them, return an array with their indices, starting with the element in sorted_arr. Otherwise, return [-1, -1]. Use O(1) extra space and do not modify the input.

Example 1:
sorted_arr = [-5, -4, -1, 4, 6, 6, 7]
unsorted_arr = [-3, 7, 18, 4, 6]
Output: [1, 3]
Explanation: We can use -4 from the sorted array and 4 from the unsorted array.

Example 2:
sorted_arr = [1, 2, 3]
unsorted_arr = [1, 2, 3]
Output: [-1, -1]
Explanation: No pair of elements sums to 0.

Example 3:
sorted_arr = [-2, 0, 1, 2]
unsorted_arr = [0, 2, -2, 4]
Output: [0, 1]
Explanation: We can use -2 from the sorted array and 2 from the unsorted array.
Constraints:

1 <= sorted_arr.length, unsorted_arr.length <= 10^6
-10^9 <= sorted_arr[i], unsorted_arr[i] <= 10^9
sorted_arr is sorted in ascending order
The arrays have no duplicates
Use O(1) extra space and do not modify the input

Note: several inputs admit more than one valid pair (Example 3 also allows [1, 0] and
[3, 2]). Any pair whose elements sum to 0 is accepted.
*/

/// Returns `[sortedIndex, unsortedIndex]` for a pair of elements summing to zero,
/// or `[-1, -1]` when no such pair exists. When several pairs qualify, any one of
/// them is a correct answer.
func zeroSumPair(_ sortedArr: [Int], _ unsortedArr: [Int]) -> [Int] {
    precondition(!sortedArr.isEmpty && !unsortedArr.isEmpty, "Both arrays must be non-empty")

    for (i, n) in unsortedArr.enumerated() {
        let complement = -n
        if let complementIndex = find(target: complement, in: sortedArr) {
            return [complementIndex, i]
        }
    }
    return [-1, -1]
}

private func find(target: Int, in arr: [Int]) -> Int? {
    guard !arr.isEmpty else { return nil }

    var l = 0, r = arr.count - 1
    func isBefore(_ i: Int) -> Bool {
        arr[i] < target
    }

    guard isBefore(l) else {
        return arr[l] == target ? l : nil
    }
    guard !isBefore(r) else {
        return nil
    }
    while r - l > 1 {
        let mid = (r + l) / 2
        if isBefore(mid) {
            l = mid
        } else {
            r = mid
        }
    }
    return arr[r] == target ? r : nil
}
