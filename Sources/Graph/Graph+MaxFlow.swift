extension FullGraphProtocol where Edge: Weighted & Comparable, Node: Hashable {
    @inlinable public func maximumFlow<Algorithm: MaxFlowAlgorithm>(
        from source: Node,
        to sink: Node,
        using algorithm: Algorithm
    ) -> Edge.Weight where Algorithm.Node == Node, Algorithm.Edge == Edge {
        algorithm.maximumFlow(in: self, from: source, to: sink)
    }

    @inlinable public func minimumCut<Algorithm: MaxFlowAlgorithm>(
        from source: Node,
        to sink: Node,
        using algorithm: Algorithm
    ) -> (cutValue: Edge.Weight, cutEdges: Set<GraphEdge<Node, Edge>>) where Algorithm.Node == Node, Algorithm.Edge == Edge {
        algorithm.minimumCut(in: self, from: source, to: sink)
    }
}

public protocol MaxFlowAlgorithm<Node, Edge> {
    associatedtype Node: Hashable
    associatedtype Edge: Hashable & Weighted

    func maximumFlow(
        in graph: some FullGraphProtocol<Node, Edge>,
        from source: Node,
        to sink: Node
    ) -> Edge.Weight

    func minimumCut(
        in graph: some FullGraphProtocol<Node, Edge>,
        from source: Node,
        to sink: Node
    ) -> (cutValue: Edge.Weight, cutEdges: Set<GraphEdge<Node, Edge>>)
}

extension MaxFlowAlgorithm {
    func maximumFlow(
        in graph: some FullGraphProtocol<Node, Edge>,
        from source: Node,
        to sink: Node
    ) -> Edge.Weight {
        minimumCut(in: graph, from: source, to: sink).cutValue // ha!
    }
}
