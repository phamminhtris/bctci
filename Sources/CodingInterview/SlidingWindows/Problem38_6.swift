/**
Problem prompt:
Problem 38.6 - Max Subarray Sum
Given a non-empty array arr of integers (which can be negative), find the non-empty subarray with the maximum sum and return its sum.


Example 1: arr = [1, 2, 3, -2, 1]
Output: 6. The subarray with the maximum sum is [1, 2, 3].

Example 2: arr = [1, 2, 3, -2, 7]
Output: 11. The subarray with the maximum sum is the whole array.

Example 3: arr = [1, 2, 3, -8, 7]
Output: 7. The subarray with the maximum sum is [7].

Example 4: arr = [-2, -3, -4]
Output: -2. The subarray cannot be empty.
Constraints:

1 <= len(arr) <= 10^5
Each element in arr is an integer between -10^6 and 10^6
*/

func maxSubarraySum(in array: [Int]) -> Int {
    if let maxValue = array.max(), maxValue < 0 {
        return maxValue
    }

    var r = 0
    var maxSum = 0
    var currentSum = 0
    while r < array.count {
        let canGrow =  currentSum + array[r] >= 0
        if canGrow {
            currentSum += array[r]
            maxSum = max(currentSum, maxSum)
            r += 1
        } else {
            r += 1
            currentSum = 0
        }
    }
    return maxSum
}
