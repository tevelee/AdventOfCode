import Collections

extension MaxFlowAlgorithm {
    @inlinable public static func fordFulkerson<Node, Edge>() -> Self where Self == FordFulkersonAlgorithm<Node, Edge> {
        FordFulkersonAlgorithm()
    }
}

public struct FordFulkersonAlgorithm<Node: Hashable, Edge: Hashable & Weighted>: MaxFlowAlgorithm where Edge.Weight: Numeric {
    @inlinable public init() {}

    @inlinable public func maximumFlow(
        in graph: some FullGraphProtocol<Node, Edge>,
        from source: Node,
        to sink: Node
    ) -> Edge.Weight {
        var residual = ResidualGraph(graph: graph)
        var maxFlow: Edge.Weight = .zero

        while let path = residual.searchFirst(from: source, strategy: .dfs(.trackPath()), goal: { $0.node == sink }) {
            let flow = path.edges.map { residual.residualCapacity(from: $0.source, to: $0.destination) }.min() ?? .zero
            maxFlow += flow
            residual.addFlow(path: path.path, flow: flow)
        }

        return maxFlow
    }

    @inlinable public func minimumCut(
        in graph: some FullGraphProtocol<Node, Edge>,
        from source: Node,
        to sink: Node
    ) -> (cutValue: Edge.Weight, cutEdges: Set<GraphEdge<Node, Edge>>) {
        var residual = ResidualGraph(graph: graph)
        var maxFlow: Edge.Weight = .zero

        while let path = residual.searchFirst(from: source, strategy: .dfs(.trackPath()), goal: { $0.node == sink }) {
            let flow = path.edges.map { residual.residualCapacity(from: $0.source, to: $0.destination) }.min() ?? .zero
            maxFlow += flow
            residual.addFlow(path: path.path, flow: flow)
        }

        let reachable = residual.reachableNodes(from: source)
        let cutEdges = graph.allEdges.filter { edge in
            reachable.contains(edge.source) && !reachable.contains(edge.destination)
        }

        return (cutValue: maxFlow, cutEdges: Set(cutEdges))
    }
}
