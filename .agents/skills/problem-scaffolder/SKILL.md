---
name: problem-scaffolder
description: Use when creating a new CodingInterview problem from a prompt, including source prompt text, Swift Testing cases, and a stub implementation without real solution logic.
---

# Problem Scaffolder

Use this workflow for new interview-practice problem files.

1. Read the problem prompt, target directory, and problem ID.
2. Derive a clear top-level Swift function signature from the prompt.
3. Write tests from the prompt/examples/constraints, not from implementation details.
4. Add only a stub implementation. Do not solve the problem unless explicitly asked.
5. Use `Scripts/generate-problem.sh` with temporary files:

```bash
Scripts/generate-problem.sh \
  --prompt-file /tmp/prompt.txt \
  --stub-file /tmp/stub.swift \
  --test-body-file /tmp/test-body.swift \
  SlidingWindows 38_9
```

The `test-body` file is inserted inside `struct ProblemXX_YYTests { ... }`, so indent it by four spaces.

Run the scoped test after generation:

```bash
swift test --filter ProblemXX_YYTests
```

Expected result for a pure stub: compile succeeds and behavior assertions fail.
