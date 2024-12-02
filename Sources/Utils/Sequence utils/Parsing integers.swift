import Algorithms

extension String {
    @inlinable public var lazyIntegers: some Sequence<Int> {
        self[...].lazyIntegers
    }

    @inlinable public var integers: [Int] {
        self[...].integers
    }
}

extension Substring {
    @inlinable public var lazyIntegers: some Sequence<Int> {
        lazy.chunked { $0.isWholeNumber || $0 == "-" }.filter(\.0).compactMap { Int($0.1) }
    }

    @inlinable public var integers: [Int] {
        Array(lazyIntegers)
    }
}
