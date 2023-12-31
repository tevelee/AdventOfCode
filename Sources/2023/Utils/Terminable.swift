public protocol Terminable<Node> {
    associatedtype Node
    func goalReached(for node: Node) -> Bool
}

extension Traversable {
    @inlinable public func goal(_ goalReached: @escaping (Node) -> Bool) -> ConditionalTermination<Self> {
        ConditionalTermination(base: self, goalReached: goalReached)
    }
}

extension TraversableWrapper where Base: Terminable {
    @inlinable public func goalReached(for node: Node) -> Bool {
        base.goalReached(for: extractBaseNode(node))
    }
}

public struct ConditionalTermination<Base: Traversable>: Traversable, Terminable, TraversableWrapper {
    public typealias Node = Edge.Node
    public typealias Edge = Base.Edge

    public let base: Base
    public let goalReached: (Node) -> Bool
    public let extractBaseNode: (Node) -> Base.Node = \.self

    @inlinable public init(base: Base, goalReached: @escaping (Node) -> Bool) {
        self.base = base
        self.goalReached = goalReached
    }

    @inlinable public var start: Node {
        base.start
    }

    @inlinable public func edges(from node: Node) -> Base.Edges {
        base.edges(from: node)
    }

    @inlinable public func goalReached(for node: Node) -> Bool {
        goalReached(node)
    }
}
