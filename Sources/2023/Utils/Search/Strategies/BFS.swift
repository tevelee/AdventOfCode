import Collections

struct BFS<Node>: SearchStrategy {
    init() {}

    var queue: Deque<Node> = []

    mutating func add(_ node: Node) {
        queue.append(node)
    }

    mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        guard let next = queue.popFirst() else { return nil }
        queue.append(contentsOf: neighbors(next))
        return next
    }
}
