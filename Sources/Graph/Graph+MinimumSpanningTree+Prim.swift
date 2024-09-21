import Collections

extension MinimumSpanningTreeAlgorithm {
    @inlinable public static func prim<Node, Edge>() -> Self where Self == PrimAlgorithm<Node, Edge> {
        PrimAlgorithm()
    }
}

public struct PrimAlgorithm<Node: Hashable, Edge: Weighted & Equatable>: MinimumSpanningTreeAlgorithm {
    @inlinable public init() {}

    @inlinable public func minimumSpanningTree(in graph: some FullGraphProtocol<Node, Edge>) -> [GraphEdge<Node, Edge>] {
        guard let startNode = graph.allNodes.first else {
            return []
        }
        let nodeCount = graph.allNodes.count

        var mst: [GraphEdge<Node, Edge>] = []
        var visited: Set<Node> = [startNode]
        var heap = Heap<GraphEdge<Node, Edge>>()

        for edge in graph.edges(from: startNode) {
            heap.insert(edge)
        }

        while let edge = heap.popMin() {
            let destination = edge.destination
            if !visited.contains(destination) {
                visited.insert(destination)
                mst.append(edge)

                for nextEdge in graph.edges(from: destination) {
                    if !visited.contains(nextEdge.destination) {
                        heap.insert(nextEdge)
                    }
                }

                if visited.count == nodeCount {
                    break
                }
            }
        }

        return mst
    }
}
