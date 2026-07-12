import Testing
@testable import CodingInterview

struct Problem28_1Tests {
    let board = [
        [0, 0, 0, 1, 0, 0],
        [0, 1, 1, 1, 0, 0],
        [0, 1, 0, 1, 1, 0],
        [1, 1, 1, 1, 0, 0],
        [0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0]
    ]

    @Test("King moves from [3, 5]")
    func kingMoves() {
        let result = chessPieceMoves(board: board, piece: .king, r: 3, c: 5)
        let expected: [[Int]] = [[2, 5], [3, 4], [4, 4], [4, 5]]
        #expect(Set(result.map { "\($0[0]),\($0[1])" }) == Set(expected.map { "\($0[0]),\($0[1])" }))
    }

    @Test("Knight moves from [4, 3]")
    func knightMoves() {
        let result = chessPieceMoves(board: board, piece: .knight, r: 4, c: 3)
        let expected: [[Int]] = [[2, 2], [3, 5], [5, 5]]
        #expect(Set(result.map { "\($0[0]),\($0[1])" }) == Set(expected.map { "\($0[0]),\($0[1])" }))
    }

    @Test("Queen moves from [4, 4]")
    func queenMoves() {
        let result = chessPieceMoves(board: board, piece: .queen, r: 4, c: 4)
        let expected: [[Int]] = [[3, 4], [3, 5], [4, 0], [4, 1], [4, 2], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]]
        #expect(Set(result.map { "\($0[0]),\($0[1])" }) == Set(expected.map { "\($0[0]),\($0[1])" }))
    }

    @Test("Edge case - 1x1 board")
    func singleCellBoard() {
        let result = chessPieceMoves(board: [[0]], piece: .queen, r: 0, c: 0)
        #expect(result.isEmpty)
    }

    @Test("Edge case - all occupied except current position")
    func allOccupiedExceptCurrent() {
        let result = chessPieceMoves(board: [[1, 1], [1, 0]], piece: .knight, r: 1, c: 1)
        #expect(result.isEmpty)
    }

    /// Compares reachable-cell lists ignoring order, while still catching
    /// duplicate cells (a plain `Set` comparison would silently hide those).
    private func expectCells(_ result: [[Int]], _ expected: [[Int]]) {
        func sorted(_ cells: [[Int]]) -> [[Int]] {
            cells.sorted { $0.lexicographicallyPrecedes($1) }
        }
        #expect(sorted(result) == sorted(expected))
    }

    @Test("King reachable cells", arguments: [
        // All eight neighbours free from the centre of a 3x3.
        (board: [[0, 0, 0], [0, 0, 0], [0, 0, 0]], r: 1, c: 1,
         expected: [[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]]),
        // Corner: only three neighbours stay on the board.
        (board: [[0, 0, 0], [0, 0, 0], [0, 0, 0]], r: 0, c: 0,
         expected: [[0, 1], [1, 0], [1, 1]]),
        // Occupied diagonals are skipped; the orthogonal neighbours remain.
        (board: [[1, 0, 1], [0, 0, 0], [1, 0, 1]], r: 1, c: 1,
         expected: [[0, 1], [1, 0], [1, 2], [2, 1]]),
    ])
    func kingReachableCells(board: [[Int]], r: Int, c: Int, expected: [[Int]]) {
        expectCells(chessPieceMoves(board: board, piece: .king, r: r, c: c), expected)
    }

    @Test("Knight reachable cells", arguments: [
        // Centre of an empty 5x5: all eight L-moves land on the board.
        (board: [[0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0]], r: 2, c: 2,
         expected: [[0, 1], [0, 3], [1, 0], [1, 4], [3, 0], [3, 4], [4, 1], [4, 3]]),
        // Corner: only two L-moves stay in bounds.
        (board: [[0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0]], r: 0, c: 0,
         expected: [[1, 2], [2, 1]]),
        // Jumps over the occupied ring around it; the (0,3) landing is blocked.
        (board: [[0, 0, 0, 1, 0],
                 [0, 1, 1, 1, 0],
                 [0, 1, 0, 1, 0],
                 [0, 1, 1, 1, 0],
                 [0, 0, 0, 0, 0]], r: 2, c: 2,
         expected: [[0, 1], [1, 0], [1, 4], [3, 0], [3, 4], [4, 1], [4, 3]]),
    ])
    func knightReachableCells(board: [[Int]], r: Int, c: Int, expected: [[Int]]) {
        expectCells(chessPieceMoves(board: board, piece: .knight, r: r, c: c), expected)
    }

    @Test("Queen reachable cells", arguments: [
        // Empty 5x5: rays extend to every edge in all eight directions.
        (board: [[0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0],
                 [0, 0, 0, 0, 0]], r: 2, c: 2,
         expected: [[0, 0], [0, 2], [0, 4], [1, 1], [1, 2], [1, 3],
                    [2, 0], [2, 1], [2, 3], [2, 4],
                    [3, 1], [3, 2], [3, 3], [4, 0], [4, 2], [4, 4]]),
        // A ray stops before the blocker and never passes through it.
        (board: [[0, 0, 1, 0, 0]], r: 0, c: 0,
         expected: [[0, 1]]),
        // Every ray is blocked on its first step -> no reachable cells.
        (board: [[1, 1, 1], [1, 0, 1], [1, 1, 1]], r: 1, c: 1,
         expected: []),
    ])
    func queenReachableCells(board: [[Int]], r: Int, c: Int, expected: [[Int]]) {
        expectCells(chessPieceMoves(board: board, piece: .queen, r: r, c: c), expected)
    }
}
