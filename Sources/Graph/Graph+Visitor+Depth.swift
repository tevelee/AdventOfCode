extension VisitorProtocol {
    @inlinable public static func trackDepth<Node, Edge>() -> Self where Self == DepthVisitor<NodeVisitor<Node, Edge>> {
        NodeVisitor().trackDepth()
    }

    @inlinable public func trackDepth() -> DepthVisitor<Self> {
        DepthVisitor(base: self)
    }
}

public struct DepthVisitor<Base: VisitorProtocol>: VisitorProtocol {
    public typealias Node = Base.Node
    public typealias Edge = Base.Edge
    public typealias Visit = (base: Base.Visit, node: Node, depth: Int)

    @usableFromInline let base: Base

    @inlinable public init(base: Base) {
        self.base = base
    }

    @inlinable public func node(from visit: Visit) -> Node {
        base.node(from: visit.base)
    }

    @inlinable public func visit(node: Node, from previousVisit: (visit: Visit, edge: GraphEdge<Node, Edge>)?) -> Visit {
        (
            base: base.visit(node: node, from: previousVisit.map { ($0.visit.base, $0.edge) }),
            node: node,
            depth: previousVisit.map { $0.visit.depth + 1 } ?? 0
        )
    }
}
