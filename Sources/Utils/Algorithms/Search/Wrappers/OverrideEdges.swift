extension Traversable {
    @inlinable public func next<CustomEdge: EdgeProtocol<Node>, CustomEdges: Collection<CustomEdge>>(edges: @escaping (Node) -> CustomEdges) -> OverrideEdges<Self, CustomEdge, CustomEdges> {
        OverrideEdges(base: self, edges: edges)
    }

    @inlinable public func next<Neighbors: Collection<Node>>(neighbors: @escaping (Node) -> Neighbors) -> OverrideEdges<Self, GraphEdge<Node>, LazyMapSequence<Neighbors, GraphEdge<Node>>> {
        next { node in
            neighbors(node).lazy.map {
                GraphEdge(source: node, destination: $0)
            }
        }
    }

    @inlinable public func next<CustomEdge: EdgeProtocol<Node>>(edge: @escaping (Node) -> CustomEdge) -> OverrideEdges<Self, CustomEdge, CollectionOfOne<CustomEdge>> {
        next { CollectionOfOne(edge($0)) }
    }

    @inlinable public func next(neighbor: @escaping (Node) -> Node) -> OverrideEdges<Self, GraphEdge<Node>, LazyMapSequence<CollectionOfOne<Node>, GraphEdge<Node>>> {
        next { CollectionOfOne(neighbor($0)) }
    }
}

public struct OverrideEdges<Base: Traversable, OverridedEdge: EdgeProtocol<Base.Node>, OverridedEdges: Collection<OverridedEdge>>: Traversable, TraversableWrapper {
    public typealias Node = Base.Node
    public typealias Edge = OverridedEdge
    public typealias Edges = OverridedEdges

    public let base: Base
    public let edges: (Node) -> OverridedEdges
    public let extractBaseNode: (Node) -> Base.Node = \.self

    @inlinable public init(base: Base, edges: @escaping (Node) -> OverridedEdges) {
        self.base = base
        self.edges = edges
    }

    @inlinable public var start: Node {
        base.start
    }

    @inlinable public func edges(from node: Node) -> Edges {
        edges(node)
    }
}

extension OverrideEdges: Terminable where Base: Terminable {}
