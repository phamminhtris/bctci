/**
Problem prompt:
Given a non-empty grid of positive integers, grid, find the path from the top-left corner to the bottom-right corner with the largest sum. You can only go down or to the right (not diagonal).


Example 1: grid = [[1, 4, 3],
                   [2, 7, 6],
                   [5, 8, 9]]
Output: 29. The maximum path is 1 -> 4 -> 7 -> 8 -> 9.

Example 2: grid = [[5]]
Output: 5

Example 3: grid = [[1, 2, 3]]
Output: 6. The maximum path is 1 -> 2 -> 3.
Constraints:

1 <= R, C <= 1000, where R is the number of rows and C is the number of columns in the grid.
1 <= grid[i][j] <= 1000.
*/

func maximumPathSum(in grid: [[Int]]) -> Int {
    var maxPath = 0
    let numRow = grid.count
    let numCol = grid[0].count
    func visit(r: Int, c: Int, currentSum: Int) {
        if r == numRow - 1 && c == numCol - 1 { 
            // bottom right cell 
            maxPath = max(currentSum + grid[r][c], maxPath)
        } else {
            let newSum = currentSum + grid[r][c]
            if r + 1 < numRow {
                visit(r: r + 1, c: c, currentSum: newSum)
            }
            if c + 1 < numCol {
                visit(r: r, c: c + 1, currentSum: newSum)
            }
        }
    }
    visit(r: 0, c: 0, currentSum: 0)
    return maxPath
}
