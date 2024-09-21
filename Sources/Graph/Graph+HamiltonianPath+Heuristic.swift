import Collections

extension HamiltonianPathAlgorithm {
    @inlinable public static func heuristic<Node, Edge>(_ heuristic: Self.Heuristic) -> Self where Self == HeuristicHamiltonianPathAlgorithm<Node, Edge> {
        .init(heuristic: heuristic)
    }
}

public struct HeuristicHamiltonianPathAlgorithm<Node: Hashable, Edge>: HamiltonianPathAlgorithm {
    public struct Heuristic {
        public let evaluate: (_ node: Node, _ path: [Node], _ graph: any FullGraphProtocol<Node, Edge>) -> Double

        @inlinable public init(evaluate: @escaping (Node, [Node], any FullGraphProtocol<Node, Edge>) -> Double) {
            self.evaluate = evaluate
        }
    }

    public let heuristic: Heuristic

    @inlinable public init(heuristic: Heuristic) {
        self.heuristic = heuristic
    }

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
        var openSet = Heap<State>()
        let initialHeuristic = heuristic.evaluate(source, [source], graph)
        openSet.insert(State(node: source, path: [source], visited: [source], estimatedTotalCost: initialHeuristic))

        while let currentState = openSet.popMin() {
            let currentNode = currentState.node

            if currentState.visited.count == graph.allNodes.count {
                if isCycle {
                    if graph.edges(from: currentNode).contains(where: { $0.destination == source }) {
                        // Reconstruct the path and append the closing edge
                        let edges = constructEdges(from: currentState.path, withCycle: true, graph: graph)
                        return Path(source: source, destination: destination, edges: edges)
                    }
                } else {
                    let edges = constructEdges(from: currentState.path, withCycle: false, graph: graph)
                    return Path(source: source, destination: destination, edges: edges)
                }
                continue
            }

            // Explore all unvisited neighbors
            for edge in graph.edges(from: currentNode) {
                let neighbor = edge.destination
                if currentState.visited.contains(neighbor) {
                    continue
                }

                // Create a new path by appending the neighbor
                var newPath = currentState.path
                newPath.append(neighbor)

                // Update the visited set
                var newVisited = currentState.visited
                newVisited.insert(neighbor)

                // Calculate the heuristic for the neighbor
                let heuristicValue = heuristic.evaluate(neighbor, newPath, graph)

                // Create a new state and add it to the open set
                let newState = State(
                    node: neighbor,
                    path: newPath,
                    visited: newVisited,
                    estimatedTotalCost: Double(newPath.count) + heuristicValue
                )
                openSet.insert(newState)
            }
        }

        return nil
    }

    @usableFromInline func constructEdges(
        from nodes: [Node],
        withCycle: Bool,
        graph: any FullGraphProtocol<Node, Edge>
    ) -> [GraphEdge<Node, Edge>] {
        var edges: [GraphEdge<Node, Edge>] = []
        for i in 0..<nodes.count - 1 {
            let source = nodes[i]
            let destination = nodes[i + 1]
            if let edge = graph.edges(from: source).first(where: { $0.destination == destination }) {
                edges.append(edge)
            }
        }
        if withCycle, let lastEdge = graph.edges(from: nodes.last!).first(where: { $0.destination == nodes.first! }) {
            edges.append(lastEdge)
        }
        return edges
    }

    @usableFromInline struct State: Comparable {
        @usableFromInline let node: Node
        @usableFromInline let path: [Node]
        @usableFromInline let visited: Set<Node>
        @usableFromInline let estimatedTotalCost: Double

        @inlinable init(node: Node, path: [Node], visited: Set<Node>, estimatedTotalCost: Double) {
            self.node = node
            self.path = path
            self.visited = visited
            self.estimatedTotalCost = estimatedTotalCost
        }

        @inlinable static func < (lhs: State, rhs: State) -> Bool {
            lhs.estimatedTotalCost < rhs.estimatedTotalCost
        }
    }
}

extension HeuristicHamiltonianPathAlgorithm.Heuristic {
    @inlinable public static func degree() -> Self {
        .init { node, _, graph in
            Double(graph.edges(from: node).count)
        }
    }

    @inlinable public static func distance(distanceAlgorithm: DistanceAlgorithm<Node, Double>) -> Self {
        .init { node, path, graph in
            let visited = Set(path)
            let unvisited = graph.allNodes.filter { !visited.contains($0) }
            guard !unvisited.isEmpty else { return .zero }

            let totalDistance = unvisited.reduce(.zero) { sum, unvisitedNode in
                return sum + distanceAlgorithm.distance(node, unvisitedNode)
            }
            return -totalDistance / Double(unvisited.count)
        }
    }
}
