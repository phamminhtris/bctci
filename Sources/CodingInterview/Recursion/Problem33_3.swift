/**
Problem prompt:
Given three integers a > 1, p ≥ 0, and m > 1, compute a^p % m while avoiding storing intermediate values much larger than m.

The basic recurrence relation for powers is:

a^0 = 1
For p > 0, a^p = a * a^(p-1)
When it comes to the modulo operation, we can apply it at each step without affecting the result:

a^0 % m = 1
For p > 0, a^p % m = (a * (a^(p-1) % m)) % m

Example 1: a = 2, p = 5, m = 100
Output: 32

Example 2: a = 2, p = 5, m = 30
Output: 2

Example 3: a = 123456789, p = 987654321, m = 1000000007
Output: 652541198

Example 4: a = 3, p = 1, m = 5
Output: 3

Example 5: a = 5, p = 3, m = 7
Output: 6
Constraints:

1 < a ≤ 10^9
0 ≤ p ≤ 10^9
1 < m ≤ 10^9
*/

func modularPower(a: Int, p: Int, m: Int) -> Int {
    var memo = [Int: Int]()

    func pow(a: Int, p: Int, m: Int) -> Int {
        if let res = memo[p] { 
            return res
        }
        if p == 0 { 
            return 1
        }
        let res = if p % 2 == 0 {
            (pow(a: a, p: p / 2, m: m) * pow(a: a, p: p / 2, m: m)) % m
        } else {
            a * pow(a: a, p: p - 1, m: m) % m
        }
        memo[p] = res
        return res
    }

    return pow(a: a, p: p, m: m)
}


