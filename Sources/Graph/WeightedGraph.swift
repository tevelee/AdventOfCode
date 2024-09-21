public struct WeightedGraph<Graph: GraphProtocol, Edge: Weighted>: GraphProtocol {
    public typealias Node = Graph.Node

    @usableFromInline let graph: Graph
    @usableFromInline let weight: (Node, Node) -> Edge

    @inlinable public init(
        graph: Graph,
        weight: @escaping (Node, Node) -> Edge
    ) where Graph.Edge == Void {
        self.graph = graph
        self.weight = weight
    }

    public func edges(from node: Graph.Node) -> [GraphEdge<Graph.Node, Edge>] {
        graph.edges(from: node).map {
            GraphEdge(
                source: $0.source,
                destination: $0.destination,
                value: weight($0.source, $0.destination)
            )
        }
    }
}

extension WeightedGraph {
    @inlinable public init<Value, PreviousEdge>(
        graph: Graph,
        weight: @escaping (Graph.Node, Graph.Node, PreviousEdge) -> Edge
    ) where Graph == GridGraph<Value, PreviousEdge> {
        self.graph = graph
        self.weight = { source, destination in
            weight(source, destination, graph.edge(source, destination))
        }
    }
}

extension GraphProtocol where Edge == Void {
    @inlinable public func weighted<NewEdge: Weighted>(weight: @escaping (Node, Node) -> NewEdge) -> WeightedGraph<Self, NewEdge> {
        WeightedGraph(graph: self, weight: weight)
    }

    @inlinable public func weighted<NewEdge: Weighted>(constant value: @autoclosure @escaping () -> NewEdge) -> WeightedGraph<Self, NewEdge> {
        WeightedGraph(graph: self) { _, _ in value() }
    }
}

extension GridGraph where Edge == Void {
    @inlinable public func weightedByDistance(_ distanceAlgorithm: DistanceAlgorithm<Node, Double> = .eucledianDistance(of: \Self.Node.position.coordinates)) -> WeightedGraph<Self, Double> {
        WeightedGraph(graph: self, weight: distanceAlgorithm.distance)
    }
}
