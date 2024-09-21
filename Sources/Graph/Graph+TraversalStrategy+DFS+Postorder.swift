import Collections

extension DFSOrder {
    @inlinable public static func postorder<Visitor: VisitorProtocol>() -> Self where Self == DFSOrder<DepthFirstSearchPostorder<Visitor>> {
        .init()
    }
}

extension GraphTraversalStrategy {
    @inlinable public static func dfs<Visitor: VisitorProtocol>(
        _ visitor: Visitor,
        order: DFSOrder<DepthFirstSearchPostorder<Visitor>>
    ) -> Self where Self == DepthFirstSearchPostorder<Visitor> {
        .init(visitor: visitor)
    }

    @inlinable public static func dfs<Node, Edge>(
        order: DFSOrder<DepthFirstSearchPostorder<NodeVisitor<Node, Edge>>>
    ) -> Self where Self == DepthFirstSearchPostorder<NodeVisitor<Node, Edge>> {
        .init(visitor: .onlyNodes())
    }
}

public struct DepthFirstSearchPostorder<Visitor: VisitorProtocol>: GraphTraversalStrategy {
    public typealias Storage = Deque<(isFirst: Bool, visit: Visitor.Visit)>
    public typealias Node = Visitor.Node
    public typealias Edge = Visitor.Edge
    public typealias Visit = Visitor.Visit

    @usableFromInline let visitor: Visitor

    @inlinable public init(visitor: Visitor) {
        self.visitor = visitor
    }

    @inlinable public func initializeStorage(startNode: Node) -> Storage {
        Deque([(isFirst: true, visit: visitor.visit(node: startNode, from: nil))])
    }

    @inlinable public func next(from stack: inout Storage, edges: (Node) -> some Sequence<GraphEdge<Node, Edge>>) -> Visit? {
        guard let (isFirst, visit) = stack.popLast() else { return nil }
        if isFirst {
            stack.append((isFirst: false, visit: visit))
            let newVisits = edges(node(from: visit)).reversed().map { edge in
                (isFirst: true, visit: visitor.visit(node: edge.destination, from: (visit, edge)))
            }
            stack.append(contentsOf: newVisits)
            return next(from: &stack, edges: edges)
        } else {
            return visit
        }
    }

    @inlinable public func node(from visit: Visitor.Visit) -> Visitor.Node {
        visitor.node(from: visit)
    }
}
