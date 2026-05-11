/**
Basic heap implementation
*/

final class Heap<T: Comparable> {
    let isHigherPriority: (T, T) -> Bool
    var storage: [T] = []

    init(isHigherPriority: @escaping (T, T) -> Bool) {
        self.isHigherPriority = isHigherPriority
    }

    var size: Int { storage.count }

    func top() -> T? { 
        storage.first
    }

    func push(_ elem: T) {
        func bubbleUp(idx: Int) { 
            var currentIndex = idx
            while let parentIdx = parent(of: currentIndex) {
                if isHigherPriority(storage[currentIndex], storage[parentIdx]) { 
                    storage.swapAt(currentIndex, parentIdx)
                    currentIndex = parentIdx
                } else {
                    break
                }
            } 
        }

        storage.append(elem)
        bubbleUp(idx: storage.count - 1)
    }

    func pop() -> T? {

        func bubbleDown(idx: Int) {
            var currentIdx = idx
            while currentIdx < storage.count {
                var currentMinIdx = currentIdx
                let left = leftChild(of: currentIdx)
                if left < storage.count { 
                    if isHigherPriority(storage[left], storage[currentIdx]) {
                        currentMinIdx = left
                    }
                }

                let right = rightChild(of: currentIdx)
                if right < storage.count {
                    if isHigherPriority(storage[right], storage[currentMinIdx]) {
                        currentMinIdx = right
                    }
                }

                if currentMinIdx != currentIdx {
                    storage.swapAt(currentMinIdx, currentIdx)
                    currentIdx = currentMinIdx
                } else {
                    break
                }
            }
        }
        guard !storage.isEmpty else { return nil }

        let root = storage.first

        storage.swapAt(0, storage.count - 1)
        _ = storage.popLast()
        
        bubbleDown(idx: 0)
        return root
    }
}

extension Heap {
    private func parent(of idx: Int) -> Int? {
        guard idx != 0 else { return nil }
        return (idx - 1) / 2
    }

    private func leftChild(of idx: Int) -> Int { 
        2 * idx + 1
    }

    private func rightChild(of idx: Int) -> Int {
        2 * idx + 2
    }
}