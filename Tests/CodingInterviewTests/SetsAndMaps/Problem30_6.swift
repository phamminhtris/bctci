import Testing
@testable import CodingInterview


/**
[4, 10, 3, 100, 5, 2, 10000] -> Output: [[5, 0], [1, 3], [3, 6]]
*/
struct Problem30_6Tests {

    struct TestCase {
        let input: [Int]
        let expected: [[Int]]
    }

    @Test("test find all squares", arguments: [
        TestCase(
            input: [4, 10, 3, 100, 5, 2, 10000],
            expected: [[5, 0], [1, 3], [3, 6]]
        ),
        TestCase(
            input: [1],
            expected: [[0, 0]]
        ),
    ])
    func testFindAllSquares(testCase: TestCase) async throws {
        #expect(
            CodingInterview.findAllSquares(arr: testCase.input)
                == testCase.expected
        )
    }

}