import Collections

extension DFSOrder {
    @inlinable public static func preorder<Visitor: VisitorProtocol>() -> Self where Self == DFSOrder<DepthFirstSearchPreorder<Visitor>> {
        .init()
    }
}

extension GraphTraversalStrategy {
    @inlinable public static func dfs<Visitor: VisitorProtocol>(
        _ visitor: Visitor,
        order: DFSOrder<DepthFirstSearchPreorder<Visitor>>
    ) -> Self where Self == DepthFirstSearchPreorder<Visitor> {
        .init(visitor: visitor)
    }

    @inlinable public static func dfs<Node, Edge>(
        order: DFSOrder<DepthFirstSearchPreorder<NodeVisitor<Node, Edge>>>
    ) -> Self where Self == DepthFirstSearchPreorder<NodeVisitor<Node, Edge>> {
        .init(visitor: .onlyNodes())
    }
}

public struct DepthFirstSearchPreorder<Visitor: VisitorProtocol>: GraphTraversalStrategy {
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

    @inlinable public func next(from stack: inout Storage, edges: (Node) -> some Sequence<GraphEdge<Node, Edge>>) -> Visit? {
        guard let visit = stack.popLast() else { return nil }
        let visits = edges(node(from: visit)).reversed().map { edge in
            visitor.visit(node: edge.destination, from: (visit, edge))
        }
        stack.append(contentsOf: visits)
        return visit
    }

    @inlinable public func node(from visit: Visitor.Visit) -> Visitor.Node {
        visitor.node(from: visit)
    }
}


