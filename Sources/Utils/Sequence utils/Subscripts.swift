extension Collection {
    @inlinable public subscript(safe position: Index) -> Element? where Index == Int {
        let index = self.index(startIndex, offsetBy: position)
        return indices.contains(index) ? self[index] : nil
    }
}

extension RandomAccessCollection {
    @inlinable public func index(forRelativeIndex relativeIndex: Int) -> Index {
        index(startIndex, offsetBy: relativeIndex)
    }

    @inlinable public subscript(relativeIndex relativeIndex: Int) -> Element {
        self[index(forRelativeIndex: relativeIndex)]
    }
}

extension String {
    @inlinable public subscript(relativeIndex i: Int) -> Character? {
        self[...][relativeIndex: i]
    }
}

extension Substring {
    @inlinable public subscript(relativeIndex relativeIndex: Int) -> Character? {
        guard relativeIndex < count else { return nil }
        return self[index(startIndex, offsetBy: relativeIndex)]
    }
}
