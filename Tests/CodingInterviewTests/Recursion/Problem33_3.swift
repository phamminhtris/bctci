import Testing

@testable import CodingInterview

struct Problem33_3Tests {
    struct TestInput {
        let a: Int
        let p: Int
        let m: Int
        let expected: Int
    }

    static let testCases: [TestInput] = [
        TestInput(a: 2, p: 5, m: 100, expected: 32),
        TestInput(a: 2, p: 5, m: 30, expected: 2),
        TestInput(a: 123456789, p: 987654321, m: 1000000007, expected: 652541198),
        TestInput(a: 3, p: 1, m: 5, expected: 3),
        TestInput(a: 5, p: 3, m: 7, expected: 6),
        TestInput(a: 2, p: 0, m: 5, expected: 1),
        TestInput(a: 10, p: 2, m: 5, expected: 0)
    ]

    @Test(
        "Problem 33.3 - modularPower",
        arguments: testCases
    )
    func testModularPower(testCase: TestInput) {
        #expect(modularPower(a: testCase.a, p: testCase.p, m: testCase.m) == testCase.expected)
    }
}
