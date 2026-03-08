/**
Given a balanced parentheses string, s, a balanced partition is a partition of s into substrings, each of which is itself balanced. Return the maximum possible number of substrings in a balanced partition.


Example: s = "((()))(()())()(()(()))"
Output: 4. The balanced partition with the most substrings is "((()))",
"(()())", "()", "(()(()))".
Constraints:

The length of s is at most 10^5
s consists only of '(' and ')'
*/

func maxBalancePartition(_ s: String) -> Int {
    var count = 0
    var openParenCount = 0
    for char in s {
        if char == "(" {
            openParenCount += 1
        } else if char == ")" {
            openParenCount -= 1
        }
        if openParenCount == 0 {
            count += 1
        }
    }
    return count
}