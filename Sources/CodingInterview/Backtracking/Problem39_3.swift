/**
Problem prompt:
A permutation of a list is a list with the same elements but in any order. Finding all permutations means finding all possible orderings of the input elements.

Given an array of unique characters, arr, return all possible permutations, in any order.


Example 1: arr = ['x', 'y', 'z']
Output: [['x', 'y', 'z'],
         ['x', 'z', 'y'],
         ['y', 'x', 'z'],
         ['y', 'z', 'x'],
         ['z', 'x', 'y'],
         ['z', 'y', 'x']]

Example 2: arr = ['x']
Output: [['x']]
Constraints:

The elements in arr are unique.
The length of arr is at most 10.
*/

func allPermutations(of elements: [Character]) -> [[Character]] {
    var res = [[Character]]() 
    var perm = elements 
    func visit(i: Int) {
        if i == elements.count - 1 {
            res.append(perm)
        } else {
            for j in i..<elements.count {
                perm.swapAt(i, j)
                visit(i: i + 1)
                perm.swapAt(i, j)
            }
        }
    }
    visit(i: 0)
    return res
}
