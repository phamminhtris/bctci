//
//  TwoPointers.swift
//  BCTCI
//
//  Created by Tri Pham on 4/30/25.
//

import Foundation

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
