import Testing
@testable import CodingInterview

struct Problem39_3Tests {
    struct TestCase {
        let elements: [Character]
        let expected: [[Character]]
    }

    @Test(
        "Problem 39.3 - returns every permutation without depending on order",
        arguments: [
            TestCase(
                elements: ["x"],
                expected: [["x"]]
            ),
            TestCase(
                elements: ["x", "y"],
                expected: [
                    ["x", "y"],
                    ["y", "x"],
                ]
            ),
            TestCase(
                elements: ["x", "y", "z"],
                expected: [
                    ["x", "y", "z"],
                    ["x", "z", "y"],
                    ["y", "x", "z"],
                    ["y", "z", "x"],
                    ["z", "x", "y"],
                    ["z", "y", "x"],
                ]
            ),
        ]
    )
    func testAllPermutations(testCase: TestCase) {
        let actual = allPermutations(of: testCase.elements)

        #expect(actual.count == testCase.expected.count)
        #expect(normalizedPermutations(actual) == normalizedPermutations(testCase.expected))
    }

    @Test("Problem 39.3 - returns n! unique permutations")
    func testAllPermutationsCountForFourElements() {
        let elements: [Character] = ["a", "b", "c", "d"]
        let actual = allPermutations(of: elements)
        let normalized = normalizedPermutations(actual)

        #expect(actual.count == 24)
        #expect(normalized.count == 24)
        #expect(normalized.contains("abcd"))
        #expect(normalized.contains("dcba"))
        #expect(actual.allSatisfy { $0.sorted() == elements.sorted() })
    }

    private func normalizedPermutations(_ permutations: [[Character]]) -> Set<String> {
        Set(permutations.map { String($0) })
    }
}
