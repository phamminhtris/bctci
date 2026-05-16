/**
Problem prompt:
Given an array sales, where sales[i] is the number of sales on the i-th day, find the most consecutive days with at most 3 bad days.

A bad day is a day with fewer than 10 sales.


Example 1: sales = [0, 14, 7, 9, 0, 20, 10, 0, 10]
Output: 6.
There are two 6-day periods with at most 3 bad days:
  - [14, 7, 9, 0, 20, 10]
  - [9, 0, 20, 10, 0, 10]

Example 2: sales = [10, 10, 10]
Output: 3. All days are good days.

Example 3: sales = [5, 5, 5, 5]
Output: 3. We can include at most 3 bad days.
Constraints:

0 <= len(sales) <= 10^5
0 <= sales[i] <= 10^3
*/

func mostConsecutiveDaysWithAtMostThreeBadDays(in sales: [Int]) -> Int {
    var r = 0, l = 0
    var longest = 0
    var badCount = 0
    while r < sales.count {
        let currentIsBadDay = sales[r] < 10
        let canGrow = badCount < 3 || !currentIsBadDay

        if canGrow {
            if currentIsBadDay {
                badCount += 1
            }
            r += 1
            longest = max(longest, r - l)
        } else {
            if sales[l] < 10 {
                badCount -= 1
            }
            l += 1
        }
    }
    return longest
}
