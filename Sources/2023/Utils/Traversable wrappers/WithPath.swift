extension Traversable {
    func includePath() -> WithPath<Self> {
        WithPath(base: self)
    }
}

struct WithPath<Base: Traversable>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let path: [Base.Node]
    }
    typealias Edge = GraphEdge<Node>
    typealias Edges = LazyMapCollection<Base.Edges, Edge>

    let base: Base
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, path: [])
    }

    func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy.map {
            Edge(
                source: Node(node: $0.source, path: node.path),
                destination: Node(node: $0.destination, path: node.path + $0.destination)
            )
        }
    }
}

extension WithPath: Terminable where Base: Terminable {}
