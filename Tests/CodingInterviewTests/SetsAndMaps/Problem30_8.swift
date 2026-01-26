import Testing
@testable import CodingInterview

extension Array where Element == (Int, Int) {
	static func == (lhs: [(Int, Int)], rhs: [(Int, Int)]) -> Bool {
		guard lhs.count == rhs.count else { return false }
		for (left, right) in zip(lhs, rhs) {
			if left.0 != right.0 || left.1 != right.1 {
				return false
			}
		}
		return true
	}
}

/**
PROBLEM 30.8 CHEATER DETECTION
You are given an array, answers, with the answers of a multi-choice test. The list has k characters ('a', 'b', 'c', or 'd'), where k is the number of questions in the exam.
You are also given m, the number of desks per row in the classroom where the exam took place.
You are also given an array, students, of students' answers for the test. Each entry is a tuple [student_id, desk, answers], where:
• Student IDs are unique positive integers.
• Desks are unique positive integers. Desks are arranged in rows of desks, starting with desks 1 to m in the first row, m+1 to 2m in the second row, and so on. Not all desks may be occupied. E.g., there may be a student at desk 2 but none at desk 1.
• For each student, answers is an array of k characters ('a', 'b', 'c', or 'd').
Two students are considered suspect if they have made identical mistakes (matching correct scores are not suspicious) and sit next to each other in the same row we don't care about students in the front or behind one another).
Return a list of all pairs of suspect students in any order (the order of the two students in a pair also doesn't matter).
*/
struct Problem30_8Tests {

	struct TestCase {
		let answers: [Character]
		let m: Int
		let students: [(Int, Int, [Character])]
		let expected: [(Int, Int)]
	}

	private func normalize(_ pairs: [(Int, Int)]) -> [(Int, Int)] {
		pairs
			.map { $0.0 < $0.1 ? ($0.0, $0.1) : ($0.1, $0.0) }
			.sorted { lhs, rhs in
				if lhs.0 == rhs.0 { return lhs.1 < rhs.1 }
				return lhs.0 < rhs.0
			}
	}

	@Test("Cheater detection", arguments: [
		// Adjacent desks (2,3) in same row share identical mistakes; row boundary prevents (3,4).
		TestCase(
			answers: Array("abcd"),
			m: 3,
			students: [
				(1, 1, Array("abcd")),
				(2, 2, Array("abdd")),
				(3, 3, Array("abdd")),
				(4, 4, Array("abdd")),
				(5, 5, Array("acdd")),
				(6, 6, Array("addd"))
			],
			expected: [(2, 3)]
		),
		// Two valid adjacent pairs: (10,11) in row 1 and (14,15) in row 2; non-adjacent seats are ignored.
		TestCase(
			answers: Array("abcda"),
			m: 4,
			students: [
				(10, 1, Array("bbcda")),
				(11, 2, Array("bbcda")),
				(12, 4, Array("bbcda")),
				(13, 5, Array("bbcda")),
				(14, 6, Array("aacca")),
				(15, 7, Array("aacca"))
			],
			expected: [(10, 11), (14, 15)]
		),
		// Adjacent students but no mistakes (all correct), so no suspects.
		TestCase(
			answers: Array("abc"),
			m: 2,
			students: [
				(21, 1, Array("abc")),
				(22, 2, Array("abc"))
			],
			expected: []
		),
		// Single student cannot form a suspect pair.
		TestCase(
			answers: Array("abcd"),
			m: 5,
			students: [
				(31, 2, Array("abdd"))
			],
			expected: []
		)
	])
	func testSuspectStudents(testCase: TestCase) async throws {
		let result = suspectStudents(
			answers: testCase.answers,
			m: testCase.m,
			students: testCase.students
		)

		#expect(normalize(result) == normalize(testCase.expected))
	}
}
