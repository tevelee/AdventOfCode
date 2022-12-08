import Algorithms

public extension AsyncSequence {
    func eraseToAnyAsyncSequence() -> AnyAsyncSequence<Self.Element> {
        AnyAsyncSequence(self)
    }
}

public struct AnyAsyncSequence<Element>: AsyncSequence {
    public typealias AsyncIterator = AnyAsyncIterator<Element>

    let _makeIterator: () -> AnyAsyncIterator<Element>

    public init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        _makeIterator = {
            AnyAsyncIterator(sequence.makeAsyncIterator)
        }
    }

    public func makeAsyncIterator() -> AnyAsyncIterator<Element> {
        _makeIterator()
    }
}

public struct AnyAsyncIterator<Element>: AsyncIteratorProtocol {
    let _next: () async throws -> Element?

    public init<I: AsyncIteratorProtocol>(_ iteratorFactory: () -> I) where I.Element == Element {
        var iterator = iteratorFactory()
        _next = {
            try await iterator.next()
        }
    }

    public mutating func next() async throws -> Element? {
        try await _next()
    }
}

public typealias Lines = AnyAsyncSequence<String>

public extension String {
    var lines: LazyMapSequence<LazySplitCollection<LazySequence<String>.Elements>, String> {
        lines(includeEmptyLines: false)
    }

    func lines(includeEmptyLines: Bool) -> LazyMapSequence<LazySplitCollection<LazySequence<String>.Elements>, String> {
        self.lazy.split(separator: "\n", omittingEmptySubsequences: !includeEmptyLines).map(String.init)
    }

    var paragraphs: [[String]] {
        split(separator: "\n", omittingEmptySubsequences: false).split(separator: "").map { $0.map(String.init) }
    }

    var words: [String] {
        split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
    }
}

public extension Substring {
    var words: [String] {
        split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
    }
}

public extension Sequence {
    var async: AsyncSequenceFromSequence<Self> {
        AsyncSequenceFromSequence(base: self)
    }
}

public struct AsyncSequenceFromSequence<Base: Sequence>: AsyncSequence {
    public typealias AsyncIterator = AsyncIteratorFromIterator<Base.Iterator>
    public typealias Element = Base.Element

    let base: Base

    public func makeAsyncIterator() -> AsyncIteratorFromIterator<Base.Iterator> {
        AsyncIteratorFromIterator(iterator: base.makeIterator())
    }

    public struct AsyncIteratorFromIterator<Iterator: IteratorProtocol>: AsyncIteratorProtocol {
        var iterator: Iterator

        public mutating func next() async throws -> Iterator.Element? {
            iterator.next()
        }
    }
}
