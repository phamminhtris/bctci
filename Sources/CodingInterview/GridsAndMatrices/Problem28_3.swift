/**
Problem prompt:
Given a positive and odd integer n, return an nxn grid of integers filled as follows: the grid should have every number from 0 to n^2 - 1 in spiral order, starting by going down from the center and turning clockwise.

Example 1:
n = 5
Output: [[16, 17, 18, 19, 20],
         [15,  4,  5,  6, 21],
         [14,  3,  0,  7, 22],
         [13,  2,  1,  8, 23],
         [12, 11, 10,  9, 24]]

Example 2:
n = 1
Output: [[0]]

Example 3:
n = 3
Output: [[4, 5, 6],
         [3, 0, 7],
         [2, 1, 8]]

Constraints:
- 0 < n < 1000
- n is odd
*/

/// Builds the n x n clockwise spiral described in the prompt.
///
/// - Parameter n: Odd grid size, 0 < n < 1000.
/// - Returns: An n x n grid holding every value in 0..<(n * n) in spiral order.
func spiralGrid(n: Int) -> [[Int]] {
    precondition(n > 0 && n < 1000, "n must satisfy 0 < n < 1000")
    precondition(n % 2 == 1, "n must be odd")

    let unvisited = -1
    var res = Array(repeating: Array(repeating: unvisited, count: n), count: n)
    let directions = [
        (dr: -1, dc: 0), // up
        (dr: 0, dc: -1), // left
        (dr: 1, dc: 0), // down
        (dr: 0, dc: 1) // right
    ]
    var directionIndex = 0

    func canVisit(r: Int, c: Int) -> Bool {
        r >= 0 && r < n && c >= 0 && c < n && res[r][c] == unvisited
    }

    // Walk the spiral in reverse: start at the bottom-right holding the largest
    // value and step inward, so the walk finishes on the center holding 0.
    var r = n - 1
    var c = n - 1
    for current in stride(from: n * n - 1, through: 1, by: -1) {
        res[r][c] = current
        var (dr, dc) = directions[directionIndex]
        // The spiral never doubles back, so one turn always finds the next cell.
        if !canVisit(r: r + dr, c: c + dc) {
            directionIndex = (directionIndex + 1) % directions.count
            (dr, dc) = directions[directionIndex]
        }
        r += dr
        c += dc
    }
    res[n / 2][n / 2] = 0

    return res
}
