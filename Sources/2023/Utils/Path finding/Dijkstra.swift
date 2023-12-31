import Collections

public final class Dijkstra<Traversal: Traversable, Cost: FixedWidthInteger & Comparable> where Traversal.Node: Hashable {
    public let traversal: Traversal

    @inlinable public init(traversal: () -> Traversal) {
        self.traversal = traversal()
    }

    @usableFromInline internal func shortestPath(
        weight: ((Traversal.Edge) -> Cost)? = nil,
        goalReached: ((Traversal.Node) -> Bool)? = nil
    ) -> [Traversal.Node] {
        let (_, predecessors, destination) = dijkstraCore(
            from: traversal.start,
            weight: weight,
            goalReached: goalReached
        )
        return buildPath(from: predecessors, destination: destination)
    }

    @usableFromInline internal func shortestPaths(weight: ((Traversal.Edge) -> Cost)? = nil) -> [Traversal.Node: [Traversal.Node]] {
        let predecessors = dijkstraCore(from: traversal.start, weight: weight, goalReached: nil).predecessors
        var paths: [Traversal.Node: [Traversal.Node]] = [:]
        for (node, _) in predecessors {
            paths[node] = buildPath(from: predecessors, destination: node)
        }
        return paths
    }

    @usableFromInline struct Node: Comparable {
        var node: Traversal.Node
        var cost: Cost

        @usableFromInline static func < (lhs: Node, rhs: Node) -> Bool {
            return lhs.cost < rhs.cost
        }
    }

    private func dijkstraCore(
        from start: Traversal.Node,
        weight: ((Traversal.Edge) -> Cost)?,
        goalReached: ((Traversal.Node) -> Bool)?
    ) -> (distances: [Traversal.Node: Cost], predecessors: [Traversal.Node: Traversal.Node?], lastNode: Traversal.Node) {
        var distances: [Traversal.Node: Cost] = [:]
        var predecessors: [Traversal.Node: Traversal.Node?] = [:]
        var priorityQueue = Heap<Node>()

        distances[start] = 0
        priorityQueue.insert(Node(node: start, cost: 0))
        var lastNode = start

        while let current = priorityQueue.popMin()?.node {
            lastNode = current
            if goalReached?(current) ?? false {
                break
            }
            let currentDistance = distances[current] ?? 0

            for edge in traversal.edges(from: current) {
                let distanceToNeighbor = currentDistance + (weight?(edge) ?? 0)
                let neighbor = edge.destination

                if distanceToNeighbor < (distances[neighbor] ?? .max) {
                    distances[neighbor] = distanceToNeighbor
                    predecessors[neighbor] = current
                    priorityQueue.insert(Node(node: neighbor, cost: distanceToNeighbor))
                }
            }
        }

        return (distances, predecessors, lastNode)
    }

    private func buildPath(from predecessors: [Traversal.Node: Traversal.Node?], destination: Traversal.Node) -> [Traversal.Node] {
        var path: [Traversal.Node] = []
        var current: Traversal.Node? = destination
        while let next = current, let predecessor = predecessors[next] {
            path.append(next)
            current = predecessor
        }
        return path.reversed()
    }
}

extension Dijkstra where Traversal: Terminable {
    @inlinable public func shortestPath() -> [Traversal.Node] {
        shortestPath(goalReached: traversal.goalReached)
    }

    @inlinable public func shortestPath() -> [Traversal.Node] where Traversal.Edge: WeightedEdgeProtocol, Traversal.Edge.Weight == Cost {
        shortestPath(weight: { $0.weight }, goalReached: traversal.goalReached)
    }
}

extension Dijkstra where Traversal.Edge: WeightedEdgeProtocol, Traversal.Edge.Weight == Cost {
    @inlinable public func shortestPath() -> [Traversal.Node] {
        shortestPath(weight: { $0.weight })
    }

    @inlinable public func shortestPaths() -> [Traversal.Node: [Traversal.Node]] {
        shortestPaths(weight: { $0.weight })
    }
}
