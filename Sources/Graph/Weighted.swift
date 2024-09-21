public protocol Weighted {
    associatedtype Weight: Comparable

    var weight: Weight { get }
}

extension Weighted where Self: Comparable {
    @inlinable public var weight: Self { self }
}

extension Comparable where Self: Weighted {
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.weight < rhs.weight
    }
}

extension Int: Weighted {}
extension UInt: Weighted {}
extension Double: Weighted {}
extension Float: Weighted {}

