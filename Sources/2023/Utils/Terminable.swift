protocol Terminable<Node> {
    associatedtype Node
    func goalReached(for node: Node) -> Bool
}

extension Traversable {
    func goal(_ goalReached: @escaping (Node) -> Bool) -> ConditionalTermination<Self> {
        ConditionalTermination(base: self, goalReached: goalReached)
    }
}

extension TraversableWrapper where Base: Terminable {
    func goalReached(for node: Node) -> Bool {
        base.goalReached(for: extractBaseNode(node))
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
