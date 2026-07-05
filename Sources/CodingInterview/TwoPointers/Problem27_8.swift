/**
Problem prompt:
Given three sorted arrays, arr1, arr2, and arr3, return a new array with the elements of all three arrays, in sorted order, without duplicates.


Example 1:
Input:
arr1 = [2, 3, 3, 4, 5, 7]
arr2 = [3, 3, 9]
arr3 = [3, 3, 9]
Output: [2, 3, 4, 5, 7, 9]
Explanation: The value 3 appears multiple times in the input but only once in
the output.

Example 2:
Input:
arr1 = [1, 2, 3]
arr2 = [2, 3, 4]
arr3 = [3, 4, 5]
Output: [1, 2, 3, 4, 5]
Explanation: Each duplicate value is included only once.

Example 3:
Input:
arr1 = [1, 1, 1, 1]
arr2 = [1, 1, 1]
arr3 = [1, 1]
Output: [1]
Explanation: All ones are merged into a single occurrence.
Constraints:

The input arrays are sorted in ascending order
0 ≤ arr1.length, arr2.length, arr3.length ≤ 10^6
-10^9 ≤ arr1[i], arr2[i], arr3[i] ≤ 10^9
*/

func mergeThreeSortedArraysUnique(_ arr1: [Int], _ arr2: [Int], _ arr3: [Int]) -> [Int] {
    var i = 0, j = 0, k = 0
    var res = [Int]()
    while i < arr1.count || j < arr2.count || k < arr3.count {
        var min = Int.max
        if i < arr1.count, min > arr1[i] {
            min = arr1[i]
        }

        if j < arr2.count, min > arr2[j] {
            min = arr2[j]
        }

        if k < arr3.count, min > arr3[k] {
            min = arr3[k]
        }

        if i < arr1.count, arr1[i] == min {
            i += 1
        } else if j < arr2.count, arr2[j] == min {
            j += 1
        } else if k < arr3.count, arr3[k] == min {
            k += 1
        }

        if res.last != min {
            res.append(min)
        }
    }

    return res
}
