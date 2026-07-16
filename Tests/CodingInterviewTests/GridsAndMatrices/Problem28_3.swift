import Testing
@testable import CodingInterview

struct Problem28_3Tests {
    @Test("Examples from the prompt", arguments: [
        (n: 1, expected: [[0]]),
        (n: 3, expected: [[4, 5, 6],
                          [3, 0, 7],
                          [2, 1, 8]]),
        (n: 5, expected: [[16, 17, 18, 19, 20],
                          [15,  4,  5,  6, 21],
                          [14,  3,  0,  7, 22],
                          [13,  2,  1,  8, 23],
                          [12, 11, 10,  9, 24]]),
    ])
    func promptExamples(n: Int, expected: [[Int]]) {
        #expect(spiralGrid(n: n) == expected)
    }

    @Test("Grid is n x n", arguments: [1, 3, 5, 7, 9, 51])
    func gridDimensions(n: Int) {
        let grid = spiralGrid(n: n)
        #expect(grid.count == n)
        #expect(grid.allSatisfy { $0.count == n })
    }

    @Test("Every value in 0..<n*n appears exactly once", arguments: [1, 3, 5, 7, 9, 51])
    func valuesArePermutation(n: Int) {
        let values = spiralGrid(n: n).flatMap { $0 }.sorted()
        #expect(values == Array(0..<(n * n)))
    }

    @Test("Spiral starts at the center and steps down first", arguments: [3, 5, 7, 9, 51])
    func startsAtCenterGoingDown(n: Int) {
        let grid = spiralGrid(n: n)
        let center = n / 2
        // 0 sits in the center, and the first step is downward, so 1 is the cell below.
        #expect(grid[center][center] == 0)
        #expect(grid[center + 1][center] == 1)
        // The first clockwise turn from "down" is to the left, so 2 sits there.
        #expect(grid[center + 1][center - 1] == 2)
    }

    @Test("Spiral ends in the bottom-right corner", arguments: [1, 3, 5, 7, 9, 51])
    func endsInBottomRightCorner(n: Int) {
        let grid = spiralGrid(n: n)
        // The outermost ring is walked last and finishes at the bottom-right cell.
        #expect(grid[n - 1][n - 1] == n * n - 1)
    }

    @Test("Largest allowed odd n stays consistent")
    func largestAllowedN() {
        let n = 999
        let grid = spiralGrid(n: n)
        let center = n / 2
        #expect(grid.count == n)
        #expect(grid[center][center] == 0)
        #expect(grid[center + 1][center] == 1)
        #expect(grid[n - 1][n - 1] == n * n - 1)
        #expect(Set(grid.flatMap { $0 }).count == n * n)
    }
}
