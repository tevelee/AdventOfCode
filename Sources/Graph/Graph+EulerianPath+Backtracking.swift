extension EulerianPathAlgorithm {
    @inlinable public static func backtracking<Node, Edge>() -> Self where Self == BacktrackingEulerianPathAlgorithm<Node, Edge> {
        .init()
    }
}

public struct BacktrackingEulerianPathAlgorithm<Node: Hashable, Edge: Hashable>: EulerianPathAlgorithm {
    @inlinable public init() {}

    @inlinable public func findEulerianPath(
        from source: Node,
        to destination: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        guard graph.hasEulerianPath() else { return nil }
        return findEulerianSequence(from: source, to: destination, isCycle: false, in: graph)
    }

    @inlinable public func findEulerianCycle(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        guard graph.hasEulerianCycle() else { return nil }
        return findEulerianSequence(from: source, to: source, isCycle: true, in: graph)
    }

    @usableFromInline func findEulerianSequence(
        from source: Node,
        to destination: Node,
        isCycle: Bool,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        var adjacency: [Node: [GraphEdge<Node, Edge>]] = [:]
        for edge in graph.allEdges {
            adjacency[edge.source, default: []].append(edge)
        }

        let totalEdges = graph.allEdges.count
        var path: [GraphEdge<Node, Edge>] = []

        func backtrack(current: Node) -> Bool {
            if path.count == totalEdges {
                return current == destination
            }

            guard let edges = adjacency[current], !edges.isEmpty else {
                return false
            }

            for (index, edge) in edges.enumerated() {
                // Choose the edge
                path.append(edge)
                adjacency[current]?.remove(at: index)

                // Explore
                if backtrack(current: edge.destination) {
                    return true
                }

                // Un-choose (backtrack)
                path.removeLast()
                adjacency[current]?.insert(edge, at: index)
            }

            return false
        }

        if backtrack(current: source) {
            return Path(source: source, destination: destination, edges: path)
        }

        return nil
    }
}
