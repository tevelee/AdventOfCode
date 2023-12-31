extension Traversable {
    @inlinable public func weight<Weight: Numeric>(_ weight: @escaping (Edge) -> Weight) -> Weighted<Self, Weight> {
        Weighted(base: self, weight: weight)
    }
}

public struct Weighted<Base: Traversable, Weight: Numeric>: Traversable, TraversableWrapper {
    public typealias Node = Base.Node
    public typealias Edge = WeightedEdge<Base.Edge>

    public struct WeightedEdge<BaseEdge: EdgeProtocol>: EdgeProtocol, WeightedEdgeProtocol {
        public typealias Node = BaseEdge.Node
        public let base: BaseEdge
        public let weight: Weight

        @inlinable public var source: Node {
            base.source
        }

        @inlinable public var destination: Node {
            base.destination
        }

        @inlinable public init(source: BaseEdge.Node, destination: BaseEdge.Node) {
            base = BaseEdge(source: source, destination: destination)
            weight = .zero
        }

        @inlinable public init(base: BaseEdge, weight: Weight) {
            self.base = base
            self.weight = weight
        }
    }
    public typealias Edges = LazyMapCollection<Base.Edges, Edge>

    public let base: Base
    public let weight: (Base.Edge) -> Weight
    public let extractBaseNode: (Node) -> Base.Node = { $0 }

    @inlinable public init(base: Base, weight: @escaping (Base.Edge) -> Weight) {
        self.base = base
        self.weight = weight
    }

    @inlinable public var start: Node {
        base.start
    }

    @inlinable public func edges(from node: Node) -> Edges {
        base.edges(from: node).lazy.map {
            Edge(
                base: $0,
                weight: weight($0)
            )
        }
    }
}

extension Weighted: Terminable where Base: Terminable {}

public protocol WeightedEdgeProtocol {
    associatedtype Weight: Numeric
    var weight: Weight { get }
}

extension TraversableWrapper where Base: WeightedEdgeProtocol {
    @inlinable public var weight: Base.Weight {
        base.weight
    }
}
