/**
Problem prompt:
Given two sorted arrays of integers, arr1 and arr2, return a new array that contains all the elements in arr1 and arr2 in sorted order, including duplicates.


Example 1:
Input:
arr1 = [1, 3, 4, 5]
arr2 = [2, 4, 4]
Output: [1, 2, 3, 4, 4, 4, 5]
Explanation: All elements are merged in sorted order.

Example 2:
Input:
arr1 = [-1]
arr2 = []
Output: [-1]
Explanation: When one array is empty, the result is just the other array.

Example 3:
Input:
arr1 = [1, 3, 5]
arr2 = [2, 4, 6]
Output: [1, 2, 3, 4, 5, 6]
Constraints:

arr1 and arr2 are sorted in ascending order
0 ≤ arr1.length, arr2.length ≤ 10^6
-10^9 ≤ arr1[i], arr2[i] ≤ 10^9
*/

func mergeSortedArrays(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    var i = 0, j = 0
    var res = [Int]()
    res.reserveCapacity(arr1.count + arr2.count)
    while i < arr1.count && j < arr2.count {
        if arr1[i] < arr2[j] {
            res.append(arr1[i])
            i += 1 
        } else if arr1[i] > arr2[j] {
            res.append(arr2[j])
            j += 1
        } else {
            res.append(arr1[i])
            res.append(arr2[j])
            i += 1
            j += 1
        }
    }

    while i < arr1.count {
        res.append(arr1[i])
        i += 1
    }

    while j < arr2.count {
        res.append(arr2[j])
        j += 1
    }
    return res
}
