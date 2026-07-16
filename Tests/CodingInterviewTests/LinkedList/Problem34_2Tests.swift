import Testing
@testable import CodingInterview

struct Problem34_2Tests {
    @Test("Problem 34.2 - pushFront then popFront returns latest pushed and updates count")
    func testPushFrontAndPopFront() {
        let list = DoublyLinkedList<Int>()

        list.pushFront(v: 1)
        list.pushFront(v: 2)
        list.pushFront(v: 3)

        #expect(list.count == 3)
        #expect(list.popFront() == 3)
        #expect(list.count == 2)
        #expect(list.popFront() == 2)
        #expect(list.count == 1)
        #expect(list.popFront() == 1)
        #expect(list.count == 0)
    }

    @Test("Problem 34.2 - pushBack then popBack returns latest pushed and updates count")
    func testPushBackAndPopBack() {
        let list = DoublyLinkedList<Int>()

        list.pushBack(v: 1)
        list.pushBack(v: 2)
        list.pushBack(v: 3)

        #expect(list.count == 3)
        #expect(list.popBack() == 3)
        #expect(list.count == 2)
        #expect(list.popBack() == 2)
        #expect(list.count == 1)
        #expect(list.popBack() == 1)
        #expect(list.count == 0)
    }

    @Test("Problem 34.2 - popFront on empty list returns nil")
    func testPopFrontEmptyList() {
        let list = DoublyLinkedList<Int>()

        #expect(list.popFront() == nil)
        #expect(list.count == 0)
    }

    @Test("Problem 34.2 - popBack on empty list returns nil")
    func testPopBackEmptyList() {
        let list = DoublyLinkedList<Int>()

        #expect(list.popBack() == nil)
        #expect(list.count == 0)
    }

    @Test("Problem 34.2 - popFront on single element should empty list for future operations")
    func testPopFrontSingleElementResetsList() {
        let list = DoublyLinkedList<Int>()

        list.pushFront(v: 10)
        #expect(list.popFront() == 10)
        #expect(list.count == 0)

        list.pushBack(v: 20)
        #expect(list.count == 1)
        #expect(list.popFront() == 20)
        #expect(list.count == 0)
    }

    @Test("Problem 34.2 - contains returns nil when missing and returns matching node when present")
    func testContains() {
        let list = DoublyLinkedList<Int>()

        list.pushBack(v: 1)
        list.pushBack(v: 2)
        list.pushBack(v: 2)
        list.pushBack(v: 3)

        #expect(list.contains(v: 2)?.value == 2)
        #expect(list.contains(v: 99) == nil)
    }

    @Test("Problem 34.2 - pushFront/Back preserve neighbors when linking")
    func testDoublyLinks() {
        let list = DoublyLinkedList<Int>()

        list.pushFront(v: 1)
        list.pushBack(v: 2)
        list.pushBack(v: 3)

        if let second = list.contains(v: 2) {
            #expect(second.prev?.value == 1)
            #expect(second.next?.value == 3)
        } else {
            #expect(false)
        }

        if let first = list.contains(v: 1) {
            #expect(first.prev == nil)
            #expect(first.next?.value == 2)
        } else {
            #expect(false)
        }
    }
}
