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
    let numRow = grid.count
    let numCol = grid[0].count
    var cache = [[Int]](repeating: Array<Int>(repeating: 0, count: numCol), count: numRow)
    for r in 0..<numRow { 
        for c in 0..<numCol {
            if r == 0 && c == 0 {
                cache[r][c] = grid[r][c]
            } else if r == 0 { 
                cache[r][c] = cache[r][c - 1] + grid[r][c]
            } else if c == 0 {
                cache[r][c] = cache[r - 1][c] + grid[r][c]
            } else {
                cache[r][c] = grid[r][c] + max(cache[r - 1][c], cache[r][c - 1]) 
            }
        }
    }
    return cache[numRow - 1][numCol - 1]
}
