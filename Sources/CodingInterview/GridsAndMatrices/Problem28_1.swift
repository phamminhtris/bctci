/**
Problem prompt:

For context, this is how the King, Knight, and Queen move on a chessboard:
- The king can go to any adjacent cell, including diagonals.
- The knight 'jumps' one cell in one dimension and two in the other, even if there are pieces in between.
- The queen can move any number of cells in any direction, including diagonals, but cannot go through occupied cells.

We are given three inputs:
- board: an nxn binary grid, where a 0 denotes an empty cell, 1 denotes an occupied cell
- piece: one of king, knight, or queen
- r and c: with 0 ≤ r < n and 0 ≤ c < n, which denote an unoccupied position in the board

Return a list of all the unoccupied cells in board that can be reached by the given piece in one move starting from [r, c]. The order of the output cells does not matter.

Constraints:
- 1 ≤ n ≤ 100
- board[i][j] is either 0 or 1
- 0 ≤ r, c < n
- piece is one of king, knight, or queen
*/

enum ChessPiece {
    case king
    case knight
    case queen

    var directionOffsets: [(Int, Int)] {
        switch self {
        case .king, .queen:
            var offsets = [(Int, Int)]()
            for dr in -1...1 {
                for dc in -1...1 {
                    if dr == 0, dc == 0 { continue }
                    offsets.append((dr, dc))
                }
            }
            return offsets
        case .knight:
            return [
                (-2, -1), (-2, 1), (-1, 2), (1, 2),
                (2, 1), (2, -1), (1, -2), (-1, -2)
            ]
        }
    }
}

func chessPieceMoves(board: [[Int]], piece: ChessPiece, r: Int, c: Int) -> [[Int]] {
    func isValidMove(r: Int, c: Int) -> Bool {
        return r >= 0 && r < board.count
            && c >= 0 && c < board[0].count
            && board[r][c] != 1
    }
    var res = [[Int]]()
    switch piece {
    case .knight, .king:
        for (dr, dc) in piece.directionOffsets {
            let nr = r + dr
            let nc = c + dc
            if isValidMove(r: nr, c: nc) {
                res.append([nr, nc])
            }
        }
    case .queen:
        for (dr, dc) in piece.directionOffsets {
            var nr = r + dr
            var nc = c + dc
            while isValidMove(r: nr, c: nc) {
                res.append([nr, nc])
                nr += dr
                nc += dc
            }
        }
    }
    return res
}
