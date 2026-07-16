import Testing
@testable import CodingInterview

struct Problem39_4Tests {
    struct TestCase {
        let sentence: String
        let expected: [String]
    }

    @Test(
        "Problem 39.4 - returns every word inclusion outcome without depending on order",
        arguments: [
            TestCase(
                sentence: "",
                expected: [""]
            ),
            TestCase(
                sentence: "hello",
                expected: ["", "hello"]
            ),
            TestCase(
                sentence: "I love dogs",
                expected: [
                    "",
                    "I",
                    "love",
                    "dogs",
                    "I love",
                    "I dogs",
                    "love dogs",
                    "I love dogs",
                ]
            ),
        ]
    )
    func testShakespearify(testCase: TestCase) {
        let actual = shakespearify(testCase.sentence)

        #expect(actual.count == testCase.expected.count)
        #expect(Set(actual) == Set(testCase.expected))
    }

    @Test("Problem 39.4 - returns 2^n unique outcomes")
    func testShakespearifyCountForFourWords() {
        let actual = shakespearify("to be or not")
        let normalized = Set(actual)

        #expect(actual.count == 16)
        #expect(normalized.count == 16)
        #expect(normalized.contains(""))
        #expect(normalized.contains("to be or not"))
    }
}
