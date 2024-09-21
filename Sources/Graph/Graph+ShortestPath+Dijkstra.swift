import Collections

extension ShortestPathAlgorithm {
    @inlinable public static func dijkstra<Node, Edge>() -> Self where Self == DijkstraAlgorithm<Node, Edge> {
        .init()
    }
}

extension GraphProtocol where Node: Hashable, Edge: Weighted, Edge.Weight: Numeric {
    @inlinable public func shortestPath(
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? {
        shortestPath(from: source, to: destination, using: .dijkstra())
    }
}

public struct DijkstraAlgorithm<Node: Hashable, Edge: Weighted>: ShortestPathAlgorithm where Edge.Weight: Numeric {
    @inlinable public init() {}

    @inlinable public func shortestPath(
        in graph: some GraphProtocol<Node, Edge>,
        from source: Node,
        to destination: Node
    ) -> Path<Node, Edge>? {
        let result = computeShortestPaths(in: graph, from: source, stopAt: destination)
        return result.connectingEdges[destination].flatMap { _ in
            Path(connectingEdges: result.connectingEdges, source: source, destination: destination)
        }
    }

    @usableFromInline func computeShortestPaths(
        in graph: some GraphProtocol<Node, Edge>,
        from source: Node,
        stopAt destination: Node?
    ) -> (costs: [Node: Edge.Weight], connectingEdges: [Node: GraphEdge<Node, Edge>]) {
        var openSet = Heap<State>()
        var costs: [Node: Edge.Weight] = [source: .zero]
        var connectingEdges: [Node: GraphEdge<Node, Edge>] = [:]
        var closedSet: Set<Node> = []

        openSet.insert(
            State(
                node: source,
                totalCost: .zero
            )
        )

        while let currentState = openSet.popMin() {
            let currentNode = currentState.node

            if let destination = destination, currentNode == destination {
                break
            }

            if !closedSet.insert(currentNode).inserted {
                continue
            }

            for edge in graph.edges(from: currentNode) {
                let neighbor = edge.destination
                let weight = edge.value.weight
                let newCost = currentState.totalCost + weight

                if costs[neighbor] == nil || newCost < costs[neighbor]! {
                    costs[neighbor] = newCost
                    connectingEdges[neighbor] = edge
                    openSet.insert(State(node: neighbor, totalCost: newCost))
                }
            }
        }

        return (costs, connectingEdges)
    }

    @usableFromInline struct State: Comparable {
        @usableFromInline let node: Node
        @usableFromInline let totalCost: Edge.Weight

        @inlinable init(node: Node, totalCost: Edge.Weight) {
            self.node = node
            self.totalCost = totalCost
        }

        @inlinable public static func < (lhs: State, rhs: State) -> Bool {
            lhs.totalCost < rhs.totalCost
        }
    }
}
