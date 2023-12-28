import Foundation
import Collections

//ShortestPath {
//    AStar()
//} traversal: {
//    Traversal(start: "A") { node in
//        connections[node].flatMap { Edge(source: node, destination: $0).withWeight(0).withHeuristic(0) } ?? []
//    }
//    .goal {
//        $0.node == "Z"
//    }
//}

//final class AStar<Traversal: Traversable & Terminable, Cost: Numeric & Comparable> where Traversal.Node: Hashable, Traversal.Edges.Element == Edge<Traversal.Node> {
//    typealias Node = Traversal.Node
//
//    private final class AStarNode: Comparable {
//        let node: Node
//        let parent: AStarNode?
//        var gScore: Cost
//        var hScore: Cost
//        var fScore: Cost { gScore + hScore }
//
//        init(node: Node, parent: AStarNode? = nil, gScore: Cost = 0, hScore: Cost = 0) {
//            self.node = node
//            self.parent = parent
//            self.gScore = gScore
//            self.hScore = hScore
//        }
//
//        static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
//            lhs.node == rhs.node
//        }
//
//        static func < (lhs: AStarNode, rhs: AStarNode) -> Bool {
//            lhs.fScore < rhs.fScore
//        }
//    }
//
//    private let traversal: Traversal
//
//    init(traversal: Traversal) {
//        self.traversal = traversal
//    }
//
//    func shortestPath(from start: Node, to destination: Node) -> [Node] {
//        var frontier = Heap<AStarNode>() // Assume Heap is a priority queue implementation
//        frontier.insert(AStarNode(node: start))
//
//        var explored: [Node: Cost] = [:]
//        explored[start] = 0
//
//        while let currentNode = frontier.popMin() {
//            let current = currentNode.node
//
//            if traversal.goalReached(for: current) {
//                return buildPath(from: currentNode)
//            }
//
//            for edge in traversal.edges(from: current) {
//                let neighbor = edge.destination
//                let moveCost = edge.weight
//                let newCost = currentNode.gScore + moveCost
//
//                if explored[neighbor] == nil || explored[neighbor]! > newCost {
//                    explored[neighbor] = newCost
//                    let hScore = edge.heuristic(from: current, to: destination)
//                    let node = AStarNode(node: neighbor, parent: currentNode, gScore: newCost, hScore: hScore)
//                    frontier.insert(node)
//                }
//            }
//        }
//
//        return []
//    }
//
//    private func buildPath(from node: AStarNode) -> [Node] {
//        var path: [Node] = []
//        var current: AStarNode? = node
//        while let currentNode = current {
//            path.append(currentNode.node)
//            current = currentNode.parent
//        }
//        return path.reversed()
//    }
//}
