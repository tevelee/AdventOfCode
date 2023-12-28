import Foundation

protocol Traversable<Node> {
    associatedtype Node
    associatedtype Edge: EdgeProtocol<Node>
    associatedtype Edges: Collection<Edge>

    var start: Edge.Node { get }
    func edges(from node: Edge.Node) -> Edges
}

protocol EdgeProtocol<Node> {
    associatedtype Node
    var source: Node { get }
    var destination: Node { get }

    init(source: Node, destination: Node)
}

struct GraphEdge<Node>: EdgeProtocol {
    var source: Node
    var destination: Node

    init(source: Node, destination: Node) {
        self.source = source
        self.destination = destination
    }
}

protocol Terminable<Node> {
    associatedtype Node
    func goalReached(for node: Node) -> Bool
}

struct Traversal<Node, Edge: EdgeProtocol<Node>, Edges: Collection<Edge>>: Traversable {
    let start: Node
    let edges: (Node) -> Edges

    init(start: Node, edges: @escaping (Node) -> Edges) {
        self.start = start
        self.edges = edges
    }

    func edges(from node: Node) -> Edges {
        edges(node)
    }
}

extension Traversal {
    init<Neighbors: Collection<Node>>(start: Node, neighbors: @escaping (Node) -> Neighbors) where Edge == GraphEdge<Node>, Edges == LazyMapSequence<Neighbors, Edge> {
        self.init(start: start) { node in
            neighbors(node).lazy.map {
                GraphEdge(source: node, destination: $0)
            }
        }
    }
}

extension Traversal where Edges == CollectionOfOne<Edge> {
    init(start: Node, edge: @escaping (Node) -> Edge) {
        self.init(start: start) { CollectionOfOne(edge($0)) }
    }
}

extension Traversal where Edges == LazyMapSequence<CollectionOfOne<Node>, GraphEdge<Node>> {
    init(start: Node, neighbor: @escaping (Node) -> Node) {
        self.init(start: start) { CollectionOfOne(neighbor($0)) }
    }
}

extension Traversable {
    func includePath() -> WithPath<Self> {
        WithPath(base: self)
    }
    func avoidCycles<HashValue: Hashable>(of hashValue: @escaping (Node) -> HashValue) -> Acyclic<Self, HashValue> {
        Acyclic(base: self, hashValue: hashValue)
    }
    func avoidCycles() -> Acyclic<Self, Node> where Node: Hashable {
        Acyclic(base: self) { $0 }
    }
    func goal(_ goalReached: @escaping (Node) -> Bool) -> ConditionalTermination<Self> {
        ConditionalTermination(base: self, goalReached: goalReached)
    }
    func until(depth: Int) -> ConditionalTermination<WithDepth<Self>> {
        ConditionalTermination(base: WithDepth(base: self)) { $0.depth == depth }
    }
    func map<T>(_ transform: @escaping (Node) -> T) -> MappedTraversal<Self, T> {
        MappedTraversal(base: self, transform: transform)
    }
    func weight<Weight: Numeric>(_ weight: @escaping (Edge) -> Weight) -> Weighted<Self, Weight> {
        Weighted(base: self, weight: weight)
    }
}

protocol HasWeight {
    associatedtype Weight: Numeric
    var weight: Weight { get }
}

protocol HasWeightedEdge {
    associatedtype Edge: HasWeight
}

struct Weighted<Base: Traversable, Weight: Numeric>: Traversable, TraversableWrapper, HasWeightedEdge {
    typealias Node = Base.Node
    typealias Edge = WeightedEdge<Base.Edge>
    
    struct WeightedEdge<BaseEdge: EdgeProtocol>: EdgeProtocol, HasWeight {
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

extension Weighted: Terminable where Base: Terminable {
    func goalReached(for node: Node) -> Bool {
        base.goalReached(for: extractBaseNode(node))
    }
}

protocol TraversableWrapper: Traversable {
    associatedtype Base: Traversable

    var base: Base { get }
    var extractBaseNode: (Node) -> Base.Node { get }
}

extension TraversableWrapper where Base: TraversableWrapper {
    func extractBaseNode(_ node: Base.Node) -> Base.Base.Node {
        base.extractBaseNode(node)
    }
}

extension TraversableWrapper where Base: Terminable {
    func goalReached(for node: Node) -> Bool {
        base.goalReached(for: extractBaseNode(node))
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

extension MappedTraversal: Terminable where Base: Terminable {
    func goalReached(for node: Node) -> Bool {
        base.goalReached(for: node.node)
    }
}

struct ConditionalTermination<Base: Traversable>: Traversable, Terminable, TraversableWrapper {
    typealias Node = Edge.Node
    typealias Edge = Base.Edge

    let base: Base
    let goalReached: (Node) -> Bool
    let extractBaseNode: (Node) -> Base.Node = \.self

    var start: Node {
        base.start
    }

    func edges(from node: Node) -> Base.Edges {
        base.edges(from: node)
    }

    func goalReached(for node: Node) -> Bool {
        goalReached(node)
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

struct Acyclic<Base: Traversable, HashValue: Hashable>: Traversable, TraversableWrapper {
    struct Node {
        let node: Base.Node
        let visited: Set<HashValue>
    }
    typealias Edge = GraphEdge<Node>
    typealias Edges = LazyFilterCollection<LazyMapCollection<Base.Edges, Edge>>

    let base: Base
    let hashValue: (Base.Node) -> HashValue
    let extractBaseNode: (Node) -> Base.Node = \.node

    var start: Node {
        Node(node: base.start, visited: [])
    }

    func edges(from node: Node) -> Edges {
        base.edges(from: node.node).lazy
            .map {
                Edge(
                    source: Node(node: $0.source, visited: node.visited),
                    destination: Node(node: $0.destination, visited: node.visited + hashValue($0.source))
                )
            }
            .filter { edge in
                !edge.destination.visited.contains(hashValue(edge.source.node))
            }
    }
}
