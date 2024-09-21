import Collections

extension GraphTraversalStrategy {
    @inlinable public static func bfs<Visitor: VisitorProtocol>(
        _ visitor: Visitor
    ) -> Self where Self == BreadthFirstSearch<Visitor> {
        .init(visitor: visitor)
    }

    @inlinable public static func bfs<Node, Edge>() -> Self where Self == BreadthFirstSearch<NodeVisitor<Node, Edge>> {
        .init(visitor: .onlyNodes())
    }
}

public struct BreadthFirstSearch<Visitor: VisitorProtocol>: GraphTraversalStrategy {
    public typealias Storage = Deque<Visitor.Visit>
    public typealias Node = Visitor.Node
    public typealias Edge = Visitor.Edge
    public typealias Visit = Visitor.Visit

    @usableFromInline let visitor: Visitor

    @inlinable public init(visitor: Visitor) {
        self.visitor = visitor
    }

    @inlinable public func initializeStorage(startNode: Node) -> Storage {
        Deque([visitor.visit(node: startNode, from: nil)])
    }

    @inlinable public func next(from queue: inout Storage, edges: (Node) -> some Sequence<GraphEdge<Node, Edge>>) -> Visit? {
        guard let visit = queue.popFirst() else { return nil }
        let visits = edges(node(from: visit)).map { edge in
            visitor.visit(node: edge.destination, from: (visit, edge))
        }
        queue.append(contentsOf: visits)
        return visit
    }

    @inlinable public func node(from visit: Visit) -> Node {
        visitor.node(from: visit)
    }
}
