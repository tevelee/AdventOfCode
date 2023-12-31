extension Traversable {
    func weight<Weight: Numeric>(_ weight: @escaping (Edge) -> Weight) -> Weighted<Self, Weight> {
        Weighted(base: self, weight: weight)
    }
}

struct Weighted<Base: Traversable, Weight: Numeric>: Traversable, TraversableWrapper {
    typealias Node = Base.Node
    typealias Edge = WeightedEdge<Base.Edge>

    struct WeightedEdge<BaseEdge: EdgeProtocol>: EdgeProtocol, WeightedEdgeProtocol {
        typealias Node = BaseEdge.Node
        let base: BaseEdge
        let weight: Weight

        var source: Node {
            base.source
        }

        var destination: Node {
            base.destination
        }

        init(source: BaseEdge.Node, destination: BaseEdge.Node) {
            base = BaseEdge(source: source, destination: destination)
            weight = .zero
        }

        init(base: BaseEdge, weight: Weight) {
            self.base = base
            self.weight = weight
        }
    }
    typealias Edges = LazyMapCollection<Base.Edges, Edge>

    let base: Base
    let weight: (Base.Edge) -> Weight
    let extractBaseNode: (Node) -> Base.Node = { $0 }

    var start: Node {
        base.start
    }

    func edges(from node: Node) -> Edges {
        base.edges(from: node).lazy.map {
            Edge(
                base: $0,
                weight: weight($0)
            )
        }
    }
}

extension Weighted: Terminable where Base: Terminable {}

protocol WeightedEdgeProtocol {
    associatedtype Weight: Numeric
    var weight: Weight { get }
}

extension TraversableWrapper where Base: WeightedEdgeProtocol {
    var weight: Base.Weight {
        base.weight
    }
}
