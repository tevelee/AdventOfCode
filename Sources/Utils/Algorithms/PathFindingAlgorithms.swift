import Collections

public protocol PathFinding {
    associatedtype Coordinate: Hashable
    associatedtype Cost: FixedWidthInteger

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

public final class Dijkstra<Map: PathFinding>: PathFinder where Map.Coordinate: Comparable {
    public typealias Coordinate = Map.Coordinate
    public typealias Cost = Map.Cost

    private let map: Map

    public init(map: Map) {
        self.map = map
    }

    public func shortestPath(from start: Coordinate, to destination: Coordinate) -> [Coordinate] {
        buildPath(from: dijkstraCore(from: start).predecessors, destination: destination).reversed()
    }

    public func shortestPaths(from start: Coordinate) -> [Coordinate: [Coordinate]] {
        let predecessors = dijkstraCore(from: start).predecessors
        var paths = [Coordinate: [Coordinate]]()
        for (node, _) in predecessors {
            paths[node] = buildPath(from: predecessors, destination: node).reversed()
        }
        return paths
    }

    private func dijkstraCore(from start: Coordinate) -> (distances: [Coordinate: Cost], predecessors: [Coordinate: Coordinate?]) {
        var distances = [Coordinate: Cost]()
        var predecessors = [Coordinate: Coordinate?]()
        var priorityQueue = Heap<Coordinate>()

        distances[start] = 0
        priorityQueue.insert(start)

        while let current = priorityQueue.popMin() {
            for neighbor in map.neighbors(for: current, goal: start) {
                let newDistance = distances[current, default: .max] + map.costToMove(from: current, to: neighbor)
                if newDistance < distances[neighbor, default: .max] {
                    distances[neighbor] = newDistance
                    predecessors[neighbor] = current
                    priorityQueue.insert(neighbor)
                }
            }
        }

        return (distances, predecessors)
    }

    private func buildPath(from predecessors: [Coordinate: Coordinate?], destination: Coordinate) -> [Coordinate] {
        var path = [Coordinate]()
        var current: Coordinate? = destination
        while let next = current, let predecessor = predecessors[next] {
            path.append(next)
            current = predecessor
        }
        return path
    }
}

public protocol AllCoordinatesProviding {
    associatedtype Coordinate: Hashable
    var allCoordinates: [Coordinate] { get }
}

public final class FloydWarshall<Node: Hashable> {
    public struct Connection: Hashable {
        public let node: Node
        public let weight: Int

        public init(node: Node, weight: Int) {
            self.node = node
            self.weight = weight
        }
    }

    private let nodes: [Node: Set<Connection>]

    public init(nodes: [Node: Set<Connection>]) {
        self.nodes = nodes
    }

    public lazy var shortestPaths: [Node: [Node: Int]] = calculate()

    private func calculate() -> [Node: [Node: Int]] {
        var result: [Node: [Node: Int]] = [:]
        for (node, connections) in nodes {
            for other in nodes.keys {
                result[node, default: [:]][other] = 9999 // TODO: Int.max causes artihmetic overflow
            }
            for other in connections {
                result[node]![other.node] = other.weight
                //result[other.node]![node] = other.weight
            }
            result[node, default: [:]][node] = 0
        }
        for k in nodes.keys {
            for i in nodes.keys {
                for j in nodes.keys {
                    if result[i]![j]! > result[i]![k]! + result[k]![j]! {
                        result[i]![j]! = result[i]![k]! + result[k]![j]!
                    }
                }
            }
        }
        return result
    }
}
