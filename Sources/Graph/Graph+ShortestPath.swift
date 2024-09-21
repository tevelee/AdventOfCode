extension GraphProtocol where Node: Hashable, Edge: Weighted {
    @inlinable public func shortestPath(
        from source: Node,
        to destination: Node,
        using algorithm: some ShortestPathAlgorithm<Node, Edge>
    ) -> Path<Node, Edge>? {
        algorithm.shortestPath(in: self, from: source, to: destination)
    }
}

public protocol ShortestPathAlgorithm<Node, Edge> {
    associatedtype Node
    associatedtype Edge

    @inlinable func shortestPath(
        in graph: some GraphProtocol<Node, Edge>,
        from start: Node,
        to goal: Node
    ) -> Path<Node, Edge>?
}

public struct Path<Node, Edge> {
    public let source: Node
    public let destination: Node
    public let edges: [GraphEdge<Node, Edge>]

    @inlinable public init(source: Node, destination: Node, edges: [GraphEdge<Node, Edge>]) {
        self.source = source
        self.destination = destination
        self.edges = edges
    }

    @inlinable public var path: [Node] {
        [source] + edges.map(\.destination)
    }
}

extension Path: Equatable where Node: Equatable, Edge: Equatable {}
extension Path: Hashable where Node: Hashable, Edge: Hashable {}

extension Path where Edge: Weighted, Edge.Weight: Numeric {
    @inlinable public var cost: Edge.Weight {
        edges.lazy.map(\.value.weight).reduce(into: .zero, +=)
    }
}

extension Path where Node: Hashable {
    @inlinable init?(
        connectingEdges: [Node: GraphEdge<Node, Edge>],
        source: Node,
        destination: Node
    ) {
        var path: [GraphEdge<Node, Edge>] = []
        var currentNode = destination

        while currentNode != source {
            guard let edge = connectingEdges[currentNode] else {
                return nil
            }
            path.append(edge)
            currentNode = edge.source
        }

        self.init(source: source, destination: destination, edges: path.reversed())
    }
}
