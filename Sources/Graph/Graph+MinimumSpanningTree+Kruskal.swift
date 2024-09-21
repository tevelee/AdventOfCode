import Collections

extension MinimumSpanningTreeAlgorithm {
    @inlinable public static func kruskal<Node, Edge>() -> Self where Self == KruskalAlgorithm<Node, Edge> {
        KruskalAlgorithm()
    }
}

public struct KruskalAlgorithm<Node: Hashable, Edge: Weighted>: MinimumSpanningTreeAlgorithm {
    @inlinable public init() {}

    @inlinable public func minimumSpanningTree(in graph: some FullGraphProtocol<Node, Edge>) -> [GraphEdge<Node, Edge>] {
        let sortedEdges = graph.allEdges.sorted { $0.value.weight < $1.value.weight }
        let nodeCount = graph.allNodes.count

        var mst: [GraphEdge<Node, Edge>] = []
        var uf = UnionFind<Node>()
        for edge in sortedEdges {
            let source = edge.source
            let destination = edge.destination

            if uf.find(source) != uf.find(destination) {
                uf.union(source, destination)
                mst.append(edge)
            }

            if mst.count == nodeCount - 1 {
                break
            }
        }
        return mst
    }
}

public struct UnionFind<Node: Hashable> {
    @usableFromInline var parent: [Node: Node]

    @inlinable public init() {
        self.parent = [:]
    }

    @inlinable public mutating func find(_ node: Node) -> Node {
        if parent[node] != node && parent[node] != nil {
            parent[node] = find(parent[node]!) // Path compression
        } else if parent[node] == nil {
            parent[node] = node
        }
        return parent[node]!
    }

    @inlinable public mutating func union(_ node1: Node, _ node2: Node) {
        let root1 = find(node1)
        let root2 = find(node2)
        if root1 != root2 {
            parent[root2] = root1
        }
    }
}
