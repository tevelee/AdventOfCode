public protocol FullGraphProtocol<Node, Edge>: GraphProtocol {
    var allNodes: [Node] { get }
    var allEdges: [GraphEdge<Node, Edge>] { get }
}

extension FullGraphProtocol {
    @inlinable public var allEdges: [GraphEdge<Node, Edge>] {
        allNodes.flatMap(edges)
    }
}

extension GraphProtocol where Self: FullGraphProtocol, Node: Equatable {
    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        allEdges.filter { $0.source == node }
    }
}

extension Graph: FullGraphProtocol where Node: Hashable {
    public var allNodes: [Node] {
        var nodes = Set<Node>()
        for edge in _edges {
            nodes.insert(edge.source)
            nodes.insert(edge.destination)
        }
        return Array(nodes)
    }

    public var allEdges: [GraphEdge<Node, Edge>] {
        _edges
    }
}

extension BinaryGraph: FullGraphProtocol where Node: Hashable {
    public var allNodes: [Node] {
        var nodes = Set<Node>()
        for edge in _edges {
            nodes.insert(edge.source)
            if let node = edge.lhs?.destination {
                nodes.insert(node)
            }
            if let node = edge.rhs?.destination {
                nodes.insert(node)
            }
        }
        return Array(nodes)
    }

    public var allEdges: [GraphEdge<Node, Edge>] {
        _edges.compactMap(\.lhs) + _edges.compactMap(\.rhs)
    }
}

extension HashedGraph: FullGraphProtocol {
    public var allNodes: [Node] {
        var map: [HashValue: Node] = [:]
        for edge in allEdges {
            map[hashValue(edge.source)] = edge.source
            map[hashValue(edge.destination)] = edge.destination
        }
        return Array(map.values)
    }

    public var allEdges: [GraphEdge<Node, Edge>] {
        _edges.values.flatMap(\.self)
    }
}

extension GridGraph: FullGraphProtocol {
    public var allNodes: [Node] {
        grid.positions.map { self[$0] }
    }
}

extension WeightedGraph: FullGraphProtocol where Graph: FullGraphProtocol {
    public var allNodes: [Node] {
        graph.allNodes
    }

    public var allEdges: [GraphEdge<Node, Edge>] {
        graph.allEdges.map { edge in
            GraphEdge(
                source: edge.source,
                destination: edge.destination,
                value: weight(edge.source, edge.destination)
            )
        }
    }
}
