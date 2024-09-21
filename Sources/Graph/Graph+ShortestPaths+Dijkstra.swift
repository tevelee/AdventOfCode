extension ShortestPathsAlgorithm {
    @inlinable public static func dijkstra<Node, Edge>() -> Self where Self == DijkstraAlgorithm<Node, Edge> {
        .init()
    }
}

extension GraphProtocol where Node: Hashable, Edge: Weighted, Edge.Weight: Numeric {
    @inlinable public func shortestPaths(
        from source: Node
    ) -> [Node: Path<Node, Edge>] {
        shortestPaths(from: source, using: .dijkstra())
    }
}

extension DijkstraAlgorithm: ShortestPathsAlgorithm {
    @inlinable public func shortestPaths(
        in graph: some GraphProtocol<Node, Edge>,
        from source: Node
    ) -> [Node: Path<Node, Edge>] {
        let result = computeShortestPaths(in: graph, from: source, stopAt: nil)

        var paths: [Node: Path<Node, Edge>] = [:]
        for node in result.connectingEdges.keys {
            if let path = Path(connectingEdges: result.connectingEdges, source: source, destination: node) {
                paths[node] = path
            }
        }

        paths[source] = Path(source: source, destination: source, edges: [])

        return paths
    }
}
