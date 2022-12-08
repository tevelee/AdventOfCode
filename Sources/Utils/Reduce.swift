public extension AsyncSequence {
    func reduce(_ nextPartialResult: (Element, Element) throws -> Element) async rethrows -> Element? {
        var iterator = makeAsyncIterator()
        guard let first = try await iterator.next() else { return nil }
        return try await AsyncIteratorSequence(base: iterator).reduce(first, nextPartialResult)
    }
}

private struct AsyncIteratorSequence<Base: AsyncIteratorProtocol>: AsyncSequence {
    typealias AsyncIterator = Base
    typealias Element = Base.Element

    let base: Base

    func makeAsyncIterator() -> Base {
        base
    }
}
