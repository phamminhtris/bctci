import Testing
@testable import CodingInterview

struct Problem28_4Tests {
    /// Builds an `rows` x `printRows.count` field where column `j` has its
    /// lone snowprint at row `printRows[j]`.
    private func makeField(rows: Int, printRows: [Int]) -> [[Int]] {
        var field = Array(repeating: Array(repeating: 0, count: printRows.count), count: rows)
        for (column, row) in printRows.enumerated() {
            field[row][column] = 1
        }
        return field
    }

    @Test("Examples from the prompt", arguments: [
        (field: [[0, 0, 0, 0, 0, 0],
                 [0, 0, 1, 0, 0, 0],
                 [1, 1, 0, 1, 0, 0],
                 [0, 0, 0, 0, 1, 1]],
         expected: 1),
        (field: [[0, 0, 0, 1, 0, 0],
                 [0, 0, 1, 0, 1, 0],
                 [1, 1, 0, 0, 0, 1],
                 [0, 0, 0, 0, 0, 0]],
         expected: 0),
        (field: [[1, 1, 1]], expected: 0),
    ])
    func promptExamples(field: [[Int]], expected: Int) {
        #expect(closestApproachToRiver(field: field) == expected)
    }

    @Test("A single-column field reports that column's own row", arguments: [
        (printRow: 0, rows: 3),
        (printRow: 1, rows: 3),
        (printRow: 2, rows: 3),
    ])
    func singleColumnField(printRow: Int, rows: Int) {
        let field = makeField(rows: rows, printRows: [printRow])
        #expect(closestApproachToRiver(field: field) == printRow)
    }

    @Test("A single-row field always reads as touching the river")
    func singleRowField() {
        let field = makeField(rows: 1, printRows: [0, 0, 0, 0])
        #expect(closestApproachToRiver(field: field) == 0)
    }

    @Test("A path that never leaves the bottom row stays as far as possible from the river")
    func pathStaysFarFromRiver() {
        let field = makeField(rows: 3, printRows: [2, 2, 2, 2])
        #expect(closestApproachToRiver(field: field) == 2)
    }

    @Test("A path that dips to the top row partway through touches the river")
    func pathDipsToRiverMidCrossing() {
        let field = makeField(rows: 4, printRows: [3, 2, 1, 0, 1, 2])
        #expect(closestApproachToRiver(field: field) == 0)
    }

    @Test("Largest allowed field stays consistent when the fox never nears the river")
    func largestAllowedFieldFarFromRiver() {
        let rows = 1000
        let printRows = Array(repeating: rows - 1, count: 1000)
        let field = makeField(rows: rows, printRows: printRows)
        #expect(closestApproachToRiver(field: field) == rows - 1)
    }
}
