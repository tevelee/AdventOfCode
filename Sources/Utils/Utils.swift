import Algorithms
import AsyncAlgorithms

extension AsyncSequence {
    @inlinable public func collect() async rethrows -> [Element] {
        try await Array(self)
    }
}

extension String {
    @inlinable public subscript(_ i: Int) -> Character? {
        self[...][i]
    }

    @inlinable public var integers: [Int] {
        self[...].integers
    }
}

extension Substring {
    @inlinable public subscript(_ i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }

    @inlinable public var integers: [Int] {
        chunked { $0.isWholeNumber || $0 == "-" }.filter(\.0).compactMap { Int($0.1) }
    }
}

extension Collection {
    @inlinable public subscript(safe position: Index) -> Element? where Index == Int {
        let index = self.index(startIndex, offsetBy: position)
        return indices.contains(index) ? self[index] : nil
    }

    @inlinable public func sorted<T>(by selector: (Element) -> T) -> [Element] where T: Comparable {
        sorted(by: selector, comparator: <)
    }

    @inlinable public func sorted<T>(by selector: (Element) -> T, comparator: (T, T) -> Bool) -> [Element] where T: Comparable {
        sorted { comparator(selector($0), selector($1)) }
    }

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

    @inlinable public func reduce(_ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element? {
        var iterator = makeIterator()
        return try iterator.next().map { first in
            try IteratorSequence(iterator).reduce(first, nextPartialResult)
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

extension Array {
    @inlinable public func rotatedClockwise<T>() -> [[T]] where Element == [T] {
        guard let firstRow = self.first else { return self }
        return firstRow.indices.map { x in
            reversed().map { $0[x] }
        }
    }
}

@inlinable public func product3<C: Collection>(_ c1: C, _ c2: C, _ c3: C) -> [(C.Element, C.Element, C.Element)] {
    product(product(c1, c2), c3).map { p, z in
        let (x,y) = p
        return (x,y,z)
    }
}

extension Sequence {
    @inlinable public func max<T: Comparable>(of property: (Element) -> T) -> T? {
        map(property).max()
    }

    @inlinable public func min<T: Comparable>(of property: (Element) -> T) -> T? {
        map(property).min()
    }

    @inlinable public func sum<T: Numeric>(of property: (Element) -> T) -> T {
        reduce(into: 0) { $0 += property($1) }
    }

    @inlinable public func sum<T: Numeric>(of property: (Element) async throws -> T) async throws -> T {
        var result: T = 0
        for element in self {
            result += try await property(element)
        }
        return result
    }

    @inlinable public func product<T: Numeric>(of property: (Element) -> T) -> T {
        reduce(into: 1) { $0 *= property($1) }
    }

    @inlinable public func product<T: Numeric>(of property: (Element) async throws -> T) async throws -> T {
        var result: T = 1
        for element in self {
            result *= try await property(element)
        }
        return result
    }

    @inlinable public func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        try filter(condition).count
    }
}

extension Sequence where Element: Numeric {
    @inlinable public func sum() -> Element {
        sum { $0 }
    }

    @inlinable public func product() -> Element {
        product { $0 }
    }
}

extension AsyncSequence {
    @inlinable public func sum<T: Numeric>(of property: (Element) -> T) async throws -> T {
        try await reduce(into: 0) { $0 += property($1) }
    }

    @inlinable public func product<T: Numeric>(of property: (Element) -> T) async throws -> T {
        try await reduce(into: 1) { $0 *= property($1) }
    }

    @inlinable public func count(where condition: @escaping @Sendable (Element) throws -> Bool) async throws -> Int {
        try await filter(condition).count
    }

    @inlinable public var count: Int {
        get async throws {
            try await reduce(0) { result, _ in result + 1 }
        }
    }
}

extension AsyncSequence where Element: Equatable {
    @inlinable public func split(by element: Element) -> AnyAsyncSequence<[Element]> {
        chunked(into: Array.self, on: { $0 != element }).filter(\.0).map(\.1).eraseToAnyAsyncSequence()
    }
}

extension AsyncSequence where Element: Numeric {
    @inlinable public func sum() async throws -> Element {
        try await sum { $0 }
    }
}

extension Collection where Element: Equatable {
    @inlinable public func hasPrefix(_ other: some Collection<Element>) -> Bool {
        if other.isEmpty {
            return true
        }
        guard first == other.first else {
            return false
        }
        return dropFirst().hasPrefix(other.dropFirst())
    }
}

@inlinable public func pow(_ value: Int, base: Int = 2) -> Int {
    if base == 0 {
        precondition(value != 0)
        return 1
    }
    return Array(repeating: base, count: value).product()
}

extension Dictionary where Value: Hashable {
    @inlinable public var flipped: [Value: Key] {
        Dictionary<Value, [Key]>(grouping: keys, by: { self[$0]! }).compactMapValues(\.first)
    }
}

extension Dictionary {
    @inlinable public func mapKeys<NewKey: Hashable>(_ transform: (Key) -> NewKey, uniquingKeysWith: (Value, Value) -> Value = takeNewest) -> [NewKey: Value] {
        Dictionary<NewKey, Value>(map { (transform($0.key), $0.value) }, uniquingKeysWith: uniquingKeysWith)
    }
}

@inlinable public prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
    { !$0[keyPath: keyPath] }
}

@inlinable public func takeNewest<T>(old: T, new: T) -> T {
    new
}

@inlinable public func takeOldest<T>(old: T, new: T) -> T {
    old
}

@inlinable public func + <Key: Hashable, Value>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    lhs.merging(rhs, uniquingKeysWith: takeNewest)
}

public struct ParseError: Error {
    let message: String

    public init(_ message: String = "") {
        self.message = message
    }
}
