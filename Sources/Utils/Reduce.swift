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
