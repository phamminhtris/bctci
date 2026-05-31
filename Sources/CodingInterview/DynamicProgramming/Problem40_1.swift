/**
Problem prompt:
We are driving down a road with n rest stops between us and our destination. For each rest stop, our mapping software tells us how long of a detour it would be to stop there. We start before the first rest stop and our destination is past the last one.

We are given an array of n positive integers, times, indicating the delay incurred to stop at each rest stop. If we don't want to go more than 2 rest stops without taking a break, what's the least amount of time we have to spend on detours?


Example 1:
times = [8, 1, 2, 3, 9, 6, 2, 4]
Output: 6. The optimal rest stops are: [8, *1*, 2, *3*, 9, 6, *2*, 4]

Example 2:
times = [8, 1, 2, 3, 9, 3, 2, 4]
Output: 5. The optimal rest stops are: [8, 1, *2*, 3, 9, *3*, 2, 4]

Example 3:
times = [10, 10]
Output: 0. We don't need to make any stops.

Example 4:
times = [10]
Output: 0. We don't need to make any stops.

Example 5:
times = []
Output: 0. We don't need to make any stops.
*/

func minimumDetourTime(_ times: [Int]) -> Int {
    if times.count < 3 { 
        return 0
    }
    let stopCount = times.count
    var memo = [
        stopCount - 1: times[stopCount - 1],
        stopCount - 2: times[stopCount - 2],
        stopCount - 3: times[stopCount - 3]
    ]
    func delay(i: Int) -> Int {
        if let delayAtIndex = memo[i] {
            return delayAtIndex
        }

        if i < times.count - 3 {
            let delayAtI = times[i] + min(delay(i: i + 1), delay(i: i + 2), delay(i: i + 3))
            memo[i] = delayAtI
            return delayAtI
        } else { 
            return times[i]
        }
    }

    return min(delay(i: 0), delay(i: 1), delay(i: 2))
}
