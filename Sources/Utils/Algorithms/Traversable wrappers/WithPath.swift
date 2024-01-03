extension Traversable {
    @inlinable public func includePath() -> WithPath<Self> {
        WithPath(base: self)
    }
}

public struct WithPath<Base: Traversable>: Traversable, TraversableWrapper {
    public typealias Node = NodeWithPath<Base.Node>
    public typealias Edge = GraphEdge<Node>
    public typealias Edges = LazyMapCollection<Base.Edges, Edge>

    public let base: Base
    public let extractBaseNode: (Node) -> Base.Node = \.node

    @inlinable public init(base: Base) {
        self.base = base
    }

    @inlinable public var start: Node {
        Node(node: base.start, path: [])
    }

    @inlinable public func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy.map {
            Edge(
                source: Node(node: $0.source, path: node.path),
                destination: Node(node: $0.destination, path: node.path + $0.destination)
            )
        }
    }
}

public struct NodeWithPath<Node> {
    public let node: Node
    public let path: [Node]

    public init(node: Node, path: [Node]) {
        self.node = node
        self.path = path
    }
}

extension WithPath: Terminable where Base: Terminable {}
