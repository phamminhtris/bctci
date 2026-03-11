import Foundation

/**
A nested array is an array where each element is either:

An integer, or
A nested array (note that this is a recursive definition).
The sum of a nested array is defined recursively as the sum of all its elements. Given a nested array, arr, return its sum.

Example 1: arr = [1, [2, 3], [4, [5]], 6]
Output: 21

Example 2: arr = [[[[1]], 2]]
Output: 3

Example 3: arr = []
Output: 0

Example 4: arr = [[], [1, 2], [], [3]]
Output: 6

Example 5: arr = [-1, [-2, 3], [4, [-5]], 6]
Output: 5
*/

indirect enum NestArray {
    case int(Int)
    case array([NestArray])
}

func nestedArraySum(arr: [NestArray]) -> Int {
    var runningSum = 0
    for elem in arr {
        switch elem {
            case .int(let num):
                runningSum += num
            case .array(let childArr):
                runningSum += nestedArraySum(arr: childArr)
        }
    }
    return runningSum
}
