# AGENTS.md

## Scope
These instructions apply to everything under `/Users/tri/Developer/CodingInterview`.

## Project Context
- Swift Package project for interview practice problems.
- Source code lives in `Sources/CodingInterview/*`.
- Tests live in `Tests/CodingInterviewTests/*`.
- Naming follows problem IDs, e.g. `Problem32_2.swift`.

## Working Rules
- Keep responses concise.
- Prefer small, focused changes over broad refactors.
- Preserve existing file organization and naming.
- Do not add new dependencies unless explicitly requested.

## Swift Guidelines
- Use clear, interview-friendly solutions.
- Favor readable O(n)/O(log n) approaches and mention tradeoffs when relevant.
- Keep helper method separation when requested.
- Use defensive guards/preconditions for invalid inputs where appropriate.
- Avoid force unwraps unless provably safe.

## Testing
- Add or update targeted tests for behavior changes.
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
