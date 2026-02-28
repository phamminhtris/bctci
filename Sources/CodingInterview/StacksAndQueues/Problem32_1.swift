//
//  Problem32_1.swift
//  CodingInterview
//
//  Created by Tri Pham on 2/8/26.
//

/**
 Given an array of integers, arr, a compress operation finds the first pair of consecutive equal numbers and combines them into their sum. If there are no consecutive equal numbers, the array is considered fully compressed. Your goal is to repeatedly compress the array until it is fully compressed.
 
 Example 1: arr = [8, 4, 2, 2, 2, 4]
 Output: [16, 2, 4].
 The steps are [8, 4, 2, 2, 2, 4] -> [8, 4, 4, 2, 4] -> [8, 8, 2, 4] -> [16, 2,
 4]

 Example 2: arr = [4, 4, 4, 4]
 Output: [16]
 The steps are [4, 4, 4, 4] -> [8, 4, 4] -> [8, 8] -> [16]

 Example 3: arr = [1, 2, 3, 4]
 Output: [1, 2, 3, 4]
 */

import Collections
import Foundation

func compressArray(_ arr: [Int]) -> [Int] {
    var stack = [Int]()
    for element in arr {
        stack.append(element)
        compressStack(stack: &stack)
    }

    return stack
}

func compressStack(stack: inout [Int]) {
    while true {
        if let curr = stack.popLast() {
            if let top = stack.popLast() {
                if curr == top {
                    stack.append(top + curr)
                } else {
                    stack.append(top)
                    stack.append(curr)
                    break
                }
            } else {
                stack.append(curr)
                break
            }
        } else {
            break
        }
    }
}
