import Foundation

/**
Given a string, word, consisting of lowercase letters only, return a sorted array with all the letters in word sorted from most frequent to least frequent. If two frequencies are the same, break the tie alphabetically.

Example 1: word = "supercalifragilisticexpialidocious"
Output: ['i', 'a', 'c', 'l', 's', 'e', 'o', 'p', 'r', 'u', 'd', 'f', 'g', 't',
'x']

Example 2: word = "aabbbcccc"
Output: ['c', 'b', 'a']. 'c' appears 4 times, 'b' appears 3 times, and 'a'
appears 2 times.

Example 3: word = "abc"
Output: ['a', 'b', 'c']. All letters appear once, so they are sorted
alphabetically.
*/

func sortLetter(_ input: String) -> [Character] {
    var freqMap = [Character: Int]()

    for letter in input { 
        freqMap[letter, default: 0] += 1 
    }
    return freqMap.sorted(by: {  
        if $0.value > $1.value {
            return true
        } else if $0.value == $1.value {
            return $0.key < $1.key
        } else {
            return false
        }
    }).map(\.key)

}