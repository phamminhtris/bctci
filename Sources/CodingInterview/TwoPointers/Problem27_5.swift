/**
Problem prompt:
Given a string, s, where half of the letters are lowercase and half uppercase, return whether the word formed by the lowercase letters is the same as the reverse of the word formed by the uppercase letters. Assume that the length, n, is even.


Example 1:
Input: s = "haDrRAHd"
Output: true
Explanation:
- Lowercase letters: "hard"
- Uppercase letters: "DRAH"
- When reversed, "DRAH" becomes "HARD", which matches "hard" ignoring case.

Example 2:
Input: s = "haHrARDd"
Output: false
Explanation:
- Lowercase letters: "hard"
- Uppercase letters: "HARD"
- When reversed, "HARD" becomes "DRAH", which doesn't match "hard".

Example 3:
Input: s = "BbbB"
Output: true
Explanation:
- Lowercase letters: "bb"
- Uppercase letters: "BB"
- When reversed, "BB" becomes "BB", which matches "bb" ignoring case.
Constraints:

0 ≤ s.length ≤ 10^6
s contains only uppercase and lowercase English letters
*/

func isReversedCaseMatch(_ s: String) -> Bool {
    let letters = Array(s)
    var l = 0, r = letters.count - 1

    while l < letters.count && r >= 0 {
        if !letters[l].isLowercase {
            l += 1
        } else if !letters[r].isUppercase {
            r -= 1
        } else if letters[l].lowercased() != letters[r].lowercased() {
            return false
        } else {
            l += 1
            r -= 1
        }
    }
    return true
}
