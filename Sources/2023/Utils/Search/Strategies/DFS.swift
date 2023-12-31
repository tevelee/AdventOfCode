struct DFSNode<Node> {
    let node: Node
    var isFirstVisit: Bool
}

struct DFS<Node, Order: TraversalOrder>: SearchStrategy where Order.Node == DFSNode<Node> {
    var stack: [DFSNode<Node>] = []
    let order: Order

    init(order: Order = .preorder) where Self == DFS<Node, PreorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }

    init(order: Order) where Self == DFS<Node, PostorderTraversalOrder<DFSNode<Node>>> {
        self.order = order
    }

    mutating func add(_ node: Node) {
        stack.append(DFSNode(node: node, isFirstVisit: true))
    }

    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        while var node = stack.popLast() {
            if node.isFirstVisit {
                node.isFirstVisit.toggle()
                let neighbors = neighbors(node.node).map {
                    DFSNode(node: $0, isFirstVisit: true)
                }
                stack = order.order(node: node, neighbors: neighbors) + stack
                continue
            }
            return node.node
        }
        return nil
    }
}
