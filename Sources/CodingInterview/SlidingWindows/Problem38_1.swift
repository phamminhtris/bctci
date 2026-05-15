/**
Given an array, sales, find the most sales in any 7-day period.


Example 1: sales = [0, 3, 7, 12, 10, 5, 0, 1, 0, 15, 12, 11, 1]
Output: 44
The 7-day period with the most sales is [5, 0, 1, 0, 15, 12, 11].

Example 2: sales = [0, 3, 7, 12]
Output: 0
There is no 7-day period.

Example 3: sales = [1, 2, 3, 4, 5, 6, 7]
Output: 28
The only 7-day period is the entire array.
Constraints:

The length of sales is at most 10^6
Each element in sales is a non-negative integer less than 10^3
*/

func mostWeeklySales(sales: [Int]) -> Int {
    guard sales.count >= 7 else { return 0 }

    var currentSum = 0
    var maxSale = 0
    var l = 0, r = 0 
    while r < sales.count {
        currentSum += sales[r]
        r += 1
        if r - l == 7 {
            maxSale = max(maxSale, currentSum)
            currentSum -= sales[l]
            l += 1
        }
    }
    return maxSale
}