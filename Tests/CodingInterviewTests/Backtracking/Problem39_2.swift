import Testing
@testable import CodingInterview

struct Problem39_2Tests {
    struct TestCase {
        let elements: [Character]
        let expected: [[Character]]
    }

    @Test(
        "Problem 39.2 - returns every subset without depending on order",
        arguments: [
            TestCase(
                elements: [],
                expected: [[]]
            ),
            TestCase(
                elements: ["x"],
                expected: [[], ["x"]]
            ),
            TestCase(
                elements: ["x", "y"],
                expected: [[], ["x"], ["y"], ["x", "y"]]
            ),
            TestCase(
                elements: ["x", "y", "z"],
                expected: [
                    [],
                    ["x"],
                    ["y"],
                    ["z"],
                    ["x", "y"],
                    ["x", "z"],
                    ["y", "z"],
                    ["x", "y", "z"],
                ]
            ),
        ]
    )
    func testAllSubsets(testCase: TestCase) {
        let actual = allSubsets(of: testCase.elements)

        #expect(actual.count == testCase.expected.count)
        #expect(normalizedSubsets(actual) == normalizedSubsets(testCase.expected))
    }

    @Test("Problem 39.2 - returns 2^n unique subsets")
    func testAllSubsetsCountForFourElements() {
        let actual = allSubsets(of: ["a", "b", "c", "d"])
        let normalized = normalizedSubsets(actual)

        #expect(actual.count == 16)
        #expect(normalized.count == 16)
        #expect(normalized.contains(""))
        #expect(normalized.contains("abcd"))
    }

    private func normalizedSubsets(_ subsets: [[Character]]) -> Set<String> {
        Set(subsets.map { String($0.sorted()) })
    }
}
