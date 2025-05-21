//
//  TwoPointers.swift
//  BCTCI
//
//  Created by Tri Pham on 4/30/25.
//

import Foundation

// Problem 27.8
// Input: [2, 3, 3, 4, 5, 7], [3, 3, 9], [3, 3, 9]
func threeWayMergeWithoutDuplicates(arr1: [Int], arr2: [Int], arr3: [Int]) -> [Int] {
    var i = 0, j = 0, k = 0
    var res = [Int]()

    while i < arr1.count || j < arr2.count || k < arr3.count {
        var currentElem = [Int]()
        if i < arr1.count {
            currentElem.append(arr1[i])
        }
        if j < arr2.count {
            currentElem.append(arr2[j])
        }
        if k < arr3.count {
            currentElem.append(arr3[k])
        }
        
        if let min = currentElem.min() {
            if res.last != min {
                res.append(min)
            }
            // move pointers
            if i < arr1.count, arr1[i] == min {
                i += 1
            }
            if j < arr2.count, arr2[j] == min {
                j += 1
            }
            if k < arr3.count, arr3[k] == min {
                k += 1
            }
        }

    }
    return res
}

// Problem 27.9
// Input: [8, 4, 2, 6]
// Output: [2, 4, 6, 8]
func sortValleyShapeArray(_ arr: [Int]) -> [Int] {
    var l = 0, r = arr.count - 1
    var res = Array(repeating: 0, count: arr.count)
    var i = arr.count - 1
    while l < r {
        if arr[l] < arr[r] {
            res[i] = arr[r]
            i -= 1
            r -= 1
        } else {
            res[i] = arr[l]
            l += 1
            i -= 1
        }
    }
    res[0] = arr[l]
    return res
}

func missingNumbersInRange(_ arr: [Int], low: Int, high: Int) -> [Int] {
    var i = 0
    var current = low
    var res = [Int]()
    
    while current <= high {
        if i >= arr.count {
            break
        }
        let elem = arr[i]
        if elem < current {
            // either already added or out of range
            i += 1
        } else if elem == current {
            // found common element
            i += 1
            current += 1
        } else {
            res.append(current)
            current += 1
        }
    }

    while current <= high {
        res.append(current)
        current += 1
    }

    return res
}
