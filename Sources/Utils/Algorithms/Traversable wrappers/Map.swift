extension Traversable {
    @inlinable public func map<T>(_ transform: @escaping (Node) -> T) -> MappedTraversal<Self, T> {
        MappedTraversal(base: self, transform: transform)
    }
}

public struct MappedTraversal<Base: Traversable, Element>: Traversable, TraversableWrapper {
    public struct Node {
        public let node: Base.Node
        public let transformed: Element

        @inlinable public init(node: Base.Node, transformed: Element) {
            self.node = node
            self.transformed = transformed
        }
    }
    public typealias Edge = GraphEdge<Node>
    public typealias Edges = LazyMapCollection<Base.Edges, Edge>

    public let base: Base
    public let transform: (Base.Node) -> Element
    public let extractBaseNode: (Node) -> Base.Node = \.node

    @inlinable public init(base: Base, transform: @escaping (Base.Node) -> Element) {
        self.base = base
        self.transform = transform
    }

    @inlinable public var start: Node {
        Node(node: base.start, transformed: transform(base.start))
    }

    @inlinable public func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy.map {
            GraphEdge(
                source: Node(node: $0.source, transformed: transform($0.source)),
                destination: Node(node: $0.destination, transformed: transform($0.destination))
            )
        }
    }
}

extension MappedTraversal: Terminable where Base: Terminable {}
