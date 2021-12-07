import Foundation
import Algorithms

extension AsyncSequence {
    func eraseToAnyAsyncSequence() -> AnyAsyncSequence<Self.Element> {
        AnyAsyncSequence(self)
    }
}

struct AnyAsyncSequence<Element>: AsyncSequence {
    typealias AsyncIterator = AnyAsyncIterator<Element>

    let _makeIterator: () -> AnyAsyncIterator<Element>

    init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
        _makeIterator = {
            AnyAsyncIterator(sequence.makeAsyncIterator)
        }
    }

    func makeAsyncIterator() -> AnyAsyncIterator<Element> {
        _makeIterator()
    }
}

struct AnyAsyncIterator<Element>: AsyncIteratorProtocol {
    let _next: () async throws -> Element?

    init<I: AsyncIteratorProtocol>(_ iteratorFactory: () -> I) where I.Element == Element {
        var iterator = iteratorFactory()
        _next = {
            try await iterator.next()
        }
    }

    mutating func next() async throws -> Element? {
        try await _next()
    }
}

typealias Lines = AnyAsyncSequence<String>

extension String {
    var lines: LazyMapSequence<LazySplitCollection<LazySequence<String>.Elements>, String> {
        lines(includeEmptyLines: false)
    }

    func lines(includeEmptyLines: Bool) -> LazyMapSequence<LazySplitCollection<LazySequence<String>.Elements>, String> {
        self.lazy.split(separator: "\n", omittingEmptySubsequences: !includeEmptyLines).map(String.init)
    }

    var paragraphs: [[String]] {
        split(separator: "\n", omittingEmptySubsequences: false).split(separator: "").map { $0.map(String.init) }
    }
}

extension Sequence {
    var async: AsyncSequenceFromSequence<Self> {
        AsyncSequenceFromSequence(base: self)
    }
}

struct AsyncSequenceFromSequence<Base: Sequence>: AsyncSequence {
    typealias AsyncIterator = AsyncIteratorFromIterator<Base.Iterator>
    typealias Element = Base.Element

    let base: Base

    func makeAsyncIterator() -> AsyncIteratorFromIterator<Base.Iterator> {
        AsyncIteratorFromIterator(iterator: base.makeIterator())
    }

    struct AsyncIteratorFromIterator<Iterator: IteratorProtocol>: AsyncIteratorProtocol {
        var iterator: Iterator

        mutating func next() async throws -> Iterator.Element? {
            iterator.next()
        }
    }
}
