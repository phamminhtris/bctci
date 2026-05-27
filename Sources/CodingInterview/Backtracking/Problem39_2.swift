/**
Problem prompt:
Given a set of elements, S, a subset of S is another set obtained by removing any number of elements from S (including none or all of them). As usual with sets, order does not matter.

Given an array of unique characters, S, return all possible subsets in any order.


Example: S = ['x', 'y', 'z']
Output: [[],
         ['x'],
         ['y'],
         ['z'],
         ['x', 'y'],
         ['x', 'z'],
         ['y', 'z'],
         ['x', 'y', 'z']]
Constraints:

The elements in S are unique.
The length of S is at most 12.
*/

func allSubsets(of elements: [Character]) -> [[Character]] {
    var res = [[Character]]() 
    var subset = [Character]() 
    func visit(index: Int) { 
        if index == elements.count {
            res.append(subset)
            return
        }

        subset.append(elements[index])
        visit(index: index + 1)
        subset.removeLast()

        visit(index: index + 1)
    }
    visit(index: 0)
    return res
}
