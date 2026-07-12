/**
Problem prompt:
Imagine that an n x n chessboard has a number of queens in it. Remember that in chess, a queen can move any number of cells horizontally, vertically, or diagonally.

We are given an nxn binary grid, board, with n > 0, where 0 indicates that the cell is unoccupied, and a 1 indicates a queen (the color of the queen doesn't matter). Return a binary board with the same dimensions. In the returned board, 0 denotes that a cell is 'safe', and a 1 denotes that a cell is not safe. A cell is safe if there isn't a queen in it and no queen on the board can reach it in a single move.

Example 1:
board = [[0, 0, 0, 1],
         [0, 0, 0, 0],
         [0, 0, 0, 0],
         [1, 0, 0, 0]]
Output: [[1, 1, 1, 1],
         [1, 0, 1, 1],
         [1, 1, 0, 1],
         [1, 1, 1, 1]]

Example 2:
board = [[1]]
Output: [[1]]
Explanation: The only cell has a queen, so it's not safe.

Example 3:
board = [[0]]
Output: [[0]]
Explanation: With no queens, all cells are safe.

Constraints:
- 1 ≤ n ≤ 100
- board[i][j] is either 0 or 1
*/

let directionOffset: [(Int, Int)] = [
        (-1, -1), (-1, 0), (-1, 1), 
        (0, -1), (0, 1),
        (1, -1), (1, 0), (1, 1)
]

struct Loc: Hashable {
    let r: Int
    let c: Int
}

func queensReach(board: [[Int]]) -> [[Int]] {
    var res = board

    for r in 0..<board.count {
        for c in 0..<board[0].count {
            if board[r][c] == 1 {
                markUnsafe(board: &res, r: r, c: c)
            }
        } 
    }
    return res
}

func markUnsafe(board: inout [[Int]], r: Int, c: Int) {
    for (offsetR, offsetC) in directionOffset {
        var nr = r + offsetR
        var nc = c + offsetC
        while nr >= 0 && nr < board.count
            && nc >= 0 && nc < board[0].count {
                board[nr][nc] = 1
                nr = nr + offsetR
                nc = nc + offsetC
        }
    }
}

/// Same result as `queensReach`, but O(rows * cols) instead of walking a ray
/// out of every queen (which is O(rows * cols * n) on a queen-heavy board).
///
/// A cell is unsafe exactly when it shares a row, a column, or one of the two
/// diagonals with some queen. Blocking never changes that: if queen A's ray to
/// cell C is blocked by queen B, then B lies on the same line between them, so
/// B — or the last queen before C — reaches C itself. So we only need to know
/// *which lines hold a queen*, never how far each queen actually travels.
/// Each cell sits on exactly one "\" diagonal and one "/" diagonal, and each of
/// those has a natural name: stepping along a "\" keeps `r - c` constant, and
/// stepping along a "/" keeps `r + c` constant. So a queen at (r, c) "owns" row
/// r, column c, diagonal `r - c`, and anti-diagonal `r + c` — and a cell is
/// unsafe exactly when it lands on a line some queen owns.
func queensReachOptimized(board: [[Int]]) -> [[Int]] {
    let rows = board.count
    guard rows > 0, let cols = board.first?.count, cols > 0 else { return board }

    var rowsWithQueen = Set<Int>()
    var columnsWithQueen = Set<Int>()
    var diagonalsWithQueen = Set<Int>()      // named by r - c
    var antiDiagonalsWithQueen = Set<Int>()  // named by r + c

    for r in 0..<rows {
        for c in 0..<cols where board[r][c] == 1 {
            rowsWithQueen.insert(r)
            columnsWithQueen.insert(c)
            diagonalsWithQueen.insert(r - c)
            antiDiagonalsWithQueen.insert(r + c)
        }
    }

    var res = board
    for r in 0..<rows {
        for c in 0..<cols {
            let isUnsafe = rowsWithQueen.contains(r)
                || columnsWithQueen.contains(c)
                || diagonalsWithQueen.contains(r - c)
                || antiDiagonalsWithQueen.contains(r + c)
            res[r][c] = isUnsafe ? 1 : 0
        }
    }
    return res
}
