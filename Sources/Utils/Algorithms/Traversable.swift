public protocol Traversable<Node> {
    associatedtype Node
    associatedtype Edge: EdgeProtocol<Node>
    associatedtype Edges: Collection<Edge>

    var start: Edge.Node { get }
    func edges(from node: Edge.Node) -> Edges
}

public struct Traversal<Node, Edge: EdgeProtocol<Node>, Edges: Collection<Edge>>: Traversable {
    public let start: Node
    public let edges: (Node) -> Edges

    @inlinable public init(start: Node, edges: @escaping (Node) -> Edges) {
        self.start = start
        self.edges = edges
    }

    @inlinable public func edges(from node: Node) -> Edges {
        edges(node)
    }
}

extension Traversal {
    @inlinable public init<Neighbors: Collection<Node>>(start: Node, neighbors: @escaping (Node) -> Neighbors) where Edge == GraphEdge<Node>, Edges == LazyMapSequence<Neighbors, Edge> {
        self.init(start: start) { node in
            neighbors(node).lazy.map {
                GraphEdge(source: node, destination: $0)
            }
        }
    }
}

extension Traversal where Edges == CollectionOfOne<Edge> {
    @inlinable public init(start: Node, edge: @escaping (Node) -> Edge) {
        self.init(start: start) { CollectionOfOne(edge($0)) }
    }
}

extension Traversal where Edges == LazyMapSequence<CollectionOfOne<Node>, GraphEdge<Node>> {
    @inlinable public init(start: Node, neighbor: @escaping (Node) -> Node) {
        self.init(start: start) { CollectionOfOne(neighbor($0)) }
    }
}

public protocol EdgeProtocol<Node> {
    associatedtype Node
    var source: Node { get }
    var destination: Node { get }

    init(source: Node, destination: Node)
}

public struct GraphEdge<Node>: EdgeProtocol {
    public var source: Node
    public var destination: Node

    @inlinable public init(source: Node, destination: Node) {
        self.source = source
        self.destination = destination
    }
}
