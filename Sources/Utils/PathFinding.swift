import SwiftGraph
import Collections

public protocol PathFinding {
    associatedtype Coordinate: Hashable
    associatedtype Cost: Numeric & Comparable

    func neighbors(for point: Coordinate, goal: Coordinate) -> [Coordinate]
    func costToMove(from: Coordinate, to: Coordinate) -> Cost
    func distance(from: Coordinate, to: Coordinate) -> Cost
    func goalReached(at: Coordinate, goal: Coordinate) -> Bool
}

public protocol PathFinder {
    associatedtype Map: PathFinding
    func shortestPath(from start: Map.Coordinate, to destination: Map.Coordinate) -> [Map.Coordinate]
}

public final class AStar<Map: PathFinding>: PathFinder {
    public typealias Coordinate = Map.Coordinate
    public typealias Cost = Map.Cost

    private final class AStarNode: Comparable {
        let coordinate: Coordinate
        let parent: AStarNode?

        var fScore: Cost { gScore + hScore }
        let gScore: Cost
        let hScore: Cost

        init(coordinate: Coordinate, parent: AStarNode? = nil, moveCost: Cost = 0, hScore: Cost = 0) {
            self.coordinate = coordinate
            self.parent = parent
            self.gScore = (parent?.gScore ?? 0) + moveCost
            self.hScore = hScore
        }

        static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
            lhs.coordinate == rhs.coordinate
        }

        static func < (lhs: AStarNode, rhs: AStarNode) -> Bool {
            lhs.fScore < rhs.fScore
        }
    }

    private let map: Map

    public init(map: Map) {
        self.map = map
    }

    public func shortestPath(from start: Coordinate, to destination: Coordinate) -> [Coordinate] {
        var frontier = Heap<AStarNode>()
        frontier.insert(AStarNode(coordinate: start))

        var explored: [Coordinate: Cost] = [:]
        explored[start] = 0

        while let currentNode = frontier.popMin() {
            let currentCoordinate = currentNode.coordinate

            if map.goalReached(at: currentCoordinate, goal: destination) {
                var result = [Coordinate]()
                var node: AStarNode? = currentNode
                while let n = node {
                    result.append(n.coordinate)
                    node = n.parent
                }
                return Array(result.reversed().dropFirst())
            }

            for neighbor in map.neighbors(for: currentCoordinate, goal: destination) {
                let moveCost = map.costToMove(from: currentCoordinate, to: neighbor)
                let newcost = currentNode.gScore + moveCost

                if explored[neighbor] == nil || explored[neighbor]! > newcost {
                    explored[neighbor] = newcost
                    let hScore = map.distance(from: currentCoordinate, to: neighbor)
                    let node = AStarNode(coordinate: neighbor, parent: currentNode, moveCost: moveCost, hScore: hScore)
                    frontier.insert(node)
                }
            }
        }

        return []
    }
}
