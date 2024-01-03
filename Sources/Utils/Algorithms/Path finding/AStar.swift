import Collections

public final class AStar<Traversal: Traversable & Terminable, Cost: Numeric & Comparable> where Traversal.Node: Hashable, Traversal.Edge: WeightedEdgeProtocol, Traversal.Edge.Weight == Cost {
    public typealias Node = Traversal.Node

    @usableFromInline final class AStarNode: Comparable {
        @usableFromInline let node: Node
        @usableFromInline let parent: AStarNode?
        @usableFromInline var gScore: Cost
        @usableFromInline var hScore: Cost
        @usableFromInline var fScore: Cost { gScore + hScore }

        @usableFromInline init(node: Node, parent: AStarNode? = nil, gScore: Cost = 0, hScore: Cost = 0) {
            self.node = node
            self.parent = parent
            self.gScore = gScore
            self.hScore = hScore
        }

        @usableFromInline static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
            lhs.node == rhs.node
        }

        @usableFromInline static func < (lhs: AStarNode, rhs: AStarNode) -> Bool {
            lhs.fScore < rhs.fScore
        }
    }

    @usableFromInline let traversal: Traversal
    @usableFromInline let heuristic: (Traversal.Node) -> Cost

    @inlinable public init(traversal: () -> Traversal, heuristic: @escaping (Traversal.Node) -> Cost = { _ in 0 }) {
        self.traversal = traversal()
        self.heuristic = heuristic
    }

    @inlinable public func shortestPath() -> [Node] {
        var explored: [Node: Cost] = [:]
        explored[traversal.start] = 0
        return Search {
            MinimumFirst()
        } traversal: {
            Utils.Traversal(start: AStarNode(node: traversal.start)) { [traversal, heuristic] currentNode in
                traversal.edges(from: currentNode.node).compactMap { edge in
                    let moveCost = edge.weight
                    let newCost = currentNode.gScore + moveCost

                    let neighbor = edge.destination
                    if explored[neighbor].map({ $0 > newCost }) ?? true {
                        explored[neighbor] = newCost
                        return AStarNode(node: neighbor, parent: currentNode, gScore: newCost, hScore: heuristic(currentNode.node))
                    } else {
                        return nil
                    }
                }
            }
        }
        .first { [traversal] in traversal.goalReached(for: $0.node) }
        .map(buildPath) ?? []
    }

    @usableFromInline func buildPath(from node: AStarNode) -> [Node] {
        var path: [Node] = []
        var current: AStarNode? = node
        while let currentNode = current {
            path.append(currentNode.node)
            current = currentNode.parent
        }
        return path.reversed()
    }
}
