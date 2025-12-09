extension Array {
    @inlinable public func rotatedClockwise<T>() -> [[T]] where Element == [T] {
        guard let firstRow = self.first else { return self }
        return firstRow.indices.map { x in
            reversed().map { $0[x] }
        }
    }
}

extension Array where Element: Hashable {
    @inlinable public func removingDuplicates() -> [Element] {
        var elements: Set<Element> = []
        return filter {
            elements.insert($0).inserted
        }
    }
}

extension Sequence {
    @inlinable public func allPairs() -> some Sequence<(Element, Element)> {
        enumerated().lazy.flatMap { offset, first in
            self.lazy.dropFirst(offset + 1).map { second in
                (first, second)
            }
        }
    }
}
