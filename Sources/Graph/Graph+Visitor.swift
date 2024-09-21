public protocol VisitorProtocol<Node, Edge> {
    associatedtype Node
    associatedtype Edge
    associatedtype Visit

    @inlinable func visit(node: Node, from previousVisit: (visit: Visit, edge: GraphEdge<Node, Edge>)?) -> Visit
    @inlinable func node(from visit: Visit) -> Node
}

extension VisitorProtocol {
    @inlinable public static func onlyNodes<Node, Edge>() -> Self where Self == NodeVisitor<Node, Edge> {
        NodeVisitor()
    }
}

public struct NodeVisitor<Node, Edge>: VisitorProtocol {
    public typealias Visit = Node
    public typealias Storage = Void

    @inlinable public init() {}

    @inlinable public func visit(node: Node, from: (visit: Visit, edge: GraphEdge<Node, Edge>)?) -> Visit {
        node
    }

    @inlinable public func node(from visit: Visit) -> Node {
        visit
    }
}
