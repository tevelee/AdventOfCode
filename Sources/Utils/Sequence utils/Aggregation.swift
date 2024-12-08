import AsyncAlgorithms

extension Sequence {
    @inlinable public func max<T: Comparable, E>(of property: (Element) throws(E) -> T) throws(E) -> T? {
        try map(property).max()
    }

    @inlinable public func min<T: Comparable, E>(of property: (Element) throws(E) -> T) throws(E) -> T? {
        try map(property).min()
    }

    @inlinable public func sum<T: Numeric>(of property: (Element) throws -> T) rethrows -> T {
        try reduce(into: 0) { $0 += try property($1) }
    }

    @inlinable public func sum<T: Numeric>(of property: (Element) async throws -> T) async rethrows -> T {
        try await reduce(into: 0) { $0 += try await property($1) }
    }

    @inlinable public func product<T: Numeric>(of property: (Element) throws -> T) rethrows -> T {
        try reduce(into: 1) { $0 *= try property($1) }
    }

    @inlinable public func product<T: Numeric>(of property: (Element) async throws -> T) async rethrows -> T {
        try await reduce(into: 1) { $0 *= try await property($1) }
    }

    @inlinable public func reduce<T: Numeric, E>(into: T, next: (inout T, Element) async throws(E) -> Void) async throws(E) -> T {
        var result: T = into
        for element in self {
            try await next(&result, element)
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

    @inlinable public func sum<T: Numeric>(of property: (Element) -> T) async rethrows -> T {
        try await reduce(into: 0) { $0 += property($1) }
    }

    @inlinable public func product<T: Numeric>(of property: (Element) -> T) async rethrows -> T {
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
    @inlinable public func sum() async rethrows -> Element {
        try await sum { $0 }
    }
}
