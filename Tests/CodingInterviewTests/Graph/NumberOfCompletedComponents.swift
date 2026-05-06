import Testing
@testable import CodingInterview

struct NumberOfCompletedComponentsTests {
    struct TestInput {
        let n: Int
        let edges: [[Int]]
        let expected: Int
    }

    @Test(
        "Counts complete connected components",
        arguments: [
            TestInput(
                n: 6,
                edges: [[0, 1], [0, 2], [1, 2], [3, 4]],
                expected: 3
            ),
            TestInput(
                n: 6,
                edges: [[0, 1], [0, 2], [1, 2], [3, 4], [3, 5]],
                expected: 1
            ),
            TestInput(
                n: 4,
                edges: [[0, 1]],
                expected: 3
            )
        ]
    )
    func testCountCompleteComponents(_ testCase: TestInput) {
        #expect(countCompleteComponents(testCase.n, testCase.edges) == testCase.expected)
    }

    @Test("Counts isolated vertices as complete components")
    func testIsolatedVertices() {
        #expect(countCompleteComponents(3, []) == 3)
    }
}
