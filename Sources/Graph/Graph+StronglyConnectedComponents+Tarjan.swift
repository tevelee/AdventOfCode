extension StronglyConnectedComponentsAlgorithm {
    @inlinable public static func tarjan<Node, Edge>() -> Self where Self == TarjanSCCAlgorithm<Node, Edge> {
        .init()
    }
}

public struct TarjanSCCAlgorithm<Node: Hashable, Edge>: StronglyConnectedComponentsAlgorithm {
    @inlinable public init() {}

    @inlinable public func findStronglyConnectedComponents(in graph: some FullGraphProtocol<Node, Edge>) -> [[Node]] {
        var index = 0
        var stack: [Node] = []
        var indices: [Node: Int] = [:]
        var lowLinks: [Node: Int] = [:]
        var onStack: Set<Node> = []
        var sccs: [[Node]] = []

        for node in graph.allNodes where indices[node] == nil {
            dfs(graph: graph, node: node, index: &index, stack: &stack, indices: &indices, lowLinks: &lowLinks, onStack: &onStack, sccs: &sccs)
        }

        return sccs
    }

    @usableFromInline func dfs(
        graph: some FullGraphProtocol<Node, Edge>,
        node: Node,
        index: inout Int,
        stack: inout [Node],
        indices: inout [Node: Int],
        lowLinks: inout [Node: Int],
        onStack: inout Set<Node>,
        sccs: inout [[Node]]
    ) {
        indices[node] = index
        lowLinks[node] = index
        index += 1
        stack.append(node)
        onStack.insert(node)

        for edge in graph.edges(from: node) {
            let neighbor = edge.destination
            if indices[neighbor] == nil {
                dfs(graph: graph, node: neighbor, index: &index, stack: &stack, indices: &indices, lowLinks: &lowLinks, onStack: &onStack, sccs: &sccs)
                lowLinks[node] = min(lowLinks[node]!, lowLinks[neighbor]!)
            } else if onStack.contains(neighbor) {
                lowLinks[node] = min(lowLinks[node]!, indices[neighbor]!)
            }
        }

        if lowLinks[node] == indices[node] {
            var scc: [Node] = []
            var poppedNode: Node
            repeat {
                poppedNode = stack.removeLast()
                onStack.remove(poppedNode)
                scc.append(poppedNode)
            } while poppedNode != node
            sccs.append(scc)
        }
    }
}
