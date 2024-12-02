extension Collection {
    @inlinable public var headAndTail: (head: Element, tail: SubSequence)? {
        guard let head = first else { return nil }
        return (head, dropFirst())
    }
}

extension Sequence {
    @inlinable public var headAndTail: (head: Element, tail: IteratorSequence<Iterator>)? {
        var iterator = makeIterator()
        guard let head = iterator.next() else { return nil }
        let tail = IteratorSequence(iterator)
        return (head, tail)
    }
}
