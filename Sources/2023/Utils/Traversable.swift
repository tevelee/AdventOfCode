protocol Traversable<Node> {
    associatedtype Node
    associatedtype Edge: EdgeProtocol<Node>
    associatedtype Edges: Collection<Edge>

    var start: Edge.Node { get }
    func edges(from node: Edge.Node) -> Edges
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
