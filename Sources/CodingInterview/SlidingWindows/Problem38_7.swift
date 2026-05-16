/**
Problem prompt:
Given the array sales, where sales[i] is the number of sales on the i-th day, find the longest sequence of days alternating between good days and bad days.

A good day is a day with at least 10 sales. A bad day is a day with fewer than 10 sales.


Example 1: sales = [8, 9, 20, 0, 9]
Output: 3. The only good day is day 2, so the subarray [9, 20, 0] alternates
from bad to good to bad.

Example 2: sales = [0, 0, 0]
Output: 1. Every day is bad, so we cannot find any pair of consecutive days
that alternate.

Example 3: sales = [5, 10, 5, 10]
Output: 4. The entire array alternates between bad and good days.
Constraints:

0 <= len(sales) <= 10^5
0 <= sales[i] <= 10^3
*/

func longestAlternatingGoodBadDays(in sales: [Int]) -> Int {
    var r = 0, l = 0
    var longest = 0
    while r < sales.count {
        let canGrow = r == 0 || sales[r].isBadDay != sales[r - 1].isBadDay
        if canGrow {
            r += 1
            longest = max(longest, r - l)
        } else {
            l = r
            r += 1
        }
    }
    return longest
}

private extension Int {
    var isBadDay: Bool {
        self < 10
    }
}
