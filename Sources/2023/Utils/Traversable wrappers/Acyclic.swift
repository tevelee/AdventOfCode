extension Traversable {
    func avoidCycles<HashValue: Hashable>(of hashValue: @escaping (Node) -> HashValue) -> Acyclic<Self, HashValue> {
        Acyclic(base: self, hashValue: hashValue)
    }
    func avoidCycles() -> Acyclic<Self, Node> where Node: Hashable {
        Acyclic(base: self) { $0 }
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

extension Acyclic: Terminable where Base: Terminable {}
