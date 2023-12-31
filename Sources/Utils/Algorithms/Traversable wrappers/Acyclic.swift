extension Traversable {
    @inlinable public func avoidCycles<HashValue: Hashable>(of hashValue: @escaping (Node) -> HashValue) -> Acyclic<Self, HashValue> {
        Acyclic(base: self, hashValue: hashValue)
    }
    @inlinable public func avoidCycles() -> Acyclic<Self, Node> where Node: Hashable {
        Acyclic(base: self) { $0 }
    }
}

public struct Acyclic<Base: Traversable, HashValue: Hashable>: Traversable, TraversableWrapper {
    public struct Node {
        public let node: Base.Node
        public let visited: Set<HashValue>

        @inlinable public init(node: Base.Node, visited: Set<HashValue>) {
            self.node = node
            self.visited = visited
        }
    }
    public typealias Edge = GraphEdge<Node>
    public typealias Edges = LazyFilterCollection<LazyMapCollection<Base.Edges, Edge>>

    public let base: Base
    public let hashValue: (Base.Node) -> HashValue
    public let extractBaseNode: (Node) -> Base.Node = \.node

    @inlinable public init(base: Base, hashValue: @escaping (Base.Node) -> HashValue) {
        self.base = base
        self.hashValue = hashValue
    }

    @inlinable public var start: Node {
        Node(node: base.start, visited: [])
    }

    @inlinable public func edges(from node: Node) -> Edges {
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

extension Acyclic: Terminable where Base: Terminable {}
