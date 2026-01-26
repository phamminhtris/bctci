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

func suspectStudents(answers: [Character], m: Int, students: [(Int, Int, [Character])]) -> [(Int, Int)] {
    return []
}