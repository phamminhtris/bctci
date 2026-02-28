//
//  Problem31_6.swift
//  CodingInterview
//
//  Created by Tri Pham on 2/1/26.
//

/**
 Given an array of n unique integers, arr, return the k smallest numbers, in any order.


 Example 1: arr = [15, 4, 13, 8, 10, 5, 2, 20, 3, 9, 11, 27], k = 5
 Output: [4, 3, 2, 5, 8]. The order doesn't matter.

 Example 2: arr = [5, 3, 1, 4, 2], k = 1
 Output: [1]. The smallest element.

 Example 3: arr = [5, 3, 1, 4, 2], k = 4
 Output: [1, 2, 3, 4]. All elements except the largest one.
 Constraints:

 0 ≤ k ≤ n ≤ 10^5
 All elements in arr are unique
 Each element in arr is between -10^9 and 10^9

 */

import Foundation
import Collections

func kSmallest(_ nums: [Int], k: Int) -> [Int] {
    var heap = Heap<Int>(nums)
    while heap.count > k {
        _ = heap.popMax()
    }
    return heap.unordered
}


