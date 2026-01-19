import Foundation
/**
Implement a class, Checker, that receives a strings upon initialization. The class must support a method, expands_into(s2), which takes another string and checks if s2 can be formed by adding exactly one letter to s1 and reordering the letters. All letters in both strings are lowercase alphabetical characters.
*/
struct Checker {
    let s: String
    
    init(_ s: String) {
        self.s = s
    }

    func expandsInto(_ s2: String) -> Bool {
        if self.s.count != s2.count - 1 {
            return false
        }

        var freqMap: [Character: Int] = [:]
        for char in s2 { 
            freqMap[char, default: 0] += 1
        }

        for char in s {
            if let count = freqMap[char] {
                if count == 1 {
                    freqMap[char] = nil
                } else {
                    freqMap[char] = count - 1
                }
            } else {
                return false
            }
        }
        return freqMap.count == 1 && freqMap.values.first == 1
    }
}