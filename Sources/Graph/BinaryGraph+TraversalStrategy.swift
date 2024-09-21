public protocol BinaryGraphTraversalStrategy<Node, Edge, Visit> {
    associatedtype Node
    associatedtype Edge
    associatedtype Visit
    associatedtype Storage

    @inlinable func initializeStorage(startNode: Node) -> Storage
    @inlinable func next(from storage: inout Storage, graph: some BinaryGraphProtocol<Node, Edge>) -> Visit?
}
