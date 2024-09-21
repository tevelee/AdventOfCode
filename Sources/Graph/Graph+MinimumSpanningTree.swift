extension FullGraphProtocol where Edge: Weighted, Node: Hashable {
    @inlinable public func minimumSpanningTree<Algorithm: MinimumSpanningTreeAlgorithm>(
        using algorithm: Algorithm
    ) -> [GraphEdge<Node, Edge>] where Algorithm.Node == Node, Algorithm.Edge == Edge {
        algorithm.minimumSpanningTree(in: self)
    }
}

public protocol MinimumSpanningTreeAlgorithm<Node, Edge> {
    associatedtype Node
    associatedtype Edge: Weighted

    func minimumSpanningTree(in graph: some FullGraphProtocol<Node, Edge>) -> [GraphEdge<Node, Edge>]
}
