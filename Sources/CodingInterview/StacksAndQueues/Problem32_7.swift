/**
Given a string, s, and an array of strings, brackets, where each element consists of two characters, representing matching opening and closing brackets, return whether s is balanced according to those brackets:

Characters not in brackets do not affect whether s is balanced.
A pair of matching brackets of one type cannot surround only half of a matching pair of another type of brackets.
Assume that brackets does not contain any repeated characters.

Example 1: s = "((a+b)*[c-d]-{e/f})", brackets = ["()", "[]", "{}"]
Output: True

Example 2: s = "()[}", brackets = ["()", "[]", "{}"]
Output: False

Example 3: s = "([)]", brackets = ["()", "[]", "{}"]
Output: False

Example 4: s = "<div> hello :) </div>", brackets = ["<>", "()"]
Output: False

Example 5: s = ")))(()((", brackets = [")("]
Output: True
*/



func balanceCustomBrackets(s: String, brackets: [String]) -> Bool {
    var lookupDict = [Character: (Character, Bool)]()
    // value is matching pair and whether or not it is opening
    for pair in brackets {
        // Assume that pair are valid we can add checking if necessary
        lookupDict[pair.first!] = (pair.last!, true)
        lookupDict[pair.last!] = (pair.first!, false)
    }

    var stack = [Character]()
    for char in s {
        if let (matching, isOpening) = lookupDict[char] {
            if isOpening {
                stack.append(char)
            } else {
                if stack.last == matching {
                    stack.popLast()
                } else {
                    return false
                }
            }
        }
    }

    return stack.isEmpty
}