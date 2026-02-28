//
//  Problem32_2.swift
//  CodingInterview
//
//  Created by Tri Pham on 2/28/26.
//

/**
 Given an array of integers, arr, and an integer k ≥ 2, a k-compress operation finds the first block of k consecutive equal numbers and combines them into their sum. If there are no k consecutive equal numbers, the array is considered fully k-compressed.
 
 Example 1: arr = [1, 9, 9, 3, 3, 3, 4], k = 3
 Output: [1, 27, 4]
 The steps are [1, 9, 9, 3, 3, 3, 4] -> [1, 9, 9, 9, 4] -> [1, 27, 4]

 Example 2: arr = [8, 4, 2, 2], k = 2
 Output: [16]

 Example 3: arr = [4, 4, 4, 4], k = 5
 Output: [4, 4, 4, 4]
 */

import Foundation

func compressArrayK(_ arr: [Int], k: Int) -> [Int] {
    var res = [Int]()
    for num in arr {
        res.append(num)
        compressTop(k: k, array: &res)
    }
    return res
}

func compressTop(k: Int, array: inout [Int]) {
    guard array.count >= k else { return }
    while array.count >= k {
        let temp = array.suffix(k)
        let first = temp.first
        if let first, temp.allSatisfy({ $0 == first }) {
            let new = first * k
            array.removeLast(k)
            array.append(new)
            continue
        } else {
            return
        }
    }
}
