public protocol Container<Element> {
    associatedtype Element

    var elements: [Element] { get }
}

extension Array: Container {
    @inlinable public var elements: [Element] { self }
}

@inlinable public func nonNegativeModulo(of lhs: Int, by rhs: Int) -> Int {
    let result = lhs % rhs
    return result >= 0 ? result : result + rhs
}

extension Collection {
    @inlinable public subscript(safe position: Index) -> Element? where Index == Int {
        let index = self.index(startIndex, offsetBy: position)
        return indices.contains(index) ? self[index] : nil
    }
}
