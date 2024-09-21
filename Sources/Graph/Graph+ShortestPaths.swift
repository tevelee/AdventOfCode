extension GraphProtocol {
    @inlinable public func shortestPaths<Algorithm: ShortestPathsAlgorithm>(
        from source: Node,
        using algorithm: Algorithm
    ) -> [Node: Path<Node, Edge>] where Algorithm.Node == Node, Algorithm.Edge == Edge {
        algorithm.shortestPaths(in: self, from: source)
    }
}

public protocol ShortestPathsAlgorithm<Node, Edge> {
    associatedtype Node: Hashable
    associatedtype Edge

    @inlinable func shortestPaths(
        in graph: some GraphProtocol<Node, Edge>,
        from source: Node
    ) -> [Node: Path<Node, Edge>]
}
