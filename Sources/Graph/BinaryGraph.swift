public struct BinaryGraphEdges<Node, Edge>: Container {
    public typealias Element = GraphEdge<Node, Edge>

    public var source: Node
    public var lhs: Element?
    public var rhs: Element?

    @inlinable public init(source: Node, lhs: Element?, rhs: Element?) {
        self.source = source
        self.lhs = lhs
        self.rhs = rhs
    }

    @inlinable public var elements: [Element] { [lhs, rhs].compactMap(\.self) }
}

public protocol BinaryGraphProtocol<Node, Edge>: GraphProtocol {
    associatedtype Node
    associatedtype Edge = Void

    @inlinable func edges(from node: Node) -> BinaryGraphEdges<Node, Edge>
}

extension GraphProtocol where Self: BinaryGraphProtocol {
    @inlinable public func edges(from node: Node) -> [GraphEdge<Node, Edge>] {
        let edges: BinaryGraphEdges<Node, Edge> = self.edges(from: node)
        return edges.elements
    }
}

public struct LazyBinaryGraph<Node, Edge>: BinaryGraphProtocol {
    @usableFromInline let _edges: (Node) -> BinaryGraphEdges<Node, Edge>

    @inlinable public init(neighborNodes: @escaping (Node) -> (lhs: Node?, rhs: Node?)?) where Edge == Void {
        _edges = { node in
            let destinations = neighborNodes(node)
            return BinaryGraphEdges(
                source: node,
                lhs: destinations?.lhs.map { .init(source: node, destination: $0) },
                rhs: destinations?.rhs.map { .init(source: node, destination: $0) }
            )
        }
    }

    @_disfavoredOverload
    @inlinable public init(customEdges edges: @escaping (Node) -> BinaryGraphEdges<Node, Edge>) {
        _edges = edges
    }

    @inlinable public func edges(from node: Node) -> BinaryGraphEdges<Node, Edge> {
        _edges(node)
    }
}

public struct BinaryGraph<Node, Edge>: BinaryGraphProtocol {
    @usableFromInline let _edges: [BinaryGraphEdges<Node, Edge>]
    @usableFromInline let isEqual: (Node, Node) -> Bool

    @inlinable public init(edges: [BinaryGraphEdges<Node, Edge>], isEqual: @escaping (Node, Node) -> Bool) {
        self._edges = edges
        self.isEqual = isEqual
    }

    @inlinable public func edges(from node: Node) -> BinaryGraphEdges<Node, Edge> {
        _edges.first { isEqual($0.source, node) } ?? BinaryGraphEdges(source: node, lhs: nil, rhs: nil)
    }
}

extension BinaryGraph where Node: Equatable {
    @inlinable public init(edges: [BinaryGraphEdges<Node, Edge>]) {
        self.init(edges: edges, isEqual: ==)
    }

    @inlinable public init(edges: [Node: (lhs: Node?, rhs: Node?)?]) where Edge == Void {
        self.init(
            edges: edges.map { source, destinations in
                BinaryGraphEdges(
                    source: source,
                    lhs: destinations?.lhs.map { GraphEdge(source: source, destination: $0) },
                    rhs: destinations?.rhs.map { GraphEdge(source: source, destination: $0) }
                )
            },
            isEqual: ==
        )
    }
}

public struct HashedBinaryGraph<Node, Edge, HashValue: Hashable>: BinaryGraphProtocol {
    @usableFromInline let _edges: [HashValue: BinaryGraphEdges<Node, Edge>]
    @usableFromInline let hashValue: (Node) -> HashValue

    public init(edges: [BinaryGraphEdges<Node, Edge>], hashValue: @escaping (Node) -> HashValue) {
        self._edges = edges.keyed { hashValue($0.source) }
        self.hashValue = hashValue
    }

    @inlinable public func edges(from node: Node) -> BinaryGraphEdges<Node, Edge> {
        _edges[hashValue(node)] ?? BinaryGraphEdges(source: node, lhs: nil, rhs: nil)
    }
}

extension HashedBinaryGraph where Node: Hashable, HashValue == Node {
    @inlinable public init(edges: [BinaryGraphEdges<Node, Edge>]) {
        self.init(edges: edges, hashValue: \.self)
    }

    @inlinable public init(edges: [Node: (lhs: Node?, rhs: Node?)?]) where Node: Hashable, Edge == Void {
        self.init(
            edges: edges.map { source, destinations in
                BinaryGraphEdges(
                    source: source,
                    lhs: destinations?.lhs.map { GraphEdge(source: source, destination: $0) },
                    rhs: destinations?.rhs.map { GraphEdge(source: source, destination: $0) }
                )
            },
            hashValue: \.self
        )
    }


}
