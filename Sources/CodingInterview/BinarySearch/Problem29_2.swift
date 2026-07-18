/**
Problem prompt:
You are given an API called is_stolen(t) which takes a timestamp as input and returns True if the bike is missing at that timestamp and False if it is still there. You're also given two timestamps, t1 and t2, representing when you parked the bike and when you found it missing. Return the timestamp when the bike was first missing, minimizing the number of API calls. Assume that 0 < t1 < t2, is_stolen(t1) is False, and is_stolen(t2) is True.

CCTV Footage Example

Example 1: t1 = 1, t2 = 5, is_stolen = lambda t: t >= 3
Output: 3. The bike was stolen at timestamp 3.

Example 2: t1 = 1, t2 = 10, is_stolen = lambda t: t >= 7
Output: 7. The bike was stolen at timestamp 7.

Example 3: t1 = 5, t2 = 10, is_stolen = lambda t: t >= 8
Output: 8. The bike was stolen at timestamp 8.
Constraints:

0 < t1 < t2 <= 10^6
The API call is_stolen(t) takes O(1) time
*/

func firstStolenTimestamp(_ t1: Int, _ t2: Int, isStolen: (Int) -> Bool) -> Int {
    var l = t1
    var r = t2

    func isBefore(_ t: Int) -> Bool {
        !isStolen(t)
    }

    while r - l > 1 {
        let mid = (l + r) / 2
        if isBefore(mid) {
            l = mid
        } else {
            r = mid
        }
    }
    return r
}
