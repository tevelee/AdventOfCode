import Collections

extension DFSOrder {
    @inlinable public static func inorder<Visitor: VisitorProtocol>() -> Self where Self == DFSOrder<DepthFirstSearchInorder<Visitor>> {
        .init()
    }
}

extension BinaryGraphTraversalStrategy {
    @inlinable public static func dfs<Visitor: VisitorProtocol>(
        _ visitor: Visitor,
        order: DFSOrder<DepthFirstSearchInorder<Visitor>>
    ) -> Self where Self == DepthFirstSearchInorder<Visitor> {
        .init(visitor: visitor)
    }

    @inlinable public static func dfs<Node, Edge>(
        order: DFSOrder<DepthFirstSearchInorder<NodeVisitor<Node, Edge>>>
    ) -> Self where Self == DepthFirstSearchInorder<NodeVisitor<Node, Edge>> {
        .init(visitor: .onlyNodes())
    }
}

public struct DepthFirstSearchInorder<Visitor: VisitorProtocol>: BinaryGraphTraversalStrategy {
    public typealias Node = Visitor.Node
    public typealias Edge = Visitor.Edge
    public typealias Visit = Visitor.Visit
    public typealias Storage = Deque<(isFirst: Bool, visit: Visit)>

    @usableFromInline let visitor: Visitor

    @inlinable public init(visitor: Visitor) {
        self.visitor = visitor
    }

    @inlinable public func initializeStorage(startNode: Node) -> Storage {
        Deque([(isFirst: true, visit: visitor.visit(node: startNode, from: nil))])
    }

    @inlinable public func next(from stack: inout Storage, graph: some BinaryGraphProtocol<Node, Edge>) -> Visitor.Visit? {
        guard let (isFirst, visit) = stack.popLast() else { return nil }
        if isFirst {
            let edges = graph.edges(from: node(from: visit))
            if let edge = edges.rhs {
                stack.append((isFirst: true, visit: visitor.visit(node: edge.destination, from: (visit, edge))))
            }
            stack.append((isFirst: false, visit: visit))
            if let edge = edges.lhs {
                stack.append((isFirst: true, visit: visitor.visit(node: edge.destination, from: (visit, edge))))
            }
            return next(from: &stack, graph: graph)
        } else {
            return visit
        }
    }

    @inlinable public func node(from visit: Visit) -> Node {
        visitor.node(from: visit)
    }
}
