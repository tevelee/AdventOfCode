extension TraversalOrder {
    static var preorder: PreorderTraversalOrder<Node> {
        PreorderTraversalOrder()
    }
}

struct PreorderTraversalOrder<Node>: TraversalOrder {
    func order(node: Node, neighbors: some Collection<Node>) -> [Node] {
        [node] + neighbors
    }
}
