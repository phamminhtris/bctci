/**
Problem prompt:
A YouTuber has fetched the number of likes and dislikes of a video each day since its publication. We say a day is positive if it has more likes than dislikes.

We are given:

Two arrays, likes and dislikes, of length n, representing the likes and dislikes on each day.
An array periods of length p, where each element is a pair [l, r] with 0 ≤ l ≤ r < n. Each pair represents a time period from day l to day r inclusive.
Return an array, results, of length p, where results[i] is the number of positive days during period[i].


Example:
likes    = [6, 3, 4, 8, 7, 2, 6, 5, 0, 1]
dislikes = [6, 0, 8, 0, 0, 0, 1, 8, 0, 2]
periods  = [[0, 1], [0, 5], [5, 8], [3, 3]]

Output: [1, 4, 2, 1]
For instance, element 0 (for the period [0, 1]) is 1 because
day 0 doesn't have more likes than dislikes, but day 1 does.
Constraints:

The length of likes and dislikes is the same and is at most 10^5
Each element in likes and dislikes is a non-negative integer less than 10^4
The length of periods is at most 10^5
periods[i].length == 2
0 <= periods[i][0] <= periods[i][1] < n
*/

func positiveDaysDuringPeriods(_ likes: [Int], dislikes: [Int], periods: [[Int]]) -> [Int] {
    let positiveDays = zip(likes, dislikes).map { like, dislike in 
        like > dislike
    }
    var positiveDaySoFar = [Int]()
    positiveDaySoFar.reserveCapacity(positiveDays.count)
    for isPositive in positiveDays { 
        positiveDaySoFar.append((positiveDaySoFar.last ?? 0) + (isPositive ? 1 : 0))
    }

    return periods.map { p in 
        let start = p[0]
        let end = p[1]
        if start == 0 { 
            return positiveDaySoFar[end]
        } else { 
            return positiveDaySoFar[end] - positiveDaySoFar[start - 1]
        }
    }
}
