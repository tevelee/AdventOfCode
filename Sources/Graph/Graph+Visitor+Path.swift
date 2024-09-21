extension VisitorProtocol {
    @inlinable public static func trackPath<Node, Edge>() -> Self where Self == PathVisitor<NodeVisitor<Node, Edge>> {
        NodeVisitor().trackPath()
    }

    @inlinable public func trackPath() -> PathVisitor<Self> {
        PathVisitor(base: self)
    }
}

public struct PathVisitor<Base: VisitorProtocol>: VisitorProtocol {
    public typealias Node = Base.Node
    public typealias Edge = Base.Edge

    public struct Visit {
        public let base: Base.Visit
        public let node: Base.Node
        public let edges: [GraphEdge<Node, Edge>]

        @inlinable public init(base: Base.Visit, node: Node, edges: [GraphEdge<Node, Edge>]) {
            self.base = base
            self.node = node
            self.edges = edges
        }

        @inlinable public var path: [Node] {
            edges.map(\.source) + [node]
        }
    }

    @usableFromInline let base: Base

    @inlinable public init(base: Base) {
        self.base = base
    }

    @inlinable public func node(from visit: Visit) -> Node {
        base.node(from: visit.base)
    }

    @inlinable public func visit(node: Node, from previousVisit: (visit: Visit, edge: GraphEdge<Node, Edge>)?) -> Visit {
        Visit(
            base: base.visit(node: node, from: previousVisit.map { ($0.visit.base, $0.edge) }),
            node: node,
            edges: previousVisit.map { $0.visit.edges + [$0.edge] } ?? []
        )
    }
}

extension PathVisitor.Visit where Base.Edge: Weighted, Base.Edge.Weight: Numeric {
    @inlinable public var cost: Base.Edge.Weight {
        edges.lazy.map(\.value.weight).reduce(into: .zero, +=)
    }
}
