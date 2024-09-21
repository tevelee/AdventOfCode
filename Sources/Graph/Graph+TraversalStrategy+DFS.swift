import Collections

public struct DFSOrder<Concrete> {
    @inlinable public init() {}
}

extension GraphTraversalStrategy {
    @inlinable public static func dfs<Visitor: VisitorProtocol>(
        _ visitor: Visitor
    ) -> Self where Self == DepthFirstSearchPreorder<Visitor> {
        .init(visitor: visitor)
    }

    @inlinable public static func dfs<Node, Edge>() -> Self where Self == DepthFirstSearchPreorder<NodeVisitor<Node, Edge>> {
        .init(visitor: .onlyNodes())
    }
}
