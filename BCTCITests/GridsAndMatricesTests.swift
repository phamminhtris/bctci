//
//  GridsAndMatricesTests.swift
//  BCTCITests
//
//  Created by Tri Pham on 8/12/25.
//

import BCTCI
import Testing

extension Array where Element == [Int] {
    func sortedInts() -> [[Int]] {
        self.sorted {
            if $0[0] != $1[0] {
                return $0[0] < $1[0] // Sort by first element
            } else {
                return $0[1] < $1[1] // Then sort by second element
            }
        }
    }
}

struct GridsAndMatricesTests {
    @Test
    func chessMove_givenKingPiece_shouldReturnCorrectResult() {
        let firstBoard = [[0, 0, 0, 1, 0, 0],
                          [0, 1, 1, 1, 0, 0],
                          [0, 1, 0, 1, 1, 0],
                          [1, 1, 1, 1, 0, 0],
                          [0, 0, 0, 0, 0, 0],
                          [0, 1, 0, 0, 0, 0]]
        let expectedResult = [[2, 5], [3, 4], [4, 4], [4, 5]]

        #expect(
            chessMove(
                board: firstBoard,
                piece: .king,
                r: 3,
                c: 5
            ).sortedInts() == expectedResult.sortedInts()
        )

        #expect(
            chessMove(
                board: firstBoard,
                piece: .king,
                r: 2,
                c: 2
            ).sortedInts() == []
        )
    }

    @Test
    func chessMove_givenKnightPiece_shouldReturnCorrectResult() {
        let firstBoard = [[0, 0, 0, 1, 0, 0],
                          [0, 1, 1, 1, 0, 0],
                          [0, 1, 0, 1, 1, 0],
                          [1, 1, 1, 1, 0, 0],
                          [0, 0, 0, 0, 0, 0],
                          [0, 1, 0, 0, 0, 0]]
        let expectedResult = [[2, 2], [3, 5], [5, 5]]

        #expect(
            chessMove(
                board: firstBoard,
                piece: .knight,
                r: 4,
                c: 3
            ).sortedInts() == expectedResult.sortedInts()
        )
    }

    @Test
    func chessMove_givenQueenPiece_shouldReturnCorrectResult() {
        let firstBoard = [[0, 0, 0, 1, 0, 0],
                          [0, 1, 1, 1, 0, 0],
                          [0, 1, 0, 1, 1, 0],
                          [1, 1, 1, 1, 0, 0],
                          [0, 0, 0, 0, 0, 0],
                          [0, 1, 0, 0, 0, 0]]
        let expectedResult = [[3, 4], [3, 5], [4, 0], [4, 1], [4, 2], [4, 3], [4, 5], [5, 3], [5,
                                                                                               4], [5, 5]]

        #expect(
            chessMove(
                board: firstBoard,
                piece: .queen,
                r: 4,
                c: 4
            ).sortedInts() == expectedResult.sortedInts()
        )
    }
}
