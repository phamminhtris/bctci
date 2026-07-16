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

    // Stub: correct shape, no spiral logic yet.
    return Array(repeating: Array(repeating: 0, count: n), count: n)
}
