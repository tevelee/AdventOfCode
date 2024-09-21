import Algorithms

public protocol GraphProtocol<Node, Edge> {
    associatedtype Node
    associatedtype Edge = Void

    @inlinable func edges(from node: Node) -> [GraphEdge<Node, Edge>]
}

public struct GraphEdge<Node, Value> {
    public let source: Node
    public let destination: Node
    public let value: Value

    @inlinable public init(source: Node, destination: Node, value: Value = ()) {
        self.source = source
        self.destination = destination
        self.value = value
    }
}

extension GraphEdge: Equatable where Node: Equatable, Value: Equatable {}
extension GraphEdge: Hashable where Node: Hashable, Value: Hashable {}
extension GraphEdge: Comparable where Node: Equatable, Value: Equatable, Value: Weighted {
    @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value.weight < rhs.value.weight
    }
}
extension GraphEdge: Weighted where Value: Weighted {
    @inlinable public var weight: Value.Weight {
        value.weight
    }
}

public struct LazyGraph<Node, Edge>: GraphProtocol {
    @usableFromInline let _edges: (Node) -> [GraphEdge<Node, Edge>]

    @inlinable public init<Nodes: Sequence<Node>>(neighborNodes: @escaping (Node) -> Nodes) where Edge == Void {
        _edges = { node in neighborNodes(node).lazy.map { GraphEdge(source: node, destination: $0) } }
    }

    @inlinable public init(neighbor: @escaping (Node) -> Node) where Edge == Void {
        self.init(neighborNodes: { CollectionOfOne(neighbor($0)) })
    }

    @_disfavoredOverload
    @inlinable public init(customEdges edges: @escaping (Node) -> [GraphEdge<Node, Edge>]) {
        _edges = edges
    }

    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        _edges(node)
    }

    @inlinable public func materialize(starting: Node, strategy: some GraphTraversalStrategy<Node, Edge, Node>, isEqual: @escaping (Node, Node) -> Bool) -> Graph<Node, Edge> {
        Graph(edges: traverse(from: starting, strategy: strategy).flatMap(edges), isEqual: isEqual)
    }

    @inlinable public func materialize(starting: Node, strategy: some GraphTraversalStrategy<Node, Edge, Node>) -> Graph<Node, Edge> where Node: Equatable {
        Graph(edges: traverse(from: starting, strategy: strategy).flatMap(edges))
    }

    @inlinable public func materialize<HashValue: Hashable>(starting: Node, strategy: some GraphTraversalStrategy<Node, Edge, Node>, hashValue: @escaping (Node) -> HashValue) -> HashedGraph<Node, Edge, HashValue> {
        HashedGraph(edges: traverse(from: starting, strategy: strategy).flatMap(edges), hashValue: hashValue)
    }

    @inlinable public func materialize(starting: Node, strategy: some GraphTraversalStrategy<Node, Edge, Node>) -> HashedGraph<Node, Edge, Node> where Node: Hashable {
        HashedGraph(edges: traverse(from: starting, strategy: strategy).flatMap(edges))
    }
}

public struct Graph<Node, Edge>: GraphProtocol {
    @usableFromInline let _edges: [GraphEdge<Node, Edge>]
    @usableFromInline let isEqual: (Node, Node) -> Bool

    @inlinable public init(edges: [GraphEdge<Node, Edge>], isEqual: @escaping (Node, Node) -> Bool) {
        self._edges = edges
        self.isEqual = isEqual
    }

    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        self._edges.filter { isEqual($0.source, node) }
    }
}

extension Graph where Node: Equatable {
    @inlinable public init(edges: [GraphEdge<Node, Edge>]) {
        self.init(edges: edges, isEqual: ==)
    }

    @inlinable public init(edges: [Node: [Node]]) where Edge == Void {
        self.init(edges: edges.flatMap { source, destinations in
            destinations.map { GraphEdge(source: source, destination: $0) }
        }, isEqual: ==)
    }

    @inlinable public init(edges: [Node: [Node: Edge]]) where Node: Hashable {
        self.init(edges: edges.flatMap { source, destinations in
            destinations.map { GraphEdge(source: source, destination: $0, value: $1) }
        }, isEqual: ==)
    }
}

public struct HashedGraph<Node, Edge, HashValue: Hashable>: GraphProtocol {
    @usableFromInline let _edges: [HashValue: [GraphEdge<Node, Edge>]]
    @usableFromInline let hashValue: (Node) -> HashValue

    @inlinable public init(edges: [HashValue: [GraphEdge<Node, Edge>]], hashValue: @escaping (Node) -> HashValue) {
        self._edges = edges
        self.hashValue = hashValue
    }

    @inlinable public init(edges: [GraphEdge<Node, Edge>], hashValue: @escaping (Node) -> HashValue) {
        self._edges = edges.grouped { hashValue($0.source) }
        self.hashValue = hashValue
    }

    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        self._edges[hashValue(node)] ?? []
    }
}

extension HashedGraph where Node: Hashable, HashValue == Node {
    @inlinable public init(edges: [GraphEdge<Node, Edge>]) {
        self.init(edges: edges, hashValue: \.self)
    }

    @inlinable public init(edges: [Node: [Node]]) where Edge == Void {
        self.init(edges: edges.flatMap { source, destinations in
            destinations.map { GraphEdge(source: source, destination: $0) }
        }.grouped(by: \.source), hashValue: \.self)
    }
}
