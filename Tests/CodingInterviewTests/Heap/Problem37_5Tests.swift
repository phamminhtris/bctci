import Testing
@testable import CodingInterview

struct Problem37_5Tests {
    struct Song {
        let title: String
        let playCount: Int
    }

    @Test("Problem 37.5 - single registered song is not popular")
    func testSingleRegisteredSongIsNotPopular() {
        var popularSongs = PopularSongs()

        popularSongs.registerPlay("Boolean Rhapsody", 193)

        #expect(!popularSongs.isPopular("Boolean Rhapsody"))
    }

    @Test("Problem 37.5 - popularity updates as songs are registered")
    func testPopularityUpdatesAsSongsAreRegistered() {
        var popularSongs = PopularSongs()

        popularSongs.registerPlay("Boolean Rhapsody", 193)
        #expect(!popularSongs.isPopular("Boolean Rhapsody"))

        register(
            [
                Song(title: "Coding In The Deep", playCount: 140),
                Song(title: "All the Single Brackets", playCount: 132),
            ],
            in: &popularSongs
        )

        #expect(popularSongs.isPopular("Boolean Rhapsody"))
        #expect(!popularSongs.isPopular("Coding In The Deep"))
        #expect(!popularSongs.isPopular("All the Single Brackets"))

        register(
            [
                Song(title: "All About That Base Case", playCount: 291),
                Song(title: "Oops! I Broke Prod Again", playCount: 274),
                Song(title: "Here Comes The Bug", playCount: 223),
            ],
            in: &popularSongs
        )

        #expect(!popularSongs.isPopular("Boolean Rhapsody"))
        #expect(popularSongs.isPopular("Here Comes The Bug"))
    }

    @Test("Problem 37.5 - even sized median uses average of middle counts")
    func testEvenSizedMedianUsesAverage() {
        var popularSongs = PopularSongs()

        register(
            [
                Song(title: "A", playCount: 10),
                Song(title: "B", playCount: 20),
                Song(title: "C", playCount: 30),
                Song(title: "D", playCount: 40),
            ],
            in: &popularSongs
        )

        #expect(!popularSongs.isPopular("B"))
        #expect(popularSongs.isPopular("C"))
    }

    @Test("Problem 37.5 - songs tied with the median are not popular")
    func testSongsTiedWithMedianAreNotPopular() {
        var popularSongs = PopularSongs()

        register(
            [
                Song(title: "A", playCount: 10),
                Song(title: "B", playCount: 20),
                Song(title: "C", playCount: 20),
                Song(title: "D", playCount: 30),
            ],
            in: &popularSongs
        )

        #expect(!popularSongs.isPopular("B"))
        #expect(!popularSongs.isPopular("C"))
        #expect(popularSongs.isPopular("D"))
    }

    private func register(_ songs: [Song], in popularSongs: inout PopularSongs) {
        for song in songs {
            popularSongs.registerPlay(song.title, song.playCount)
        }
    }
}
