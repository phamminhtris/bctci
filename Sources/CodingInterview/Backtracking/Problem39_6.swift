/**
Problem prompt:
A jumping number is a positive integer where every two consecutive digits differ by one, such as 2343. Given a positive integer, n, return all jumping numbers smaller than n, ordered from smallest to largest.


Example 1: n = 34
Output: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 21, 23, 32]

Example 2: n = 1
Output: []
Constraints:

n is a positive integer less than 10^5.
*/

func jumpingNumbers(smallerThan n: Int) -> [Int] {
    var results = [Int]()

    func visit(number: Int) {
        if number >= n {
            return
        }
        results.append(number)
        let lastDigit = number % 10
        if lastDigit > 0 { 
            visit(number: number * 10 + (lastDigit - 1))
        }
        if lastDigit < 9 {
            visit(number: number * 10 + (lastDigit + 1))
        }
    }
    for num in 1...9 { 
        visit(number: num)
    }
    results.sort()
    return results
}

extension Array where Element == Int { 
    var number: Int { 
        Int(self.map { String($0) }.joined(separator: ""))!
    }
}
