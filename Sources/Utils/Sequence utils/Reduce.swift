extension Sequence {
    @inlinable public func reduce(_ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element? {
        var iterator = makeIterator()
        return try iterator.next().map { first in
            try IteratorSequence(iterator).reduce(first, nextPartialResult)
        }
    }
}

extension AsyncSequence {
    @inlinable public func reduce(_ nextPartialResult: (Element, Element) throws -> Element) async rethrows -> Element? {
        var iterator = makeAsyncIterator()
        guard let first = try await iterator.next() else { return nil }
        return try await AsyncIteratorSequence(base: iterator).reduce(first, nextPartialResult)
    }
}

@usableFromInline struct AsyncIteratorSequence<Base: AsyncIteratorProtocol>: AsyncSequence {
    @usableFromInline typealias AsyncIterator = Base
    @usableFromInline typealias Element = Base.Element

    @usableFromInline let base: Base

    @usableFromInline init(base: Base) {
        self.base = base
    }

    @usableFromInline func makeAsyncIterator() -> Base {
        base
    }
}
