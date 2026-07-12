import Testing
@testable import CodingInterview

struct Problem28_2Tests {
    @Test("Examples from the prompt", arguments: [
        // Queens on the two opposite corners of the anti-diagonal.
        (board: [[0, 0, 0, 1],
                 [0, 0, 0, 0],
                 [0, 0, 0, 0],
                 [1, 0, 0, 0]],
         expected: [[1, 1, 1, 1],
                    [1, 0, 1, 1],
                    [1, 1, 0, 1],
                    [1, 1, 1, 1]]),
        // The only cell holds a queen, so it is not safe.
        (board: [[1]], expected: [[1]]),
        // No queens at all, so every cell is safe.
        (board: [[0]], expected: [[0]]),
    ])
    func promptExamples(board: [[Int]], expected: [[Int]]) {
        #expect(queensReach(board: board) == expected)
    }

    @Test("Single queen covers its row, column, and both diagonals", arguments: [
        // Queen at [1, 1] on a 4x4 board: cells off all four of its lines stay safe.
        (board: [[0, 0, 0, 0],
                 [0, 1, 0, 0],
                 [0, 0, 0, 0],
                 [0, 0, 0, 0]],
         expected: [[1, 1, 1, 0],
                    [1, 1, 1, 1],
                    [1, 1, 1, 0],
                    [0, 1, 0, 1]]),
        // Queen in a corner: the far corner of the other diagonal is out of reach.
        (board: [[1, 0, 0],
                 [0, 0, 0],
                 [0, 0, 0]],
         expected: [[1, 1, 1],
                    [1, 1, 0],
                    [1, 0, 1]]),
        // A queen anywhere in a single row reaches the whole row.
        (board: [[0, 0, 1, 0, 0]], expected: [[1, 1, 1, 1, 1]]),
    ])
    func singleQueenCoverage(board: [[Int]], expected: [[Int]]) {
        #expect(queensReach(board: board) == expected)
    }

    @Test("Boards with no safe cells or all safe cells", arguments: [
        // Every cell holds a queen.
        (board: [[1, 1], [1, 1]], expected: [[1, 1], [1, 1]]),
        // A queen in the centre of a 3x3 reaches every other cell.
        (board: [[0, 0, 0],
                 [0, 1, 0],
                 [0, 0, 0]],
         expected: [[1, 1, 1],
                    [1, 1, 1],
                    [1, 1, 1]]),
        // Empty board: every cell is safe.
        (board: [[0, 0, 0],
                 [0, 0, 0],
                 [0, 0, 0]],
         expected: [[0, 0, 0],
                    [0, 0, 0],
                    [0, 0, 0]]),
    ])
    func saturatedAndEmptyBoards(board: [[Int]], expected: [[Int]]) {
        #expect(queensReach(board: board) == expected)
    }

    @Test("Multiple queens combine their coverage")
    func multipleQueens() {
        let board = [[0, 0, 0, 0, 0],
                     [0, 1, 0, 0, 0],
                     [0, 0, 0, 0, 0],
                     [0, 0, 0, 0, 1],
                     [0, 0, 0, 0, 0]]
        // [1, 1] covers row 1, column 1, and its diagonals; [3, 4] covers row 3,
        // column 4, and its diagonals. Only [0, 3], [4, 0], and [4, 2] survive.
        let expected = [[1, 1, 1, 0, 1],
                        [1, 1, 1, 1, 1],
                        [1, 1, 1, 1, 1],
                        [1, 1, 1, 1, 1],
                        [0, 1, 0, 1, 1]]
        #expect(queensReach(board: board) == expected)
    }

    @Test("Large board with a single queen keeps distant cells safe")
    func largeBoard() {
        let n = 100
        var board = Array(repeating: Array(repeating: 0, count: n), count: n)
        board[0][0] = 1
        let result = queensReach(board: board)
        #expect(result[0][0] == 1)
        #expect(result[0][99] == 1)
        #expect(result[99][0] == 1)
        #expect(result[99][99] == 1)
        #expect(result[1][2] == 0)
        #expect(result[98][99] == 0)
    }
}
