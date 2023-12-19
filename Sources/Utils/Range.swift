import Foundation

extension Range<Int> {
    @inlinable public var count: Int {
        upperBound - lowerBound
    }

    @inlinable public func contains(_ element: Int) -> Bool {
        lowerBound <= element && element < upperBound
    }
}

extension ClosedRange<Int> {
    @inlinable public var count: Int {
        upperBound - lowerBound + 1
    }

    @inlinable public func contains(_ element: Int) -> Bool {
        lowerBound <= element && element <= upperBound
    }
}
