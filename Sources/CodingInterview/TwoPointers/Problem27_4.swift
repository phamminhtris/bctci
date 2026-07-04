/**
Problem prompt:
Given a string s, return whether its letters form a palindrome ignoring punctuation, spaces, and casing.


Example 1:
Input: s = "Bob wondered, 'Now, Bob?'"
Output: true
Explanation: Considering only letters and ignoring case, we get
"bobwonderednowbob" which is a palindrome.

Example 2:
Input: s = "race a car"
Output: false
Explanation: Considering only letters and ignoring case, we get "raceacar"
which is not a palindrome.
Constraints:

0 <= s.length <= 10^6
s consists of printable ASCII characters
*/

func isLetterPalindrome(_ s: String) -> Bool {
    let characters = Array(s)
    
    var l = 0, r = characters.count - 1
    while l < r {
        if !characters[l].isLetter {
            l += 1
        } else if !characters[r].isLetter {
            r -= 1
        } else if characters[l].lowercased() != characters[r].lowercased() {
            return false
        } else {
            l += 1
            r -= 1
        }
    }
    return true
}
