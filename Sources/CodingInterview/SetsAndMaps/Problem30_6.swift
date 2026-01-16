/**
Given an array of unique, positive integers, arr, return a list with all pairs of indices [i, j], such that arr[i] == arr[j]^2
You can return the pairs in any order.

Example: arr = [4, 10, 3, 100, 5, 2, 10000] -> Output: [[5, 0], [1, 3], [3, 6]]
*/

public func findAllSquares(arr: [Int]) -> [[Int]] {
    var indexMap = [Int: Int]()
    arr.enumerated().forEach { index, value in 
        indexMap[value] = index
    }

    var result = [[Int]]()
    for (index, value) in arr.enumerated() { 
        let square = value * value
        if let squareIndex = indexMap[square] {
            result.append([index, squareIndex])
        }
    }
    return result
}