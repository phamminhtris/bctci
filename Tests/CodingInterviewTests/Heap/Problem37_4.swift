import Testing
@testable import CodingInterview

struct Problem37_4Tests {
    struct Song {
        let title: String
        let playCount: Int
    }

    @Test("Problem 37.4 - topK returns empty before registrations")
    func testEmptyTopSongs() {
        var topSongs = TopSong3(3)

        #expect(topSongs.topK().isEmpty)
    }

    @Test("Problem 37.4 - topK returns all songs when fewer than k are registered")
    func testFewerThanKRegisteredSongs() {
        var topSongs = TopSong3(3)

        register(
            [
                Song(title: "Boolean Rhapsody", playCount: 193),
                Song(title: "Coding In The Deep", playCount: 146),
            ],
            in: &topSongs
        )

        let result = topSongs.topK()

        #expect(result.count == 2)
        #expect(Set(result) == ["Boolean Rhapsody", "Coding In The Deep"])
    }

    @Test("Problem 37.4 - topK uses cumulative plays from repeated registrations")
    func testRepeatedRegistrationsAccumulatePlays() {
        var topSongs = TopSong3(3)

        register(
            [
                Song(title: "Boolean Rhapsody", playCount: 100),
                Song(title: "Boolean Rhapsody", playCount: 193),
                Song(title: "Coding In The Deep", playCount: 75),
                Song(title: "Coding In The Deep", playCount: 75),
                Song(title: "All About That Base Case", playCount: 200),
                Song(title: "All About That Base Case", playCount: 90),
                Song(title: "All About That Base Case", playCount: 1),
                Song(title: "Here Comes The Bug", playCount: 223),
                Song(title: "Oops! I Broke Prod Again", playCount: 274),
                Song(title: "All the Single Brackets", playCount: 132),
            ],
            in: &topSongs
        )

        let result = topSongs.topK()

        #expect(result.count == 3)
        #expect(
            Set(result) == [
                "Boolean Rhapsody",
                "All About That Base Case",
                "Oops! I Broke Prod Again",
            ]
        )
    }

    @Test("Problem 37.4 - repeated registrations can move a song into topK")
    func testRepeatedRegistrationsCanChangeRanking() {
        var topSongs = TopSong3(2)

        register(
            [
                Song(title: "A", playCount: 60),
                Song(title: "B", playCount: 50),
                Song(title: "C", playCount: 40),
            ],
            in: &topSongs
        )

        #expect(Set(topSongs.topK()) == ["A", "B"])

        topSongs.registerPlays("C", 31)

        let result = topSongs.topK()

        #expect(result.count == 2)
        #expect(Set(result) == ["A", "C"])
    }

    @Test("Problem 37.4 - topK does not mutate rankings")
    func testTopKDoesNotMutateRankings() {
        var topSongs = TopSong3(2)

        register(
            [
                Song(title: "A", playCount: 10),
                Song(title: "B", playCount: 30),
                Song(title: "C", playCount: 20),
            ],
            in: &topSongs
        )

        let firstResult = topSongs.topK()
        let secondResult = topSongs.topK()

        #expect(firstResult.count == 2)
        #expect(secondResult.count == 2)
        #expect(Set(firstResult) == ["B", "C"])
        #expect(Set(secondResult) == ["B", "C"])
    }

    @Test("Problem 37.4 - k of one returns the highest cumulative play count")
    func testKOfOne() {
        var topSongs = TopSong3(1)

        register(
            [
                Song(title: "A", playCount: 10),
                Song(title: "B", playCount: 40),
                Song(title: "A", playCount: 35),
                Song(title: "C", playCount: 44),
            ],
            in: &topSongs
        )

        #expect(topSongs.topK() == ["A"])
    }

    @Test("Problem 37.4 - topK accepts any tied song at cutoff")
    func testTieAtCutoff() {
        var topSongs = TopSong3(2)

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

    private func register(_ songs: [Song], in topSongs: inout TopSong3) {
        for song in songs {
            topSongs.registerPlays(song.title, song.playCount)
        }
    }
}
