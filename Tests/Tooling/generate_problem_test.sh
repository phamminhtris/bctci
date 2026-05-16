#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fixture="$(mktemp -d)"
stderr_file="$fixture/stderr.txt"

cleanup() {
    rm -rf "$fixture"
}
trap cleanup EXIT

fail() {
    echo "FAIL: $1" >&2
    exit 1
}

assert_file_exists() {
    [[ -f "$1" ]] || fail "Expected file to exist: $1"
}

assert_contains() {
    local file="$1"
    local expected="$2"

    grep -Fq "$expected" "$file" || fail "Expected '$file' to contain '$expected'"
}

"$repo_root/Scripts/generate-problem.sh" --root "$fixture" SlidingWindows 38_2

source_file="$fixture/Sources/CodingInterview/SlidingWindows/Problem38_2.swift"
test_file="$fixture/Tests/CodingInterviewTests/SlidingWindows/Problem38_2.swift"

assert_file_exists "$source_file"
assert_file_exists "$test_file"
assert_contains "$test_file" "import Testing"
assert_contains "$test_file" "@testable import CodingInterview"
assert_contains "$test_file" "struct Problem38_2Tests"

"$repo_root/Scripts/generate-problem.sh" --root "$fixture" Heap Problem39_1.swift

assert_file_exists "$fixture/Sources/CodingInterview/Heap/Problem39_1.swift"
assert_file_exists "$fixture/Tests/CodingInterviewTests/Heap/Problem39_1.swift"

prompt_file="$fixture/prompt.txt"
stub_file="$fixture/stub.swift"
test_body_file="$fixture/test-body.swift"

cat >"$prompt_file" <<'PROMPT'
Given an array values, return the largest value.

Example: values = [1, 2, 3]
Output: 3
PROMPT

cat >"$stub_file" <<'STUB'
func largestValue(in values: [Int]) -> Int {
    0
}
STUB

cat >"$test_body_file" <<'TESTS'
    struct TestCase {
        let values: [Int]
        let expected: Int
    }

    @Test(
        "Problem 40.1 - returns largest value",
        arguments: [
            TestCase(values: [1, 2, 3], expected: 3),
        ]
    )
    func testLargestValue(testCase: TestCase) {
        #expect(largestValue(in: testCase.values) == testCase.expected)
    }
TESTS

"$repo_root/Scripts/generate-problem.sh" \
    --root "$fixture" \
    --prompt-file "$prompt_file" \
    --stub-file "$stub_file" \
    --test-body-file "$test_body_file" \
    SlidingWindows 40_1

generated_source="$fixture/Sources/CodingInterview/SlidingWindows/Problem40_1.swift"
generated_test="$fixture/Tests/CodingInterviewTests/SlidingWindows/Problem40_1.swift"

assert_contains "$generated_source" "Given an array values, return the largest value."
assert_contains "$generated_source" "func largestValue(in values: [Int]) -> Int"
assert_contains "$generated_test" "struct Problem40_1Tests"
assert_contains "$generated_test" "@Test("
assert_contains "$generated_test" "#expect(largestValue(in: testCase.values) == testCase.expected)"

if "$repo_root/Scripts/generate-problem.sh" --root "$fixture" SlidingWindows 38_2 2>"$stderr_file"; then
    fail "Expected duplicate generation to fail"
fi

assert_contains "$stderr_file" "already exists"
