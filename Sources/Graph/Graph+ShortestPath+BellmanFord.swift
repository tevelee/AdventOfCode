import Collections

extension FullGraphProtocol where Node: Hashable, Edge: Weighted {
    @inlinable public func shortestPath(
        from source: Node,
        to destination: Node,
        using algorithm: some ShortestPathOnFullGraphAlgorithm<Node, Edge>
    ) -> Path<Node, Edge>? {
        algorithm.shortestPath(in: self, from: source, to: destination)
    }

    @inlinable public func shortestPath(
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? where Edge.Weight: FixedWidthInteger {
        self.shortestPath(from: source, to: destination, using: .bellmanFord())
    }
}

public protocol ShortestPathOnFullGraphAlgorithm<Node, Edge> {
    associatedtype Node
    associatedtype Edge

    @inlinable func shortestPath(
        in graph: some FullGraphProtocol<Node, Edge>,
        from start: Node,
        to goal: Node
    ) -> Path<Node, Edge>?
}

extension ShortestPathOnFullGraphAlgorithm {
    @inlinable public static func bellmanFord<Node, Edge>() -> Self where Self == BellmanFordAlgorithm<Node, Edge> {
        .init()
    }
}

public struct BellmanFordAlgorithm<Node: Hashable, Edge: Weighted>: ShortestPathOnFullGraphAlgorithm where Edge.Weight: FixedWidthInteger {
    @inlinable public init() {}

    @inlinable public func shortestPath(
        in graph: some FullGraphProtocol<Node, Edge>,
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? {
        var distances: [Node: Edge.Weight] = [:]
        var predecessors: [Node: GraphEdge<Node, Edge>] = [:]

        distances[source] = .zero

        // Relax edges repeatedly
        for _ in 1..<graph.allNodes.count {
            for edge in graph.allEdges {
                let currentDistance = distances[edge.source] ?? .max
                let newDistance = currentDistance + edge.value.weight

                if newDistance < (distances[edge.destination] ?? .max) {
                    distances[edge.destination] = newDistance
                    predecessors[edge.destination] = edge
                }
            }
        }

        // Check for negative-weight cycles
        for edge in graph.allEdges {
            let currentDistance = distances[edge.source] ?? .max
            let newDistance = currentDistance + edge.value.weight

            if newDistance < (distances[edge.destination] ?? .max) {
                // Negative cycle detected
                return nil
            }
        }

        return Path(connectingEdges: predecessors, source: source, destination: destination)
    }
}
