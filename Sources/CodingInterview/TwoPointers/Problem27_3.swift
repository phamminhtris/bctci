/**
Problem prompt:
Given two sorted arrays, arr1 and arr2, return their intersection.

The intersection is a new array that contains all elements that appear in both arrays, in sorted order, including duplicates.


Example 1:
Input:
arr1 = [1, 2, 3]
arr2 = [1, 3, 5]
Output: [1, 3]
Explanation: 1 and 3 appear in both arrays.

Example 2:
Input:
arr1 = [1, 1, 1]
arr2 = [1, 1]
Output: [1, 1]
Explanation: Two 1s appear in both arrays.

Example 3:
Input:
arr1 = [1, 2, 2, 3]
arr2 = []
Output: []
*/

func intersectSortedArrays(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    var p1 = 0, p2 = 0
    var res = [Int]()
    while p1 < arr1.count && p2 < arr2.count {
        if arr1[p1] == arr2[p2] {
            res.append(arr1[p1])
            p1 += 1
            p2 += 1
        } else if arr1[p1] < arr2[p2] {
            p1 += 1
        } else {
            p2 += 1
        }
    }

    return res 

}
