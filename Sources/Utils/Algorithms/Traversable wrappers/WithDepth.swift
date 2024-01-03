extension Traversable {
    @inlinable public func includeDepth() -> WithDepth<Self> {
        WithDepth(base: self)
    }

    @inlinable public func until(depth: Int) -> ConditionalTermination<WithDepth<Self>> {
        ConditionalTermination(base: includeDepth()) { $0.depth == depth }
    }
}

public struct WithDepth<Base: Traversable>: Traversable, TraversableWrapper {
    public typealias Node = NodeWithDepth<Base.Node>
    public typealias Edge = GraphEdge<Node>
    public typealias Edges = LazyMapCollection<Base.Edges, Edge>

    public let base: Base
    public let extractBaseNode: (Node) -> Base.Node = \.node

    @inlinable public init(base: Base) {
        self.base = base
    }

    @inlinable public var start: Node {
        Node(node: base.start, depth: 0)
    }

    @inlinable public func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy.map { edge in
            Edge(
                source: Node(node: edge.source, depth: node.depth),
                destination: Node(node: edge.destination, depth: node.depth + 1)
            )
        }
    }
}

extension WithDepth: Terminable where Base: Terminable {}

public struct NodeWithDepth<Node> {
    public var node: Node
    public let depth: Int

    public init(node: Node, depth: Int) {
        self.node = node
        self.depth = depth
    }
}
