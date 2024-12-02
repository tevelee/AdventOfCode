import AsyncAlgorithms

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
    @inlinable public func collect() async rethrows -> [Element] {
        try await Array(self)
    }

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

extension AsyncSequence where Element: Numeric {
    @inlinable public func sum() async throws -> Element {
        try await sum { $0 }
    }
}
