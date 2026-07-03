/**
Problem prompt:
Given a string s, return whether s is a palindrome. A palindrome is a string that reads the same forward and backward.


Example 1: s = "level"
Output: true

Example 2: s = "naan"
Output: true

Example 3: s = "hello"
Output: false
Constraints:

The length of s is at most 10^6
s consists of lowercase English letters
*/

func isPalindrome(_ s: String) -> Bool {
    let characters = Array(s)

    var l = 0, r = characters.count - 1
    while l < r { 
        if characters[l] != characters[r] {
            return false 
        }
        l += 1
        r -= 1
    }

    return true

}
