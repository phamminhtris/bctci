/**
Problem prompt:
Given an array of integers, arr, and a number w, return whether there are 3 integers in arr that add up to w. We cannot use the value at the same index more than once.


Example: arr = [4, 4, 5, -6, -4, 0], w = 4
Output: True. The triplet (4, 4, -4) adds up to 4.

Example: arr = [5, 0, 1], w = 5
Output: False. We cannot use the 0 twice.
Constraints:

0 <= arr.length <= 1000
-10^7 <= arr[i] <= 10^7
-10^7 <= w <= 10^7
*/

func hasTripletSum(_ arr: [Int], target w: Int) -> Bool {
    var indexMap = [Int: [Int]]()
    for (index, num) in arr.enumerated() {
        indexMap[num, default: []].append(index)
    }
    for i in 0..<arr.count {
        for j in (i + 1)..<arr.count { 
            let complement = w - (arr[i] + arr[j])
            if let complementIndices = indexMap[complement] { 
                for k in complementIndices { 
                    if k != i && k != j { 
                        return true
                    }
                }
            }
        }
    }
    return false
}
