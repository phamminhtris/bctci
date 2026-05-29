import Testing
@testable import CodingInterview

struct Problem39_5Tests {
    struct TestCase {
        let sentence: String
        let synonyms: [String: [String]]
        let expected: [String]
    }

    @Test(
        "Problem 39.5 - returns all synonym replacement sentences without depending on order",
        arguments: [
            TestCase(
                sentence: "one does not simply walk into mordor",
                synonyms: [
                    "walk": ["stroll", "hike", "wander"],
                    "simply": ["just", "merely"],
                ],
                expected: [
                    "one does not just stroll into mordor",
                    "one does not just hike into mordor",
                    "one does not just wander into mordor",
                    "one does not merely stroll into mordor",
                    "one does not merely hike into mordor",
                    "one does not merely wander into mordor",
                ]
            ),
            TestCase(
                sentence: "walk",
                synonyms: [
                    "walk": ["stroll"],
                ],
                expected: [
                    "stroll",
                ]
            ),
            TestCase(
                sentence: "stay here",
                synonyms: [
                    "stay": ["remain", "wait"],
                ],
                expected: [
                    "remain here",
                    "wait here",
                ]
            ),
        ]
    )
    func testSynonymSentences(testCase: TestCase) {
        let actual = synonymSentences(testCase.sentence, synonyms: testCase.synonyms)

        #expect(actual.count == testCase.expected.count)
        #expect(Set(actual) == Set(testCase.expected))
    }

    @Test("Problem 39.5 - replaces repeated words independently")
    func testSynonymSentencesWithRepeatedWords() {
        let actual = synonymSentences(
            "walk walk",
            synonyms: [
                "walk": ["stroll", "hike"],
            ]
        )
        let expected = [
            "stroll stroll",
            "stroll hike",
            "hike stroll",
            "hike hike",
        ]

        #expect(actual.count == expected.count)
        #expect(Set(actual) == Set(expected))
    }
}
