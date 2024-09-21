extension HamiltonianPathAlgorithm {
    @inlinable public static func backtracking<Node, Edge>() -> Self where Self == BacktrackingHamiltonianPathAlgorithm<Node, Edge> {
        .init()
    }
}

public struct BacktrackingHamiltonianPathAlgorithm<Node: Hashable, Edge>: HamiltonianPathAlgorithm {
    @inlinable public init() {}

    @inlinable public func findHamiltonianPath(
        from source: Node,
        to destination: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        findHamiltonianSequence(from: source, to: destination, isCycle: false, in: graph)
    }

    @inlinable public func findHamiltonianCycle(
        from source: Node,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        findHamiltonianSequence(from: source, to: source, isCycle: true, in: graph)
    }

    @usableFromInline func findHamiltonianSequence(
        from source: Node,
        to destination: Node,
        isCycle: Bool,
        in graph: some FullGraphProtocol<Node, Edge>
    ) -> Path<Node, Edge>? {
        let allNodes = Set(graph.allNodes)
        var path: [Node] = [source]
        var visited = Set<Node>([source])
        var resultPath: [GraphEdge<Node, Edge>]?

        func backtrack(current: Node) {
            if resultPath != nil {
                return
            }

            if visited.count == allNodes.count {
                if isCycle {
                    if let closingEdge = graph.edges(from: current).first(where: { $0.destination == source }) {
                        let edges = constructEdges(from: path, withCycle: true, closingEdge: closingEdge)
                        resultPath = edges
                    }
                } else {
                    let edges = constructEdges(from: path, withCycle: false, closingEdge: nil)
                    resultPath = edges
                }
                return
            }

            for edge in graph.edges(from: current) {
                let neighbor = edge.destination
                if !visited.contains(neighbor) {
                    // Choose
                    visited.insert(neighbor)
                    path.append(neighbor)

                    // Explore
                    backtrack(current: neighbor)

                    // Un-choose (backtrack)
                    visited.remove(neighbor)
                    path.removeLast()
                }
            }
        }

        func constructEdges(from nodes: [Node], withCycle: Bool, closingEdge: GraphEdge<Node, Edge>?) -> [GraphEdge<Node, Edge>] {
            var edges: [GraphEdge<Node, Edge>] = []
            for i in 0..<nodes.count - 1 {
                let source = nodes[i]
                let destination = nodes[i + 1]
                if let edge = graph.edges(from: source).first(where: { $0.destination == destination }) {
                    edges.append(edge)
                }
            }
            if withCycle, let closingEdge = closingEdge {
                edges.append(closingEdge)
            }
            return edges
        }

        backtrack(current: source)

        if let edges = resultPath {
            return Path(source: source, destination: destination, edges: edges)
        }
        return nil
    }
}
