extension TraversalOrder {
    static var postorder: PostorderTraversalOrder<Node> {
        PostorderTraversalOrder()
    }
}

struct PostorderTraversalOrder<Node>: TraversalOrder {
    func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        neighbors + [node]
    }
}
