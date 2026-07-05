import Testing
@testable import CodingInterview

struct Problem27_13Tests {
    struct TestCase {
        let arr: [Int]
    }

    private func isPartitionedEvensBeforeOdds(_ arr: [Int]) -> Bool {
        var seenOdd = false
        for value in arr {
            if value % 2 == 0 {
                if seenOdd { return false }
            } else {
                seenOdd = true
            }
        }
        return true
    }

    @Test(
        "Problem 27.13 - partitions evens before odds while keeping the same multiset of elements",
        arguments: [
            TestCase(arr: [1, 2, 3, 4, 5]),
            TestCase(arr: [5, 1, 3, 1, 5]),
            TestCase(arr: [1, 3, 2, 4]),
        ]
    )
    func testPartitionsEvensBeforeOdds(testCase: TestCase) {
        var result = testCase.arr
        partitionEvensBeforeOdds(&result)
        #expect(isPartitionedEvensBeforeOdds(result))
        #expect(result.sorted() == testCase.arr.sorted())
    }

    @Test("Problem 27.13 - handles an empty array")
    func testHandlesEmptyArray() {
        var arr: [Int] = []
        partitionEvensBeforeOdds(&arr)
        #expect(arr == [])
    }

    @Test(
        "Problem 27.13 - handles arrays that are entirely even or entirely odd",
        arguments: [
            TestCase(arr: [2, 4, 6, 8]),
            TestCase(arr: [1, 3, 5, 7]),
        ]
    )
    func testHandlesUniformParityArrays(testCase: TestCase) {
        var result = testCase.arr
        partitionEvensBeforeOdds(&result)
        #expect(isPartitionedEvensBeforeOdds(result))
        #expect(result.sorted() == testCase.arr.sorted())
    }

    @Test("Problem 27.13 - handles negative numbers and boundary magnitude values")
    func testHandlesNegativeAndBoundaryValues() {
        var arr = [-1_000_000_000, 999_999_999, -3, 4, 0, 1_000_000_000]
        let original = arr
        partitionEvensBeforeOdds(&arr)
        #expect(isPartitionedEvensBeforeOdds(arr))
        #expect(arr.sorted() == original.sorted())
    }
}
