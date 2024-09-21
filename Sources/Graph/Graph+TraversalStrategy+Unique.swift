extension GraphTraversalStrategy {
    @inlinable public func visitEachNodeOnce() -> UniqueTraversalStrategy<Self, some Hashable> where Node: Hashable {
        visitEachNodeOnce(by: \.self)
    }

    @inlinable public func visitEachNodeOnce<HashValue>(by hashValue: @escaping (Node) -> HashValue) -> UniqueTraversalStrategy<Self, HashValue> {
        .init(base: self, hashValue: hashValue)
    }
}

public struct UniqueTraversalStrategy<Base: GraphTraversalStrategy, HashValue: Hashable>: GraphTraversalStrategy {
    public typealias Node = Base.Node
    public typealias Edge = Base.Edge
    public typealias Visit = Base.Visit
    public typealias Storage = (base: Base.Storage, visited: Set<HashValue>)

    public var base: Base
    public var hashValue: (Node) -> HashValue

    @inlinable public init(base: Base, hashValue: @escaping (Node) -> HashValue) {
        self.base = base
        self.hashValue = hashValue
    }

    @inlinable public func initializeStorage(startNode: Node) -> Storage {
        (base: base.initializeStorage(startNode: startNode), visited: [])
    }

    @inlinable public func next(from storage: inout Storage, edges: (Node) -> some Sequence<GraphEdge<Node, Edge>>) -> Visit? {
        while let visit = base.next(from: &storage.base, edges: {
            edges($0).filter {
                !storage.visited.contains(hashValue($0.destination))
            }
        }) {
            let node = base.node(from: visit)
            if storage.visited.contains(hashValue(node)) {
                continue
            }
            defer {
                storage.visited.insert(hashValue(node))
            }
            return visit
        }
        return nil
    }

    @inlinable public func node(from visit: Visit) -> Node {
        base.node(from: visit)
    }
}
