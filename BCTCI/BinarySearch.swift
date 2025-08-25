//
//  BinarySearch.swift
//  BCTCI
//
//  Created by Tri Pham on 8/17/25.
//

import Foundation

// Problem 29.3
public func valleyBottom(valley: [Int]) -> Int {
    if valley.isEmpty {
        return -1
    } else if valley.count == 1 {
        return valley.first!
    }

    var l = 0, r = valley.count - 1

    while r - l > 1 {
        let mid = (l + r) / 2
        if valley[l] < valley[r] {
            r = mid
        } else {
            l = mid
        }
    }

    if valley[l] < valley[r] {
        return valley[l]
    } else {
        return valley[r]
    }
}

// Problem 29.4
public func twoArrayTwoSum(sorted: [Int], unsorted: [Int]) -> [Int] {
    func find(num: Int, in sorted: [Int]) -> Int {
        if sorted.isEmpty {
            return -1
        }
        if sorted.count == 1, let first = sorted.first, first == num {
            return 0
        }
        var l = 0, r = sorted.count - 1
        while r - l > 1 {
            let mid = (r + l) / 2
            if sorted[mid] < num {
                l = mid
            } else {
                r = mid
            }
        }
        return sorted[r] == num ? r : -1
    }
    // for each element in unsorted
    //      find additive inverse using binary search
    for (index, num) in unsorted.enumerated() {
        let additiveInverseIdx = find(num: -num, in: sorted)
        if additiveInverseIdx != -1 {
            return [additiveInverseIdx, index]
        }
    }
    return [-1, -1]
}
