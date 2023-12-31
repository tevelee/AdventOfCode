import Collections

public struct BFS<Node>: SearchStrategy {
    @inlinable public init() {}

    @usableFromInline var queue: Deque<Node> = []

    @inlinable public mutating func add(_ node: Node) {
        queue.append(node)
    }

    @inlinable public mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        guard let next = queue.popFirst() else { return nil }
        queue.append(contentsOf: neighbors(next))
        return next
    }
}
