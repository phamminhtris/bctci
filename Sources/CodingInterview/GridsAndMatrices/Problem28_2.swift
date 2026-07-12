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
