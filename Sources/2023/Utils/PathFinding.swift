import Foundation
import Collections

//ShortestPath {
//    AStar()
//} traversal: {
//    Traversal(start: "A") {
//        connections[$0] ?? []
//    }
//    .cost { _, _ in
//        1
//    }
//    .distance { _, _ in
//        1
//    }
//    .goal {
//        $0.node == "Z"
//    }
//}

//protocol ShortestPathStrategy<Node> {
//    associatedtype Node
//}
//
//struct ShortestPath<Node, Strategy: ShortestPathStrategy<Node>, Traversal: Traversable<Node>> {
//    let strategy: () -> Strategy
//    let traversal: Traversal
//
//    init(
//        strategy: @escaping () -> Strategy,
//        traversal: () -> Traversal
//    ) {
//        self.strategy = strategy
//        self.traversal = traversal()
//    }
//}
//
//private final class AStarNode<Node: Equatable, Cost: Numeric & Comparable>: Comparable {
//    let node: Node
//    let parent: AStarNode?
//
//    var fScore: Cost { gScore + hScore }
//    let gScore: Cost
//    let hScore: Cost
//
//    init(node: Node, parent: AStarNode? = nil, moveCost: Cost = 0, hScore: Cost = 0) {
//        self.node = node
//        self.parent = parent
//        self.gScore = (parent?.gScore ?? 0) + moveCost
//        self.hScore = hScore
//    }
//
//    static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
//        lhs.node == rhs.node
//    }
//
//    static func < (lhs: AStarNode, rhs: AStarNode) -> Bool {
//        lhs.fScore < rhs.fScore
//    }
//}
//
//final class AStar<Traversal: Traversable<Node> & Terminable, Node: Hashable & Equatable, Cost: Numeric & Comparable>: ShortestPathStrategy {
//    private let traversal: Traversal
//
//    init(traversal: Traversal) {
//        self.traversal = traversal
//    }
//
//    func shortestPath(from start: Node, to destination: Node) -> [Node] {
//        var frontier = Heap<AStarNode<Node, Cost>>()
//        frontier.insert(AStarNode(node: start))
//
//        var explored: [Node: Cost] = [:]
//        explored[start] = 0
//
//        while let current = frontier.popMin() {
//            if traversal.goalReached(for: current.node) {
//                return buildPath(from: current)
//            }
//
//            for neighbor in traversal.neighbors(of: current.node) {
//                let moveCost = traversal.cost(current.node, neighbor)
//                let newCost = current.gScore + moveCost
//
//                if explored[neighbor] == nil || explored[neighbor]! > newCost {
//                    explored[neighbor] = newCost
//                    let hScore = traversal.heuristic(neighbor, destination)
//                    let node = AStarNode(node: neighbor, parent: current, moveCost: moveCost, hScore: hScore)
//                    frontier.insert(node)
//                }
//            }
//        }
//
//        return []
//    }
//
//    private func buildPath(from node: AStarNode<Node, Cost>) -> [Node] {
//        var path: [Node] = []
//        var current: AStarNode? = node
//        while let n = current {
//            path.append(n.node)
//            current = n.parent
//        }
//        return Array(path.reversed().dropFirst())
//    }
//}
