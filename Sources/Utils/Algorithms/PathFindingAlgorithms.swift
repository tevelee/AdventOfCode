import Collections

public protocol PathFinding {
    associatedtype Coordinate: Hashable
    associatedtype Cost: FixedWidthInteger

    func neighbors(for point: Coordinate, goal: Coordinate) -> [Coordinate]
    func costToMove(from: Coordinate, to: Coordinate) -> Cost
    func distance(from: Coordinate, to: Coordinate) -> Cost
    func goalReached(at: Coordinate, goal: Coordinate) -> Bool
}

extension PathFinding {
    public func costToMove(from: Coordinate, to: Coordinate) -> Cost { 0 }
    public func distance(from: Coordinate, to: Coordinate) -> Cost { 1 }
    public func goalReached(at: Coordinate, goal: Coordinate) -> Bool { at == goal }
}

public protocol PathFinder {
    associatedtype Map: PathFinding
    func shortestPath(from start: Map.Coordinate, to destination: Map.Coordinate) -> [Map.Coordinate]
}

extension PathFinding {
    @inlinable public var unique: Unique<Self, Coordinate, Coordinate> {
        Unique(base: self) { $0 }
    }
}

extension Unique: PathFinding where Base: PathFinding, Element == Base.Coordinate {
    public typealias Cost = Base.Cost
    public struct Coordinate: Hashable {
        @usableFromInline let base: Base.Coordinate
        @usableFromInline let visited: Set<HashValue>

        @inlinable public init(base: Base.Coordinate, visited: Set<HashValue> = []) {
            self.base = base
            self.visited = visited
        }

        @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.base == rhs.base
        }

        @inlinable public func hash(into hasher: inout Hasher) {
            hasher.combine(base)
        }
    }

    @inlinable public func neighbors(for point: Coordinate, goal: Coordinate) -> [Coordinate] {
        base.neighbors(for: point.base, goal: goal.base)
            .filter {
                !point.visited.contains(hashValue($0))
            }
            .map {
                Coordinate(base: $0, visited: point.visited + hashValue($0))
            }
    }

    @inlinable public func costToMove(from: Coordinate, to: Coordinate) -> Cost {
        base.costToMove(from: from.base, to: to.base)
    }

    @inlinable public func distance(from: Coordinate, to: Coordinate) -> Cost {
        base.distance(from: from.base, to: to.base)
    }

    @inlinable public func goalReached(at: Coordinate, goal: Coordinate) -> Bool {
        base.goalReached(at: at.base, goal: goal.base)
    }
}

extension PathFinder {
    @inlinable public func shortestPath<BaseMap: PathFinding>(
        from start: BaseMap.Coordinate,
        to destination: BaseMap.Coordinate
    ) -> [BaseMap.Coordinate] where Map == Unique<BaseMap, BaseMap.Coordinate, BaseMap.Coordinate> {
        shortestPath(from: .init(base: start), to: .init(base: destination)).map(\.base)
    }
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
                var result: [Coordinate] = []
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

public final class Dijkstra<Map: PathFinding>: PathFinder {
    public typealias Coordinate = Map.Coordinate
    public typealias Cost = Map.Cost

    private let map: Map

    public init(map: Map) {
        self.map = map
    }

    public func shortestPath(from start: Coordinate, to destination: Coordinate) -> [Coordinate] {
        let predecessors = dijkstraCore(from: start, to: destination).predecessors
        return buildPath(from: predecessors, destination: destination)
    }

    public func shortestPaths(from start: Coordinate) -> [Coordinate: [Coordinate]] {
        let predecessors = dijkstraCore(from: start, to: nil).predecessors
        var paths: [Coordinate: [Coordinate]] = [:]
        for (node, _) in predecessors {
            paths[node] = buildPath(from: predecessors, destination: node)
        }
        return paths
    }

    struct Node: Comparable {
        var coordinate: Coordinate
        var cost: Cost

        static func < (lhs: Node, rhs: Node) -> Bool {
            return lhs.cost < rhs.cost
        }
    }

    private func dijkstraCore(from start: Coordinate, to destination: Coordinate?) -> (distances: [Coordinate: Cost], predecessors: [Coordinate: Coordinate?]) {
        var distances: [Coordinate: Cost] = [:]
        var predecessors: [Coordinate: Coordinate?] = [:]
        var priorityQueue = Heap<Node>()

        distances[start] = 0
        priorityQueue.insert(Node(coordinate: start, cost: 0))

        while let current = priorityQueue.popMin()?.coordinate {
            if let destination, map.goalReached(at: current, goal: destination) {
                break
            }
            let currentDistance = distances[current] ?? 0

            for neighbor in map.neighbors(for: current, goal: destination ?? start) {
                let distanceToNeighbor = currentDistance + map.costToMove(from: current, to: neighbor)

                if distanceToNeighbor < (distances[neighbor] ?? .max) {
                    distances[neighbor] = distanceToNeighbor
                    predecessors[neighbor] = current
                    priorityQueue.insert(Node(coordinate: neighbor, cost: distanceToNeighbor))
                }
            }
        }

        return (distances, predecessors)
    }

    private func buildPath(from predecessors: [Coordinate: Coordinate?], destination: Coordinate) -> [Coordinate] {
        var path: [Coordinate] = []
        var current: Coordinate? = destination
        while let next = current, let predecessor = predecessors[next] {
            path.append(next)
            current = predecessor
        }
        return path.reversed()
    }
}

public protocol AllCoordinatesProviding {
    associatedtype Coordinate: Hashable
    associatedtype Coordinates: Collection<Coordinate>
    var allCoordinates: Coordinates { get }
}

extension Unique: AllCoordinatesProviding where Base: AllCoordinatesProviding & PathFinding, Element == Base.Coordinate {
    @inlinable public var allCoordinates: [Coordinate] {
        base.allCoordinates.map { .init(base: $0) }
    }
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

public final class BellmanFord<Map: PathFinding & AllCoordinatesProviding>: PathFinder {
    public typealias Coordinate = Map.Coordinate
    public typealias Cost = Map.Cost

    private let map: Map

    public init(map: Map) {
        self.map = map
    }

    public func shortestPath(from start: Coordinate, to destination: Coordinate) -> [Coordinate] {
        var distances: [Coordinate: Cost] = Dictionary(minimumCapacity: map.allCoordinates.count)
        var predecessors: [Coordinate: Coordinate?] = Dictionary(minimumCapacity: map.allCoordinates.count)

        // Initialize distances and predecessors
        for vertex in map.allCoordinates {
            distances[vertex] = (vertex == start) ? 0 : Cost.max
            predecessors[vertex] = nil
        }

        // Relax edges repeatedly
        for _ in 1..<map.allCoordinates.count {
            for vertex in map.allCoordinates {
                for neighbor in map.neighbors(for: vertex, goal: destination) {
                    let edgeWeight = map.costToMove(from: vertex, to: neighbor)
                    if let currentDistance = distances[vertex], currentDistance != Cost.max,
                        currentDistance + edgeWeight < distances[neighbor, default: Cost.max] {
                        distances[neighbor] = currentDistance + edgeWeight
                        predecessors[neighbor] = vertex
                    }
                }
            }
        }

        // Check for negative weight cycles
        for vertex in map.allCoordinates {
            for neighbor in map.neighbors(for: vertex, goal: destination) {
                let edgeWeight = map.costToMove(from: vertex, to: neighbor)
                if let currentDistance = distances[vertex], currentDistance != Cost.max,
                    currentDistance + edgeWeight < distances[neighbor, default: Cost.max] {
                    return [] // Negative cycle detected
                }
            }
        }

        // Reconstruct path from predecessors
        var path: [Coordinate] = []
        var currentVertex: Coordinate? = destination

        while let current = currentVertex, current != start, let predecessor = predecessors[current] {
            path.append(current)
            currentVertex = predecessor
        }

        if currentVertex == start {
            path.append(start)
            return path.reversed()
        } else {
            return [] // No path found
        }
    }
}
