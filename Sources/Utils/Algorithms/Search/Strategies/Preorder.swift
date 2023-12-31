extension TraversalOrder {
    @inlinable public static var preorder: PreorderTraversalOrder<Node> {
        PreorderTraversalOrder()
    }
}

public struct PreorderTraversalOrder<Node>: TraversalOrder {
    @inlinable public init() {}

    @inlinable public func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        [node] + neighbors
    }
}

extension DFS {
    @inlinable public init(order: Order = .preorder) where Self == DFS<Node, PreorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }
}
