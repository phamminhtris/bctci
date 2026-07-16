import Testing
@testable import CodingInterview

struct Problem43_3Tests {
    struct TestCase {
        let arr: [Int]
        let expected: [Int]
    }

    @Test(
        "Problem 43.3 - returns product of all other elements modulo 10^9 + 7",
        arguments: [
            TestCase(
                arr: [1, 3, 2, 1],
                expected: [6, 2, 3, 6]
            ),
            TestCase(
                arr: [0, 1, 0],
                expected: [0, 0, 0]
            ),
            TestCase(
                arr: [2, 3],
                expected: [3, 2]
            ),
            TestCase(
                arr: [0, 1, 2, 3],
                expected: [6, 0, 0, 0]
            ),
            TestCase(
                arr: [10_000, 10_000, 10_000, 10_000],
                expected: [999_993_007, 999_993_007, 999_993_007, 999_993_007]
            ),
        ]
    )
    func testProductsExceptSelf(testCase: TestCase) {
        let actual = productsExceptSelf(testCase.arr)

        #expect(actual == testCase.expected)
    }
}
