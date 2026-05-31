/**
Problem prompt:
A YouTuber wants to analyze their channel's performance to see if viewer engagement varies during certain times of the year. We are given:

An array, views, of length n > 0, where views[i] represents the number of views on day i.
An array, periods, of length p > 0, where each element is a pair [l, r] with 0 ≤ l ≤ r < n. Each pair represents a time period from day l to day r inclusive.
Return an array, results, of integers with length p, where result[i] is the number of views during period i.


Example:
views = [3, 5, 4, 8, 7, 2, 5, 3, 2, 3]
periods = [[0, 1], [0, 5], [5, 8], [3, 3]]

Output: [8, 29, 12, 8]
For instance, element 0 is 8 because 3 + 5 = 8.
Constraints:

The length of views is at most 10^5
0 <= views[i] < 10^4
The length of periods is at most 10^5
periods[i].length == 2
0 <= periods[i][0] <= periods[i][1] < n
*/

func viewsDuringPeriods(_ views: [Int], periods: [[Int]]) -> [Int] {
    var runningViews: [Int] = []
    runningViews.reserveCapacity(views.count)

    for view in views {
        runningViews.append((runningViews.last ?? 0) + view)
    }

    return periods.map { period in
        let firstDay = period[0]
        let lastDay = period[1]
        let previousViews = firstDay == 0 ? 0 : runningViews[firstDay - 1]

        return runningViews[lastDay] - previousViews
    }
}
