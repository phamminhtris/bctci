import Testing
@testable import CodingInterview

struct Problem37_2Tests {
    struct TestCase {
        let songs: [SongMetadata]
        let k: Int
        let expected: Set<String>
    }

    @Test(
        "Problem 37.2 - kMostPlayed returns top songs",
        arguments: [
            TestCase(
                songs: [
                    SongMetadata(name: "All the Single Brackets", playCount: 132),
                    SongMetadata(name: "Oops! I Broke Prod Again", playCount: 274),
                    SongMetadata(name: "Coding In The Deep", playCount: 146),
                    SongMetadata(name: "Boolean Rhapsody", playCount: 193),
                    SongMetadata(name: "Here Comes The Bug", playCount: 291),
                    SongMetadata(name: "All About That Base Case", playCount: 291),
                ],
                k: 3,
                expected: [
                    "Oops! I Broke Prod Again",
                    "Here Comes The Bug",
                    "All About That Base Case",
                ]
            ),
            TestCase(
                songs: [
                    SongMetadata(name: "A", playCount: 10),
                    SongMetadata(name: "B", playCount: 40),
                    SongMetadata(name: "C", playCount: 20),
                ],
                k: 1,
                expected: ["B"]
            ),
            TestCase(
                songs: [
                    SongMetadata(name: "A", playCount: 10),
                    SongMetadata(name: "B", playCount: 40),
                ],
                k: 5,
                expected: ["A", "B"]
            ),
            TestCase(
                songs: [
                    SongMetadata(name: "A", playCount: 5),
                ],
                k: 1,
                expected: ["A"]
            ),
        ]
    )
    func testKMostPlayed(testCase: TestCase) {
        let result = kMostPlayed(songs: testCase.songs, k: testCase.k)

        #expect(result.count == testCase.expected.count)
        #expect(Set(result) == testCase.expected)
    }

    @Test("Problem 37.2 - kMostPlayed accepts any tied song at cutoff")
    func testTieAtCutoff() {
        let songs = [
            SongMetadata(name: "Clear Winner", playCount: 100),
            SongMetadata(name: "Tie A", playCount: 50),
            SongMetadata(name: "Tie B", playCount: 50),
            SongMetadata(name: "Tie C", playCount: 50),
            SongMetadata(name: "Lower", playCount: 10),
        ]

        let result = kMostPlayed(songs: songs, k: 2)

        #expect(result.count == 2)
        #expect(result.contains("Clear Winner"))
        #expect(result.contains { ["Tie A", "Tie B", "Tie C"].contains($0) })
        #expect(!result.contains("Lower"))
    }
}
