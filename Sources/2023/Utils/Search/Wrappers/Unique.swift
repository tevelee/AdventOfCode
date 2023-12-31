public struct UniqueVisitor<Base: SearchStrategy, HashValue: Hashable>: SearchStrategy {
    public var base: Base
    public var hashValue: (Base.Node) -> HashValue
    public var visited: Set<HashValue> = []

    @inlinable public init(base: Base, hashValue: @escaping (Base.Node) -> HashValue) {
        self.base = base
        self.hashValue = hashValue
    }

    public typealias Node = Base.Node

    @inlinable public mutating func add(_ node: Node) {
        base.add(node)
    }

    @inlinable public mutating func next(neighbors: (Node) -> some Collection<Node>) -> Base.Node? {
        return base.next { node in
            defer { visited.insert(hashValue(node)) }
            return neighbors(node).filter { !visited.contains(hashValue($0)) }
        }
    }
}

extension SearchStrategy where Node: Hashable {
    @inlinable public func visitEachNodeOnlyOnce() -> UniqueVisitor<Self, Node> {
        UniqueVisitor(base: self) { $0 }
    }
}

extension SearchStrategy {
    @inlinable public func visitEachNodeOnlyOnce<HashValue: Hashable>(by hashValue: @escaping (Node) -> HashValue) -> UniqueVisitor<Self, HashValue> {
        UniqueVisitor(base: self, hashValue: hashValue)
    }
}
