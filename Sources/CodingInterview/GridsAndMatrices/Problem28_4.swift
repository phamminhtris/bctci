/**
Problem prompt:
We are tracking Elsa, an arctic fox, through a rectangular snowy field represented by a binary grid, field, where 1 denotes snowprints and 0 denotes no snowprints. We know that the fox crossed the field from left to right, so each column has exactly one 1. Between two consecutive columns, the row of the 1 may remain the same, go up by one, or go down by one. Above the field (above the first row), there is an icy river. Return how close the fox got to the river, in terms of the number of rows between it and the river.

Example 1:
field = [[0, 0, 0, 0, 0, 0],
         [0, 0, 1, 0, 0, 0],
         [1, 1, 0, 1, 0, 0],
         [0, 0, 0, 0, 1, 1]]
Output: 1
Explanation: The fox was closest to the river at column 2 (0-based), where it
was 1 row away.

Example 2:
field = [[0, 0, 0, 1, 0, 0],
         [0, 0, 1, 0, 1, 0],
         [1, 1, 0, 0, 0, 1],
         [0, 0, 0, 0, 0, 0]]
Output: 0
Explanation: The fox touched row 0, which is right next to the river.

Example 3:
field = [[1, 1, 1]]
Output: 0
Explanation: The fox stayed in row 0 the whole time.

Constraints:
- 1 ≤ R, C ≤ 1000, where R is the number of rows and C is the number of columns
- field[i][j] is either 0 or 1
- Each column has exactly one 1
- The fox's path is valid (moves at most one row up/down between columns)
*/

/// Returns how close Elsa the fox got to the river: the smallest row index
/// (0-based, counted from the field's top edge) that any of her snowprints
/// touched.
///
/// - Parameter field: An R x C binary grid with exactly one `1` per column.
/// - Returns: The minimum row index containing a `1` across all columns.
func closestApproachToRiver(field: [[Int]]) -> Int {
    let rows = field.count
    precondition(rows > 0, "field must have at least one row")
    let columns = field[0].count
    precondition(columns > 0, "field must have at least one column")

    // The fox starts wherever column 0's lone snowprint sits.
    var row = field.firstIndex { $0[0] == 1 }!
    var minRow = row

    // Each subsequent column holds exactly one snowprint, one step up, level,
    // or down from the previous one. Walk the path column by column; the loop
    // count is fixed, so it always terminates.
    for column in 1..<columns {
        for rowDelta in [-1, 0, 1] {
            let candidate = row + rowDelta
            if candidate >= 0 && candidate < rows && field[candidate][column] == 1 {
                row = candidate
                break
            }
        }
        minRow = min(minRow, row)
    }

    return minRow
}
