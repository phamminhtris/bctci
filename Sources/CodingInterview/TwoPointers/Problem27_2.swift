/**
Problem prompt:

Given an array of integers, arr, where the length, n, is even, return whether the following condition holds for every k in the range 1 ≤ k <= n/2: "the sum of the first k elements is smaller than the sum of the first 2k elements." If this condition is false for any k in the range, return false.


Example 1: arr = [1, 2, 2, -1]
Output: True. The prefix [1] has a smaller sum than the prefix [1, 2], and the
prefix [1, 2] has a smaller sum than the prefix [1, 2, 2, -1]. The other
prefixes have length > n/2.

Example 2: arr = [1, 2, -2, 1, 3, 5]
Output: False. The prefix [1, 2] has a larger sum than the prefix [1, 2, -2,
1].
*/

func hasSmallerPrefixSums(_ arr: [Int]) -> Bool {
    var sp = 0, fp = 0
    var slowSum = 0, fastSum = 0
    while fp < arr.count {
        slowSum += arr[sp]
        fastSum += arr[fp] + arr[fp + 1]
        if slowSum >= fastSum {
            return false
        }
        sp += 1
        fp += 2
    }
    return true
}
