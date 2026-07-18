import Testing
@testable import CodingInterview

struct Problem29_2Tests {
    struct TestInput {
        let name: String
        let t1: Int
        let t2: Int
        let stolenFrom: Int
    }

    /// Wraps `t >= stolenFrom` and records how many times the API was called.
    final class StolenAPI {
        let stolenFrom: Int
        private(set) var callCount = 0

        init(stolenFrom: Int) {
            self.stolenFrom = stolenFrom
        }

        func isStolen(_ t: Int) -> Bool {
            callCount += 1
            return t >= stolenFrom
        }
    }

    @Test(
        "Problem 29.2 - firstStolenTimestamp finds the moment the bike went missing",
        arguments: [
            TestInput(name: "prompt example 1", t1: 1, t2: 5, stolenFrom: 3),
            TestInput(name: "prompt example 2", t1: 1, t2: 10, stolenFrom: 7),
            TestInput(name: "prompt example 3", t1: 5, t2: 10, stolenFrom: 8),
            TestInput(name: "stolen immediately after parking", t1: 1, t2: 10, stolenFrom: 2),
            TestInput(name: "stolen at the moment it was found missing", t1: 1, t2: 10, stolenFrom: 10),
            TestInput(name: "adjacent timestamps", t1: 4, t2: 5, stolenFrom: 5),
            TestInput(name: "two-step range", t1: 4, t2: 6, stolenFrom: 5),
            TestInput(name: "even-length range", t1: 1, t2: 9, stolenFrom: 4),
            TestInput(name: "odd-length range", t1: 1, t2: 8, stolenFrom: 6),
            TestInput(name: "wide range, early theft", t1: 1, t2: 1_000_000, stolenFrom: 2),
            TestInput(name: "wide range, late theft", t1: 1, t2: 1_000_000, stolenFrom: 1_000_000),
            TestInput(name: "wide range, midpoint theft", t1: 1, t2: 1_000_000, stolenFrom: 500_000)
        ]
    )
    func testFindsTheftTimestamp(_ testCase: TestInput) {
        let api = StolenAPI(stolenFrom: testCase.stolenFrom)

        #expect(
            firstStolenTimestamp(testCase.t1, testCase.t2, isStolen: api.isStolen) == testCase.stolenFrom,
            "\(testCase.name)"
        )
    }

    @Test(
        "Problem 29.2 - firstStolenTimestamp stays within a logarithmic API budget",
        arguments: [
            TestInput(name: "prompt example 1", t1: 1, t2: 5, stolenFrom: 3),
            TestInput(name: "adjacent timestamps", t1: 4, t2: 5, stolenFrom: 5),
            TestInput(name: "wide range, early theft", t1: 1, t2: 1_000_000, stolenFrom: 2),
            TestInput(name: "wide range, late theft", t1: 1, t2: 1_000_000, stolenFrom: 1_000_000),
            TestInput(name: "wide range, midpoint theft", t1: 1, t2: 1_000_000, stolenFrom: 500_000)
        ]
    )
    func testStaysWithinAPIBudget(_ testCase: TestInput) {
        let api = StolenAPI(stolenFrom: testCase.stolenFrom)
        _ = firstStolenTimestamp(testCase.t1, testCase.t2, isStolen: api.isStolen)

        // A linear scan would need t2 - t1 calls; binary search needs about log2 of that.
        let range = testCase.t2 - testCase.t1
        let budget = (Int.bitWidth - range.leadingZeroBitCount) + 3

        #expect(api.callCount <= budget, "\(testCase.name): used \(api.callCount) calls, budget \(budget)")
    }

    @Test("Problem 29.2 - firstStolenTimestamp handles every theft timestamp in a range")
    func testEveryTheftTimestampInRange() {
        let t1 = 1
        let t2 = 500

        let wrongCount = (t1 + 1...t2).count { stolenFrom in
            let api = StolenAPI(stolenFrom: stolenFrom)
            return firstStolenTimestamp(t1, t2, isStolen: api.isStolen) != stolenFrom
        }

        #expect(wrongCount == 0, "\(wrongCount) of \(t2 - t1) theft timestamps resolved incorrectly")
    }
}
