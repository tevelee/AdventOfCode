extension Traversable {
    func map<T>(_ transform: @escaping (Node) -> T) -> MappedTraversal<Self, T> {
        MappedTraversal(base: self, transform: transform)
    }
}

struct MappedTraversal<Base: Traversable, Element>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let transformed: Element
    }
    typealias Edge = GraphEdge<Node>
    typealias Edges = LazyMapCollection<Base.Edges, Edge>

    let base: Base
    let transform: (Base.Node) -> Element
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, transformed: transform(base.start))
    }

    func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy.map {
            GraphEdge(
                source: Node(node: $0.source, transformed: transform($0.source)),
                destination: Node(node: $0.destination, transformed: transform($0.destination))
            )
        }
    }
}

extension MappedTraversal: Terminable where Base: Terminable {}
