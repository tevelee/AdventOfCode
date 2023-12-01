import Algorithms
import RegexBuilder

public extension AsyncSequence {
    @inlinable func eraseToAnyAsyncSequence() -> AnyAsyncSequence<Self.Element> {
        AnyAsyncSequence(self)
    }
}

public struct AnyAsyncSequence<Element>: AsyncSequence {
    public typealias AsyncIterator = AnyAsyncIterator<Element>

    @usableFromInline let _makeIterator: () -> AnyAsyncIterator<Element>

    @inlinable public init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        _makeIterator = {
            AnyAsyncIterator(sequence.makeAsyncIterator)
        }
    }

    @inlinable public func makeAsyncIterator() -> AnyAsyncIterator<Element> {
        _makeIterator()
    }
}

public struct AnyAsyncIterator<Element>: AsyncIteratorProtocol {
    @usableFromInline let _next: () async throws -> Element?

    @inlinable public init<I: AsyncIteratorProtocol>(_ iteratorFactory: () -> I) where I.Element == Element {
        var iterator = iteratorFactory()
        _next = {
            try await iterator.next()
        }
    }

    @inlinable public mutating func next() async throws -> Element? {
        try await _next()
    }
}

public typealias Lines = AnyAsyncSequence<String>

extension String {
    @inlinable public var lines: LazyMapSequence<SplitCollection<LazySequence<String>.Elements>, String> {
        lines(includeEmptyLines: false)
    }

    @inlinable public func lines(includeEmptyLines: Bool) -> LazyMapSequence<SplitCollection<LazySequence<String>.Elements>, String> {
        self.lazy.split(separator: "\n", omittingEmptySubsequences: !includeEmptyLines).map(String.init)
    }

    @inlinable public var paragraphs: [[String]] {
        split(separator: "\n", omittingEmptySubsequences: false).split(separator: "").map { $0.map(String.init) }
    }

    @inlinable public var words: [String] {
        split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
    }
}

extension Substring {
    @inlinable public var words: [String] {
        split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
    }
}

extension Sequence {
    @inlinable public var async: AsyncSequenceFromSequence<Self> {
        AsyncSequenceFromSequence(base: self)
    }
}

public struct AsyncSequenceFromSequence<Base: Sequence>: AsyncSequence {
    public typealias AsyncIterator = AsyncIteratorFromIterator<Base.Iterator>
    public typealias Element = Base.Element

    @usableFromInline let base: Base

    @inlinable public init(base: Base) {
        self.base = base
    }

    @inlinable public func makeAsyncIterator() -> AsyncIteratorFromIterator<Base.Iterator> {
        AsyncIteratorFromIterator(iterator: base.makeIterator())
    }

    public struct AsyncIteratorFromIterator<Iterator: IteratorProtocol>: AsyncIteratorProtocol {
        @usableFromInline var iterator: Iterator

        @inlinable public init(iterator: Iterator) {
            self.iterator = iterator
        }

        @inlinable public mutating func next() async throws -> Iterator.Element? {
            iterator.next()
        }
    }
}

extension AsyncSequence {
    @inlinable public func enumerated() -> AsyncEnumeratedSequence<Self> {
        AsyncEnumeratedSequence(base: self)
    }
}

public struct AsyncEnumeratedSequence<Base: AsyncSequence>: AsyncSequence {
    public typealias AsyncIterator = Iterator<Base.AsyncIterator>
    public typealias Element = AsyncIterator.Element

    @usableFromInline var base: Base

    @inlinable public init(base: Base) {
        self.base = base
    }

    @inlinable public func makeAsyncIterator() -> Iterator<Base.AsyncIterator> {
        Iterator(base: base.makeAsyncIterator())
    }

    public struct Iterator<BaseIterator: AsyncIteratorProtocol>: AsyncIteratorProtocol {
        public typealias Element = (offset: Int, value: BaseIterator.Element)

        @usableFromInline var base: BaseIterator
        @usableFromInline var offset: Int

        @inlinable public init(base: BaseIterator, offset: Int = 0) {
            self.base = base
            self.offset = offset
        }

        @inlinable public mutating func next() async throws -> (offset: Int, value: BaseIterator.Element)? {
            defer { offset += 1 }
            return try await base.next().map { (offset, $0) }
        }
    }
}
