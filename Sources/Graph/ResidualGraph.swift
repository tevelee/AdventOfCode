public struct ResidualGraph<Graph: FullGraphProtocol>: GraphProtocol where Graph.Node: Hashable, Graph.Edge: Weighted, Graph.Edge.Weight: Numeric {
    public typealias Node = Graph.Node
    public typealias Edge = Graph.Edge.Weight

    @usableFromInline var graph: Graph
    @usableFromInline var flows: [Graph.Node: [Graph.Node: Edge]]

    @inlinable public init(graph: Graph) {
        self.graph = graph
        self.flows = [:]
    }

    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        var residualEdges: [GraphEdge<Node, Edge>] = []
        for edge in graph.edges(from: node) {
            let capacity = edge.value.weight
            let flow = flows[node]?[edge.destination] ?? 0
            let residualCapacity = capacity - flow
            if residualCapacity > 0 {
                residualEdges.append(GraphEdge(source: node, destination: edge.destination, value: residualCapacity))
            }

            // Add reverse edge for possible flow cancellation
            let reverseFlow = flows[edge.destination]?[node] ?? 0
            if reverseFlow > 0 {
                residualEdges.append(GraphEdge(source: edge.destination, destination: node, value: reverseFlow))
            }
        }
        return residualEdges
    }

    @inlinable public mutating func addFlow(path: [Graph.Node], flow: Edge) {
        for i in 0..<path.count-1 {
            let u = path[i]
            let v = path[i+1]
            flows[u, default: [:]][v, default: 0] += flow
            flows[v, default: [:]][u, default: 0] -= flow
        }
    }

    @inlinable public func flow(from u: Node, to v: Node) -> Edge {
        flows[u]?[v] ?? 0
    }

    @inlinable public func capacity(from u: Node, to v: Node) -> Edge {
        graph.edges(from: u).first(where: { $0.destination == v })?.value.weight ?? 0
    }

    @inlinable public func residualCapacity(from u: Node, to v: Node) -> Edge {
        capacity(from: u, to: v) - flow(from: u, to: v)
    }
}

extension ResidualGraph {
    @inlinable public func reachableNodes(from source: Node) -> Set<Node> {
        var reachable = Set<Node>()
        var queue: [Node] = [source]
        reachable.insert(source)

        while !queue.isEmpty {
            let current = queue.removeFirst()
            for edge in edges(from: current) {
                let neighbor = edge.destination
                if !reachable.contains(neighbor) && edge.value > .zero {
                    reachable.insert(neighbor)
                    queue.append(neighbor)
                }
            }
        }

        return reachable
    }
}
