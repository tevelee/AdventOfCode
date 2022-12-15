import Algorithms

public extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}

public extension String {
    subscript(_ i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
}

public extension Substring {
    subscript(_ i: Int) -> Character? {
        guard i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
}

public extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    func sorted<T>(by selector: (Element) -> T) -> [Element] where T: Comparable {
        sorted(by: selector, comparator: <)
    }

    func sorted<T>(by selector: (Element) -> T, comparator: (T, T) -> Bool) -> [Element] where T: Comparable {
        sorted { comparator(selector($0), selector($1)) }
    }

    var headAndTail: (head: Element, tail: SubSequence)? {
        guard let head = first else { return nil }
        return (head, dropFirst())
    }
}

public extension Sequence {
    var headAndTail: (head: Element, tail: IteratorSequence<Iterator>)? {
        var iterator = makeIterator()
        guard let head = iterator.next() else { return nil }
        let tail = IteratorSequence(iterator)
        return (head, tail)
    }

    @inlinable func reduce(_ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element? {
        var iterator = makeIterator()
        return try iterator.next().map { first in
            try IteratorSequence(iterator).reduce(first, nextPartialResult)
        }
    }

    func dictionary<Key: Hashable>(by keySelector: (Element) -> Key) -> [Key: [Element]] {
        .init(grouping: self, by: keySelector)
    }

    func dictionary<Key: Hashable>(byUniqueKey keySelector: (Element) -> Key) -> [Key: Element] {
        Dictionary(grouping: self, by: keySelector).compactMapValues(\.first)
    }
}

public extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}

public func product3<C: Collection>(_ c1: C, _ c2: C, _ c3: C) -> [(C.Element, C.Element, C.Element)] {
    product(product(c1, c2), c3).map { p, z in
        let (x,y) = p
        return (x,y,z)
    }
}

public extension Sequence {
    func sum<T: Numeric>(of property: (Element) -> T) -> T {
        reduce(into: 0) { $0 += property($1) }
    }

    func product<T: Numeric>(of property: (Element) -> T) -> T {
        reduce(into: 1) { $0 *= property($1) }
    }

    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        try filter(condition).count
    }
}

public extension Sequence where Element: Numeric {
    func sum() -> Element {
        sum { $0 }
    }

    func product() -> Element {
        product { $0 }
    }
}

public extension AsyncSequence {
    func sum<T: Numeric>(of property: (Element) -> T) async throws -> T {
        try await reduce(into: 0) { $0 += property($1) }
    }

    func count(where condition: @escaping @Sendable (Element) throws -> Bool) async throws -> Int {
        try await filter(condition).count
    }

    var count: Int {
        get async throws {
            try await reduce(0) { result, _ in result + 1 }
        }
    }
}

public extension AsyncSequence where Element: Numeric {
    func sum() async throws -> Element {
        try await sum { $0 }
    }
}

public func pow(_ value: Int, base: Int = 2) -> Int {
    Array(repeating: base, count: value).product()
}

public extension Dictionary where Value: Hashable {
    var flipped: [Value: Key] {
        Dictionary<Value, [Key]>(grouping: keys, by: { self[$0]! }).compactMapValues(\.first)
    }
}

public prefix func !<T>(keyPath: KeyPath<T, Bool>) -> (T) -> Bool {
    { !$0[keyPath: keyPath] }
}
