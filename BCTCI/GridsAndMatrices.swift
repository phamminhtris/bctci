//
//  GridsAndMatrices.swift
//  BCTCI
//
//  Created by Tri Pham on 8/12/25.
//

import Foundation

/**
 Problem 28.1
 
 The king can go to any adjacent cell, including diagonals. The knight 'jumps' one cell in one dimension and two in the other, even if there are pieces in between. The queen can move any number of cells in any direction, including diagonals, but cannot go through occupied cells.
 
 We are given three inputs:
 
 board, an nxn binary grid, where a 0 denotes an empty cell, 1 denotes an occupied cell (for this problem, it doesn't matter what piece is in it)
 piece, which is one of "king", "knight", or "queen"
 r and c, with 0 ≤ r < n and 0 ≤ c < n, which denote an unoccupied position in the board
 Return a list of all the unoccupied cells in board that can be reached by the given piece in one move starting from [r, c]. The order of the output cells does not matter.
 */

public enum Piece {
    case king, knight, queen
}

public extension Piece {
    var directions: [(Int, Int)] {
        switch self {
        case .king:
            return [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]
        case .knight:
            return [(-2, -1), (-2, 1), (-1, -2), (-1, 2), (1, -2), (1, 2), (2, -1), (2, 1)]
        case .queen:
            // queen can move like king but more steps
            return [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]
        }
    }
}

public func chessMove(board: [[Int]], piece: Piece, r: Int, c: Int) -> [[Int]] {
    
    func isValidMove(board: [[Int]], r: Int, c: Int) -> Bool {
        return r >= 0 && r < board.count && c >= 0 && c < board[0].count && board[r][c] == 0
    }
    
    var results = [[Int]]()
    switch piece {
    case .king, .knight:
        for (dr, dc) in piece.directions {
            if isValidMove(board: board, r: r + dr, c: c + dc) {
                results.append([r + dr, c + dc])
            }
        }
    case .queen:
        for (dr, dc) in piece.directions {
            var nr = r, nc = c
            while true {
                nr += dr
                nc += dc
                if isValidMove(board: board, r: nr, c: nc) {
                    results.append([nr, nc])
                } else {
                    break
                }
            }
        }
    }
    return results
}
