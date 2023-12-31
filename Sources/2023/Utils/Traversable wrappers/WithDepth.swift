extension Traversable {
    func until(depth: Int) -> ConditionalTermination<WithDepth<Self>> {
        ConditionalTermination(base: WithDepth(base: self)) { $0.depth == depth }
    }
}

struct WithDepth<Base: Traversable>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let depth: Int
    }
    typealias Edge = GraphEdge<Node>
    typealias Edges = LazyMapCollection<Base.Edges, Edge>

    let base: Base
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, depth: 0)
    }

    func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy.map { edge in
            Edge(
                source: Node(node: edge.source, depth: node.depth),
                destination: Node(node: edge.destination, depth: node.depth + 1)
            )
        }
    }
}

extension WithDepth: Terminable where Base: Terminable {}
