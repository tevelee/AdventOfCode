extension EulerianPathAlgorithm {
    @inlinable public static func hierholzer<Node, Edge: Numeric>() -> Self where Self == HierholzerEulerianPathAlgorithm<Node, Edge> {
        .init(defaultEdgeValue: .zero)
    }

    @inlinable public static func hierholzer<Node>() -> Self where Self == HierholzerEulerianPathAlgorithm<Node, Void> {
        .init(defaultEdgeValue: ())
    }
}

public struct HierholzerEulerianPathAlgorithm<Node: Hashable, Edge>: EulerianPathAlgorithm {
    @usableFromInline let defaultEdgeValue: Edge

    @inlinable public init(defaultEdgeValue: Edge) {
        self.defaultEdgeValue = defaultEdgeValue
    }

    @inlinable public func findEulerianPath(
        from source: Node,
        to destination: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        guard graph.hasEulerianPath() else { return nil }

        var adjacency = [Node: [GraphEdge<Node, Edge>]]()
        for edge in graph.allEdges {
            adjacency[edge.source, default: []].append(edge)
        }

        let tempEdge = GraphEdge(source: destination, destination: source, value: defaultEdgeValue)
        adjacency[destination, default: []].append(tempEdge)

        var stack = [source]
        var circuit: [GraphEdge<Node, Edge>] = []

        while !stack.isEmpty {
            let current = stack.last!

            if var edges = adjacency[current], !edges.isEmpty {
                let edge = edges.removeLast()
                adjacency[current]! = edges
                stack.append(edge.destination)
            } else {
                stack.removeLast()
                if let last = stack.last, let edge = graph.allEdges.first(where: { $0.source == last && $0.destination == current }) {
                    circuit.append(edge)
                }
            }
        }

        let orderedCircuit = Array(circuit.reversed())

        guard let tempIndex = orderedCircuit.firstIndex(where: { $0.source == destination && $0.destination == source }) else {
            return nil
        }

        let pathEdges = orderedCircuit[tempIndex + 1 ..< orderedCircuit.endIndex] + orderedCircuit[0 ..< tempIndex]

        let finalPathEdges = pathEdges.filter { !($0.source == destination && $0.destination == source) }

        if finalPathEdges.count == graph.allEdges.count {
            return Path(source: source, destination: destination, edges: Array(finalPathEdges))
        } else {
            return nil
        }
    }

    @inlinable public func findEulerianCycle(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        guard graph.hasEulerianCycle() else { return nil }

        var adjacency = [Node: [GraphEdge<Node, Edge>]]()
        for edge in graph.allEdges {
            adjacency[edge.source, default: []].append(edge)
        }

        var stack = [source]
        var circuit: [GraphEdge<Node, Edge>] = []

        while !stack.isEmpty {
            let current = stack.last!

            if var edges = adjacency[current], !edges.isEmpty {
                let edge = edges.removeLast()
                adjacency[current]! = edges
                stack.append(edge.destination)
            } else {
                stack.removeLast()
                if let last = stack.last, let edge = graph.allEdges.first(where: { $0.source == last && $0.destination == current }) {
                    circuit.append(edge)
                }
            }
        }

        let orderedCircuit = circuit.reversed()

        if orderedCircuit.count == graph.allEdges.count {
            return Path(source: source, destination: source, edges: Array(orderedCircuit))
        } else {
            return nil
        }
    }
}
