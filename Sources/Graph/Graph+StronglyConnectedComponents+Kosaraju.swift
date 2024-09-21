extension StronglyConnectedComponentsAlgorithm {
    @inlinable public static func kosaraju<Node, Edge>() -> Self where Self == KosarajuSCCAlgorithm<Node, Edge> {
        .init()
    }
}

public struct KosarajuSCCAlgorithm<Node: Hashable, Edge>: StronglyConnectedComponentsAlgorithm {
    @inlinable public init() {}

    @inlinable public func findStronglyConnectedComponents(in graph: some FullGraphProtocol<Node, Edge>) -> [[Node]] {
        guard let sorted = graph.topologicalSort() else { return [] }

        let reversedGraph = ReversedGraph(base: graph)

        var result: [[Node]] = []

        var visited: Set<Node> = []
        for node in sorted.reversed() {
            if !visited.contains(node) {
                var scc: [Node] = []
                dfsCollect(graph: reversedGraph, node: node, visited: &visited, scc: &scc)
                result.append(scc)
            }
        }

        return result
    }

    @usableFromInline func dfsCollect(graph: some FullGraphProtocol<Node, Edge>, node: Node, visited: inout Set<Node>, scc: inout [Node]) {
        visited.insert(node)
        scc.append(node)
        for edge in graph.edges(from: node) {
            let neighbor = edge.destination
            if !visited.contains(neighbor) {
                dfsCollect(graph: graph, node: neighbor, visited: &visited, scc: &scc)
            }
        }
    }

    @usableFromInline func reverseGraph(_ graph: some FullGraphProtocol<Node, Edge>) -> Graph<Node, Edge> {
        let reversedEdges = graph.allEdges.map { GraphEdge(source: $0.destination, destination: $0.source, value: $0.value) }
        return Graph(edges: reversedEdges)
    }
}
