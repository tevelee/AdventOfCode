extension TraversalOrder {
    @inlinable public static var postorder: PostorderTraversalOrder<Node> {
        PostorderTraversalOrder()
    }
}

public struct PostorderTraversalOrder<Node>: TraversalOrder {
    @inlinable public init() {}

    @inlinable public func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        neighbors + [node]
    }
}

extension DFS {
    @inlinable public init(order: Order) where Self == DFS<Node, PostorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }
}
