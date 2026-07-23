import Testing
@testable import CodingInterview

struct Problem29_4Tests {
    struct ExactInput {
        let name: String
        let sortedArr: [Int]
        let unsortedArr: [Int]
        let expected: [Int]
    }

    struct PairInput {
        let name: String
        let sortedArr: [Int]
        let unsortedArr: [Int]
    }

    @Test(
        "Problem 29.4 - zeroSumPair finds the only zero-sum pair",
        arguments: [
            ExactInput(
                name: "prompt example 1",
                sortedArr: [-5, -4, -1, 4, 6, 6, 7],
                unsortedArr: [-3, 7, 18, 4, 6],
                expected: [1, 3]
            ),
            ExactInput(
                name: "single element in each array",
                sortedArr: [5],
                unsortedArr: [-5],
                expected: [0, 0]
            ),
            ExactInput(
                name: "match at the first sorted index",
                sortedArr: [-9, -3, 2, 8],
                unsortedArr: [1, 9, 4],
                expected: [0, 1]
            ),
            ExactInput(
                name: "match at the last sorted index",
                sortedArr: [-7, -2, 3, 10],
                unsortedArr: [5, -10, 8],
                expected: [3, 1]
            ),
            ExactInput(
                name: "match at the last unsorted index",
                sortedArr: [-4, -1, 6],
                unsortedArr: [2, 3, 4],
                expected: [0, 2]
            ),
            ExactInput(
                name: "zero pairs with zero",
                sortedArr: [0, 1, 2],
                unsortedArr: [3, 0],
                expected: [0, 1]
            ),
            ExactInput(
                name: "constraint bounds",
                sortedArr: [-1_000_000_000, 0, 999_999_999],
                unsortedArr: [1_000_000_000, 7],
                expected: [0, 0]
            )
        ]
    )
    func testFindsUniquePair(_ testCase: ExactInput) {
        #expect(zeroSumPair(testCase.sortedArr, testCase.unsortedArr) == testCase.expected, "\(testCase.name)")
    }

    @Test(
        "Problem 29.4 - zeroSumPair returns some valid pair when several exist",
        arguments: [
            PairInput(
                name: "prompt example 3, three valid pairs",
                sortedArr: [-2, 0, 1, 2],
                unsortedArr: [0, 2, -2, 4]
            ),
            PairInput(
                name: "fully symmetric arrays",
                sortedArr: [-3, -2, -1, 1, 2, 3],
                unsortedArr: [3, 2, 1, -1, -2, -3]
            ),
            PairInput(
                name: "two candidates on opposite ends",
                sortedArr: [-8, -5, 0, 5, 8],
                unsortedArr: [8, 100, -8]
            )
        ]
    )
    func testFindsSomeValidPair(_ testCase: PairInput) {
        let result = zeroSumPair(testCase.sortedArr, testCase.unsortedArr)

        guard result.count == 2 else {
            Issue.record("\(testCase.name): expected two indices, got \(result)")
            return
        }

        let sortedIndex = result[0]
        let unsortedIndex = result[1]

        guard testCase.sortedArr.indices.contains(sortedIndex),
              testCase.unsortedArr.indices.contains(unsortedIndex) else {
            Issue.record("\(testCase.name): indices \(result) are out of range")
            return
        }

        let sum = testCase.sortedArr[sortedIndex] + testCase.unsortedArr[unsortedIndex]
        #expect(sum == 0, "\(testCase.name): \(testCase.sortedArr[sortedIndex]) + \(testCase.unsortedArr[unsortedIndex]) != 0")
    }

    @Test(
        "Problem 29.4 - zeroSumPair reports no pair as [-1, -1]",
        arguments: [
            PairInput(
                name: "prompt example 2",
                sortedArr: [1, 2, 3],
                unsortedArr: [1, 2, 3]
            ),
            PairInput(
                name: "single element in each array, no match",
                sortedArr: [1],
                unsortedArr: [1]
            ),
            PairInput(
                name: "negations fall between sorted elements",
                sortedArr: [-5, -3, -1],
                unsortedArr: [2, 4, 6]
            ),
            PairInput(
                name: "zero present on only one side",
                sortedArr: [0, 4],
                unsortedArr: [1, 2, 3]
            ),
            PairInput(
                name: "negation below the sorted range",
                sortedArr: [3, 4, 5],
                unsortedArr: [10, 20]
            ),
            PairInput(
                name: "negation above the sorted range",
                sortedArr: [-5, -4, -3],
                unsortedArr: [-10, -20]
            ),
            PairInput(
                name: "constraint bounds, no match",
                sortedArr: [-1_000_000_000],
                unsortedArr: [-1_000_000_000]
            )
        ]
    )
    func testReportsMissingPair(_ testCase: PairInput) {
        #expect(zeroSumPair(testCase.sortedArr, testCase.unsortedArr) == [-1, -1], "\(testCase.name)")
    }

    @Test("Problem 29.4 - zeroSumPair finds a match anywhere in the sorted array")
    func testEveryMatchPosition() {
        // Odd values only, so every even negation probed below is guaranteed absent.
        let sortedArr = (0..<200).map { 2 * $0 + 1 }

        let wrongCount = sortedArr.indices.count { matchIndex in
            let unsortedArr = [4, 8, 12, -sortedArr[matchIndex], 16]
            return zeroSumPair(sortedArr, unsortedArr) != [matchIndex, 3]
        }

        #expect(wrongCount == 0, "\(wrongCount) of \(sortedArr.count) match positions resolved incorrectly")
    }

    @Test("Problem 29.4 - zeroSumPair handles a large input with one match")
    func testLargeInputWithMatch() {
        let sortedArr = Array(1...500_000)
        var unsortedArr = (1..<500_000).map { 1_000_000 + $0 }
        unsortedArr.append(-250_000)

        #expect(zeroSumPair(sortedArr, unsortedArr) == [249_999, 499_999])
    }

    @Test("Problem 29.4 - zeroSumPair handles a large input with no match")
    func testLargeInputWithoutMatch() {
        let sortedArr = Array(1...500_000)
        let unsortedArr = (1...500_000).map { 1_000_000 + $0 }

        #expect(zeroSumPair(sortedArr, unsortedArr) == [-1, -1])
    }
}
