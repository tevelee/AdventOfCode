extension TraversalOrder {
    public var reversed: ReversedTraversalOrder<Self> {
        ReversedTraversalOrder(base: self)
    }
}

public struct ReversedTraversalOrder<Base: TraversalOrder>: TraversalOrder {
    public typealias Node = Base.Node

    let base: Base

    init(base: Base) {
        self.base = base
    }

    public func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        base.order(node: node, neighbors: neighbors).reversed()
    }
}
