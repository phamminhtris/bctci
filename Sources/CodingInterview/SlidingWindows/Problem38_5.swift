/**
Problem prompt:
Given an array, sales, where sales[i] is the number of sales on the i-th day, find the most consecutive days with no bad days.

A bad day is a day with fewer than 10 sales.


Example 1: sales = [0, 14, 7, 12, 10, 20]
Output: 3. The subarray [12, 10, 20] has no bad days.

Example 2: sales = [10, 10, 10]
Output: 3. All days are good days.

Example 3: sales = [5, 5, 5]
Output: 0. There are no good days.
Constraints:

0 <= len(sales) <= 10^5
0 <= sales[i] <= 10^3
*/

func mostConsecutiveGoodDays(in sales: [Int]) -> Int {
    var r = 0, l = 0
    var maxConsecutive = 0
    while r < sales.count {
        let canGrow = sales[r] >= 10
        if canGrow {
            r += 1
            maxConsecutive = max(maxConsecutive, r - l)
        } else {
            r = r + 1
            l = r
        }
    }
    return maxConsecutive
}
