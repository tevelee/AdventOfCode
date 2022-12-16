public final class Disktra<Node: Hashable> {
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

    public func shortestPaths(from origin: Node) -> [Node: [Node]] {
        let paths: Paths = shortestPaths(from: origin)
        return Dictionary(uniqueKeysWithValues: nodes.map { (key: $0.key, value: self.path(to: $0.key, in: paths)) })
    }

    public func shortestPath(from origin: Node, to destination: Node) -> [Node] {
        path(to: destination, in: shortestPaths(from: origin))
    }

    private typealias PathComponent = (shortestDistance: Int, previousNode: Node?)
    private typealias Paths = [Node: PathComponent]

    private func shortestPaths(from origin: Node) -> Paths {
        var unvisitedNodes: Set<Node> = Set(nodes.keys)
        var currentlyKnownShortestPaths: Paths = nodes.mapValues { _ in (shortestDistance: .max, previousNode: nil) }
        currentlyKnownShortestPaths[origin] = (shortestDistance: 0, previousNode: nil)

        repeat {
            let next = unvisitedNodes
                .lazy
                .compactMap { node in
                    currentlyKnownShortestPaths[node].map {
                        (node: node, distance: $0.shortestDistance)
                    }
                }
                .min { $0.distance < $1.distance }
            if let next {
                let unvisitedNeighbors = nodes[next.node]!.filter { unvisitedNodes.contains($0.node) }
                for neighbor in unvisitedNeighbors {
                    let newDistance = neighbor.weight + next.distance
                    if newDistance < currentlyKnownShortestPaths[neighbor.node]!.shortestDistance {
                        currentlyKnownShortestPaths[neighbor.node] = (shortestDistance: newDistance, previousNode: next.node)
                    }
                }
                unvisitedNodes.remove(next.node)
            } else {
                break
            }
        } while !unvisitedNodes.isEmpty

        return currentlyKnownShortestPaths
    }

    private func path(to node: Node, in paths: Paths) -> [Node] {
        var currentNode = node
        var path: [Node] = [node]
        while let previous = paths[currentNode]?.previousNode {
            path.append(previous)
            currentNode = previous
        }
        return path.reversed()
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
