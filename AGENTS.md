# AGENTS.md

## Scope
These instructions apply to everything under `/Users/tri/Developer/CodingInterview`.

## Project Context
- Swift Package project for interview practice problems.
- Source code lives in `Sources/CodingInterview/*`.
- Tests live in `Tests/CodingInterviewTests/*`.
- Naming follows problem IDs, e.g. `Problem32_2.swift`.
- Test files add a `Tests` suffix and match their suite type, e.g. `Problem32_2Tests.swift` holds `struct Problem32_2Tests`. This keeps a filename search for `Problem32_2.swift` unambiguous.

## Working Rules
- Keep responses concise.
- Default to explanation-only debugging/review; do not modify code unless explicitly requested.
- CRITICAL: Do not implement real solution logic unless explicitly requested by the user.
- Prefer small, focused changes over broad refactors.
- Preserve existing file organization and naming.
- Do not add new dependencies unless explicitly requested.

## Tooling
- When asked to create/scaffold a new problem and matching test file, use `Scripts/generate-problem.sh <DirectoryName> <ProblemID>`.
- The script accepts IDs like `38_2`, `Problem38_2`, or `Problem38_2.swift` and creates both source and test files.
- When a prompt, tests, and stub are available, pass generated temp files with `--prompt-file`, `--stub-file`, and `--test-body-file`.

## Skills
- For new problem scaffolding from a prompt, use `.agents/skills/problem-scaffolder/SKILL.md`.
- For Swift data-structure complexity, internals, or collection-choice questions, use `.agents/skills/swift-data-structures-expert/SKILL.md`.

## Swift Guidelines
- Use clear, interview-friendly solutions.
- Favor readable O(n)/O(log n) approaches and mention tradeoffs when relevant.
- Keep helper method separation when requested.
- Use defensive guards/preconditions for invalid inputs where appropriate.
- Avoid force unwraps unless provably safe.

## Testing
- Add or update targeted tests for behavior changes.
- For test design, derive cases from the problem prompt/requirements (not implementation details) unless explicitly requested.
- Prefer parameterized tests when multiple scenarios share the same assertion pattern.
- Do not force all scenarios into one parameterized test; split into multiple parameterized tests when behaviors differ.
- Include edge cases that still satisfy the stated problem constraints.
- Prefer running scoped tests first:
  - `swift test --filter Problem32_2Tests`
- Run full suite when practical:
  - `swift test`
- If unrelated tests fail, call that out clearly and do not mask it.

## Review Focus
When asked for review, prioritize:
1. Correctness bugs and crash risks
2. Edge cases and missing tests
3. Time/space complexity
4. Swift readability and API design
