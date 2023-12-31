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
