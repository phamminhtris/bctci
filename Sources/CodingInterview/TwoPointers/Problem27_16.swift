/**
Problem prompt:
Given an array, arr, containing only of the characters 'R' (red), 'W' (white), and 'B' (blue), sort the array in place so that the same colors are adjacent, with the colors in the order red, white, and blue.

Example 1:
Input: arr = ['R', 'W', 'B', 'B', 'W', 'R', 'W']
Output: ['R', 'R', 'W', 'W', 'W', 'B', 'B']

Example 2:
Input: arr = ['B', 'R']
Output: ['R', 'B']

Constraints:
0 ≤ arr.length ≤ 10^6
arr[i] is either 'R', 'W', or 'B'
*/

func sortColors(_ arr: inout [Character]) {
    var rCount = 0, wCount = 0
    for c in arr {
        if c == "R" { 
            rCount += 1
        } else if c == "W" {
            wCount += 1
        }
    }

    var i = 0
    for _ in 0..<rCount {
        arr[i] = "R"
        i += 1
    }

    for _ in 0..<wCount {
        arr[i] = "W"
        i += 1
    }

    while i < arr.count {
        arr[i] = "B"
        i += 1
    }
}

// Dutch National Flag partition: low/mid/high pointers classify and swap
// each element in a single pass instead of counting then overwriting.
func sortColorsThreePointer(_ arr: inout [Character]) {
    var low = 0
    var mid = 0
    var high = arr.count - 1

    while mid <= high {
        switch arr[mid] {
            case "R":
                arr.swapAt(low, mid)
                low += 1
                mid += 1
            case "W":
                mid += 1
            default:
                arr.swapAt(mid, high)
                high -= 1
        }
    }
}
