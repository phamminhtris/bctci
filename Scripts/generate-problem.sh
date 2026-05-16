#!/usr/bin/env bash
set -euo pipefail

usage() {
    cat >&2 <<'USAGE'
Usage: Scripts/generate-problem.sh [options] <DirectoryName> <ProblemID>

Options:
  --root PATH             Generate under PATH instead of the repository root
  --prompt TEXT           Insert TEXT into the source problem prompt block
  --prompt-file PATH      Insert PATH contents into the source problem prompt block
  --stub-file PATH        Append PATH contents after the source problem prompt block
  --test-body-file PATH   Insert PATH contents inside the generated test suite

Examples:
  Scripts/generate-problem.sh SlidingWindows 38_2
  Scripts/generate-problem.sh Heap Problem37_6
  Scripts/generate-problem.sh Graph Problem36_6.swift
  Scripts/generate-problem.sh --prompt-file prompt.txt --stub-file stub.swift --test-body-file tests.swift SlidingWindows 38_9
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
prompt_text=""
stub_file=""
test_body_file=""
positionals=()

read_required_file() {
    local file="$1"

    if [[ ! -r "$file" ]]; then
        echo "File is not readable: $file" >&2
        exit 2
    fi

    cat "$file"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root)
            if [[ $# -lt 2 ]]; then
                usage
                exit 2
            fi
            repo_root="$2"
            shift 2
            ;;
        --prompt)
            if [[ $# -lt 2 ]]; then
                usage
                exit 2
            fi
            prompt_text="$2"
            shift 2
            ;;
        --prompt-file)
            if [[ $# -lt 2 ]]; then
                usage
                exit 2
            fi
            prompt_text="$(read_required_file "$2")"
            shift 2
            ;;
        --stub-file)
            if [[ $# -lt 2 ]]; then
                usage
                exit 2
            fi
            stub_file="$2"
            [[ -r "$stub_file" ]] || {
                echo "File is not readable: $stub_file" >&2
                exit 2
            }
            shift 2
            ;;
        --test-body-file)
            if [[ $# -lt 2 ]]; then
                usage
                exit 2
            fi
            test_body_file="$2"
            [[ -r "$test_body_file" ]] || {
                echo "File is not readable: $test_body_file" >&2
                exit 2
            }
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --)
            shift
            while [[ $# -gt 0 ]]; do
                positionals+=("$1")
                shift
            done
            ;;
        -*)
            echo "Unknown option: $1" >&2
            usage
            exit 2
            ;;
        *)
            positionals+=("$1")
            shift
            ;;
    esac
done

if [[ ${#positionals[@]} -ne 2 ]]; then
    usage
    exit 2
fi

directory_name="${positionals[0]}"
problem_id="${positionals[1]}"

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

{
    echo "/**"
    echo "Problem prompt:"
    if [[ -n "$prompt_text" ]]; then
        printf '%s\n' "$prompt_text"
    else
        echo
    fi
    echo "*/"

    if [[ -n "$stub_file" ]]; then
        echo
        cat "$stub_file"
    fi
} >"$source_file"

{
    echo "import Testing"
    echo "@testable import CodingInterview"
    echo
    echo "struct $test_type_name {"
    if [[ -n "$test_body_file" ]]; then
        cat "$test_body_file"
    fi
    echo "}"
} >"$test_file"

echo "Created:"
echo "  $source_file"
echo "  $test_file"
