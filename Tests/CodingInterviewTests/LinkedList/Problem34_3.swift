import Testing
@testable import CodingInterview

struct Problem34_3Tests {
    @Test("Problem 34.3 - push then pop follows LIFO")
    func testPushAndPop() {
        let stack = Stack<Int>()

        stack.push(1)
        stack.push(2)
        stack.push(3)

        #expect(stack.pop() == 3)
        #expect(stack.pop() == 2)
        #expect(stack.pop() == 1)
        #expect(stack.pop() == nil)
    }

    @Test("Problem 34.3 - peek does not remove top element")
    func testPeekDoesNotMutate() {
        let stack = Stack<Int>()

        stack.push(1)
        stack.push(2)
        #expect(stack.peek() == 2)
        #expect(stack.peek() == 2)
        #expect(stack.pop() == 2)
        #expect(stack.pop() == 1)
    }

    @Test("Problem 34.3 - size tracks push and pop")
    func testSize() {
        let stack = Stack<Int>()

        #expect(stack.size() == 0)

        stack.push(1)
        #expect(stack.size() == 1)

        stack.push(2)
        #expect(stack.size() == 2)

        _ = stack.pop()
        #expect(stack.size() == 1)

        _ = stack.pop()
        #expect(stack.size() == 0)
    }

    @Test("Problem 34.3 - empty reflects stack state")
    func testEmpty() {
        let stack = Stack<Int>()

        #expect(stack.empty())
        #expect(stack.pop() == nil)
        #expect(stack.peek() == nil)

        stack.push(10)
        #expect(!stack.empty())

        _ = stack.pop()
        #expect(stack.empty())
    }

    @Test("Problem 34.3 - pop on empty stack returns nil")
    func testPopEmpty() {
        let stack = Stack<Int>()

        #expect(stack.pop() == nil)
        #expect(stack.size() == 0)
        #expect(stack.empty())
    }
}
