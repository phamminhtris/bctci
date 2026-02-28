//
//  Problem32_2Tests.swift
//  CodingInterviewTests
//
//  Created by Testing on 2026-02-28.
//

import Testing
@testable import CodingInterview

struct Problem32_2Tests {
  struct TestInput {
    let arr: [Int]
    let k: Int
    let expected: [Int]
  }

  @Test("Problem 32.2 - k-compress", arguments: [
    TestInput(arr: [1, 9, 9, 3, 3, 3, 4], k: 3, expected: [1, 27, 4]),
    TestInput(arr: [8, 4, 2, 2], k: 2, expected: [16]),
    TestInput(arr: [4, 4, 4, 4], k: 5, expected: [4, 4, 4, 4]),
    TestInput(arr: [1, 2, 3, 4], k: 2, expected: [1, 2, 3, 4]),
    TestInput(arr: [2, 2, 2, 2], k: 2, expected: [8]),
    TestInput(arr: [5, 5, 5], k: 3, expected: [15]),
    TestInput(arr: [7, 7, 7, 7, 7], k: 5, expected: [35]),
    TestInput(arr: [10], k: 2, expected: [10]),
    // Exercises multiple compressions in a single pass.
    TestInput(arr: [1, 1, 2, 2, 2, 1, 1, 1], k: 3, expected: [1, 1, 6, 3])
  ]) func testCompressArrayK(testCase: TestInput) {
    #expect(compressArrayK(testCase.arr, k: testCase.k) == testCase.expected)
  }
}
