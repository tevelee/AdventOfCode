import Foundation

public protocol Search {
    associatedtype Coordinate: Hashable

    func neighbors(for point: Coordinate) -> [Coordinate]
    func goalReached(at: Coordinate) -> Bool
}

protocol SearchStrategy<Node> {
    associatedtype Node

    mutating func add(_ node: Node)
    mutating func next() -> Node?
}

func search<Map: Search>(
    start: Map.Coordinate,
    map: Map,
    strategy: inout some SearchStrategy<Map.Coordinate>
) -> Map.Coordinate? {
    var visited = Set<Map.Coordinate>()
    strategy.add(start)

    while let current = strategy.next() {
        if map.goalReached(at: current) {
            return current
        }

        visited.insert(current)

        for neighbor in map.neighbors(for: current) where !visited.contains(neighbor) {
            strategy.add(neighbor)
        }
    }

    return nil
}

struct BFS<Node>: SearchStrategy where Node: Hashable {
    private var queue: [Node] = []

    mutating func add(_ node: Node) {
        queue.append(node)
    }

    mutating func next() -> Node? {
        if queue.isEmpty {
            nil
        } else {
            queue.removeFirst()
        }
    }
}

struct DFS<Node>: SearchStrategy where Node: Hashable {
    private var stack: [Node] = []

    mutating func add(_ node: Node) {
        stack.append(node)
    }

    mutating func next() -> Node? {
        stack.popLast()
    }
}
