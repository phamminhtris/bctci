#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat >&2 <<'USAGE'
Usage: Scripts/generate-problem.sh [--root PATH] <DirectoryName> <ProblemID>

Examples:
  Scripts/generate-problem.sh SlidingWindows 38_2
  Scripts/generate-problem.sh Heap Problem37_6
  Scripts/generate-problem.sh Graph Problem36_6.swift
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--root" ]]; then
    if [[ $# -lt 3 ]]; then
        usage
        exit 2
    fi

    repo_root="$2"
    shift 2
fi

if [[ $# -ne 2 ]]; then
    usage
    exit 2
fi

directory_name="$1"
problem_id="$2"

problem_name="${problem_id%.swift}"
if [[ "$problem_name" != Problem* ]]; then
    problem_name="Problem$problem_name"
fi

if [[ ! "$problem_name" =~ ^Problem[0-9]+_[0-9]+$ ]]; then
    echo "ProblemID must look like 38_2, Problem38_2, or Problem38_2.swift" >&2
    exit 2
fi

test_type_name="${problem_name}Tests"
source_directory="$repo_root/Sources/CodingInterview/$directory_name"
test_directory="$repo_root/Tests/CodingInterviewTests/$directory_name"
source_file="$source_directory/$problem_name.swift"
test_file="$test_directory/$problem_name.swift"

if [[ -e "$source_file" || -e "$test_file" ]]; then
    echo "Refusing to overwrite because a target file already exists:" >&2
    [[ -e "$source_file" ]] && echo "  $source_file" >&2
    [[ -e "$test_file" ]] && echo "  $test_file" >&2
    exit 1
fi

mkdir -p "$source_directory" "$test_directory"

cat >"$source_file" <<SWIFT
/**
Problem prompt:

*/

SWIFT

cat >"$test_file" <<SWIFT
import Testing
@testable import CodingInterview

struct $test_type_name {
}
SWIFT

echo "Created:"
echo "  $source_file"
echo "  $test_file"
