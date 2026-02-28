import Testing
@testable import CodingInterview

struct Problem32_5Tests {
    struct TestInput {
        let actions: [Action]
        let expected: String
    }

    @Test("Problem 32.5 - currentURLFollowUp", arguments: [
        // Prompt example.
        TestInput(
            actions: [
                .go("google.com"),
                .go("wikipedia.com"),
                .back(1),
                .forward(1),
                .back(3),
                .go("netflix.com"),
                .forward(3),
            ],
            expected: "netflix.com"
        ),
        // First action is go; with no navigation, current URL is that page.
        TestInput(
            actions: [.go("google.com")],
            expected: "google.com"
        ),
        // Going back past available history should stay on the oldest reachable page.
        TestInput(
            actions: [
                .go("a.com"),
                .go("b.com"),
                .go("c.com"),
                .back(10),
            ],
            expected: "a.com"
        ),
        // Going forward past available pages should stop at the last forwardable page.
        TestInput(
            actions: [
                .go("a.com"),
                .go("b.com"),
                .go("c.com"),
                .back(2),
                .forward(10),
            ],
            expected: "c.com"
        ),
        // A new go clears forward history.
        TestInput(
            actions: [
                .go("a.com"),
                .go("b.com"),
                .go("c.com"),
                .back(2),
                .go("d.com"),
                .forward(3),
            ],
            expected: "d.com"
        ),
        // Repeated back at the first page should keep user at the first page.
        TestInput(
            actions: [
                .go("a.com"),
                .go("b.com"),
                .back(1),
                .back(5),
            ],
            expected: "a.com"
        ),
        // Forward immediately after go with no prior back should do nothing.
        TestInput(
            actions: [
                .go("a.com"),
                .forward(3),
            ],
            expected: "a.com"
        ),
        // Mixed navigation with bounded back/forward steps.
        TestInput(
            actions: [
                .go("a.com"),
                .go("b.com"),
                .go("c.com"),
                .back(1),
                .back(1),
                .forward(1),
            ],
            expected: "b.com"
        ),
    ])
    func testCurrentURLFollowUp(testCase: TestInput) {
        #expect(currentURLFollowUp(actions: testCase.actions) == testCase.expected)
    }
}
