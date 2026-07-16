import Testing
@testable import CodingInterview

struct Problem37_3Tests {
    struct Song {
        let title: String
        let playCount: Int
    }

    @Test("Problem 37.3 - topK returns empty before registrations")
    func testEmptyTopSongs() {
        let topSongs = TopSongs(3)

        #expect(topSongs.topK().isEmpty)
    }

    @Test("Problem 37.3 - topK returns all songs when fewer than k are registered")
    func testFewerThanKRegisteredSongs() {
        var topSongs = TopSongs(3)

        register(
            [
                Song(title: "Boolean Rhapsody", playCount: 193),
                Song(title: "Coding In The Deep", playCount: 146),
            ],
            in: &topSongs
        )

        let result: Set<String> = Set(topSongs.topK())

        #expect(result == ["Boolean Rhapsody", "Coding In The Deep"])
    }

    @Test("Problem 37.3 - topK updates as more songs are registered")
    func testIncrementalTopK() {
        var topSongs = TopSongs(3)

        register(
            [
                Song(title: "Boolean Rhapsody", playCount: 193),
                Song(title: "Coding In The Deep", playCount: 146),
            ],
            in: &topSongs
        )

        #expect(Set(topSongs.topK()) == ["Boolean Rhapsody", "Coding In The Deep"])

        register(
            [
                Song(title: "All About That Base Case", playCount: 291),
                Song(title: "Here Comes The Bug", playCount: 223),
                Song(title: "Oops! I Broke Prod Again", playCount: 274),
                Song(title: "All the Single Brackets", playCount: 132),
            ],
            in: &topSongs
        )

        let result: Set<String> = Set(topSongs.topK())

        #expect(result.count == 3)
        #expect(
            result == [
                "All About That Base Case",
                "Here Comes The Bug",
                "Oops! I Broke Prod Again",
            ]
        )
    }

    @Test("Problem 37.3 - k of one returns the highest play count")
    func testKOfOne() {
        var topSongs = TopSongs(1)

        register(
            [
                Song(title: "A", playCount: 10),
                Song(title: "B", playCount: 40),
                Song(title: "C", playCount: 20),
            ],
            in: &topSongs
        )

        #expect(topSongs.topK() == ["B"])
    }

    @Test("Problem 37.3 - topK accepts any tied song at cutoff")
    func testTieAtCutoff() {
        var topSongs = TopSongs(2)

        register(
            [
                Song(title: "Clear Winner", playCount: 100),
                Song(title: "Tie A", playCount: 50),
                Song(title: "Tie B", playCount: 50),
                Song(title: "Tie C", playCount: 50),
                Song(title: "Lower", playCount: 10),
            ],
            in: &topSongs
        )

        let result = topSongs.topK()

        #expect(result.count == 2)
        #expect(result.contains("Clear Winner"))
        #expect(result.contains { ["Tie A", "Tie B", "Tie C"].contains($0) })
        #expect(!result.contains("Lower"))
    }

    private func register(_ songs: [Song], in topSongs: inout TopSongs) {
        for song in songs {
            topSongs.registerPlays(song.title, song.playCount)
        }
    }
}
