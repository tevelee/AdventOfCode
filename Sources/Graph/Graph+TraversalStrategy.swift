public protocol GraphTraversalStrategy<Node, Edge, Visit> {
    associatedtype Node
    associatedtype Edge
    associatedtype Visit
    associatedtype Storage

    @inlinable func initializeStorage(startNode: Node) -> Storage
    @inlinable func next(from storage: inout Storage, edges: (Node) -> some Sequence<GraphEdge<Node, Edge>>) -> Visit?
    @inlinable func node(from visit: Visit) -> Node
}

extension GraphTraversalStrategy {
    @inlinable public func next(from storage: inout Storage, graph: some GraphProtocol<Node, Edge>) -> Visit? {
        next(from: &storage, edges: graph.edges)
    }
}
