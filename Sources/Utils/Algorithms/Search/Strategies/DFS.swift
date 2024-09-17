public struct DFSNode<Node> {
    public let node: Node
    public var isFirstVisit: Bool

    @inlinable public init(node: Node, isFirstVisit: Bool = true) {
        self.node = node
        self.isFirstVisit = isFirstVisit
    }
}

public struct DFS<Node, Order: TraversalOrder>: SearchStrategy where Order.Node == DFSNode<Node> {
    public var stack: [DFSNode<Node>] = []
    public let order: Order

    @inlinable public init(order: Order) {
        self.order = order
    }

    @inlinable public mutating func add(_ node: Node) {
        stack.append(DFSNode(node: node, isFirstVisit: true))
    }

    @inlinable public mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        while var node = stack.first {
            stack.removeFirst()
            if node.isFirstVisit {
                node.isFirstVisit.toggle()
                let neighbors = neighbors(node.node).map {
                    DFSNode(node: $0, isFirstVisit: true)
                }
                stack.prepend(order.order(node: node, neighbors: neighbors))
            } else {
                return node.node
            }
        }
        return nil
    }
}

extension Array {
    @inlinable mutating func prepend(_ other: Self) {
        self = other + self
    }
}
