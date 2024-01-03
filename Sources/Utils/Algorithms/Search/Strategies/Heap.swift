import Collections

public struct MinimumFirst<Node: Comparable>: SearchStrategy {
    @inlinable public init() {}

    @usableFromInline var heap: Heap<Node> = []

    @inlinable public mutating func add(_ node: Node) {
        heap.insert(node)
    }

    @inlinable public mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        guard let value = heap.popMin() else { return nil }
        for neighbor in neighbors(value) {
            heap.insert(neighbor)
        }
        return value
    }
}

public struct MaximumFirst<Node: Comparable>: SearchStrategy {
    @inlinable public init() {}

    @usableFromInline var heap: Heap<Node> = []

    @inlinable public mutating func add(_ node: Node) {
        heap.insert(node)
    }

    @inlinable public mutating func next(neighbors: (Node) -> some Collection<Node>) -> Node? {
        guard let value = heap.popMax() else { return nil }
        for neighbor in neighbors(value) {
            heap.insert(neighbor)
        }
        return value
    }
}
